package io.github.mirus.tencent_cloud_tts_server

import java.nio.charset.StandardCharsets
import java.security.MessageDigest

fun sha256Hex(s: String): String {
    val md = MessageDigest.getInstance("SHA-256")
    val b = s.toByteArray(StandardCharsets.UTF_8)
    val d = md.digest(b)
    return d.toHexString()
}