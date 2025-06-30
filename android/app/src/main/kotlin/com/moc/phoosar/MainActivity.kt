package com.moc.phoosar

import android.os.Bundle
import android.util.Log
import com.tiktok.TikTokBusinessSdk
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONObject
import com.tiktok.appevents.base.TTBaseEvent


class MainActivity : FlutterActivity() {
    private val CHANNEL = "tiktok_events"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                try {
                    when (call.method) {
                        "trackEvent" -> handleTrackEvent(call, result)
                        "trackPurchase" -> handleTrackPurchase(call, result)
                        "setUserData" -> handleSetUserData(call, result)
                        else -> result.notImplemented()
                    }
                } catch (e: Exception) {
                    result.error("TIKTOK_ERROR", e.message, null)
                }
            }
    }

    private fun handleTrackEvent(call: MethodCall, result: MethodChannel.Result) {
        val eventName = call.argument<String>("eventName") ?: ""
        val properties = call.argument<Map<String, Any>>("properties") ?: emptyMap()

        val builder = TTBaseEvent.newBuilder(eventName)
        for ((key, value) in properties) {
            builder.addProperty(key, value)
        }
        Log.d("EventTracking", "Tracking TTEvent: ${eventName}")
        TikTokBusinessSdk.trackTTEvent(builder.build())
        result.success(null)
    }

    private fun handleTrackPurchase(call: MethodCall, result: MethodChannel.Result) {
        Log.d("HandleTrackPurchase", "TestHandleTrackPurchase")
        val value = call.argument<Double>("value") ?: 0.0
        val currency = call.argument<String>("currency") ?: "USD"
        val properties = call.argument<Map<String, Any>>("properties") ?: emptyMap()

        val builder = TTBaseEvent.newBuilder("Purchase")
            .addProperty("value", value)
            .addProperty("currency", currency)

        for ((key, value) in properties) {
            builder.addProperty(key, value)
        }

        TikTokBusinessSdk.trackTTEvent(builder.build())
        result.success(null)
    }

    private fun handleSetUserData(call: MethodCall, result: MethodChannel.Result) {
        Log.d("HandleTrackUserData", "TestHandleTrackUserData")
        val builder = TTBaseEvent.newBuilder("SetUserData")

        call.argument<String>("externalId")?.let { builder.addProperty("external_id", it) }
        call.argument<String>("email")?.let { builder.addProperty("email", it) }
        call.argument<String>("phone")?.let { builder.addProperty("phone", it) }

        Log.d("EventTracking", "Tracking TTEvent")
        TikTokBusinessSdk.trackTTEvent(builder.build())
        result.success(null)
    }

    private fun convertMapToJson(map: Map<String, Any>): JSONObject {
        val json = JSONObject()
        for ((key, value) in map) {
            json.put(key, value)
        }
        return json
    }
}
