// ignore_for_file: prefer_const_constructors, todo

import 'package:animations/animations.dart';
import 'package:aplikasi_keuangan_gereja/pages/admins/home/home.dart';
import 'package:aplikasi_keuangan_gereja/pages/auth/loginactivation.dart';
import 'package:aplikasi_keuangan_gereja/services/apiservices.dart';
import 'package:aplikasi_keuangan_gereja/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

import 'globals.dart';

//TODO: Run This For Flutter Native Splash (after flutter pub get)
//flutter pub run flutter_native_splash:create

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive,
  //     overlays: [SystemUiOverlay.bottom]);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserAuth(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserAuthentication(),
        ),
        ChangeNotifierProvider(
          create: (_) => QRScannerValue(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Keuangan Gereja",
        theme: ThemeData(
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              primary: buttonColor,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              textStyle: GoogleFonts.nunito(
                  color: lightText,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  letterSpacing: 0.125),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          scaffoldBackgroundColor: scaffoldBackgroundColor,
          cardColor: cardColor,
          textTheme: GoogleFonts.nunitoTextTheme(
            TextTheme(
              headline1: GoogleFonts.nunito(
                color: darkText,
                fontWeight: FontWeight.w700,
                fontSize: 101,
                letterSpacing: -0.15,
              ),
              headline2: GoogleFonts.nunito(
                color: darkText,
                fontWeight: FontWeight.w700,
                fontSize: 63,
                letterSpacing: -0.015,
              ),
              headline3: GoogleFonts.nunito(
                color: darkText,
                fontWeight: FontWeight.w700,
                fontSize: 50,
                letterSpacing: 0.0,
              ),
              headline4: GoogleFonts.nunito(
                color: darkText,
                fontWeight: FontWeight.w700,
                fontSize: 36,
                letterSpacing: 0.025,
              ),
              headline5: GoogleFonts.nunito(
                color: darkText,
                fontWeight: FontWeight.w700,
                fontSize: 25,
                letterSpacing: 0,
              ),
              headline6: GoogleFonts.nunito(
                color: darkText,
                fontWeight: FontWeight.w700,
                fontSize: 21,
                letterSpacing: 0.015,
              ),
              subtitle1: GoogleFonts.nunito(
                color: darkText,
                fontWeight: FontWeight.normal,
                fontSize: 17,
                letterSpacing: 0.015,
              ),
              subtitle2: GoogleFonts.nunito(
                color: darkText,
                fontWeight: FontWeight.w500,
                fontSize: 15,
                letterSpacing: 0.01,
              ),
              bodyText1: GoogleFonts.nunito(
                color: lightText,
                fontWeight: FontWeight.normal,
                fontSize: 17,
                letterSpacing: 0.05,
              ),
              bodyText2: GoogleFonts.nunito(
                  color: darkText,
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                  letterSpacing: 0.025),
              button: GoogleFonts.nunito(
                color: primaryColorVariant,
                fontWeight: FontWeight.w500,
                fontSize: 14,
                letterSpacing: 0.125,
              ),
              caption: GoogleFonts.nunito(
                color: darkText,
                fontWeight: FontWeight.normal,
                fontSize: 12,
                letterSpacing: 0.04,
              ),
              overline: GoogleFonts.nunito(
                color: darkText,
                fontWeight: FontWeight.normal,
                fontSize: 10,
                letterSpacing: 0.15,
              ),
            ),
          ),
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(primary: primaryColor, secondary: primaryColorVariant),
        ).copyWith(
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: <TargetPlatform, PageTransitionsBuilder>{
              TargetPlatform.android: ZoomPageTransitionsBuilder(),
              TargetPlatform.windows: SharedAxisPageTransitionsBuilder(
                  transitionType: SharedAxisTransitionType.horizontal),
            },
          ),
        ),
        home: MyApp(),
      ),
    ),
  );
}

class QRScannerValue with ChangeNotifier {
  String _qrValue = "";

  String get qrValue => _qrValue;

  void setQRValue(val) {
    _qrValue = val;
    notifyListeners();
  }
}

class UserAuth with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void setIsLoggedIn(val) {
    _isLoggedIn = val;
    notifyListeners();
  }
}

class UserAuthentication with ChangeNotifier {
  String _loginStatus = "false";
  String _kodeUser = "";
  String _kodeGereja = "";

  String get loginStatus => _loginStatus;
  String get kodeUser => _kodeUser;
  String get kodeGereja => _kodeGereja;

  void setUserAuthentication(loginStatus, kodeUser, kodeGereja) {
    _loginStatus = loginStatus;
    _kodeUser = kodeUser;
    _kodeGereja = kodeGereja;
    notifyListeners();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ServicesUser servicesUser = ServicesUser();

  @override
  void initState() {
    // TODO: implement initState
    getPrefAuth().then((value) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        context.read<UserAuth>().setIsLoggedIn(userStatus);
        FlutterNativeSplash.remove();
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future getPrefAuth() async {
    final prefs = await SharedPreferences.getInstance();
    userStatus = prefs.getBool('userStatus') ?? false;
    kodeUser = prefs.getString('kodeUser') ?? "";
    kodeGereja = prefs.getString('kodeGereja') ?? "";
  }

  @override
  Widget build(BuildContext context) {
    if (context.watch<UserAuth>().isLoggedIn) {
      debugPrint(context.watch<UserAuth>().isLoggedIn.toString());
      debugPrint("$userStatus, $kodeUser, $kodeGereja");
      return AdminHome();
    } else {
      debugPrint(context.watch<UserAuth>().isLoggedIn.toString());
      debugPrint("$userStatus, $kodeUser, $kodeGereja");
      return LoginActivationController();
    }
  }
}
