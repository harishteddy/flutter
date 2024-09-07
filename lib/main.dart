import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:smartech_appinbox/model/smt_appinbox_model.dart';
import 'package:smartech_appinbox/smartech_appinbox.dart';
import 'package:smartech_base/smartech_base.dart';
import 'package:smartech_nudges/listener/px_listener.dart';
import 'package:smartech_nudges/netcore_px.dart';
import 'package:smartech_nudges/px_widget.dart';
import 'package:smartech_nudges/tracker/route_obersver.dart';
import 'package:smartech_push/smartech_push.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smartech_push/smt_notification_callback.dart';

@pragma('vm:entry-point')

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //await Firebase.initializeApp();
  bool isFromSmt = await SmartechPush().isNotificationFromSmartech(message.data.toString());
  if (isFromSmt) {
    SmartechPush().handlePushNotification(message.data.toString());
    print("pnbackground mode :" + message.data.toString());
    return;
  }
  // Handle if not from Smartech
}

Future<void> main() async {

  runApp(const MyApp());


  print("smt1");



  List<MessageCategory> categoryList = [];
  SmartechAppinbox().getAppInboxCategoryWiseMessageList(categoryList: categoryList?.where((element) => element.selected).map((e) => e.name).toList() ?? []).then((value) {
    // Here you will get list of  appinbox messages according to selected category list
    print("response app inbox4"+value.toString());
  });
  SmartechAppinbox().getAppInboxMessagesByApiCall(
      messageLimit:  10,
      smtInboxDataType:  "all",
      categoryList: categoryList.where((element) => element.selected).map((e) => e.name).toList()).then((value) {
    // Here you will get list of app inbox messages
    print("response app inbox3"+value.toString()+categoryList.toString());
  });

  SmartechAppinbox().getAppInboxMessages().then((value) {
    // Here you will get list of all appinbox messages from local db
    print("response app inbox"+value.toString());
  });

  SmartechAppinbox().getAppInboxCategoryList().then((value) {
    // Here you will get list of available categories for appinbox messages
    print("response1 app inbox"+value.toString());


  });


  Smartech().onHandleDeeplink((String? smtDeeplinkSource, String? smtDeeplink, Map<dynamic, dynamic>? smtPayload, Map<dynamic, dynamic>? smtCustomPayload) async {
// Perform action on click of Notification

    print("smtDeeplinkSource value :" + smtDeeplink.toString()+smtPayload.toString());

  });



  // Push notification

  print("pndata :");

  SmartechPush().updateNotificationPermission();

  await Firebase.initializeApp(); // Initialize Firebase here

  final androidToken = await FirebaseMessaging.instance.getToken();
  if (androidToken != null) {
    SmartechPush().setDevicePushToken(androidToken);
    print("pndata :" + androidToken);

  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    bool isFromSmt = await SmartechPush().isNotificationFromSmartech(message.data.toString());
    if (isFromSmt) {
      SmartechPush().handlePushNotification(message.data.toString());
      print("pnforeground mode :" + message.data.toString());
      return;
    }
    // Handle if not from Smartech
  });





/*
// For foreground state
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {

    print("pndata12 :");
    bool isFromSmt = await SmartechPush().isNotificationFromSmartech(message.data.toString());
    if(isFromSmt){
      SmartechPush().handlePushNotification(message.data.toString());
      print("fg pndata :" + message.data.toString());

      print("pndata :2");
      return;
    }
    // handle if not from Smartech
  });


// For background/terminated state
  @pragma('vm:entry-point')
  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("pndata13:");
    await Firebase.initializeApp();
    bool isFromSmt = await SmartechPush().isNotificationFromSmartech(message.data.toString());
    if(isFromSmt){
      SmartechPush().handlePushNotification(message.data.toString());
      print("bg pndata :" + message.data.toString());

      print("pndata3 :");
      return;
    }
    // handle if not from Smartech
  }
*/
 

}

class _PxDeeplinkListenerImpl extends PxDeeplinkListener {
  @override
  void onLaunchUrl(String url) {
    debugPrint('PXDeeplink: $url');
  }
}

class _PxActionListenerImpl extends PxActionListener {

  @override
  void onActionPerformed(String action) {
    debugPrint('PXAction: $action');
  }
}

class _PxInternalEventsListener extends PxInternalEventsListener {

  @override
  void onEvent(String eventName, Map dataFromHansel) {

    Map<String, dynamic> newMap = Map<String, dynamic>. from(dataFromHansel.map ((key, value) {
      return MapEntry (key.toString(), value);
    }));
    Smartech().trackEvent(eventName, newMap);
    debugPrint('PXEvent: $eventName eventData : $dataFromHansel');
  }
}
class MyApp extends StatelessWidget {

  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    NetcorePX.instance.registerPxActionListener("flutter action",_PxActionListenerImpl());
    NetcorePX.instance.registerPxInternalEventsListener(_PxInternalEventsListener());
    NetcorePX.instance.registerPxDeeplinkListener(_PxDeeplinkListenerImpl());
    NetcorePX.instance.enableDebugLogs();
    NetcorePX.instance.enableHierarchyLogs();


    SmartechPush().requestNotificationPermission(MyNotificationPermissionCallback());







    //NetcorePX.instance.setUserId("harishreddy.rudru@gmail.com");
    print("smtDeeplinkSource value");




    return SmartechPxWidget(
      child: MaterialApp(
        title: 'Flutter Demo',
        navigatorObservers: [PxNavigationObserver()],
        theme: ThemeData(

          primarySwatch: Colors.blue,
        ),

        home: const MyHomePage(title: 'Flutter Demo Home Page'),

      ),
    );
  }
}

class MyNotificationPermissionCallback implements SMTNotificationPermissionCallback {
  @override
  void notificationPermissionStatus(int status) {
    print('Permission status: $status');
  }
}

class MyHomePage extends StatefulWidget {

  const MyHomePage({super.key, required this.title});



  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  void _incrementCounter() {
    setState(() {



      _counter++;
      var payload = {

      "firstname":"test",
      "LastName":"test",
        "Version_Code":1.5,
        "V_Code":1.5
      };
      Smartech().trackEvent("flutter_nudges", payload);

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,

        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}