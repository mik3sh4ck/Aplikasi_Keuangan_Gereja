//ignore_for_file: todo, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:aplikasi_keuangan_gereja/main.dart';
import 'package:aplikasi_keuangan_gereja/pages/Profiles/profile.dart';
import 'package:aplikasi_keuangan_gereja/pages/admins/dashboard/dashboard.dart';
import 'package:aplikasi_keuangan_gereja/themes/colors.dart';
import 'package:flutter/material.dart';
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
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
        // margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: primaryColor,
        ),
        textStyle: GoogleFonts.nunito(
          color: navButtonPrimaryVariant,
        ),
        selectedTextStyle: GoogleFonts.nunito(
          color: navButtonPrimary,
        ),
        iconTheme: IconThemeData(
          color: Color(0xFF80633d),
          size: 20,
        ),
        selectedIconTheme: IconThemeData(
          color: navButtonPrimary,
          size: 20,
        ),
        itemTextPadding: EdgeInsets.only(left: 20),
        selectedItemTextPadding: EdgeInsets.only(left: 30),
        selectedItemDecoration: BoxDecoration(
          color: Color(0xFFFFFFFF).withOpacity(0.40),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.transparent),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
            )
          ],
        ),
      ),
      extendedTheme: SidebarXTheme(
        width: 160,
        decoration: BoxDecoration(
          color: primaryColor,
        ),
      ),
      headerDivider:
          Divider(color: navButtonPrimary.withOpacity(0.1), height: 1),
      headerBuilder: (context, extended) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(),
                ),
              );
            },
            child: FittedBox(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(360),
                child: Image.asset(
                  'lib/assets/images/defaultprofilepicture.png',
                  width: 56,
                  height: 56,
                ),
              ),
            ),
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
                        color: Color(0xFF80633d),
                        size: 21,
                      ),
                      Visibility(
                        visible: extended == true ? true : false,
                        child: Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: Text(
                            'Keluar',
                            style: TextStyle(
                              color: Color(0xFF80633d),
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
          label: 'Home',
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
          label: 'Setting',
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
        final pageTitle = _getTitleByIndex(controller.selectedIndex);
        switch (controller.selectedIndex) {
          case 0:
            return AdminDashboardPage();
          default:
            return Text(
              pageTitle,
              // style: theme.textTheme.headline5,
            );
        }
      },
    );
  }
}

String _getTitleByIndex(int index) {
  switch (index) {
    case 0:
      return "Dashboard";
    case 1:
      return "Transaksi";
    case 2:
      return "Anggota";
    case 3:
      return "Kegiatan";
    case 4:
      return "Donasi";
    case 5:
      return "Setting";
    default:
      return "Page not found";
  }
}
