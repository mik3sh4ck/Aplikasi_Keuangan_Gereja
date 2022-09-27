//ignore_for_file: todo, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:animations/animations.dart';
import 'package:aplikasi_keuangan_gereja/main.dart';
import 'package:aplikasi_keuangan_gereja/pages/Profiles/profile.dart';
import 'package:aplikasi_keuangan_gereja/pages/admins/anggota/anggota.dart';
import 'package:aplikasi_keuangan_gereja/pages/admins/dashboard/dashboard.dart';
import 'package:aplikasi_keuangan_gereja/pages/admins/donasi/donasi.dart';
import 'package:aplikasi_keuangan_gereja/pages/admins/kegiatan/kegiatan.dart';
import 'package:aplikasi_keuangan_gereja/pages/admins/settings/settings.dart';
import 'package:aplikasi_keuangan_gereja/pages/admins/transaksi/transaksi.dart';
import 'package:aplikasi_keuangan_gereja/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidebarx/sidebarx.dart';
import '../../../globals.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final _controllerSidebarX =
      SidebarXController(selectedIndex: 0, extended: true);
  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
    );

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
    );
    _controllerSidebarX.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: deviceWidth < 800
          ? AppBar(
              // backgroundColor: scaffoldBackgroundColor,
              // elevation: 0,
              iconTheme: IconThemeData(
                color: navButtonPrimaryVariant,
              ),
            )
          : null,
      body: Row(
        children: [
          if (deviceWidth > 800)
            NavigationSidebarX(controller: _controllerSidebarX),
          Expanded(
            child: Center(
              child: NavigationScreen(
                controller: _controllerSidebarX,
              ),
            ),
          ),
        ],
      ),
      drawerEnableOpenDragGesture: false,
      drawer: NavigationSidebarX(
        controller: _controllerSidebarX,
      ),
    );
  }
}

class NavigationSidebarX extends StatelessWidget {
  final SidebarXController _controller;
  const NavigationSidebarX({
    Key? key,
    required SidebarXController controller,
  })  : _controller = controller,
        super(key: key);

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    userStatus = false;
    kodeUser = "";
    kodeGereja = "";
    prefs.setBool('userStatus', userStatus);
    prefs.setString('kodeUser', kodeUser);
    prefs.setString('kodeGereja', kodeGereja);
  }

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      animationDuration: Duration(milliseconds: 400),
      controller: _controller,
      theme: SidebarXTheme(
        decoration: BoxDecoration(
          color: primaryColor,
        ),
        textStyle: GoogleFonts.nunito(
          color: navButtonPrimaryVariant,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        selectedTextStyle: GoogleFonts.nunito(
          color: navButtonPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(
          color: navButtonPrimaryVariant,
          size: 24,
        ),
        selectedIconTheme: IconThemeData(
          color: navButtonPrimary,
          size: 24,
        ),
        itemTextPadding: EdgeInsets.only(left: 20),
        selectedItemTextPadding: EdgeInsets.only(left: 30),
        selectedItemDecoration: BoxDecoration(
          color: scaffoldBackgroundColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.transparent),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
            )
          ],
        ),
      ),
      extendedTheme: SidebarXTheme(
        width: 200,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: primaryColor,
        ),
      ),
      headerDivider:
          Divider(color: navButtonPrimary.withOpacity(0.1), height: 1),
      headerBuilder: (context, extended) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: OpenContainer(
            openColor: Colors.transparent,
            closedColor: Colors.transparent,
            openElevation: 0,
            closedElevation: 0,
            transitionDuration: const Duration(milliseconds: 500),
            transitionType: ContainerTransitionType.fadeThrough,
            closedBuilder: (context, action) {
              return FittedBox(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(360),
                  child: Image.asset(
                    'lib/assets/images/defaultprofilepicture.png',
                    width: 56,
                    height: 56,
                  ),
                ),
              );
            },
            openBuilder: (context, action) {
              return ProfilePage();
            },
          ),
        );
      },
      footerDivider:
          Divider(color: navButtonPrimary.withOpacity(0.1), height: 1),
      footerBuilder: (context, extended) {
        return Align(
          alignment: extended == true ? Alignment.centerLeft : Alignment.center,
          child: FittedBox(
            alignment: Alignment.centerLeft,
            child: Align(
              child: Padding(
                padding: EdgeInsets.only(
                    top: 10, bottom: 10, left: extended == true ? 12 : 0),
                child: GestureDetector(
                  onTap: () {
                    signOut().then((value) {
                      context.read<UserAuth>().setIsLoggedIn(false);
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.logout_rounded,
                        color: navButtonPrimaryVariant,
                        size: 24,
                      ),
                      Visibility(
                        visible: extended == true ? true : false,
                        child: Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: Text(
                            'Keluar',
                            style: GoogleFonts.nunito(
                              color: navButtonPrimaryVariant,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      items: [
        SidebarXItem(
          icon: Icons.home_rounded,
          label: 'Beranda',
        ),
        SidebarXItem(
          icon: Icons.wallet_rounded,
          label: 'Keuangan',
        ),
        SidebarXItem(
          icon: Icons.people,
          label: 'Anggota',
        ),
        SidebarXItem(
          icon: Icons.event_note_rounded,
          label: 'Kegiatan',
        ),
        SidebarXItem(
          icon: Icons.inbox_rounded,
          label: 'Donasi',
        ),
        SidebarXItem(
          icon: Icons.settings,
          label: 'Pengaturan',
        ),
      ],
    );
  }
}

class NavigationScreen extends StatelessWidget {
  final SidebarXController controller;
  const NavigationScreen({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        switch (controller.selectedIndex) {
          case 0:
            return AdminDashboardControllerPage();
          case 1:
            return AdminControllerTransaksiPage();
          case 2:
            return AdminAnggotaController();
          case 3:
            return AdminControllerKegiatanPage();
          // case 4:
          //   return AdminControllerDonasiPage();
          case 5:
            return AdminSettingPageController();
          default:
            return Text(
              "Halaman Tidak Tersedia",
              // style: theme.textTheme.headline5,
            );
        }
      },
    );
  }
}
