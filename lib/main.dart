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

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Error initializing Firebase: $e');
  }

  await Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
    PrefUtils().init(),
    _requestContactPermission(),
  ]);

  runApp(const MyApp());
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
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Sizer(
          builder: (context, orientation, deviceType) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => ThemeProvider()),
                ChangeNotifierProvider(create: (_) => SignUpStepTwoProvider()),
              ],
              child: Consumer<ThemeProvider>(
                builder: (context, provider, child) {
                  return MaterialApp(
                    title: 'moodflow',
                    debugShowCheckedModeBanner: false,
                    theme: ThemeData(
                      textTheme: GoogleFonts.robotoTextTheme(),
                      colorScheme:
                          ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                      useMaterial3: true,
                      appBarTheme: AppBarTheme(
                        systemOverlayStyle: SystemUiOverlayStyle.light,
                      ),
                      cupertinoOverrideTheme: CupertinoThemeData(
                        barBackgroundColor: Colors.transparent,
                        brightness: Brightness.dark,
                      ),
                    ),
                    builder: (context, child) {
                      return MediaQuery(
                        data: MediaQuery.of(context).copyWith(
                          textScaler: TextScaler.linear(1.0),
                        ),
                        child: child!,
                      );
                    },
                    navigatorKey: NavigatorService.navigatorKey,
                    scaffoldMessengerKey: globalMessengerKey,
                    localizationsDelegates: [
                      AppLocalizationDelegate(),
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate
                    ],
                    locale: Locale('en', ''),
                    supportedLocales: [Locale('en', '')],
                    initialRoute: AppRoutes.initialRoute,
                    routes: AppRoutes.routes,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
