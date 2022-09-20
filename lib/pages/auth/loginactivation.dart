//ignore_for_file: todo

import 'package:aplikasi_keuangan_gereja/globals.dart';
import 'package:aplikasi_keuangan_gereja/main.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/apiservices.dart';
import '../../themes/colors.dart';
import '../../widgets/responsivetext.dart';

class LoginActivationController extends StatefulWidget {
  const LoginActivationController({Key? key}) : super(key: key);

  @override
  State<LoginActivationController> createState() =>
      _LoginActivationControllerState();
}

class _LoginActivationControllerState extends State<LoginActivationController> {
  final _controllerPageLoginActivation = PageController(initialPage: 0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controllerPageLoginActivation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controllerPageLoginActivation,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        LoginPage(
          controllerPageLoginActivation: _controllerPageLoginActivation,
        ),
        ActivationPage(
          controllerPageLoginActivation: _controllerPageLoginActivation,
        ),
      ],
    );
  }
}

class LoginPage extends StatefulWidget {
  final PageController controllerPageLoginActivation;
  const LoginPage({Key? key, required this.controllerPageLoginActivation})
      : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  ServicesUser servicesUser = ServicesUser();
  final _controllerUsername = TextEditingController();
  final _controllerPassword = TextEditingController();

  bool _passwordVisible = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controllerUsername.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  Future getAuth(username, password) async {
    var response = await servicesUser.getAuth(username, password);
    final prefs = await SharedPreferences.getInstance();

    if (response[0] != 404) {
      var resp = await servicesUser.getKodeGereja(response[1]['kode_user']);
      if (resp[0] != 404) {
        userStatus = true;
        kodeUser = response[1]['kode_user'].toString();
        kodeGereja = resp[1]['kode_gereja'].toString();
        prefs.setBool('userStatus', userStatus);
        prefs.setString('kodeUser', kodeUser);
        prefs.setString('kodeGereja', kodeGereja);
      }
      return true;
    } else {
      return false;
    }
  }

  imgBG(deviceWidth, deviceHeight) {
    if (deviceWidth < 800) {
      return deviceWidth;
    } else {
      return deviceHeight * 0.8;
    }
  }

  void _passwordVisibility() {
    if (mounted) {
      setState(() {
        _passwordVisible = !_passwordVisible;
      });
    }
  }

