//ignore_for_file: todo

import 'package:aplikasi_keuangan_gereja/globals.dart';
import 'package:aplikasi_keuangan_gereja/themes/colors.dart';
import 'package:aplikasi_keuangan_gereja/widgets/loadingindicator.dart';
import 'package:aplikasi_keuangan_gereja/widgets/responsivetext.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../services/apiservices.dart';

String _namaPages = "";

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

  late Future kategoriListRoles;
  late Future kategoriTampilRolePage;
  ServicesUser servicesUser = ServicesUser();

  @override
  void initState() {
    // TODO: implement initState
    kategoriListRoles = servicesUser.getRole(kodeGereja);
    kategoriTampilRolePage = servicesUser.getPageRole(kodeGereja, "");
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  _showTambahRolePage(dw, dh, namaPagePop) {
    showDialog(
      barrierDismissible: false,
      useRootNavigator: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
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
                    width: dw * 0.5,
                    child: Column(
                      children: [
                        Container(
                          width: dw * 0.5,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 16,
                              ),
                              responsiveText("Beri Role Page $namaPagePop", 26,
                                  FontWeight.w700, lightText),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FutureBuilder(
                                    future: kategoriListRoles,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        List snapData = snapshot.data! as List;
                                        if (snapData[0] != 404) {
                                          return ScrollConfiguration(
                                            behavior:
                                                ScrollConfiguration.of(context)
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
                                              physics:
                                                  const ClampingScrollPhysics(),
                                              itemCount: snapData[1].length,
                                              itemBuilder: (context, index) {
                                                return CheckboxListTile(
                                                  checkboxShape:
                                                      RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  contentPadding:
                                                      const EdgeInsets.all(0),
                                                  title: Card(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      side: BorderSide(
                                                        color: navButtonPrimary
                                                            .withOpacity(0.5),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 16,
                                                          vertical: 10),
                                                      child: Text(
                                                        snapData[1][index]
                                                            ['nama_role'],
                                                      ),
                                                    ),
                                                  ),
                                                  value: false,
                                                  onChanged: (e) {},
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
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  if (mounted) {
                                    setState(() {});
                                  }
                                  Navigator.pop(context);
                                },
                                child: const Text("Batal"),
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (mounted) {}
                                  Navigator.pop(context);
                                },
                                child: const Text("Tambah"),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      return setState(() {});
    });
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
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    controller: ScrollController(),
                    physics: const ClampingScrollPhysics(),
                    itemCount: pages.length,
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: navButtonPrimary.withOpacity(0.5),
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: ExpansionTile(
                          initiallyExpanded: false,
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          expandedAlignment: Alignment.centerLeft,
                          childrenPadding: const EdgeInsets.all(16),
                          textColor: darkText,
                          iconColor: navButtonPrimary,
                          collapsedTextColor: darkText,
                          collapsedIconColor: navButtonPrimary,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(pages[index]),
                              TextButton(
                                onPressed: () {
                                  _showTambahRolePage(
                                      deviceWidth, deviceHeight, pages[index]);
                                },
                                child: Text(
                                  "Beri Role",
                                  style: GoogleFonts.nunito(
                                    color: darkText,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          children: [
                            Divider(
                              height: 0,
                              color: navButtonPrimary.withOpacity(0.3),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: FutureBuilder(
                                    future: kategoriTampilRolePage =
                                        servicesUser.getPageRole(
                                            kodeGereja, pages[index]),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        List snapData = snapshot.data! as List;
                                        if (snapData[0] != 404) {
                                          return ScrollConfiguration(
                                            behavior:
                                                ScrollConfiguration.of(context)
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
                                              physics:
                                                  const ClampingScrollPhysics(),
                                              itemCount: snapData[1].length,
                                              itemBuilder: (context, index) {
                                                return ListTile(
                                                    title: Text(
                                                        "${snapData[1][index]['role_user']}"));
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
                              ],
                            ),
                          ],
                        ),
                      );
                    },
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
                responsiveText("Detail Halaman $_namaPages", 26,
                    FontWeight.w900, darkText),
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
                                        itemCount: snapData[1].length,
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
