package techmind.studio.detect_clap_sound_flutter;

import android.app.Activity;
import android.content.Context;
import android.media.MediaRecorder;
import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;

import java.io.IOException;
import java.util.LinkedList;
import java.util.Map;
import java.util.Queue;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import techmind.studio.detect_clap_sound_flutter.constants.ArgumentConstants;
import techmind.studio.detect_clap_sound_flutter.config.DetectConfig;
import techmind.studio.detect_clap_sound_flutter.constants.MethodConstants;
import techmind.studio.detect_clap_sound_flutter.permission.PermissionManager;
import techmind.studio.detect_clap_sound_flutter.permission.PermissionResultCallback;

public class DetectClapSoundFlutterPlugin implements FlutterPlugin, ActivityAware, MethodCallHandler, EventChannel.StreamHandler {
    private MethodChannel channel;

    private Activity mActivity;

    private Context context;

    private PermissionManager permissionManager = new PermissionManager();

    private ActivityPluginBinding activityBinding;

    private EventChannel eventChannel;

    private EventChannel.EventSink eventSink;

    private MediaRecorder recorder;

    private Runnable runnable;

    private Handler handler;

    private Queue<Integer> amplitudeQueue = new LinkedList<>();

    private boolean detectedRecently = false;

    private boolean isRecording = false;

