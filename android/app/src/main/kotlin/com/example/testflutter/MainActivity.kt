package com.example.testflutter

import android.os.Bundle
import com.netcore.android.Smartech
import com.netcore.android.smartechpush.SmartPush
import com.netcore.android.smartechpush.pnpermission.SMTNotificationPermissionCallback
import com.netcore.android.smartechpush.pnpermission.SMTPNPermissionConstants
import io.flutter.embedding.android.FlutterActivity
import io.hansel.hanselsdk.Hansel
import java.lang.ref.WeakReference


class MainActivity: FlutterActivity() {

    private val notificationPermissionCallback = object : SMTNotificationPermissionCallback {
        override fun notificationPermissionStatus(status: Int) {
            if(status == SMTPNPermissionConstants.SMT_PN_PERMISSION_GRANTED){
                //Handle the status if needed
            } else {
                //Handle the status if needed
            }
        }
    }
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val isSmartechHandledDeeplink = Smartech.getInstance(WeakReference(this)).isDeepLinkFromSmartech(intent)
        if (!isSmartechHandledDeeplink) {
            //Handle deeplink on app side
        }
        Hansel.pairTestDevice(getIntent().getDataString());
        SmartPush.getInstance(WeakReference(context)).requestNotificationPermission(notificationPermissionCallback)

//Pass the below callback if your app require notification permission granted status else pass null
        SmartPush.getInstance(WeakReference(context)).updateNotificationPermission(SMTPNPermissionConstants.SMT_PN_PERMISSION_GRANTED)

    }
    }



