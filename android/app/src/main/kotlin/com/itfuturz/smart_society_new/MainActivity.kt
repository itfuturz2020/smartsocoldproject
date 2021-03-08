package com.itfuturz.mygenie_member

import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {

  var notificationManager: NotificationManager? = null


  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)

    notificationManager = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
    if (isOreoOrAbove()) {
      setupNotificationChannels();
    }
  }

  @TargetApi(Build.VERSION_CODES.O)
  fun registerNormalNotificationChannel(notificationManager: android.app.NotificationManager) {
    val sound: Uri = Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE.toString() + "://" + getPackageName() + "/raw/alert.mp3")

    val channel_all = NotificationChannel("CHANNEL_ID_ALL", "CHANNEL_NAME_ALL", NotificationManager.IMPORTANCE_HIGH)
    val audioAttributes: AudioAttributes = Builder()
            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
            .setUsage(AudioAttributes.USAGE_ALARM)
            .build()
    channel_all.enableVibration(true)
    channel_all.setSound(sound,audioAttributes)
    notificationManager.createNotificationChannel(channel_all)
    notificationManager.notify(( int ) System. currentTimeMillis () ,
  }

  private fun isOreoOrAbove(): Boolean {
    return android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O
  }

  private fun setupNotificationChannels() {
    registerNormalNotificationChannel(notificationManager)
  }
}