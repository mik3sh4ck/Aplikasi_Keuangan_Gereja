//ignore_for_file: todo
import 'package:aplikasi_keuangan_gereja/globals.dart';
import 'package:aplikasi_keuangan_gereja/themes/colors.dart';
import 'package:aplikasi_keuangan_gereja/widgets/responsivetext.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../services/apiservices.dart';
import '../../../widgets/loadingindicator.dart';

class AdminAnggotaController extends StatefulWidget {
  const AdminAnggotaController({Key? key}) : super(key: key);

  @override
  State<AdminAnggotaController> createState() => _AdminAnggotaControllerState();
}

class _AdminAnggotaControllerState extends State<AdminAnggotaController> {
  PageController _controllerPageRole = PageController();
  PageController _controllerPageAbsensi = PageController();
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controllerPageRole,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        AdminAnggotaPage(),
        AdminRolePage(),
        AdminAbsensiPage(),
      ],
    );
  }
}

class AdminAnggotaPage extends StatefulWidget {
  const AdminAnggotaPage({Key? key}) : super(key: key);

  @override
  State<AdminAnggotaPage> createState() => _AdminAnggotaPageState();
}

class _AdminAnggotaPageState extends State<AdminAnggotaPage> {
  ServicesUser servicesUser = ServicesUser();

  late Future listUser;

  final _controllerSearch = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    listUser = servicesUser.getAllUser(kodeGereja);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controllerSearch.dispose();
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
          children: [
            Container(
              padding: const EdgeInsets.all(0),
              width: deviceWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  responsiveText("Anggota", 26, FontWeight.w900, darkText),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: deviceWidth * 0.4,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            controller: _controllerSearch,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: surfaceColor,
                              labelText: 'Cari nama anggota',
                              labelStyle: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                              ),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: navButtonPrimary.withOpacity(0.5),
                              ),
                              suffix: IconButton(
                                onPressed: () {
                                  _controllerSearch.clear();
                                },
                                icon: Icon(
                                  Icons.clear,
                                  color: navButtonPrimary.withOpacity(0.5),
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 25),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: navButtonPrimary.withOpacity(0.5),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: navButtonPrimary.withOpacity(0.5),
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: navButtonPrimary.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                        ),
                        onPressed: () {},
                        child: Row(
                          children: const [
                            Icon(Icons.add),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Role"),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                        ),
                        onPressed: () {},
                        child: Row(
                          children: const [
                            Icon(Icons.add),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Absensi"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                },
              ),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                controller: ScrollController(),
                child: SafeArea(
                  child: FutureBuilder(
                    future: listUser,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List snapData = snapshot.data! as List;
                        if (snapData[0] != 404) {
                          print(snapData[1]);
                          return ScrollConfiguration(
                            behavior: ScrollConfiguration.of(context).copyWith(
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
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: navButtonPrimary.withOpacity(0.5),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(360),
                                      child: const CircleAvatar(
                                        foregroundImage: AssetImage(
                                            "lib/assets/images/defaultprofilepicture.png"),
                                      ),
                                    ),
                                    title: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              snapData[1][index]
                                                  ['nama_lengkap_user'],
                                              style: GoogleFonts.nunito(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                                color: darkText,
                                              ),
                                            ),
                                            Text(
                                              "Role: ${snapData[1][index]['kode_role']}",
                                              style: GoogleFonts.nunito(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14,
                                                color:
                                                    darkText.withOpacity(0.5),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        TextButton(
                                          onPressed: () {},
                                          child: Text(
                                            "Ubah Role",
                                            style: GoogleFonts.nunito(
                                              color: primaryColorVariant,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 25,
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            debugPrint(
                                              index.toString(),
                                            );
                                          },
                                          icon:
                                              const Icon(Icons.delete_rounded),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      }
                      return loadingIndicator(primaryColorVariant);
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

//TODO: Role Page
class AdminRolePage extends StatefulWidget {
  const AdminRolePage({Key? key}) : super(key: key);

  @override
  State<AdminRolePage> createState() => _AdminRolePageState();
}

class _AdminRolePageState extends State<AdminRolePage> {
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
          physics: const ClampingScrollPhysics(),
          controller: ScrollController(),
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
      ),
    );
  }
}

//TODO: Absensi Page

class AdminAbsensiPage extends StatefulWidget {
  const AdminAbsensiPage({Key? key}) : super(key: key);

  @override
  State<AdminAbsensiPage> createState() => _AdminAbsensiPageState();
}

class _AdminAbsensiPageState extends State<AdminAbsensiPage> {
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
          physics: const ClampingScrollPhysics(),
          controller: ScrollController(),
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
      ),
    );
  }
}
