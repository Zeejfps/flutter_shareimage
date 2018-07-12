package com.ttuicube.shareimage;

import android.content.Intent;
import android.net.Uri;
import android.support.v4.content.FileProvider;
import android.util.Log;

import java.io.File;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * ShareimagePlugin
 */
public class ShareimagePlugin implements MethodCallHandler {

    private static final String CHANNEL = "plugins/shareimage";

    public static void registerWith(Registrar registrar) {
        MethodChannel channel = new MethodChannel(registrar.messenger(), CHANNEL);
        ShareimagePlugin instance = new ShareimagePlugin(registrar);
        channel.setMethodCallHandler(instance);
    }

    private final Registrar mRegistrar;

    private ShareimagePlugin(Registrar registrar) {
        this.mRegistrar = registrar;
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        if (call.method.equals("share")) {
            if (!(call.arguments instanceof Map)) {
                throw new IllegalArgumentException("Map argument expected");
            }
            // Android does not support showing the share sheet at a particular point on screen.
            share((String) call.argument("path"));
            result.success(null);
        } else {
            result.notImplemented();
        }
    }

    private void share(String path) {

        if (path == null || path.isEmpty()) {
            throw new IllegalArgumentException("Non-empty path expected");
        }

        Intent shareIntent = new Intent(Intent.ACTION_SEND);
        shareIntent.setType("image/*");
        shareIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
        final File photoFile = new File(path);
        Log.d("PLUGIN", photoFile.toString());
        Log.d("PLUGIN", mRegistrar.activeContext().getPackageName());
        Uri fileUri = FileProvider.getUriForFile(mRegistrar.context(), mRegistrar.activeContext().getPackageName(), photoFile);
        Log.d("PLUGIN", fileUri.toString());
        shareIntent.putExtra(Intent.EXTRA_STREAM, fileUri);
        Intent chooserIntent = Intent.createChooser(shareIntent, null);
        if (mRegistrar.activity() != null) {
            mRegistrar.activity().startActivity(chooserIntent);
        } else {
            chooserIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            mRegistrar.context().startActivity(chooserIntent);
        }
    }

}