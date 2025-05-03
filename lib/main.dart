import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'firebase_options.dart';
import 'core/app_export.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'presentation/statistics_mood_charts_screen/statisticsmood_tab_page.dart';
import 'presentation/sign_up_step_two_screen/provider/sign_up_step_two_provider.dart';
import 'package:provider/provider.dart';
import 'core/utils/url_handler.dart';
import 'core/utils/size_utils.dart';
import 'presentation/spotify_screen/provider/spotify_provider.dart';
import 'presentation/sign_up_step_four_screen/provider/sign_up_step_four_provider.dart';
import 'presentation/welcome_screen/welcome_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> globalMessengerKey = GlobalKey<ScaffoldMessengerState>();

/// This is the main entry point of the application.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Initialize URL handler before running the app
  UrlHandler.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SpotifyProvider()),
        ChangeNotifierProvider(
          create: (_) => SignUpStepFourProvider(),
          lazy: false, // Ensure provider is created immediately
        ),
      ],
      child: MyApp(),
    ),
  );
}

Future<void> _requestContactPermission() async {
  final status = await Permission.contacts.request();
  if (status.isDenied) {
    print('Contact permission denied');
  } else if (status.isGranted) {
    print('Contact permission granted');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => MaterialApp(
        theme: theme,
        title: 'MoodFlow',
        debugShowCheckedModeBanner: false,
        navigatorKey: rootNavigatorKey,
        scaffoldMessengerKey: globalMessengerKey,
        builder: (context, child) {
          SizeUtils.init(context);
          // Ensure the navigator key is properly set up
          if (rootNavigatorKey.currentState == null) {
            debugPrint('=== Navigator key not initialized ===');
          } else {
            debugPrint('=== Navigator key initialized successfully ===');
          }
          return child!;
        },
        initialRoute: AppRoutes.welcomeScreen,
        routes: AppRoutes.routes,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