    private String audioFilePath;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        this.context = flutterPluginBinding.getApplicationContext();

        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), MethodConstants.DETECT_CLAP_CHANNEL);

        eventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), MethodConstants.DETECT_CLAP_EVENT_CHANNEL);

        channel.setMethodCallHandler(this);

        eventChannel.setStreamHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case MethodConstants.GRANTED_PERMISSION_METHOD:
                result.success(permissionManager.isPermissionGranted(mActivity));
                break;

            case MethodConstants.REQUEST_PERMISSION_METHOD:
                permissionManager.hasPermission(new PermissionResultCallback() {
                    @Override
                    public void onResult(boolean hasPermission) {
                        result.success(hasPermission);
                    }
                });
                break;

            case MethodConstants.START_RECORDING_METHOD:
                startRecording(call, result);
                break;

            case MethodConstants.STOP_RECORDING_METHOD:
                stopRecording(result);
                break;

            case MethodConstants.STATUS_RECORDING_METHOD:
                result.success(isRecording);
                break;

            case MethodConstants.DISPOSE_RECORDING_METHOD:
                disposeRecording(result);
                break;

            default:
                result.notImplemented();
                break;
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        eventChannel.setStreamHandler(null);
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        mActivity = binding.getActivity();
        activityBinding = binding;

        PermissionManager pm = permissionManager;

        if (pm != null) {
            permissionManager.setActivity(mActivity);
            activityBinding.addRequestPermissionsResultListener(pm);
        }
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity();
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        onDetachedFromActivity();
        onAttachedToActivity(binding);
    }

    @Override
    public void onDetachedFromActivity() {
        PermissionManager pm = permissionManager;

        if (pm != null) {
            permissionManager.setActivity(null);
            activityBinding.addRequestPermissionsResultListener(pm);
        }

        activityBinding = null;
        mActivity = null;
    }


    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        eventSink = events;
    }

    @Override
    public void onCancel(Object arguments) {
        eventSink = null;
    }


    /**
     * [startRecording]
     * To start recording.
     * Use [eventSink] to emit event to Flutter.
     * Identifies spikes in sound amplitude, helping to detect specific sound events such as clapping or whistling.
     */
    private void startRecording(MethodCall call, MethodChannel.Result result) {
        /// Get arguments.
        String path = call.argument(ArgumentConstants.PATH_FILE);
        if (path == null || path.isEmpty()) {
            path = context.getExternalFilesDir(null).getAbsolutePath();
        }

        String fileName = call.argument(ArgumentConstants.FILE_NAME);
        if (fileName == null || fileName.isEmpty()) {
            fileName = "music";
        }

        /// Get detect config map.
        final Map<String, Object> configMap = call.argument(ArgumentConstants.DETECT_CONFIG);

        /// Define default config.
        DetectConfig detectConfig = new DetectConfig(
                getOrDefault(configMap, "threshold", 30000),
                getOrDefault(configMap, "stableThreshold", 3000),
                getOrDefault(configMap, "amplitudeSpikeThreshold", 28000),
                getOrDefault(configMap, "monitorInterval", 50),
                getOrDefault(configMap, "windowSize", 5)
        );

        recorder = new MediaRecorder();
        recorder.setAudioSource(MediaRecorder.AudioSource.MIC);
        recorder.setOutputFormat(MediaRecorder.OutputFormat.THREE_GPP);
        recorder.setAudioEncoder(MediaRecorder.AudioEncoder.AMR_NB);

        /// Set audio file path.
        audioFilePath = path + "/" + fileName + ".3gp";
        recorder.setOutputFile(audioFilePath);

        /// Start recording.
        try {
            recorder.prepare();
            recorder.start();
            isRecording = true;

            handler = new Handler(Looper.getMainLooper());

            runnable = new Runnable() {
                @Override
                public void run() {

                    /// Get Max Ampl and add to [amplitudeQueue].
                    int amplitude = recorder.getMaxAmplitude();
                    amplitudeQueue.add(amplitude);

                    if (amplitudeQueue.size() > detectConfig.getWindowSize()) {
                        amplitudeQueue.poll();
                    }

                    if (isClapDetected(detectConfig)) {

                        if (eventSink != null) {
                            eventSink.success(1);
                        }

                        detectedRecently = true;
                        amplitudeQueue.clear();

                    } else if (isAmplitudeStable(detectConfig)) {
                        detectedRecently = false;
                    }

                    handler.postDelayed(this, detectConfig.getMonitorInterval());
                }
            };
            handler.post(runnable);
            result.success("Recording starting");

        } catch (IOException e) {
            result.error("RECORDING_FAILED", "Recording failed", e.getMessage());
        }
    }


    /**
     * [isClapDetected]
     * <p>
     * To check the surge amplitude and rapid decrease.
     * <p>
     * [threshold]: Minimum amplitude threshold to identify a sound as possible clapping.
     * <p>
     * [stableThreshold]: Threshold to determine when the amplitude has returned to a stable level, helping to prevent repeated clap detection.
     * <p>
     * [amplitudeSpikeThreshold]: Threshold to determine the sudden change in amplitude (difference between largest and smallest amplitude), which characterizes applause.
     * <p>
     * [windowSize]: Number of amplitude samples in the test window.
     * <p>
     * [monitorInterval]: Interval between amplitude checks.
     */
    private boolean isClapDetected(DetectConfig config) {
        if (amplitudeQueue.size() < config.getWindowSize() || detectedRecently) {
            return false;
        }

        int maxAmplitudeInWindow = 0;
        int minAmplitudeInWindow = Integer.MAX_VALUE;

        for (int amplitude : amplitudeQueue) {
            if (amplitude > maxAmplitudeInWindow) {
                maxAmplitudeInWindow = amplitude;
            }
            if (amplitude < minAmplitudeInWindow) {
                minAmplitudeInWindow = amplitude;
            }
        }

        return maxAmplitudeInWindow > config.getThreshold() &&
                minAmplitudeInWindow < config.getStableThreshold() &&
                (maxAmplitudeInWindow - minAmplitudeInWindow) > config.getAmplitudeSpikeThreshold();
    }


    /**
     * [isAmplitudeStable]
     * To get Amplitude Stable
     */
    private boolean isAmplitudeStable(DetectConfig config) {
        for (int amplitude : amplitudeQueue) {
            if (amplitude > config.getStableThreshold()) {
                return false;
            }
        }
        return true;
    }


    /**
     * [stopRecording]
     * To stop recording when call from method channel.
     */
    private void stopRecording(MethodChannel.Result result) {
        if (recorder != null) {
            stopRecordingManually();
            result.success(audioFilePath);
        } else {
            result.error("NO_RECORDING", "No ongoing recording found", null);
        }
    }

    /**
     * [stopRecordingManually]
     * To stop recording manually
     */
    private void stopRecordingManually() {
        if (recorder != null) {
            handler.removeCallbacks(runnable);
            recorder.stop();
            recorder.release();
            recorder = null;
            isRecording = false;
        }
    }

    /**
     * [disposeRecording]
     * To clear record and stream listen
     */
    private void disposeRecording(MethodChannel.Result result) {
        if (recorder != null) {
            stopRecordingManually();
            result.success("DISPOSE RECORDING SUCCESS");
        } else {
            result.error("NO_RECORDING", "No ongoing recording found", null);
        }
    }


    /**
     * [getOrDefault]
     * Generic method to get a value from a map or return a default value if the key is not found
     */
    private <T> T getOrDefault(Map<String, Object> map, String key, T defaultValue) {
        if (map != null && map.containsKey(key) && map.get(key) != null) {
            return (T) map.get(key);
        }
        return defaultValue;
    }
}
