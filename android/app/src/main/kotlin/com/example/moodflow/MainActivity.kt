package com.example.moodflow

import android.content.Intent
import android.provider.Settings
import com.google.android.gms.maps.MapsInitializer
import com.google.firebase.remoteconfig.FirebaseRemoteConfig
import com.google.firebase.remoteconfig.FirebaseRemoteConfigSettings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "app_settings"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Initialize Remote Config
        val remoteConfig = FirebaseRemoteConfig.getInstance()
        val configSettings = FirebaseRemoteConfigSettings.Builder()
            .setMinimumFetchIntervalInSeconds(0)
            .build()
        remoteConfig.setConfigSettingsAsync(configSettings)
        
        // Set default values
        val defaults = mapOf(
            "spotify_client_id" to "826c83b9cc66470b98e91492884bab68",
            "spotify_client_secret" to "95bed038b55d4a519d328c4dfe032ce0",
            "youtube_api_key" to "AIzaSyABz9tCdUz29okHDMNQYEMX-LuvNUtjZZw",
            "unsplash_api_key" to "eyfC5QB1_xUKVD3T4v1fBbFtxFrs514GA1WXTUsFHvg",
            "tmdb_api_key" to "d333a0b62b637851256f90a16c56f448",
            "gemini_api_key" to "AIzaSyDEJ-TeTsk73dHZ9-IJFdPv2QSpmwEjCiI",
            "google_api_key" to "AIzaSyDZcRuk8N_f5lXL9EFvEyDzMP3QJYpuov4",
            "search_engine_id" to "017576662512468239146:omuauf_lfve",
            "google_maps_api_key" to "AIzaSyABz9tCdUz29okHDMNQYEMX-LuvNUtjZZw"
        )
        remoteConfig.setDefaultsAsync(defaults)
        
        // Fetch and activate Remote Config
        remoteConfig.fetchAndActivate().addOnCompleteListener { task ->
            if (task.isSuccessful) {
                // Initialize Google Maps with the key from Remote Config
                val mapsApiKey = remoteConfig.getString("google_maps_api_key")
                MapsInitializer.initialize(applicationContext)
            }
        }
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "openAccessibilitySettings") {
                val intent = Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
                intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                startActivity(intent)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }
} 