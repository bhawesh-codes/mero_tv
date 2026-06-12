package com.bhawesh.mero_tv

import android.app.PictureInPictureParams
import android.content.res.Configuration
import android.media.MediaCodecList
import android.os.Build
import android.util.Rational
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val PIP_CHANNEL = "mero_tv/pip"
    private val MEDIA_CHANNEL = "mero_tv/media_cleanup"
    
    private var pipMethodChannel: MethodChannel? = null
    private var mediaMethodChannel: MethodChannel? = null
    private var pipEnabled = false  // only true while streaming

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // PiP Channel
        pipMethodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            PIP_CHANNEL
        )

        pipMethodChannel!!.setMethodCallHandler { call, result ->
            when (call.method) {
                "enterPip" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        val params = PictureInPictureParams.Builder()
                            .setAspectRatio(Rational(16, 9))
                            .build()
                        enterPictureInPictureMode(params)
                        result.success(true)
                    } else {
                        result.error("UNSUPPORTED", "PiP not supported", null)
                    }
                }
                "setPipEnabled" -> {
                    pipEnabled = call.arguments as Boolean
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }

        // Media Cleanup Channel - FIXES THE DECODER STUCK ISSUE
        mediaMethodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            MEDIA_CHANNEL
        )

        mediaMethodChannel!!.setMethodCallHandler { call, result ->
            when (call.method) {
                "forceReleaseCodecs" -> {
                    try {
                        // This forces MediaCodec to refresh its list,
                        // releasing any stuck decoder instances
                        MediaCodecList(MediaCodecList.ALL_CODECS)
                        result.success(true)
                    } catch (e: Exception) {
                        result.success(false)
                    }
                }
                "requestGc" -> {
                    try {
                        // Request garbage collection to clean up references
                        System.gc()
                        Runtime.getRuntime().gc()
                        result.success(true)
                    } catch (e: Exception) {
                        result.success(false)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    // Fires ONLY on home button press, not notification drawer
    override fun onUserLeaveHint() {
        super.onUserLeaveHint()
        if (pipEnabled && Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val params = PictureInPictureParams.Builder()
                .setAspectRatio(Rational(16, 9))
                .build()
            enterPictureInPictureMode(params)
        }
    }

    // Notify Flutter when PiP mode changes so it can hide/show UI
    override fun onPictureInPictureModeChanged(
        isInPictureInPictureMode: Boolean,
        newConfig: Configuration
    ) {
        super.onPictureInPictureModeChanged(isInPictureInPictureMode, newConfig)
        pipMethodChannel?.invokeMethod(
            "onPipChanged",
            mapOf("isInPip" to isInPictureInPictureMode)
        )
    }
}