import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:optimal_routing/consts/styles.dart';
import 'package:optimal_routing/pages/explain_page.dart';
import 'package:optimal_routing/utils/prefs.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'pages/level_page.dart';

Future<void> main() async {
  await SentryFlutter.init(
        (options) {
      options.dsn = 'https://a8c1056062c345239476ea6986608faf@o625447.ingest.sentry.io/6255950';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(const MyApp()),
  );

  // or define SENTRY_DSN via Dart environment variable (--dart-define)
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<void> initializeDefault() async {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyAbn5MA2ZVal35qZBO0pvZRWCFj4X2K1kw",
            authDomain: "routes-ce6ef.firebaseapp.com",
            projectId: "routes-ce6ef",
            storageBucket: "routes-ce6ef.appspot.com",
            messagingSenderId: "655739182965",
            appId: "1:655739182965:web:4be3bddd18f675362f3d3c",
            measurementId: "G-5WDJ5DJHFX"),
      );
    } else {
     MobileAds.instance.initialize();
     Firebase.initializeApp();
    }
  }

  Future<bool> init(context) async {
    await initializeDefault();
    await Prefs.init();
    Style.init(context);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage('assets/icon.png'), context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Routes',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: FutureBuilder(
          future: init(context),
          builder: (context, snapshot) {

            return snapshot.hasData
                ? ((Prefs.getBool("new") ?? true)
                    ? const ExplainPage()
                    : const LevelPage())
                : Container(
                    color: Style.backgroundColor,
                  child: Center(
                    child: SizedBox(
                      width: 150,
                      height: 150,
                      child: Image.asset("assets/icon.png"),
                    ),
                  ),
                  );
          }),
    );
  }
}
