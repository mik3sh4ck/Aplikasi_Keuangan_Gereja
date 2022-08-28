//ignore_for_file: todo, prefer_const_constructors

import 'package:aplikasi_keuangan_gereja/themes/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

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
                    Text(
                      "Pages",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
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
        PageView(
          controller: _controllerPageAddRolePage,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            AdminAddRolePage(
              controllerAddRolePade: _controllerPageAddRolePage,
            ),
            AdminSettingPage(controllerSettingPage: _controllerPageSettings),
          ],
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
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () {
                  widget.controllerAddRolePade.animateToPage(1,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.ease);
                },
              ),
              Text(
                "Pages",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
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
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    margin: EdgeInsets.all(5),
                    child: ListTile(
                      leading: Text(
                        roles[index],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Text("Check Box"),
                      textColor: Colors.black,
                      tileColor: Colors.white,
                    ),
                  );
                }),
          ),
        ]),
      ),
    );
  }
}
