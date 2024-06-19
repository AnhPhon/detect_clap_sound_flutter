package techmind.studio.detect_clap_sound_flutter;

import android.app.Activity;
import android.content.Context;
import android.media.MediaRecorder;
import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;

import java.io.IOException;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import techmind.studio.detect_clap_sound_flutter.constants.ArgumentConstants;
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

    private int amplitudeThreshold = 18000;

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
     * Listen and detect sound with [amplitudeThreshold].
     * Use [eventSink] to emit event to Flutter.
     * Default [amplitudeThreshold] is 18000 for Clap Sound.
     */
    private void startRecording(MethodCall call, MethodChannel.Result result) {
        recorder = new MediaRecorder();
        recorder.setAudioSource(MediaRecorder.AudioSource.MIC);
        recorder.setOutputFormat(MediaRecorder.OutputFormat.THREE_GPP);
        recorder.setAudioEncoder(MediaRecorder.AudioEncoder.AMR_NB);

        /// Get arguments.
        String path = call.argument(ArgumentConstants.PATH_FILE);
        if (path == null || path.isEmpty()) {
            path = mActivity.getExternalFilesDir(null).getAbsolutePath();
        }

        String fileName = call.argument(ArgumentConstants.FILE_NAME);
        if(fileName == null || fileName.isEmpty()){
            fileName = "music";
        }

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

                    int amplitude = recorder.getMaxAmplitude();

                    if (amplitude >= amplitudeThreshold) {

                        if (eventSink != null) {

                            eventSink.success(1);
                        }
                    }

                    handler.postDelayed(this, 250);
                }
            };
            handler.post(runnable);
            result.success("Recording starting");

        } catch (IOException e) {
            result.error("RECORDING_FAILED", "Recording failed", e.getMessage());
        }
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
}
