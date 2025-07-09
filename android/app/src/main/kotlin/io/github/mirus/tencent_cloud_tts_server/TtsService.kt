package io.github.mirus.tencent_cloud_tts_server

import android.media.AudioFormat
import android.speech.tts.*
import android.util.Log

import java.util.Locale
import kotlin.math.min

import kotlinx.coroutines.runBlocking

const val SAMPLE_RATE = 16000

class HttpTtsService : TextToSpeechService() {
    companion object {
        const val DEFAULT_VOICE_NAME = "DEFAULT"
    }

    private lateinit var tencentTtsController: TencentTTSController

    override fun onCreate() {
        super.onCreate()

        tencentTtsController = TencentTTSController(this)
    }

    override fun onGetDefaultVoiceNameFor(lang: String, country: String, variant: String): String {
        return DEFAULT_VOICE_NAME
    }

    override fun onGetVoices(): MutableList<Voice> {
        val supportedLocale = Locale("zho", "CN")
        val voice = Voice(
            DEFAULT_VOICE_NAME,
            supportedLocale,
            Voice.QUALITY_NORMAL,
            Voice.LATENCY_NORMAL,
            true,
            emptySet()
        )
        return mutableListOf(voice)
    }

    override fun onIsValidVoiceName(voiceName: String): Int {
        val isDefault = voiceName == DEFAULT_VOICE_NAME
        if (isDefault) return TextToSpeech.SUCCESS

        return TextToSpeech.ERROR
    }

    override fun onIsLanguageAvailable(lang: String?, country: String?, variant: String?): Int {
        if (lang == "zho" && country == "CHN") {
            return TextToSpeech.LANG_AVAILABLE
        }
        return TextToSpeech.LANG_NOT_SUPPORTED
    }

    override fun onGetLanguage(): Array<String> {
        return arrayOf("zho", "CHN", "")
    }

    override fun onLoadLanguage(lang: String?, country: String?, variant: String?): Int {
        return onIsLanguageAvailable(lang, country, variant)
    }

    override fun onStop() {

    }

    override fun onSynthesizeText(request: SynthesisRequest?, callback: SynthesisCallback?) {
        if (request == null || callback == null) {
            return
        }
        if (callback.start(SAMPLE_RATE, AudioFormat.ENCODING_PCM_16BIT, 1) == TextToSpeech.ERROR) {
            Log.e("callback.start", "unknown error")
        }
        val bytes = tencentTtsController
            .synthesize(request.charSequenceText.toString())
            .getOrElse { err ->
                // TODO: Push notification
                Log.e("onSynthesizeText", err.toString())
                callback.error()
                return
            }

        var offset = 0
        while (offset < bytes.size) {
            val chunkSize = min(callback.maxBufferSize, bytes.size - offset)
            val chunk = bytes.copyOfRange(offset, offset + chunkSize)
            if (callback.audioAvailable(chunk, 0, chunk.size) == TextToSpeech.ERROR) {
                Log.e("callback.audioAvailable", "unknown error")
                return
            }
            offset += chunkSize
        }

        if (callback.done() == TextToSpeech.ERROR) {
            Log.e("callback.done", "unknown error")
            return
        }
    }
}
