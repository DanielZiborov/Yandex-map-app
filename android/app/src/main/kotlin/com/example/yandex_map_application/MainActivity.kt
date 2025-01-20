package com.example.yandex_map_application

import io.flutter.embedding.android.FlutterActivity

import android.app.Application

import com.yandex.mapkit.MapKitFactory

class MainApplication: Application() {
  override fun onCreate() {
    super.onCreate()
    MapKitFactory.setLocale("YOUR_LOCALE") // Your preferred language. Not required, defaults to system language
    MapKitFactory.setApiKey("20b56f2e-29c8-4fd1-a2a3-bce52cfeb186") // Your generated API key
  }
}
