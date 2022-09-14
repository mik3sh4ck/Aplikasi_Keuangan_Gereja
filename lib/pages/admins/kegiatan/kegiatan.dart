//ignore_for_file: todo, prefer_const_constructors
import 'package:aplikasi_keuangan_gereja/globals.dart';
import 'package:aplikasi_keuangan_gereja/services/apiservices.dart';

import 'package:dropdown_search/dropdown_search.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../themes/colors.dart';
import '../../../widgets/loadingindicator.dart';
import '../../../widgets/responsivetext.dart';

String _namaKegiatan = "";
String _kodeKegiatan = "";
String _kodeItemKebutuhan = "";
String _namaItemKebutuhan = "";

String _tempNamaPIC = "";

final List _user = [];
final List _kodeKegiatanbuatList = [];

// final List _kategoriAnggota = List.empty(growable: true);
// final List _tempKategoriAnggota = List.empty(growable: true);

class AdminControllerKegiatanPage extends StatefulWidget {
  const AdminControllerKegiatanPage({Key? key}) : super(key: key);

  @override
  State<AdminControllerKegiatanPage> createState() =>
      _AdminControllerKegiatanPageState();
}

class _AdminControllerKegiatanPageState
    extends State<AdminControllerKegiatanPage> {
  final _controllerPageKegiatan = PageController();
  final _controllerDetailPageKegiatan = PageController();
  final _controllerHistoryPageKegiatan = PageController();
  final _controllerPageAbsensiKegiatan = PageController();
  final _controllerPageDetailAbsensiKegiatan = PageController();
  final _controllerDetailPengeluaranKebutuhan = PageController();
  final _controllerPageListKode = PageController();


  @override

  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controllerPageKegiatan.dispose();
    _controllerDetailPageKegiatan.dispose();
    _controllerHistoryPageKegiatan.dispose();
    _controllerPageAbsensiKegiatan.dispose();
    _controllerPageDetailAbsensiKegiatan.dispose();
    _controllerDetailPengeluaranKebutuhan.dispose();
    _controllerPageListKode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controllerPageKegiatan,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        PageView(
          controller: _controllerDetailPageKegiatan,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            PageView(
              controller: _controllerHistoryPageKegiatan,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                PageView(
                  controller: _controllerPageListKode,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    AdminKegiatanPage(
                      controllerPageKegiatan: _controllerPageKegiatan,
                      controllerDetailPageKegiatan:
                          _controllerDetailPageKegiatan,
                      controllerHistoryPageKegiatan:
                          _controllerHistoryPageKegiatan,
                      controllerPageListKode: _controllerPageListKode,
                    ),
                    ListKodeKegiatan(
                        controllerPageListKode: _controllerPageListKode)
                  ],
                ),
                HistoryKegiatan(
                  controllerHistoryPageKegiatan: _controllerHistoryPageKegiatan,
                ),
              ],
            ),
            PageView(
              controller: _controllerPageAbsensiKegiatan,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                PageView(
                  controller: _controllerDetailPengeluaranKebutuhan,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    DetailKebutuhanPage(
                      controllerDetailPageKegiatan:
                          _controllerDetailPageKegiatan,
                      controllerPageAbsensiKegiatan:
                          _controllerPageAbsensiKegiatan,
                      controllerDetailPengeluaranKebutuhan:
                          _controllerDetailPengeluaranKebutuhan,
                    ),
                    DetailPengeluaranKebutuhan(
                        controllerPageDetailPengeluaranKebutuhan:
                            _controllerDetailPengeluaranKebutuhan)
                  ],
                ),
                PageView(
                  controller: _controllerPageDetailAbsensiKegiatan,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    AbsensiKegiatanPage(
                        controllerPageAbsensiKegiatan:
                            _controllerPageAbsensiKegiatan,
                        controllerPageDetailAbsensiKegiatan:
                            _controllerPageDetailAbsensiKegiatan),
                    DetailAbsensiKegiatan(
                        controllerPageDetailAbsensiKegiatan:
                            _controllerPageDetailAbsensiKegiatan)
                  ],
                )
              ],
            ),
          ],
        ),
        BuatKegiatanPage(controllerPageKegiatan: _controllerPageKegiatan),
      ],
    );
  }
}

class AdminKegiatanPage extends StatefulWidget {
  final PageController controllerPageKegiatan;
  final PageController controllerDetailPageKegiatan;
  final PageController controllerHistoryPageKegiatan;
  final PageController controllerPageListKode;
  const AdminKegiatanPage(
      {Key? key,
      required this.controllerPageKegiatan,
      required this.controllerDetailPageKegiatan,
      required this.controllerHistoryPageKegiatan,
      required this.controllerPageListKode})
      : super(key: key);

  @override
  State<AdminKegiatanPage> createState() => _AdminKegiatanPageState();
}

class _AdminKegiatanPageState extends State<AdminKegiatanPage> {
  ServicesUser servicesUser = ServicesUser();
  late Future kategoriProposalKegiatan;

