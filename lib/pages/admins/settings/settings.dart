//ignore_for_file: todo

import 'package:aplikasi_keuangan_gereja/globals.dart';
import 'package:aplikasi_keuangan_gereja/themes/colors.dart';
import 'package:aplikasi_keuangan_gereja/widgets/loadingindicator.dart';
import 'package:aplikasi_keuangan_gereja/widgets/responsivetext.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../services/apiservices.dart';

String _namaPages = "";
var kodestatus;

class AdminSettingPage extends StatefulWidget {
  const AdminSettingPage({Key? key}) : super(key: key);

  @override
  State<AdminSettingPage> createState() => _AdminSettingPageState();
}

class _AdminSettingPageState extends State<AdminSettingPage> {
  List<String> pages = [
    "Dashboard",
    "Keuangan",
    "Anggota",
    "Kegiatan",
    "Setting"
  ];

  late Future kategoriListRoles;
  late Future kategoriTampilRolePage;
  ServicesUser servicesUser = ServicesUser();

  final List _settingRoleList = List.empty(growable: true);
  final List _settingEnabledList = List.empty(growable: true);
  final List _tempRole = List.empty(growable: true);
  String _roleList = "";
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

  Future getallrole(kodeGereja, namaPagePop) async {
    _settingRoleList.clear();
    List temp = List.empty(growable: true);
    debugPrint("============================================================");

    var response = await servicesUser.getRole(kodeGereja);
    if (response[0] != 404) {
      for (var element in response[1]) {
        temp.add(element['nama_role'].toString());
        temp.add(element['kode_role'].toString());
        temp.add(false);
        _settingRoleList.add(temp.toList());
        temp.clear();
      }
      debugPrint(_settingRoleList.toString());
    }

    debugPrint("============================================================");
    response = await servicesUser.getPageRole(kodeGereja, namaPagePop);
    if (response[0] != 0) {
      for (var element in response[1]) {
        for (int i = 0; i < _settingRoleList.length; i++) {
          if (_settingRoleList[i][1] == element['role_user']) {
            _settingRoleList[i][2] = true;
          }
        }
        debugPrint(element.toString());
      }
    }

    debugPrint("============================================================");
    debugPrint(_settingRoleList.toString());
  }

  buatListRole(namaPagePop, context) async {
    _roleList = "";
    for (int i = 0; i < _settingRoleList.length; i++) {
      if (_settingRoleList[i][2] == true) {
        _roleList += "/${_settingRoleList[i][1]}/";
      }
    }

    await servicesUser
        .inputUpdatePageRole(kodeGereja, namaPagePop, _roleList)
        .whenComplete(() => Navigator.pop(context));
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
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            controller: ScrollController(),
                            physics: const ClampingScrollPhysics(),
                            itemCount: _settingRoleList.length,
                            itemBuilder: (context, index) {
                              return CheckboxListTile(
                                checkboxShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                contentPadding: const EdgeInsets.all(0),
                                title: Card(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: navButtonPrimary.withOpacity(0.5),
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                    child: Text(
                                      _settingRoleList[index][0],
                                    ),
                                  ),
                                ),
                                value: _settingRoleList[index][2],
                                onChanged: (e) {
                                  _settingRoleList[index][2] = e;
                                  setState(() {});
                                  debugPrint("====================");
                                  debugPrint(_settingRoleList.toString());
                                },
                              );
                            },
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
                                  if (mounted) {
                                    buatListRole(namaPagePop, context);
                                  }
                                },
                                child: const Text("Simpan"),
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

  showAlertNoAkses() {
    return showDialog(
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: const Text('Anda Tidak Mempunyai Akses'),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('Tutup'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      context: context,
    );
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
                                onPressed: () async {
                                  kodestatus = await servicesUser
                                      .checkPrevilage(3, kodeGereja, kodeRole);
                                  print(kodestatus[0]);
                                  if (kodestatus[0] == 200) {
                                    getallrole(kodeGereja, pages[index])
                                        .whenComplete(() {
                                      _showTambahRolePage(deviceWidth,
                                          deviceHeight, pages[index]);
                                    });
                                  } else {
                                    showAlertNoAkses();
                                  }
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
                                                      "${snapData[1][index]['nama_role']} ~ (Kode : ${snapData[1][index]['role_user']})"),
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