  responsiveTextField(deviceWidth, deviceHeight, controllerText, pw) {
    if (deviceWidth < 800) {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextField(
          controller: controllerText,
          obscureText: pw ? _passwordVisible : false,
          decoration: InputDecoration(
            filled: true,
            fillColor: surfaceColor,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            suffixIcon: pw == true
                ? IconButton(
                    color: buttonColor,
                    onPressed: () {
                      _passwordVisibility();
                    },
                    icon: Icon(_passwordVisible == true
                        ? Icons.visibility
                        : Icons.visibility_off),
                  )
                : null,
          ),
        ),
      );
    } else {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: SizedBox(
          width: deviceWidth * 0.4,
          child: TextField(
            controller: controllerText,
            obscureText: pw ? _passwordVisible : false,
            decoration: InputDecoration(
              filled: true,
              fillColor: surfaceColor,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                ),
              ),
              suffixIcon: pw == true
                  ? IconButton(
                      color: buttonColor,
                      onPressed: () {
                        _passwordVisibility();
                      },
                      icon: Icon(_passwordVisible == true
                          ? Icons.visibility
                          : Icons.visibility_off),
                    )
                  : null,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            child: Image(
              width: imgBG(deviceWidth, deviceHeight),
              image: const AssetImage('lib/assets/images/loginbgimg.png'),
            ),
          ),
          Positioned(
            top: 0,
            child: Image(
              width: deviceWidth,
              image: const AssetImage(
                  "lib/assets/images/loginactivationheader.png"),
            ),
          ),
          Container(
            width: deviceWidth,
            height: deviceHeight,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: SingleChildScrollView(
              child: SizedBox(
                width: deviceWidth < 800 ? deviceWidth : deviceWidth * 0.4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: deviceWidth * 0.12,
                    ),
                    responsiveText(
                      "Selamat Datang!",
                      64,
                      FontWeight.w900,
                      Colors.black,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    responsiveText(
                      "Nama Pengguna",
                      20,
                      FontWeight.w900,
                      Colors.black,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    responsiveTextField(
                        deviceWidth, deviceHeight, _controllerUsername, false),
                    const SizedBox(
                      height: 25,
                    ),
                    responsiveText(
                      "Kata Sandi",
                      20,
                      FontWeight.w900,
                      Colors.black,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    responsiveTextField(
                        deviceWidth, deviceHeight, _controllerPassword, true),
                    const SizedBox(
                      height: 25,
                    ),
                    deviceWidth < 800
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      getAuth(_controllerUsername.text,
                                              _controllerPassword.text)
                                          .then((value) {
                                        if (value) {
                                          context
                                              .read<UserAuth>()
                                              .setIsLoggedIn(true);
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  "Data yang anda masukan salah"),
                                            ),
                                          );
                                        }
                                      });
                                    },
                                    child: const Text("MASUK"),
                                  ),
                                ],
                              )
                            ],
                          )
                        : SizedBox(
                            width: deviceWidth * 0.4,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        getAuth(_controllerUsername.text,
                                                _controllerPassword.text)
                                            .then((value) {
                                          if (value) {
                                            context
                                                .read<UserAuth>()
                                                .setIsLoggedIn(true);
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    "Data yang anda masukan salah"),
                                              ),
                                            );
                                          }
                                        });
                                      },
                                      child: const Text("MASUK"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                    const SizedBox(
                      height: 25,
                    ),
                    deviceWidth < 800
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  responsiveText(
                                    "Tidak memiliki akun? ",
                                    16,
                                    FontWeight.w900,
                                    Colors.black,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      widget.controllerPageLoginActivation
                                          .animateToPage(1,
                                              duration: const Duration(
                                                  milliseconds: 700),
                                              curve: Curves.easeIn);
                                    },
                                    child: responsiveText(
                                      "Aktivasi disini",
                                      16,
                                      FontWeight.w900,
                                      primaryColorVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : SizedBox(
                            width: deviceWidth * 0.4,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    responsiveText(
                                      "Tidak memiliki akun? ",
                                      16,
                                      FontWeight.w900,
                                      Colors.black,
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        widget.controllerPageLoginActivation
                                            .animateToPage(1,
                                                duration: const Duration(
                                                    milliseconds: 700),
                                                curve: Curves.easeIn);
                                      },
                                      child: responsiveText(
                                        "Aktivasi disini",
                                        16,
                                        FontWeight.w900,
                                        primaryColorVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                    const SizedBox(
                      height: 90,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ActivationPage extends StatefulWidget {
  final PageController controllerPageLoginActivation;
  const ActivationPage({Key? key, required this.controllerPageLoginActivation})
      : super(key: key);

  @override
  State<ActivationPage> createState() => _ActivationPageState();
}

class _ActivationPageState extends State<ActivationPage> {
  final _controllerUsername = TextEditingController();
  final _controllerNotelp = TextEditingController();
  final _controllerOtp = TextEditingController();
  final _controllerPassword = TextEditingController();
  final _controllerConfirmPassword = TextEditingController();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _passwordVisible = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controllerUsername.dispose();
    _controllerNotelp.dispose();
    _controllerOtp.dispose();
    _controllerPassword.dispose();
    _controllerConfirmPassword.dispose();
    super.dispose();
  }

  imgBG(deviceWidth, deviceHeight) {
    if (deviceWidth < 800) {
      return deviceWidth;
    } else {
      return deviceHeight * 0.8;
    }
  }

  void _passwordVisibility() {
    if (mounted) {
      setState(() {
        _passwordVisible = !_passwordVisible;
      });
    }
  }

  responsiveTextField(deviceWidth, deviceHeight, controllerText, dw, pw) {
    if (deviceWidth < 800) {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextField(
          controller: controllerText,
          obscureText: pw ? _passwordVisible : false,
          decoration: InputDecoration(
            filled: true,
            fillColor: surfaceColor,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            suffixIcon: pw == true
                ? IconButton(
                    color: buttonColor,
                    onPressed: () {
                      _passwordVisibility();
                    },
                    icon: Icon(_passwordVisible == true
                        ? Icons.visibility
                        : Icons.visibility_off),
                  )
                : null,
          ),
        ),
      );
    } else {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: SizedBox(
          width: deviceWidth * dw,
          child: TextField(
            controller: controllerText,
            obscureText: pw ? _passwordVisible : false,
            decoration: InputDecoration(
              filled: true,
              fillColor: surfaceColor,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                ),
              ),
              suffixIcon: pw == true
                  ? IconButton(
                      color: buttonColor,
                      onPressed: () {
                        _passwordVisibility();
                      },
                      icon: Icon(_passwordVisible == true
                          ? Icons.visibility
                          : Icons.visibility_off),
                    )
                  : null,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            child: Image(
              width: imgBG(deviceWidth, deviceHeight),
              image: const AssetImage('lib/assets/images/loginbgimg.png'),
            ),
          ),
          Positioned(
            top: 0,
            child: Image(
              width: deviceWidth,
              image: const AssetImage(
                  "lib/assets/images/loginactivationheader.png"),
            ),
          ),
          Container(
            width: deviceWidth,
            height: deviceHeight,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                },
              ),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                controller: ScrollController(),
                child: SizedBox(
                  width: deviceWidth < 800 ? deviceWidth : deviceWidth * 0.4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: deviceWidth * 0.12,
                      ),
                      responsiveText(
                        "Aktivasi Akun",
                        64,
                        FontWeight.w900,
                        Colors.black,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      responsiveText(
                        "Nama Pengguna",
                        20,
                        FontWeight.w900,
                        Colors.black,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      responsiveTextField(deviceWidth, deviceHeight,
                          _controllerUsername, 0.4, false),
                      const SizedBox(
                        height: 25,
                      ),
                      deviceWidth < 800
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                responsiveText(
                                  "Nomor Telepon",
                                  20,
                                  FontWeight.w900,
                                  Colors.black,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                responsiveTextField(deviceWidth, deviceHeight,
                                    _controllerNotelp, 0.4, false),
                                const SizedBox(
                                  height: 25,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {},
                                      child: const Text("KIRIM"),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    responsiveText(
                                      "Nomor Telepon",
                                      20,
                                      FontWeight.w900,
                                      Colors.black,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    responsiveTextField(
                                        deviceWidth,
                                        deviceHeight,
                                        _controllerNotelp,
                                        0.4,
                                        false),
                                  ],
                                ),
                                SizedBox(
                                  width: deviceWidth * 0.02,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    responsiveText(
                                      "",
                                      20,
                                      FontWeight.w900,
                                      Colors.black,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {},
                                      child: const Text("KIRIM"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                      const SizedBox(
                        height: 25,
                      ),
                      responsiveText(
                        "Kode OTP",
                        20,
                        FontWeight.w900,
                        Colors.black,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      responsiveTextField(deviceWidth, deviceHeight,
                          _controllerOtp, 0.4, false),
                      const SizedBox(
                        height: 25,
                      ),
                      deviceWidth < 800
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                responsiveText(
                                  "Kata Sandi",
                                  20,
                                  FontWeight.w900,
                                  Colors.black,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                responsiveTextField(deviceWidth, deviceHeight,
                                    _controllerPassword, 0.4, true),
                                const SizedBox(
                                  height: 25,
                                ),
                                responsiveText(
                                  "Ulangi Kata Sandi",
                                  20,
                                  FontWeight.w900,
                                  Colors.black,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                responsiveTextField(deviceWidth, deviceHeight,
                                    _controllerConfirmPassword, 0.4, true),
                              ],
                            )
                          : Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    responsiveText(
                                      "Kata Sandi",
                                      20,
                                      FontWeight.w900,
                                      Colors.black,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    responsiveTextField(
                                        deviceWidth,
                                        deviceHeight,
                                        _controllerPassword,
                                        0.19,
                                        true),
                                  ],
                                ),
                                SizedBox(
                                  width: deviceWidth * 0.02,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    responsiveText(
                                      "Ulangi Kata Sandi",
                                      20,
                                      FontWeight.w900,
                                      Colors.black,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    responsiveTextField(
                                        deviceWidth,
                                        deviceHeight,
                                        _controllerConfirmPassword,
                                        0.19,
                                        true),
                                  ],
                                ),
                              ],
                            ),
                      const SizedBox(
                        height: 25,
                      ),
                      deviceWidth < 800
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {},
                                      child: const Text("AKTIVASI"),
                                    ),
                                  ],
                                )
                              ],
                            )
                          : SizedBox(
                              width: deviceWidth * 0.4,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {},
                                        child: const Text("AKTIVASI"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                      const SizedBox(
                        height: 25,
                      ),
                      deviceWidth < 800
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    responsiveText(
                                      "Sudah aktivasi? ",
                                      16,
                                      FontWeight.w900,
                                      Colors.black,
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        widget.controllerPageLoginActivation
                                            .animateToPage(0,
                                                duration: const Duration(
                                                    milliseconds: 700),
                                                curve: Curves.easeOut);
                                      },
                                      child: responsiveText(
                                        "Masuk disini",
                                        16,
                                        FontWeight.w900,
                                        primaryColorVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : SizedBox(
                              width: deviceWidth * 0.4,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      responsiveText(
                                        "Sudah aktivasi? ",
                                        16,
                                        FontWeight.w900,
                                        Colors.black,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          widget.controllerPageLoginActivation
                                              .animateToPage(0,
                                                  duration: const Duration(
                                                      milliseconds: 700),
                                                  curve: Curves.easeOut);
                                        },
                                        child: responsiveText(
                                          "Masuk disini",
                                          16,
                                          FontWeight.w900,
                                          primaryColorVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                      const SizedBox(
                        height: 90,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
