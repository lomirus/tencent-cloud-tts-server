package io.github.mirus.tencent_cloud_tts_server.activities

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.speech.tts.TextToSpeech

const val SAMPLE_TEXT = "这是一个使用腾讯云 TTS 合成的中文语音示例。"

class GetSampleText : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val resultIntent = Intent()
        resultIntent.putExtra(TextToSpeech.Engine.EXTRA_SAMPLE_TEXT, SAMPLE_TEXT)

        setResult(RESULT_OK, resultIntent)
        finish()
    }
}