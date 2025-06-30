package io.github.mirus.tencent_cloud_tts_server

import android.content.Context;
import android.speech.tts.*

import com.tencent.cloud.libqcloudtts.TtsController
import com.tencent.cloud.libqcloudtts.TtsMode
import com.tencent.cloud.libqcloudtts.TtsResultListener
import com.tencent.cloud.libqcloudtts.TtsError
import com.tencent.cloud.libqcloudtts.engine.offlineModule.auth.QCloudOfflineAuthInfo


class HttpTtsService : TextToSpeechService() {
    private lateinit var mTtsController: TtsController

    override fun onCreate() {
        super.onCreate()
        mTtsController = TtsController.getInstance()
    }

    override fun onIsLanguageAvailable(lang: String?, country: String?, variant: String?): Int {
        if (lang === "eng" || lang === "zho") {
            return TextToSpeech.LANG_AVAILABLE
        }
        return TextToSpeech.LANG_NOT_SUPPORTED
    }

    override fun onGetLanguage(): Array<String> {
        return arrayOf("eng", "zho")
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
    }
}
