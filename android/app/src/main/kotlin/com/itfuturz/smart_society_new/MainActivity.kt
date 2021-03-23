package com.itfuturz.mygenie_member
import android.os.Bundle
import android.app.NotificationChannel
import android.app.NotificationManager
import android.media.AudioAttributes
import android.net.Uri
import android.os.Build
import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {

  var notificationManager: NotificationManager? = null


  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {

      val soundUri: Uri = Uri.parse(
              "android.resource://" +
                      applicationContext.packageName +
                      "/" + R.raw.alert)

      val audioAttributes = AudioAttributes.Builder()
              .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
              .setUsage(AudioAttributes.USAGE_ALARM)
              .build()

      val channel = NotificationChannel("noti_push_app_1",
              "noti_push_app",
              NotificationManager.IMPORTANCE_HIGH)
      channel.setSound(soundUri, audioAttributes)
      val notificationManager = getSystemService(NotificationManager::class.java)
      notificationManager.createNotificationChannel(channel)
    }

  }

}