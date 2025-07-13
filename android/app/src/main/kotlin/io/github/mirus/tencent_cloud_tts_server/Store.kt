package io.github.mirus.tencent_cloud_tts_server

import android.content.Context
import android.content.SharedPreferences

class Store(context: Context) {
    companion object {
        private const val KEY_SECRET_ID = "flutter.secretId"
        private const val KEY_SECRET_KEY = "flutter.secretKey"
        private const val KEY_VOICE_TYPE = "flutter.voiceType"
    }

    private val prefs: SharedPreferences = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)

    fun getSecretKey(): String? {
        return prefs.getString(KEY_SECRET_KEY, null)
    }

    fun getSecretId(): String? {
        return prefs.getString(KEY_SECRET_ID, null)
    }

    fun getVoiceType(): Long {
        return prefs.getLong(KEY_VOICE_TYPE, 0)
    }
}