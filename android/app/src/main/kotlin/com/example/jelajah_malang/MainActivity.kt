package com.example.jelajah_malang

import android.content.ActivityNotFoundException
import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Menerima perintah "bukaUrl" dari Flutter (maps_service.dart)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "jelajah_malang/maps")
            .setMethodCallHandler { call, result ->
                if (call.method == "bukaUrl") {
                    val url = call.argument<String>("url")
                    try {
                        // Membuka link Google Maps di aplikasi Maps / browser
                        startActivity(Intent(Intent
                        .ACTION_VIEW, Uri.parse(url)))
                        result.success(true)
                    } catch (e: ActivityNotFoundException) {
                        result.success(false)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }
}