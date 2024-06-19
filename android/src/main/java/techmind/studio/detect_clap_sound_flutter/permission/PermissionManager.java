package techmind.studio.detect_clap_sound_flutter.permission;

import android.Manifest;
import android.app.Activity;
import android.content.pm.PackageManager;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;

import io.flutter.plugin.common.PluginRegistry;
import techmind.studio.detect_clap_sound_flutter.constants.MethodConstants;

public class PermissionManager implements PluginRegistry.RequestPermissionsResultListener {

    private PermissionResultCallback resultCallback;

    private Activity activity;


    @Override
    public boolean onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {

        if (requestCode == MethodConstants.RECORD_AUDIO_REQUEST_CODE && resultCallback != null) {

            boolean granted = grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED;

            resultCallback.onResult(granted);
            resultCallback = null;
            return true;
        }

        return false;
    }


    public void setActivity(Activity value) {
        this.activity = value;
    }


    /** [hasPermission]
     * To check and request Record permisison if not granted. */
    public void hasPermission(PermissionResultCallback resultCallback) {
        if (this.activity == null) {
            resultCallback.onResult(false);
        }

        if (!isPermissionGranted(activity)) {
            this.resultCallback = resultCallback;
            ActivityCompat.requestPermissions(activity, new String[]{Manifest.permission.RECORD_AUDIO}, MethodConstants.RECORD_AUDIO_REQUEST_CODE);
        } else {
            resultCallback.onResult(true);
        }

    }


    /** [isPermissionGranted]
     * To get status Record permission. */
    public boolean isPermissionGranted(Activity vActivity) {
        int result = ActivityCompat.checkSelfPermission(vActivity, Manifest.permission.RECORD_AUDIO);
        return result == PackageManager.PERMISSION_GRANTED;
    }


}
