//ignore_for_file: todo

import 'package:aplikasi_keuangan_gereja/globals.dart';
import 'package:aplikasi_keuangan_gereja/themes/colors.dart';
import 'package:aplikasi_keuangan_gereja/widgets/loadingindicator.dart';
import 'package:aplikasi_keuangan_gereja/widgets/responsivetext.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../services/apiservices.dart';

class AdminSettingPage extends StatefulWidget {
  final PageController controllerSettingPage;
  const AdminSettingPage({Key? key, required this.controllerSettingPage})
      : super(key: key);

  @override
  State<AdminSettingPage> createState() => _AdminSettingPageState();
}

class _AdminSettingPageState extends State<AdminSettingPage> {
  List<String> pages = [
    "Dashboard",
    "Keuangan",
    "Anggota",
    "Kegiatan",
    "Donasi",
    "Setting"
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            responsiveText("Pengaturan", 26, FontWeight.w900, darkText),
            const Divider(
              height: 56,
            ),
            Expanded(
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
                    width: deviceWidth < 800 ? deviceWidth : deviceWidth * 0.6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: navButtonPrimary.withOpacity(0.5),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              controller: ScrollController(),
                              physics: const ClampingScrollPhysics(),
                              itemCount: pages.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  color: scaffoldBackgroundColor,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: navButtonPrimary.withOpacity(0.5),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    leading: Text(pages[index]),
                                    trailing: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.all(12),
                                        shape: const CircleBorder(),
                                      ),
                                      onPressed: () {
                                        widget.controllerSettingPage
                                            .animateToPage(1,
                                                duration: const Duration(
                                                    milliseconds: 250),
                                                curve: Curves.ease);
                                      },
                                      child: Tooltip(
                                        message: "Details",
                                        child: const Icon(
                                            Icons.arrow_forward_rounded),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controllerPageSettings.dispose();
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
          controllerAddRolePade: _controllerPageSettings,
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
  late Future kategoriListRole;
  ServicesUser servicesUser = ServicesUser();

  List<String> roles = [
    "Ketua",
    "Admin",
    "Bendahara",
    "Sekretaris",
  ];
  @override
  void initState() {
    // TODO: implement initState
    kategoriListRole = servicesUser.getRole(kodeGereja);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
        child: Column(
          children: [
            Row(
              children: [
                Tooltip(
                  message: "Back",
                  child: IconButton(
                    onPressed: () {
                      widget.controllerAddRolePade.animateToPage(0,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.ease);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                ),
                const SizedBox(
                  width: 25,
                ),
                responsiveText("Detail Halaman", 26, FontWeight.w900, darkText),
              ],
            ),
            const Divider(
              height: 56,
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  },
                ),
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: navButtonPrimary.withOpacity(0.5),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: FutureBuilder(
                              future: kategoriListRole,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  List snapData = snapshot.data! as List;
                                  if (snapData[0] != 404) {
                                    return ScrollConfiguration(
                                      behavior: ScrollConfiguration.of(context)
                                          .copyWith(
                                        dragDevices: {
                                          PointerDeviceKind.touch,
                                          PointerDeviceKind.mouse,
                                        },
                                      ),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        controller: ScrollController(),
                                        physics: const ClampingScrollPhysics(),
                                        itemCount: roles.length,
                                        itemBuilder: (context, index) {
                                          return Card(
                                            color: scaffoldBackgroundColor,
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                color: navButtonPrimary
                                                    .withOpacity(0.5),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: ListTile(
                                              title: responsiveText(
                                                  snapData[1][index]
                                                      ['nama_role'],
                                                  17,
                                                  FontWeight.w700,
                                                  darkText),
                                              subtitle: responsiveText(
                                                  snapData[1][index]
                                                      ['kode_role'],
                                                  15,
                                                  FontWeight.w500,
                                                  darkText),
                                              trailing: ToggleSwitch(
                                                minWidth: 40,
                                                initialLabelIndex: 0,
                                                cornerRadius: 10,
                                                activeFgColor: Colors.white,
                                                inactiveBgColor: surfaceColor,
                                                inactiveFgColor: Colors.white,
                                                totalSwitches: 2,
                                                activeBgColors: [
                                                  [
                                                    Colors.grey.withOpacity(0.5)
                                                  ],
                                                  [
                                                    correctColor
                                                        .withOpacity(0.8),
                                                  ],
                                                ],
                                                onToggle: (index) {
                                                  debugPrint(
                                                      'switched to: $index');
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  } else if (snapData[0] == 404) {
                                    return noData();
                                  }
                                }
                                return loadingIndicator();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