  @override
  void initState() {
    // TODO: implement initState
    kategoriProposalKegiatan = servicesUser.getAllProposalKegiatan("gms001");
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
              width: deviceWidth,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      responsiveText("Kegiatan", 26, FontWeight.w900, darkText),
                      SizedBox(
                        width: 25,
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              widget.controllerHistoryPageKegiatan
                                  .animateToPage(1,
                                      duration:
                                          const Duration(milliseconds: 250),
                                      curve: Curves.ease);
                            },
                            icon: Icon(Icons.history_rounded),
                          ),
                          SizedBox(
                            width: 25,
                          ),
                          ElevatedButton(
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: primaryColorVariant,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            onPressed: () {
                              widget.controllerPageListKode.animateToPage(1,
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.ease);
                            },
                            child: Row(
                              children: [
                                Icon(Icons.add_circle_outline_rounded),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Kode Kegiatan',
                                  style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: primaryColorVariant,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            onPressed: () {
                              widget.controllerPageKegiatan.animateToPage(1,
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.ease);
                            },
                            child: Row(
                              children: [
                                Icon(Icons.add_circle_outline_rounded),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Buat Data Kegiatan',
                                  style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(
                    height: 56,
                  ),
                  SizedBox(height: 25),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: navButtonPrimary.withOpacity(0.4),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: FutureBuilder(
                        future: kategoriProposalKegiatan,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List snapData = snapshot.data! as List;
                            if (snapData[0] != 404) {
                              return ScrollConfiguration(
                                behavior:
                                    ScrollConfiguration.of(context).copyWith(
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
                                        borderRadius: BorderRadius.circular(20),
                                        side: BorderSide(
                                          color:
                                              navButtonPrimary.withOpacity(0.4),
                                        ),
                                      ),
                                      color: scaffoldBackgroundColor,
                                      child: ListTile(
                                        title: responsiveText(
                                            snapData[1][index]['nama_kegiatan'],
                                            18,
                                            FontWeight.w700,
                                            darkText),
                                        subtitle: responsiveText(
                                            snapData[1][index]['kode_kegiatan'],
                                            16,
                                            FontWeight.w500,
                                            darkText),
                                        trailing: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.all(12),
                                            shape: const CircleBorder(),
                                          ),
                                          onPressed: () {
                                            _namaKegiatan = snapData[1][index]
                                                ['nama_kegiatan'];
                                            _kodeKegiatan = snapData[1][index]
                                                ['kode_kegiatan'];
                                            widget.controllerDetailPageKegiatan
                                                .animateToPage(1,
                                                    duration: const Duration(
                                                        milliseconds: 250),
                                                    curve: Curves.ease);
                                          },
                                          child: const Icon(
                                              Icons.arrow_forward_rounded),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
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
    );
  }
}

//TODO: Buat Kegiatan Page
class BuatKegiatanPage extends StatefulWidget {
  final PageController controllerPageKegiatan;
  const BuatKegiatanPage({Key? key, required this.controllerPageKegiatan})
      : super(key: key);

  @override
  State<BuatKegiatanPage> createState() => _BuatKegiatanPageState();
}

class _BuatKegiatanPageState extends State<BuatKegiatanPage> {
  final _controllerKodeKegiatan = TextEditingController();
  final _controllerNamaKegiatan = TextEditingController();
  final _controllerjawab1 = TextEditingController();
  final _controllerKodeJenisKebutuhan = TextEditingController();
  final _controllerJenisKebutuhan = TextEditingController();
  final _controllerSaldo = TextEditingController();
  final _controllerLokasi = TextEditingController();
  final _controllerKeteranganKegiatan = TextEditingController();
  final _controllerJabatanAnggota = TextEditingController();


  final _controllerDropdownFilteruser = TextEditingController();
  final _controllerDropdownFilterKegiatan = TextEditingController();
  final _controllerDropdownFilterNamaAnggota = TextEditingController();


  final List _jabatanList = [];
  final List _namaAnggotaList = [];

  final List _kodeKegiatanList = [];
  final List _jenisKebutuhanList = [];
  final List _saldoList = [];

  bool _kategoriNotEmpty = false;

  ServicesUser servicesUserItem = ServicesUser();
  late Future kategoriItemProposalKegiatan;

  var stateOfDisable = true;
  DateTime selectedDateDariKegiatan = DateTime.now();
  String formattedDateDariKegiatan = "";
  String dateDariKegiatan = "Date";

  DateTime selectedDateSampaiKegiatan = DateTime.now();
  String formattedDateSampaiKegiatan = "";
  String dateSampaiKegiatan = "Date";

  DateTime selectedDateDariAcara = DateTime.now();
  String formattedDateDariAcara = "";
  String dateDariAcara = "Date";

  DateTime selectedDateSampaiAcara = DateTime.now();
  String formattedDateSampaiAcara = "";
  String dateSampaiAcara = "Date";

  Future _getAllUser(kodeGereja) async {
    var response = await servicesUserItem.getAllUser(kodeGereja);
    if (response[0] != 404) {
      _user.clear();
      for (var element in response[1]) {
        _user.add("${element['kode_user']} - ${element['nama_lengkap_user']}");
      }
    } else {
      throw "Gagal Mengambil Data";
    }
  }

  Future _getAllKodeKegiatanList(kodeGereja) async {
    var response = await servicesUserItem.getKodeKegiatan(kodeGereja);
    if (response[0] != 404) {
      _kodeKegiatanbuatList.clear();
      for (var element in response[1]) {
        _kodeKegiatanbuatList.add(
            "${element['kode_kategori_kegiatan']} - ${element['nama_kategori_kegiatan']}");
      }
    } else {
      throw "Gagal Mengambil Data";
    }
  }

  _splitString(val) {
    var value = val.toString();
    var split = value.indexOf(" ");
    var temp = value.substring(0, split);
    return temp;
  }

  _splitStringAkhir(val) {
    var value = val.toString();
    var split = value.indexOf(" ");
    var temp = value.substring(split + 3, val.length);
    return temp;
  }

  @override
  void initState() {
    // TODO: implement initState
    kategoriItemProposalKegiatan =
        servicesUserItem.getAllItemProposalKegiatan("gms001dns013");
    _getAllUser(kodeGereja);
    _getAllKodeKegiatanList("gms001");
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> selectDateDari(context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateDariKegiatan,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.amber, // header background color
                onPrimary: Colors.black, // header text color
                onSurface: Colors.black, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: primaryColorVariant, // button text color
                ),
              ),
            ),
            child: child!);
      },
    );
    if (picked != null && picked != selectedDateDariKegiatan) {
      if (mounted) {
        selectedDateDariKegiatan = picked;
        formattedDateDariKegiatan =
            DateFormat('dd-MM-yyyy').format(selectedDateDariKegiatan);
        dateDariKegiatan = formattedDateDariKegiatan;
        stateOfDisable = false;
        debugPrint("Selected Date From $selectedDateDariKegiatan");

        setState(() {});
      }
    }
  }

  Future<void> selectDateSampai(context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateSampaiKegiatan,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.amber, // header background color
                onPrimary: Colors.black, // header text color
                onSurface: Colors.black, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: primaryColorVariant, // button text color
                ),
              ),
            ),
            child: child!);
      },
    );
    if (picked != null && picked != selectedDateSampaiKegiatan) {
      if (mounted) {
        selectedDateSampaiKegiatan = picked;
        formattedDateSampaiKegiatan =
            DateFormat('dd-MM-yyyy').format(selectedDateSampaiKegiatan);
        dateSampaiKegiatan = formattedDateSampaiKegiatan;
        stateOfDisable = false;
        debugPrint("Selected Date From $selectedDateSampaiKegiatan");

        setState(() {});
      }
    }
  }

  Future<void> selectDateDariAcara(context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateDariAcara,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.amber, // header background color
                onPrimary: Colors.black, // header text color
                onSurface: Colors.black, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: primaryColorVariant, // button text color
                ),
              ),
            ),
            child: child!);
      },
    );
    if (picked != null && picked != selectedDateDariAcara) {
      if (mounted) {
        selectedDateDariAcara = picked;
        formattedDateDariAcara =
            DateFormat('dd-MM-yyyy').format(selectedDateDariAcara);
        dateDariAcara = formattedDateDariAcara;
        stateOfDisable = false;
        debugPrint("Selected Date From $selectedDateDariAcara");

        setState(() {});
      }
    }
  }

  Future<void> selectDateSampaiAcara(context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateSampaiAcara,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.amber, // header background color
                onPrimary: Colors.black, // header text color
                onSurface: Colors.black, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: primaryColorVariant, // button text color
                ),
              ),
            ),
            child: child!);
      },
    );
    if (picked != null && picked != selectedDateSampaiAcara) {
      if (mounted) {
        selectedDateSampaiAcara = picked;
        formattedDateSampaiAcara =
            DateFormat('dd-MM-yyyy').format(selectedDateSampaiAcara);
        dateSampaiAcara = formattedDateSampaiAcara;
        stateOfDisable = false;
        debugPrint("Selected Date From $selectedDateSampaiAcara");

        setState(() {});
      }
    }
  }

  Future postProposalKegiatan(
      kodeProposalKegiatan,
      kodeProposalGereja,
      namaProposalKegiatan,
      penanggungjawabProposalKegiatan,
      mulaiProposalKegiatan,
      selesaiProposalKegiatan,
      lokasiProposalKegiatan,
      keteranganProposalKegiatan,
      context) async {
    var response = await servicesUserItem.inputProposalKegiatan(
        kodeProposalKegiatan,
        kodeProposalGereja,
        namaProposalKegiatan,
        penanggungjawabProposalKegiatan,
        mulaiProposalKegiatan,
        selesaiProposalKegiatan,
        lokasiProposalKegiatan,
        keteranganProposalKegiatan);

    if (response[0] != 404) {
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response[1]),
        ),
      );
    }
  }

  Future postItemProposalKegiatan(
      kodeItemProposalKegiatan,
      kodeProposalKegiatan,
      kodeProposalGereja,
      jenisKebutuhan,
      budgetKebutuhan,
      context) async {
    var response = await servicesUserItem.inputItemKebutuhan(
        kodeItemProposalKegiatan,
        kodeProposalKegiatan,
        kodeProposalGereja,
        jenisKebutuhan,
        budgetKebutuhan);

    if (response[0] != 404) {
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response[1]),
        ),
      );
    }
  }

  responsiveTextField(deviceWidth, deviceHeight, controllerText) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        width: deviceWidth * 0.5,
        child: TextField(
          controller: controllerText,
          autofocus: false,
          decoration: InputDecoration(
            filled: true,
            fillColor: surfaceColor,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _showTambahDialogKebutuhan(dw, dh) {
    showDialog(
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
                              responsiveText("Tambah Kebutuhan", 26,
                                  FontWeight.w700, darkText),
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
                                  responsiveText("Kode Jenis Kebutuhan", 16,
                                      FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  responsiveTextField(
                                      dw, dh, _controllerKodeJenisKebutuhan),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  responsiveText(
                                      "Budget", 16, FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  responsiveTextField(dw, dh, _controllerSaldo),
                                ],
                              ),
                              const SizedBox(
                                height: 25,
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
                                  _controllerJenisKebutuhan.clear();
                                  _controllerKodeJenisKebutuhan.clear();
                                  _controllerSaldo.clear();
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
                                    setState(() {
                                      _kodeKegiatanList.add(
                                          _controllerKodeJenisKebutuhan.text);
                                      _jenisKebutuhanList
                                          .add(_controllerJenisKebutuhan.text);
                                      _saldoList.add(_controllerSaldo.text);
                                    });
                                  }
                                  _controllerJenisKebutuhan.clear();
                                  _controllerKodeJenisKebutuhan.clear();
                                  _controllerSaldo.clear();
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

  _showTambahDialogAnggota(dw, dh) {
    showDialog(
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
                              responsiveText("Tambah Anggota", 26,
                                  FontWeight.w700, darkText),
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
                                  responsiveText(
                                      "Jabatan", 16, FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  responsiveTextField(
                                      dw, dh, _controllerJabatanAnggota),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  responsiveText("Nama Anggota", 16,
                                      FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    child: Card(
                                      color: surfaceColor,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: DropdownSearch<dynamic>(
                                        popupProps: PopupProps.menu(
                                          showSearchBox: true,
                                          searchFieldProps: TextFieldProps(
                                            decoration: InputDecoration(
                                              border:
                                                  const OutlineInputBorder(),
                                              hintText: "Cari Disini",
                                              suffixIcon: IconButton(
                                                onPressed: () {
                                                  _controllerDropdownFilterNamaAnggota
                                                      .clear();
                                                },
                                                icon: Icon(
                                                  Icons.clear,
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                ),
                                              ),
                                            ),
                                            controller:
                                                _controllerDropdownFilterNamaAnggota,
                                          ),
                                        ),
                                        items: _user,
                                        onChanged: (val) {
                                          debugPrint(val);
                                          debugPrint(_splitString(val));
                                          _tempNamaPIC = _splitStringAkhir(val);
                                          if (_kategoriNotEmpty == false) {
                                            _kategoriNotEmpty = true;
                                            if (mounted) {
                                              setState(() {});
                                            }
                                          }
                                        },
                                        selectedItem: "Pilih User",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 25,
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
                                  _controllerJenisKebutuhan.clear();
                                  _controllerKodeJenisKebutuhan.clear();
                                  _controllerSaldo.clear();
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
                                    setState(() {
                                      _jabatanList
                                          .add(_controllerJabatanAnggota.text);
                                      _namaAnggotaList.add(_tempNamaPIC);
                                    });
                                  }
                                  _controllerJabatanAnggota.clear();
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
    return Stack(
      children: [
        Positioned(
          right: 30,
          bottom: 30,
          child: Image(
            width: (MediaQuery.of(context).size.width) * 0.33,
            image: AssetImage(
              'lib/assets/images/createaktifitas.png',
            ),
          ),
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
            child: Container(
              padding: const EdgeInsets.all(16),
              width: deviceWidth,
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        onPressed: () {
                          widget.controllerPageKegiatan.animateToPage(0,
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.ease);
                        },
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      Text(
                        "Buat Kegiatan",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ],
                  ),
                  const Divider(
                    thickness: 1,
                    height: 56,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        responsiveText(
                            "Kode Kegiatan", 14, FontWeight.w700, darkText),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: deviceWidth / 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Card(
                                  color: surfaceColor,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: DropdownSearch<dynamic>(
                                    popupProps: PopupProps.menu(
                                      showSearchBox: true,
                                      searchFieldProps: TextFieldProps(
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(),
                                          hintText: "Cari Disini",
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              _controllerDropdownFilterKegiatan
                                                  .clear();
                                            },
                                            icon: Icon(
                                              Icons.clear,
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                            ),
                                          ),
                                        ),
                                        controller:
                                            _controllerDropdownFilterKegiatan,
                                      ),
                                    ),
                                    items: _kodeKegiatanbuatList,
                                    onChanged: (val) {
                                      debugPrint(val);
                                      debugPrint(_splitString(val));
                                      if (_kategoriNotEmpty == false) {
                                        _kategoriNotEmpty = true;
                                        if (mounted) {
                                          setState(() {});
                                        }
                                      }
                                    },
                                    selectedItem: "Pilih Kegiatan",
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              responsiveText(
                                  "0000001", 18, FontWeight.w500, darkText),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        responsiveText(
                            "Nama Kegiatan", 14, FontWeight.w700, darkText),
                        SizedBox(
                          height: 10,
                        ),
                        responsiveTextField(
                            deviceWidth, deviceHeight, _controllerNamaKegiatan),
                        SizedBox(
                          height: 15,
                        ),
                        responsiveText(
                            "Lokasi Kegiatan", 14, FontWeight.w700, darkText),
                        SizedBox(
                          height: 10,
                        ),
                        responsiveTextField(
                            deviceWidth, deviceHeight, _controllerLokasi),
                        SizedBox(
                          height: 15,
                        ),
                        responsiveText("Keterangan Kegiatan", 14,
                            FontWeight.w700, darkText),
                        SizedBox(
                          height: 10,
                        ),
                        responsiveTextField(deviceWidth, deviceHeight,
                            _controllerKeteranganKegiatan),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Container(

                              padding: EdgeInsets.all(0),

                              width: deviceWidth / 2 * 0.5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  responsiveText("Tanggal Acara Mulai", 14,
                                      FontWeight.w700, darkText),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(dateDariAcara),
                                          IconButton(
                                            onPressed: () {
                                              selectDateDariAcara(context).then(
                                                (value) => setState(() {}),
                                              );
                                            },
                                            icon: const Icon(
                                                Icons.calendar_month),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(0),
                              width: deviceWidth / 2 * 0.5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  responsiveText("Tanggal Acara Selesai", 14,
                                      FontWeight.w700, darkText),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(dateSampaiAcara),
                                          IconButton(
                                            onPressed: () {
                                              selectDateSampaiAcara(context)
                                                  .then(
                                                (value) => setState(() {}),
                                              );
                                            },
                                            icon: const Icon(
                                                Icons.calendar_month),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(0),
                              width: deviceWidth / 2 * 0.5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  responsiveText("Tanggal Kegiatan Mulai", 14,
                                      FontWeight.w700, darkText),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(dateDariKegiatan),
                                          IconButton(
                                            onPressed: () {
                                              selectDateDari(context).then(
                                                (value) => setState(() {}),
                                              );
                                            },
                                            icon: const Icon(
                                                Icons.calendar_month),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(

                              padding: EdgeInsets.all(0),

                              width: deviceWidth / 2 * 0.5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  responsiveText("Tanggal Kegiatan Selesai", 14,
                                      FontWeight.w700, darkText),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(dateSampaiKegiatan),
                                          IconButton(
                                            onPressed: () {
                                              selectDateSampai(context).then(
                                                (value) => setState(() {}),
                                              );
                                            },
                                            icon: const Icon(
                                                Icons.calendar_month),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        responsiveText(
                            "Penanggung Jawab", 14, FontWeight.w700, darkText),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: deviceWidth / 2,
                          child: Card(
                            color: surfaceColor,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: DropdownSearch<dynamic>(
                              popupProps: PopupProps.menu(
                                showSearchBox: true,
                                searchFieldProps: TextFieldProps(
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    hintText: "Cari Disini",
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        _controllerDropdownFilteruser.clear();
                                      },
                                      icon: Icon(
                                        Icons.clear,
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                  controller: _controllerDropdownFilteruser,
                                ),
                              ),
                              items: _user,
                              onChanged: (val) {
                                debugPrint(val);
                                debugPrint(_splitString(val));
                                if (_kategoriNotEmpty == false) {
                                  _kategoriNotEmpty = true;
                                  if (mounted) {
                                    setState(() {});
                                  }
                                }
                              },
                              selectedItem: "Pilih User",
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        responsiveText(
                            "Anggota", 14, FontWeight.w700, darkText),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: deviceWidth * 0.50,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: navButtonPrimary.withOpacity(0.4),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  FutureBuilder(
                                    future: kategoriItemProposalKegiatan,
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
                                              itemCount: _jabatanList.length,
                                              itemBuilder: (context, index) {
                                                return Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    side: BorderSide(
                                                      color: navButtonPrimary
                                                          .withOpacity(0.4),
                                                    ),
                                                  ),
                                                  color:
                                                      scaffoldBackgroundColor,
                                                  child: ListTile(
                                                    title: Text(
                                                      _namaAnggotaList[index],
                                                    ),
                                                    subtitle: Text(
                                                        _jabatanList[index]),
                                                    trailing: IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            _namaAnggotaList
                                                                .removeAt(
                                                                    index);
                                                            _jabatanList
                                                                .removeAt(
                                                                    index);
                                                          });
                                                        },
                                                        icon:
                                                            Icon(Icons.close)),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        }
                                      }

                                      return loadingIndicator();

                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: deviceWidth * 0.5,
                                    child: Column(
                                      children: [
                                        ElevatedButton(
                                          style: TextButton.styleFrom(
                                            primary: Colors.white,
                                            backgroundColor: Color(0xFFf9ab27),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                            ),
                                          ),
                                          onPressed: () {
                                            _showTambahDialogAnggota(
                                                deviceWidth, deviceHeight);
                                          },
                                          child: Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: [
                                              Icon(Icons
                                                  .add_circle_outline_rounded),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              responsiveText(
                                                  "Tambah Anggota",
                                                  14,
                                                  FontWeight.w500,
                                                  Colors.white)
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: deviceWidth / 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              responsiveText("Item Budgeting", 14,
                                  FontWeight.w700, darkText),
                              ElevatedButton(
                                style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  backgroundColor: Color(0xFFf9ab27),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                ),
                                onPressed: () {
                                  _showTambahDialogKebutuhan(
                                      deviceWidth, deviceHeight);
                                },
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Icon(Icons.add_circle_outline_rounded),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    responsiveText("Kebutuhan", 14,
                                        FontWeight.w500, Colors.white)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: deviceWidth * 0.50,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: navButtonPrimary.withOpacity(0.4),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  FutureBuilder(
                                    future: kategoriItemProposalKegiatan,
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
                                              itemCount:
                                                  _kodeKegiatanList.length,
                                              itemBuilder: (context, index) {
                                                return Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    side: BorderSide(
                                                      color: navButtonPrimary
                                                          .withOpacity(0.4),
                                                    ),
                                                  ),
                                                  color:
                                                      scaffoldBackgroundColor,
                                                  child: ListTile(
                                                    title: Text(
                                                      _jenisKebutuhanList[
                                                          index],
                                                    ),
                                                    subtitle:
                                                        Text(_saldoList[index]),
                                                    trailing: IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            _kodeKegiatanList
                                                                .removeAt(
                                                                    index);
                                                            _jenisKebutuhanList
                                                                .removeAt(
                                                                    index);
                                                            _saldoList.removeAt(
                                                                index);
                                                          });
                                                        },
                                                        icon:
                                                            Icon(Icons.close)),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        }
                                      }

                                      return loadingIndicator();

                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: (MediaQuery.of(context).size.width) * 0.5,
                          child: Column(
                            children: [
                              ElevatedButton(
                                style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  backgroundColor: Color(0xFFf9ab27),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                ),
                                onPressed: () {
                                  postProposalKegiatan(
                                      _controllerKodeKegiatan.text,
                                      "gms001",
                                      _controllerNamaKegiatan.text,
                                      _controllerjawab1.text,
                                      dateDariKegiatan,
                                      dateSampaiKegiatan,
                                      _controllerLokasi.text,
                                      _controllerKeteranganKegiatan.text,
                                      context);

                                  for (int i = 0;
                                      i < _kodeKegiatanList.length;
                                      i++) {
                                    postItemProposalKegiatan(
                                        _kodeKegiatanList[i],
                                        _controllerKodeKegiatan.text,
                                        "gms001",
                                        _jenisKebutuhanList[i],
                                        _saldoList[i],
                                        context);
                                  }

                                  _controllerKodeKegiatan.clear();
                                  _controllerNamaKegiatan.clear();
                                  _controllerjawab1.clear();
                                  _controllerLokasi.clear();
                                  _controllerKeteranganKegiatan.clear();
                                  _controllerKodeJenisKebutuhan.clear();
                                  _controllerJenisKebutuhan.clear();
                                  _controllerSaldo.clear();

                                  widget.controllerPageKegiatan.animateToPage(0,
                                      duration: Duration(milliseconds: 700),
                                      curve: Curves.easeOut);
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: Text(
                                    'Buat',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

//TODO: Detail kebutuhan page
class DetailKebutuhanPage extends StatefulWidget {
  final PageController controllerDetailPageKegiatan;
  final PageController controllerPageAbsensiKegiatan;
  final PageController controllerDetailPengeluaranKebutuhan;
  const DetailKebutuhanPage(
      {Key? key,
      required this.controllerDetailPageKegiatan,
      required this.controllerPageAbsensiKegiatan,
      required this.controllerDetailPengeluaranKebutuhan})
      : super(key: key);

  @override
  State<DetailKebutuhanPage> createState() => _DetailKebutuhanPageState();
}

class _DetailKebutuhanPageState extends State<DetailKebutuhanPage> {
  ServicesUser servicesUserItem = ServicesUser();
  late Future kategoriDetailItemProposalKegiatan;
  final _controllerKeluarNominal = TextEditingController();
  final _controllerKeluarKeterangan = TextEditingController();
  var stateOfDisable = true;
  DateTime selectedDatePengeluaran = DateTime.now();
  String formattedDatePengeluaran = "";
  String datePengeluaran = "Date";

  @override
  void initState() {
    // TODO: implement initState
    kategoriDetailItemProposalKegiatan =
        servicesUserItem.getAllItemProposalKegiatan("gms001dns013");
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future postKebutuhanKegiatan(tanggalKebutuhan, keteranganPengeluaran,
      pengeluaranKebutuhan, kodeItemProposalKegiatan, context) async {
    var response = await servicesUserItem.inputKebutuhanKegiatan(
        tanggalKebutuhan,
        keteranganPengeluaran,
        pengeluaranKebutuhan,
        kodeItemProposalKegiatan);

    if (response[0] != 404) {
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response[1]),
        ),
      );
    }
  }

  responsiveTextField(deviceWidth, deviceHeight, controllerText) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        width: deviceWidth * 0.5,
        child: TextField(
          controller: controllerText,
          autofocus: false,
          decoration: InputDecoration(
            filled: true,
            fillColor: surfaceColor,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> selectDatePengeluaran(context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDatePengeluaran,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.amber, // header background color
                onPrimary: Colors.black, // header text color
                onSurface: Colors.black, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: primaryColorVariant, // button text color
                ),
              ),
            ),
            child: child!);
      },
    );
    if (picked != null && picked != selectedDatePengeluaran) {
      if (mounted) {
        selectedDatePengeluaran = picked;
        formattedDatePengeluaran =
            DateFormat('dd-MM-yyyy').format(selectedDatePengeluaran);
        datePengeluaran = formattedDatePengeluaran;
        stateOfDisable = false;
        debugPrint("Selected Date From $selectedDatePengeluaran");

        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return ScrollConfiguration(
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
            width: deviceWidth,
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      onPressed: () {
                        widget.controllerDetailPageKegiatan.animateToPage(0,
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.ease);
                      },
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Detail Kegiatan $_namaKegiatan",
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        Text(
                          "($_kodeKegiatan)",
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(
                  thickness: 1,
                  height: 56,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.controllerPageAbsensiKegiatan.animateToPage(1,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.ease);
                    },
                    style: TextButton.styleFrom(
                      elevation: 1,
                      primary: Colors.white,
                      backgroundColor: Color(0xFFf9ab27),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text("Absen"),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    responsiveText("Tabel Anggota Kegiatan", 20,
                        FontWeight.w700, darkText),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: deviceWidth,
                      decoration: BoxDecoration(
                        color: Color(0xFFfef5e5),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                      //width: deviceWidth / 2,
                      padding: EdgeInsets.all(10),
                      child: FutureBuilder(
                        future: kategoriDetailItemProposalKegiatan,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List snapData = snapshot.data! as List;
                            if (snapData[0] != 404) {
                              return ScrollConfiguration(
                                behavior:
                                    ScrollConfiguration.of(context).copyWith(
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
                                  itemCount: 5,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: BorderSide(
                                          color:
                                              navButtonPrimary.withOpacity(0.4),
                                        ),
                                      ),
                                      color: scaffoldBackgroundColor,
                                      child: ListTile(
                                        title: Text(
                                          "Nama",
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                          }
                          return loadingIndicator();
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      //width: deviceWidth / 2 * 0.4,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Color(0xFFfef5e5),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                      child: responsiveText("Overbudget : " "25.5%", 18,
                          FontWeight.w500, darkText),
                    )),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: responsiveTextNoMax(
                      "*"
                      "is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's.",
                      15,
                      FontWeight.w500,
                      Colors.blueAccent),
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              responsiveText("Tabel Budget", 20,
                                  FontWeight.w700, darkText),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFfef5e5),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  border: Border.all(
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                                width: deviceWidth / 2 * 0.8,
                                padding: EdgeInsets.all(10),
                                child: FutureBuilder(
                                  future: kategoriDetailItemProposalKegiatan,
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
                                              return Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  side: BorderSide(
                                                    color: navButtonPrimary
                                                        .withOpacity(0.4),
                                                  ),
                                                ),
                                                color: scaffoldBackgroundColor,
                                                child: ListTile(
                                                  title: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(snapData[1][index]
                                                          ['jenis_kebutuhan']),
                                                      Text(
                                                        "RP. ${snapData[1][index]['budget_kebutuhan']}",
                                                        style: TextStyle(
                                                            fontSize: 15),
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
                                    return loadingIndicator();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(

                            padding: EdgeInsets.all(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                responsiveText("Tabel Real", 20,

                                    FontWeight.w700, darkText),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFFfef5e5),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    border: Border.all(
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ),

                                  //width: deviceWidth / 2,

                                  padding: EdgeInsets.all(10),
                                  child: FutureBuilder(
                                    future: kategoriDetailItemProposalKegiatan,
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

                                                return Row(
                                                  children: [
                                                    Expanded(
                                                      child: Card(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          side: BorderSide(
                                                            color:
                                                                navButtonPrimary
                                                                    .withOpacity(
                                                                        0.4),
                                                          ),
                                                        ),
                                                        color:
                                                            scaffoldBackgroundColor,
                                                        child: ListTile(
                                                          title: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    snapData[1][
                                                                            index]
                                                                        [
                                                                        'jenis_kebutuhan'],
                                                                  ),
                                                                  Text(
                                                                    "0",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15),
                                                                  )
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        _kodeItemKebutuhan =
                                                                            snapData[1][index]['kode_item_proposal_gabungan'].toString();
                                                                        _namaItemKebutuhan =
                                                                            snapData[1][index]['jenis_kebutuhan'].toString();
                                                                        widget.controllerDetailPengeluaranKebutuhan.animateToPage(
                                                                            1,
                                                                            duration:
                                                                                const Duration(milliseconds: 250),
                                                                            curve: Curves.ease);
                                                                      },
                                                                      icon: Icon(
                                                                          Icons
                                                                              .arrow_forward_rounded)),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),

                                                    ),
                                                    SizedBox(width: 5,),
                                                    Text("0%"),
                                                    SizedBox(width: 5,),
                                                  ],
                                                );
                                              },
                                            ),
                                          );
                                        }
                                      }

                                      return loadingIndicator();

                                    },
                                  ),
                                ),
                              ],

                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                )
              ],

            ),
          ),
        ),
      ),
    );
  }
}

//TODO: Riwayat kebutuhan kegiatan
class HistoryKegiatan extends StatefulWidget {
  final PageController controllerHistoryPageKegiatan;
  const HistoryKegiatan({Key? key, required this.controllerHistoryPageKegiatan})
      : super(key: key);

  @override
  State<HistoryKegiatan> createState() => _HistoryKegiatanState();
}

class _HistoryKegiatanState extends State<HistoryKegiatan> {
  ServicesUser servicesUser = ServicesUser();
  late Future kategoriTransaksiRiwayat;
  @override
  void initState() {
    // TODO: implement initState
    kategoriTransaksiRiwayat = servicesUser.getAllProposalKegiatan("gms001");
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
    return Stack(
      children: [
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
            child: Container(
              padding: EdgeInsets.all(16),
              width: deviceWidth,
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        onPressed: () {
                          widget.controllerHistoryPageKegiatan.animateToPage(0,
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.ease);
                        },
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      Text(
                        "Riwayat Kegiatan",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ],
                  ),
                  const Divider(
                    thickness: 1,
                    height: 56,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: navButtonPrimary.withOpacity(0.4),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: FutureBuilder(
                        future: kategoriTransaksiRiwayat,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List snapData = snapshot.data! as List;
                            if (snapData[0] != 404) {
                              return ScrollConfiguration(
                                behavior:
                                    ScrollConfiguration.of(context).copyWith(
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
                                        borderRadius: BorderRadius.circular(20),
                                        side: BorderSide(
                                          color:
                                              navButtonPrimary.withOpacity(0.4),
                                        ),
                                      ),
                                      color: scaffoldBackgroundColor,
                                      child: ListTile(
                                        leading: Text(
                                          snapData[1][index]['nama_kegiatan'],
                                        ),
                                        trailing: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.all(12),
                                            shape: const CircleBorder(),
                                          ),
                                          onPressed: () {},
                                          child: const Icon(
                                              Icons.format_list_bulleted_sharp),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
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
      ],
    );
  }
}

//TODO: Absensi kegiatan
class AbsensiKegiatanPage extends StatefulWidget {
  final PageController controllerPageAbsensiKegiatan;
  final PageController controllerPageDetailAbsensiKegiatan;

  const AbsensiKegiatanPage(
      {Key? key,
      required this.controllerPageAbsensiKegiatan,
      required this.controllerPageDetailAbsensiKegiatan})
      : super(key: key);

  @override
  State<AbsensiKegiatanPage> createState() => _AbsensiKegiatanPageState();
}

class _AbsensiKegiatanPageState extends State<AbsensiKegiatanPage> {
  ServicesUser servicesUser = ServicesUser();
  late Future kategoriAbsensiKegiatan;

  @override
  void initState() {
    // TODO: implement initState
    kategoriAbsensiKegiatan = servicesUser.getAllProposalKegiatan("gms001");
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
    return Stack(
      children: [
        Positioned(
          right: 0,
          bottom: 0,
          child: Image(
            width: deviceWidth < 800
                ? (deviceHeight * 0.35)
                : (deviceWidth * 0.35),
            image: const AssetImage("lib/assets/images/absen.png"),
          ),
        ),
        ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse}),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            controller: ScrollController(),
            child: Container(
              padding: EdgeInsets.all(16),
              width: deviceWidth,
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        onPressed: () {
                          widget.controllerPageAbsensiKegiatan.animateToPage(0,
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.ease);
                        },
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      Text(
                        "Absensi Kegiatan",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ],
                  ),
                  const Divider(
                    thickness: 1,
                    height: 56,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: deviceWidth / 2,
                        decoration: BoxDecoration(
                          color: Color(0xFFfef5e5),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          border: Border.all(
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                        //width: deviceWidth / 2,
                        padding: EdgeInsets.all(10),
                        child: FutureBuilder(
                          future: kategoriAbsensiKegiatan,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List snapData = snapshot.data! as List;
                              if (snapData[0] != 404) {
                                return ScrollConfiguration(
                                  behavior:
                                      ScrollConfiguration.of(context).copyWith(
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
                                    itemCount: 5,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          side: BorderSide(
                                            color: navButtonPrimary
                                                .withOpacity(0.4),
                                          ),
                                        ),
                                        color: scaffoldBackgroundColor,
                                        child: ListTile(
                                          title: Text(
                                            "31/08/2022",
                                          ),
                                          trailing: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              padding: const EdgeInsets.all(12),
                                              shape: const CircleBorder(),
                                            ),
                                            onPressed: () {
                                              widget
                                                  .controllerPageDetailAbsensiKegiatan
                                                  .animateToPage(1,
                                                      duration: const Duration(
                                                          milliseconds: 250),
                                                      curve: Curves.ease);
                                            },
                                            child: const Icon(
                                                Icons.arrow_forward_rounded),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
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
            ),
          ),
        ),
      ],
    );
  }
}

//TODO: Detail absensi kegiatan
class DetailAbsensiKegiatan extends StatefulWidget {
  final PageController controllerPageDetailAbsensiKegiatan;
  const DetailAbsensiKegiatan(
      {Key? key, required this.controllerPageDetailAbsensiKegiatan})
      : super(key: key);

  @override
  State<DetailAbsensiKegiatan> createState() => _DetailAbsensiKegiatanState();
}

class _DetailAbsensiKegiatanState extends State<DetailAbsensiKegiatan> {
  ServicesUser servicesUser = ServicesUser();
  late Future kategoriDetailAbsensiKegiatan;

  final _controllerJumlahHadir = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    kategoriDetailAbsensiKegiatan =
        servicesUser.getAllProposalKegiatan("gms001");
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  responsiveTextField(deviceWidth, deviceHeight, controllerText) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        width: deviceWidth * 0.5,
        child: TextField(
          controller: controllerText,
          autofocus: false,
          decoration: InputDecoration(
            filled: true,
            fillColor: surfaceColor,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
          ),
        ),
      ),
    );
  }


  @override

  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Positioned(
          right: 0,
          bottom: 0,
          child: Image(
            width: deviceWidth < 800
                ? (deviceHeight * 0.35)
                : (deviceWidth * 0.35),
            image: const AssetImage("lib/assets/images/absen.png"),
          ),
        ),
        ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse}),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            controller: ScrollController(),
            child: Container(
              padding: EdgeInsets.all(16),
              width: deviceWidth,
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        onPressed: () {
                          widget.controllerPageDetailAbsensiKegiatan
                              .animateToPage(0,
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.ease);
                        },
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      Text(
                        "Detail Absensi Kegiatan",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ],
                  ),
                  const Divider(
                    thickness: 1,
                    height: 56,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          responsiveText("Jumlah Kehadiran Anggota", 16,
                              FontWeight.w700, darkText),
                          const SizedBox(
                            height: 10,
                          ),
                          responsiveTextField(deviceWidth, deviceHeight,
                              _controllerJumlahHadir),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: deviceWidth / 2,
                        decoration: BoxDecoration(
                          color: Color(0xFFfef5e5),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          border: Border.all(
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                        //width: deviceWidth / 2,
                        padding: EdgeInsets.all(10),
                        child: FutureBuilder(
                          future: kategoriDetailAbsensiKegiatan,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List snapData = snapshot.data! as List;
                              if (snapData[0] != 404) {
                                return ScrollConfiguration(
                                  behavior:
                                      ScrollConfiguration.of(context).copyWith(
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
                                    itemCount: 5,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          side: BorderSide(
                                            color: navButtonPrimary
                                                .withOpacity(0.4),
                                          ),
                                        ),
                                        color: scaffoldBackgroundColor,
                                        child: ListTile(
                                          title: Text(
                                            "Nama",
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
                                              [Colors.red.withOpacity(0.5)],
                                              [
                                                correctColor.withOpacity(0.8),
                                              ],
                                            ],
                                            onToggle: (index) {
                                              debugPrint('switched to: $index');
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }
                            }

                            return loadingIndicator();

                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text("Simpan"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

//TODO: Detail pengeluaran kebutuhan
class DetailPengeluaranKebutuhan extends StatefulWidget {
  final PageController controllerPageDetailPengeluaranKebutuhan;
  const DetailPengeluaranKebutuhan(
      {super.key, required this.controllerPageDetailPengeluaranKebutuhan});

  @override
  State<DetailPengeluaranKebutuhan> createState() =>
      _DetailPengeluaranKebutuhanState();
}

class _DetailPengeluaranKebutuhanState
    extends State<DetailPengeluaranKebutuhan> {
  ServicesUser servicesUser = ServicesUser();
  late Future kategoriDetailPengeluaran;

  @override
  void initState() {
    // TODO: implement initState
    kategoriDetailPengeluaran =
        servicesUser.getPengeluaranKebutuhan(_kodeItemKebutuhan);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  responsiveTextField(deviceWidth, deviceHeight, controllerText) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        width: deviceWidth * 0.5,
        child: TextField(
          controller: controllerText,
          autofocus: false,
          decoration: InputDecoration(
            filled: true,
            fillColor: surfaceColor,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override

  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse}),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        controller: ScrollController(),
        child: Container(
          padding: EdgeInsets.all(16),
          width: deviceWidth,
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: () {
                      widget.controllerPageDetailPengeluaranKebutuhan
                          .animateToPage(0,
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.ease);
                    },
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Text(

                    "Detail Pengeluaran Kebutuhan $_namaItemKebutuhan",

                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
              const Divider(
                thickness: 1,
                height: 56,
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: deviceWidth / 2,
                    decoration: BoxDecoration(
                      color: Color(0xFFfef5e5),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      border: Border.all(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                    padding: EdgeInsets.all(10),
                    child: FutureBuilder(
                      future: kategoriDetailPengeluaran,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List snapData = snapshot.data! as List;
                          if (snapData[0] != 404) {
                            return ScrollConfiguration(
                              behavior:
                                  ScrollConfiguration.of(context).copyWith(
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
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(
                                        color:
                                            navButtonPrimary.withOpacity(0.4),
                                      ),
                                    ),
                                    color: scaffoldBackgroundColor,
                                    child: ListTile(
                                      title: Text(
                                        snapData[1][index]

                                                ['pengeluaran_kebutuhan'].toString(),

                                      ),
                                      subtitle: Text(
                                        snapData[1][index][
                                            'keterangan_pengeluaran_kebutuhan'],
                                      ),
                                      trailing: Text(
                                        snapData[1][index]['tanggal_kebutuhan'],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
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
        ),
      ),
    );
  }
}

//TODO: List Kode Kegiatan
class ListKodeKegiatan extends StatefulWidget {
  final PageController controllerPageListKode;
  const ListKodeKegiatan({super.key, required this.controllerPageListKode});

  @override
  State<ListKodeKegiatan> createState() => _ListKodeKegiatanState();
}

class _ListKodeKegiatanState extends State<ListKodeKegiatan> {
  ServicesUser servicesUser = ServicesUser();
  late Future kategoriDetailPengeluaran;

  final _controllerBuatKodeKegiatan = TextEditingController();
  final _controllerBuatNamaKegiatan = TextEditingController();

  Future postKategoriKegiatan(kodeKategoriKegiatan, namaKategoriKegiatan,
      kodeGerejaKegiatan, context) async {
    var response = await servicesUser.inputKodeKegiatan(
        kodeKategoriKegiatan, namaKategoriKegiatan, kodeGerejaKegiatan);

    if (response[0] != 404) {
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response[1]),
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    kategoriDetailPengeluaran = servicesUser.getKodeKegiatan("gms001");
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  responsiveTextField(deviceWidth, deviceHeight, controllerText) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        width: deviceWidth * 0.5,
        child: TextField(
          controller: controllerText,
          autofocus: false,
          decoration: InputDecoration(
            filled: true,
            fillColor: surfaceColor,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _showTambahDialogKodeKegiatan(dw, dh) {
    showDialog(
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
                              responsiveText("Tambah Kode Kegiatan", 26,
                                  FontWeight.w700, darkText),
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
                                  responsiveText("Kode Kegiatan", 16,
                                      FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  responsiveTextField(
                                      dw, dh, _controllerBuatKodeKegiatan),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  responsiveText("Nama Kegiatan", 16,
                                      FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  responsiveTextField(
                                      dw, dh, _controllerBuatNamaKegiatan),
                                ],
                              ),
                              const SizedBox(
                                height: 25,
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
                                  if (mounted) {
                                    setState(() {
                                      postKategoriKegiatan(
                                          _controllerBuatKodeKegiatan.text,
                                          _controllerBuatNamaKegiatan.text,
                                          "gms001",
                                          context);
                                      _controllerBuatKodeKegiatan.clear();
                                      _controllerBuatNamaKegiatan.clear();
                                    });
                                  }
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
      kategoriDetailPengeluaran = servicesUser.getKodeKegiatan("gms001");
      return setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse}),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        controller: ScrollController(),
        child: Container(
          padding: EdgeInsets.all(16),
          width: deviceWidth,
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: () {
                      widget.controllerPageListKode.animateToPage(0,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.ease);
                    },
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Text(
                    "List Kode Kegiatan",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
              const Divider(
                thickness: 1,
                height: 56,
              ),
              const SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: primaryColorVariant,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  onPressed: () {
                    _showTambahDialogKodeKegiatan(deviceWidth, deviceHeight);
                  },
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Icon(Icons.add_circle_outline_rounded),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Buat Kode Kegiatan',
                        style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: deviceWidth / 2,
                    decoration: BoxDecoration(
                      color: Color(0xFFfef5e5),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      border: Border.all(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                    padding: EdgeInsets.all(10),
                    child: FutureBuilder(
                      future: kategoriDetailPengeluaran,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List snapData = snapshot.data! as List;
                          if (snapData[0] != 404) {
                            return ScrollConfiguration(
                              behavior:
                                  ScrollConfiguration.of(context).copyWith(
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
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(
                                        color:
                                            navButtonPrimary.withOpacity(0.4),
                                      ),
                                    ),
                                    color: scaffoldBackgroundColor,
                                    child: ListTile(
                                      title: Text(
                                        snapData[1][index]
                                            ['nama_kategori_kegiatan'],
                                      ),
                                      subtitle: Text(
                                        snapData[1][index]
                                            ['kode_kategori_kegiatan'],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
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
        ),
      ),
    );
  }
}
