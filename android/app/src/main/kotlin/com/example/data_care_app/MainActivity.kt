package com.example.data_care_app

import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Ensure screenshots are allowed for all screens.
        window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
    }
}
