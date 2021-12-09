package com.proxmox.app.pve_flutter_frontend

import android.content.ActivityNotFoundException
import android.content.Intent
import androidx.annotation.NonNull
import androidx.core.view.WindowCompat;
import androidx.core.splashscreen.SplashScreen;
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import androidx.core.splashscreen.SplashScreenViewProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import androidx.core.content.FileProvider
import android.util.Log
import android.os.Environment;
import android.os.Bundle;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

class MainActivity: FlutterActivity() {

    private val CHANNEL = "com.proxmox.app.pve_flutter_frontend/filesharing"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
                // Note: this method is invoked on the main thread.
                Log.d("METHODCHANNEL", call.method)
                if (call.method == "shareFile") {
                    val serializedShortcuts: Map<String, String> = call.arguments()
                    val path: String = serializedShortcuts.get("path")!!;
                    val type: String = serializedShortcuts.get("type")!!;
                    try {
                        shareFile(path, type);
                        result.success(null);
                    } catch (e: ActivityNotFoundException) {
                        result.error("ActivityNotFoundException", "", null);
                    } catch (e: Exception) {
                        result.error("PlatformException", "", null);
                    }
                } else {
                    result.notImplemented()
                }
            }
        }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState);

        val splashScreen = installSplashScreen()

        // Aligns the Flutter view vertically with the window.
        WindowCompat.setDecorFitsSystemWindows(getWindow(), false)

        splashScreen.setOnExitAnimationListener { splashScreenView -> splashScreenView.remove() }
    }

    fun shareFile(path:String, type:String){
        var file = File(path);
        val uri = FileProvider.getUriForFile(this, "com.proxmox.app.pve_flutter_frontend.provider", file);
        val viewFileIntent = Intent(Intent.ACTION_VIEW);
        viewFileIntent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_GRANT_READ_URI_PERMISSION);
        viewFileIntent.setDataAndType(uri, type);
        startActivity(viewFileIntent);
    }
}
