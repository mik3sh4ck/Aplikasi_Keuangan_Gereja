//ignore_for_file: todo
import 'package:aplikasi_keuangan_gereja/globals.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../services/apiservices.dart';
import '../../themes/colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ServicesUser servicesUser = ServicesUser();

  final _controllerNama = TextEditingController();
  final _controllerTTL = TextEditingController();
  final _controllerJenisKelamin = TextEditingController();
  final _controllerEmail = TextEditingController();
  final _controllerNoTelp = TextEditingController();
  final _controllerAlamat = TextEditingController();
  final _controllerPeran = TextEditingController();
  final _controllerKemampuan = TextEditingController();

  String _imageProfile = "";
  bool _readOnly = true;

  @override
  void initState() {
    // TODO: implement initState
    getUserData(kodeUser);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controllerNama.dispose();
    _controllerTTL.dispose();
    _controllerJenisKelamin.dispose();
    _controllerEmail.dispose();
    _controllerNoTelp.dispose();
    _controllerAlamat.dispose();
    _controllerPeran.dispose();
    _controllerKemampuan.dispose();
    super.dispose();
  }

  Future getUserData(userStatus) async {
    var response = await servicesUser.getSingleUser(userStatus);
    if (response[0] != 404) {
      _controllerNama.text = response[1]['nama_lengkap_user'].toString();
      _controllerTTL.text = response[1]['tanggal_lahir_user'].toString();
      _controllerJenisKelamin.text =
          response[1]['jenis_kelamin_user'].toString();
      _controllerEmail.text = response[1]['email_user'].toString();
      _controllerNoTelp.text = response[1]['no_telp_user'].toString();
      _controllerAlamat.text = response[1]['alamat_user'].toString();
      _controllerPeran.text = response[1]['kode_role'].toString();
      _controllerKemampuan.text = response[1]['kemampuan_user'].toString();
      if (mounted) {
        setState(() {
          _imageProfile = response[1]['foto_profile'].toString();
        });
      }
      if (_imageProfile == "") {
        if (mounted) {
          setState(() {
            _imageProfile =
                "https://yt3.ggpht.com/Zi6DMbqTrk8jpNKnJgbw_NxGnggsKX1omQnPeHxrZTmrVmon7zfmg5Q4XbqsHO9AMidW49zCPw=s900-c-k-c0x00ffffff-no-rj";
          });
        }
      }
    }
  }

  imageCheck() {
    if (_imageProfile == "") {
      return const AssetImage("lib/assets/images/defaultprofilepicture.png");
    } else {
      return NetworkImage(_imageProfile);
    }
  }

  void readOnly() {
    setState(() {
      if (mounted) {
        _readOnly = !_readOnly;
      }
    });
  }

  responsiveTextField(deviceWidth, deviceHeight, controllerText, dw, ronly) {
    if (deviceWidth < 800) {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextField(
          controller: controllerText,
          autofocus: false,
          readOnly: ronly,
          decoration: InputDecoration(
            filled: true,
            fillColor: surfaceColor,
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
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
          ),
        ),
      );
    } else {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: SizedBox(
          width: deviceWidth * 0.41,
          child: TextField(
            controller: controllerText,
            autofocus: false,
            readOnly: ronly,
            decoration: InputDecoration(
              filled: true,
              fillColor: surfaceColor,
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
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
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: navButtonPrimaryVariant,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            child: Image(
              width: deviceWidth,
              image: const AssetImage("lib/assets/images/loginactivationheader.png"),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: deviceWidth,
            height: deviceHeight,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: deviceWidth * 0.12,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(360),
                              child: SizedBox(
                                width: deviceWidth < 800 ? 120 : 160,
                                height: deviceWidth < 800 ? 120 : 160,
                                child: Image(
                                  image: imageCheck(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    deviceWidth < 800
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  "Nama Lengkap",
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              responsiveTextField(
                                deviceWidth,
                                deviceHeight,
                                _controllerNama,
                                0.45,
                                _readOnly,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  "Tanggal Lahir",
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ),
                              responsiveTextField(
                                deviceWidth,
                                deviceHeight,
                                _controllerTTL,
                                0.45,
                                _readOnly,
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 5),
                                    child: Text(
                                      "Nama Lengkap",
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  responsiveTextField(
                                    deviceWidth,
                                    deviceHeight,
                                    _controllerNama,
                                    0.45,
                                    _readOnly,
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: (deviceWidth * 0.05),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 5),
                                    child: Text(
                                      "Tanggal Lahir",
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                  ),
                                  responsiveTextField(
                                    deviceWidth,
                                    deviceHeight,
                                    _controllerTTL,
                                    0.45,
                                    _readOnly,
                                  ),
                                ],
                              ),
                            ],
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    deviceWidth < 800
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  "Jenis Kelamin",
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ),
                              responsiveTextField(
                                deviceWidth,
                                deviceHeight,
                                _controllerJenisKelamin,
                                0.45,
                                _readOnly,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  "Email",
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ),
                              responsiveTextField(
                                deviceWidth,
                                deviceHeight,
                                _controllerEmail,
                                0.45,
                                true,
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 5),
                                    child: Text(
                                      "Jenis Kelamin",
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                  ),
                                  responsiveTextField(
                                    deviceWidth,
                                    deviceHeight,
                                    _controllerJenisKelamin,
                                    0.45,
                                    _readOnly,
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: (deviceWidth * 0.05),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 5),
                                    child: Text(
                                      "Email",
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                  ),
                                  responsiveTextField(
                                    deviceWidth,
                                    deviceHeight,
                                    _controllerEmail,
                                    0.45,
                                    true,
                                  ),
                                ],
                              ),
                            ],
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    deviceWidth < 800
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  "No Telepon",
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ),
                              responsiveTextField(
                                deviceWidth,
                                deviceHeight,
                                _controllerNoTelp,
                                0.45,
                                _readOnly,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  "Alamat",
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ),
                              responsiveTextField(
                                deviceWidth,
                                deviceHeight,
                                _controllerAlamat,
                                0.45,
                                _readOnly,
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 5),
                                    child: Text(
                                      "No Telepon",
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                  ),
                                  responsiveTextField(
                                    deviceWidth,
                                    deviceHeight,
                                    _controllerNoTelp,
                                    0.45,
                                    _readOnly,
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: (deviceWidth * 0.05),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 5),
                                    child: Text(
                                      "Alamat",
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                  ),
                                  responsiveTextField(
                                    deviceWidth,
                                    deviceHeight,
                                    _controllerAlamat,
                                    0.45,
                                    _readOnly,
                                  ),
                                ],
                              ),
                            ],
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    deviceWidth < 800
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  "Peran",
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ),
                              responsiveTextField(deviceWidth, deviceHeight,
                                  _controllerPeran, 0.45, _readOnly),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  "Kemampuan",
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ),
                              responsiveTextField(
                                deviceWidth,
                                deviceHeight,
                                _controllerKemampuan,
                                0.45,
                                _readOnly,
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 5),
                                    child: Text(
                                      "Peran",
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                  ),
                                  responsiveTextField(deviceWidth, deviceHeight,
                                      _controllerPeran, 0.45, _readOnly),
                                ],
                              ),
                              SizedBox(
                                width: (deviceWidth * 0.05),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 5),
                                    child: Text(
                                      "Kemampuan",
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                  ),
                                  responsiveTextField(
                                    deviceWidth,
                                    deviceHeight,
                                    _controllerKemampuan,
                                    0.45,
                                    _readOnly,
                                  ),
                                ],
                              ),
                            ],
                          ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _readOnly
                            ? Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      readOnly();
                                    },
                                    child: const Text("EDIT PROFILE"),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Column(
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.white,
                                          side: BorderSide(
                                            width: 1,
                                            color: primaryColorVariant,
                                          ),
                                        ),
                                        onPressed: () {
                                          readOnly();
                                        },
                                        child: Text(
                                          "BATAL",
                                          style: TextStyle(
                                              color: primaryColorVariant),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: deviceWidth * 0.02,
                                  ),
                                  Column(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          readOnly();
                                        },
                                        child: const Text("SIMPAN"),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                      ],
                    ),
                    const SizedBox(
                      height: 114,
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
