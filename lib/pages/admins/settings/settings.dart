//ignore_for_file: todo, prefer_const_constructors

import 'package:aplikasi_keuangan_gereja/themes/colors.dart';
import 'package:aplikasi_keuangan_gereja/widgets/responsivetext.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class AdminSettingPage extends StatefulWidget {
  final PageController controllerSettingPage;
  const AdminSettingPage({Key? key, required this.controllerSettingPage})
      : super(key: key);

  @override
  State<AdminSettingPage> createState() => _AdminSettingPageState();
}

class _AdminSettingPageState extends State<AdminSettingPage> {
  @override
  Widget build(BuildContext context) {
    List<String> pages = [
      "ANGGOTA",
      "DASHBOARD",
      "DONASI",
      "KEGIATAN",
      "SETTINGS",
      "TRANSAKSI"
    ];

    return Scaffold(
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
        ),
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          controller: ScrollController(),
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    responsiveText("Page", 32, FontWeight.w800, darkText),
                    Divider(
                      thickness: 2,
                      color: Colors.black,
                    ),
                    Container(
                      padding: EdgeInsets.all(0),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          itemCount: pages.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.only(top: 5, bottom: 5),
                              child: ListTile(
                                leading: Text(pages[index]),
                                trailing: Icon(Icons.skip_next),
                                tileColor: surfaceColor,
                                shape: RoundedRectangleBorder(
                                  side:
                                      BorderSide(color: Colors.black, width: 1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                onTap: () {
                                  widget.controllerSettingPage.animateToPage(1,
                                      duration:
                                          const Duration(milliseconds: 250),
                                      curve: Curves.ease);
                                },
                              ),
                            );
                          }),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

class AdminSettingPageController extends StatefulWidget {
  const AdminSettingPageController({Key? key}) : super(key: key);

  @override
  State<AdminSettingPageController> createState() =>
      _AdminSettingPageControllerState();
}

class _AdminSettingPageControllerState
    extends State<AdminSettingPageController> {
  final _controllerPageSettings = PageController();
  final _controllerPageAddRolePage = PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controllerPageSettings.dispose();
    _controllerPageAddRolePage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controllerPageSettings,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        AdminSettingPage(
          controllerSettingPage: _controllerPageSettings,
        ),
        AdminAddRolePage(
          controllerAddRolePade: _controllerPageAddRolePage,
        ),
      ],
    );
  }
}

class AdminAddRolePage extends StatefulWidget {
  final PageController controllerAddRolePade;
  const AdminAddRolePage({Key? key, required this.controllerAddRolePade})
      : super(key: key);

  @override
  State<AdminAddRolePage> createState() => _AdminAddRolePageState();
}

class _AdminAddRolePageState extends State<AdminAddRolePage> {
  List<String> roles = [
    "Ketua",
    "Admin",
    "Bendahara",
    "Sekretaris",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: () {
                      widget.controllerAddRolePade.animateToPage(0,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.ease);
                    },
                  ),
                  responsiveText("Page", 32, FontWeight.w800, darkText),
                ],
              ),
              Divider(
                color: Colors.black,
                thickness: 2,
              ),
              Container(
                decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                width: MediaQuery.of(context).size.width,
                height: 500,
                padding: EdgeInsets.all(15),
                child: ListView.builder(
                    itemCount: roles.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        margin: EdgeInsets.all(5),
                        child: ListTile(
                          leading: Text(
                            roles[index],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: ToggleSwitch(
                            minWidth: 40,
                            initialLabelIndex: 0,
                            cornerRadius: 10,
                            activeFgColor: Colors.white,
                            inactiveBgColor: surfaceColor,
                            inactiveFgColor: Colors.white,
                            totalSwitches: 2,
                            activeBgColors: [
                              [Colors.grey.withOpacity(0.5)],
                              [
                                correctColor.withOpacity(0.8),
                              ],
                            ],
                            onToggle: (index) {
                              debugPrint('switched to: $index');
                            },
                          ),
                          textColor: Colors.black,
                          tileColor: Colors.white,
                        ),
                      );
                    }),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
