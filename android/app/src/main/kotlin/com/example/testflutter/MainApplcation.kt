package com.example.testflutter

import android.R
import android.app.Application
import com.netcore.android.Smartech
import com.netcore.android.smartechpush.SmartPush
import com.netcore.android.smartechpush.notification.SMTNotificationOptions
import com.netcore.smartech_appinbox.SmartechAppinboxPlugin
import com.netcore.smartech_base.SmartechBasePlugin
import com.netcore.smartech_push.SmartechPushPlugin
import io.hansel.core.logger.HSLLogLevel
import java.lang.String
import java.lang.ref.WeakReference
import kotlin.Any
import kotlin.Exception


class MainApplcation:Application() {
    override fun onCreate() {
        super.onCreate()

        val smartech = Smartech.getInstance(WeakReference(this))
        smartech.initializeSdk(this)
        smartech.trackAppInstallUpdateBySmartech()
        smartech.setDebugLevel(9)



        SmartechBasePlugin.initializePlugin(this)
        SmartechPushPlugin.initializePlugin(this)
        SmartechAppinboxPlugin.initializePlugin(this)




       
        // enabling logs for nudges product
        HSLLogLevel.all.isEnabled = true
        HSLLogLevel.mid.isEnabled = true
        HSLLogLevel.debug.isEnabled = true




        val options = SMTNotificationOptions(this)
        options.brandLogo = ""//e.g.logo is sample name for brand logo
        options.largeIcon = "icon_nofification"//e.g.ic_notification is sample name for large icon
        options.smallIcon = "ic_action_play"//e.g.ic_action_play is sample name for icon
        options.smallIconTransparent = "ic_action_play"//e.g.ic_action_play is sample name for transparent small icon
        options.transparentIconBgColor = "#FF0000"
        options.placeHolderIcon = "ic_notification"//e.g.ic_notification is sample name for placeholder icon
        SmartPush.getInstance(WeakReference(this)).setNotificationOptions(options)




    }
}