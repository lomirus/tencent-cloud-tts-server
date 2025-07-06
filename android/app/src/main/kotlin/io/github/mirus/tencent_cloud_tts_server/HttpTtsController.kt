package io.github.mirus.tencent_cloud_tts_server

import java.nio.charset.StandardCharsets
import java.security.InvalidKeyException
import java.security.MessageDigest
import java.security.NoSuchAlgorithmException
import java.io.IOException
import java.time.Instant
import java.time.ZoneId

import javax.crypto.Mac
import javax.crypto.spec.SecretKeySpec

import kotlin.io.encoding.Base64
import kotlin.uuid.ExperimentalUuidApi
import kotlin.uuid.Uuid

import kotlinx.serialization.Serializable
import kotlinx.serialization.SerialName
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.JsonArray

import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import okhttp3.MediaType.Companion.toMediaType

@Serializable
data class SynthesizeRequest(
    @SerialName("Text")
    val text: String,

    @SerialName("SessionId")
    val sessionId: String,
)

@Serializable
data class SynthesizeResponse(
    @SerialName("Response")
    val response: Response,
)

@Serializable
data class Response(
    @SerialName("Audio")
    val audio: String,

    @SerialName("RequestId")
    val requestId: String,

    @SerialName("SessionId")
    val sessionId: String,

    @SerialName("Subtitles")
    val subtitles: JsonArray,
)

@Throws(NoSuchAlgorithmException::class, InvalidKeyException::class)
private fun ByteArray.hmacSha256(msg: String): ByteArray {
    val mac = Mac.getInstance("HmacSHA256")
    val secretKeySpec = SecretKeySpec(this, mac.algorithm)
    mac.init(secretKeySpec)
    return mac.doFinal(msg.toByteArray(StandardCharsets.UTF_8))
}

class TencentTTSController {
    companion object {
        private const val SERVICE = "tts"
        private const val CONTENT_TYPE = "application/json; charset=utf-8"
        private const val HOST = "$SERVICE.tencentcloudapi.com"

        private val client: OkHttpClient = OkHttpClient()
    }

    private val secretId: String = ""
    private val secretKey: String = ""

    @Throws(IOException::class)
    fun doRequest(
        body: SynthesizeRequest,
    ): SynthesizeResponse {
        val requestJson = Json.encodeToString(body)
        val request = buildRequest(requestJson)
        val response = client.newCall(request).execute()
        val responseJson = response.body.string()
        return Json.decodeFromString<SynthesizeResponse>(responseJson)
    }

    @Throws(NoSuchAlgorithmException::class, InvalidKeyException::class)
    fun buildRequest(body: String): Request {
        val timestamp = Instant.now().epochSecond
        val auth = getAuth(timestamp, body)

        return Request.Builder()
            .url("https://$HOST")
            .header("Host", HOST)
            .header("X-TC-Timestamp", timestamp.toString())
            .header("X-TC-Version", "2019-08-23")
            .header("X-TC-Action", "TextToVoice")
            .header("X-TC-RequestClient", "SDK_KOTLIN_BAREBONE")
            .header("Authorization", auth)
            .post(body.toRequestBody(CONTENT_TYPE.toMediaType()))
            .build()
    }

    @Throws(NoSuchAlgorithmException::class, InvalidKeyException::class)
    private fun getAuth(
        timestamp: Long,
        body: String
    ): String {
        val hashedRequestPayload = sha256Hex(body)

        val canonicalRequest = """
            POST
            /
            
            content-type:$CONTENT_TYPE
            host:$HOST

            content-type;host
            $hashedRequestPayload
        """.trimIndent()

        val date = Instant.ofEpochSecond(timestamp)
            .atZone(ZoneId.of("UTC"))
            .toLocalDate()
            .toString()

        val credentialScope = "$date/$SERVICE/tc3_request"
        val hashedCanonicalRequest = sha256Hex(canonicalRequest)

        val stringToSign = """
            TC3-HMAC-SHA256
            $timestamp
            $credentialScope
            $hashedCanonicalRequest
        """.trimIndent()

        val signature = "TC3$secretKey"
            .toByteArray(StandardCharsets.UTF_8)
            .hmacSha256(date)
            .hmacSha256(SERVICE)
            .hmacSha256("tc3_request")
            .hmacSha256(stringToSign)
            .toHexString()

        return "TC3-HMAC-SHA256 Credential=$secretId/$credentialScope, SignedHeaders=content-type;host, Signature=$signature"
    }

    @Throws(NoSuchAlgorithmException::class)
    fun sha256Hex(s: String): String {
        val md = MessageDigest.getInstance("SHA-256")
        val b = s.toByteArray(StandardCharsets.UTF_8)
        val d = md.digest(b)
        return d.toHexString()
    }

    @OptIn(ExperimentalUuidApi::class)
    fun synthesize(text: String): ByteArray {
        val response = doRequest(SynthesizeRequest(
            text = text,
            sessionId = Uuid.random().toString()
        ))
        val audioString = response.response.audio
        val audioByteArray = Base64.Default.decode(audioString)
        return audioByteArray
    }
}