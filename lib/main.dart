import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'firebase_options.dart';
import 'core/app_export.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'presentation/statistics_mood_charts_screen/statisticsmood_tab_page.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
    PrefUtils().init()
  ]);
  runApp(const MyApp());
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
            return ChangeNotifierProvider<ThemeProvider>(
              create: (context) => ThemeProvider(),
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
