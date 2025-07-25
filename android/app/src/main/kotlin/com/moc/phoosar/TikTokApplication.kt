package com.moc.phoosar

import android.app.Application
import android.util.Log
import com.tiktok.TikTokBusinessSdk
import com.tiktok.TikTokBusinessSdk.TTConfig
import com.tiktok.appevents.base.TTBaseEvent
import org.json.JSONObject

class TikTokApplication : Application() {

    override fun onCreate() {
        super.onCreate()
        System.setProperty("java.net.preferIPv4Stack", "true")

        val ttConfig = TTConfig(applicationContext)
            .setAppId("com.moc.updatephoosar")
            .setTTAppId("7519743096805097473")
//            .openDebugMode()
//            .setLogLevel(TikTokBusinessSdk.LogLevel.DEBUG)

        TikTokBusinessSdk.initializeSdk(ttConfig, object : TikTokBusinessSdk.TTInitCallback {
            override fun success() {
                Log.d("TikTokSDK", "Initialization successful")
            }

            override fun fail(code: Int, msg: String?) {
                Log.e("TikTokSDK", "Initialization failed: $code - $msg")
            }
        })
        TikTokBusinessSdk.startTrack()
    }

}
