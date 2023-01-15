import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
\import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:optimal_routing/pages/explain_page.dart';
import 'package:optimal_routing/pages/game_page_layers.dart';
import 'package:optimal_routing/pages/level_page_layers_v4.dart';
import 'package:optimal_routing/utils/ads.dart';
import 'package:optimal_routing/utils/prefs.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'consts/styles.dart';

Future<void> initFirebaseAdmob() async {
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
    if (!kIsWeb) Ads.createRewardedAd();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initFirebaseAdmob();
  await Prefs.init();
  if (Prefs.getInt('lamps') == null) Prefs.setInt('lamps', 1000000);
  //if(Prefs.getInt("lamps") == null)
  //Prefs.setInt("lamps", 20);
  //Prefs.clear();// TODO remove
  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://a8c1056062c345239476ea6986608faf@o625447.ingest.sentry.io/6255950';
    },
    appRunner: () => runApp(const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<bool> init(context) async {
    return true;
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Routes',
      theme: Style.theme1,
      home: Builder(
        builder: (BuildContext context) {
          Style.init(context);
          if (!kIsWeb) Style.changeStatusBarColor(context);

          return kIsWeb
              ? const GamePage(level: 0)
              : ((Prefs.getBool("new") ?? true) ? const ExplainPage() : const LevelPageV4());
        },
      ),
    );
  }
}
