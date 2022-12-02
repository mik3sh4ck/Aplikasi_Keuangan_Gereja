//ignore_for_file: todo
import 'package:aplikasi_keuangan_gereja/globals.dart';
import 'package:aplikasi_keuangan_gereja/services/apiservices.dart';
import 'package:aplikasi_keuangan_gereja/widgets/string_extension.dart';

import 'package:dropdown_search/dropdown_search.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../themes/colors.dart';
import '../../../widgets/loadingindicator.dart';
import '../../../widgets/responsivetext.dart';

var kodestatus;
String _namaKegiatan = "";
String _namaKegiatanRiwayat = "";
String _kodeKegiatan = "";
String _kodeKegiatanGabungan = "";
String _kodeItemKebutuhan = "";
String _namaItemKebutuhan = "";
String _tanggalAbsensi = "";

String _kodeKegiatanHistory = "";

String _tempNamaPIC = "";
String _tempKodeUserPIC = "";
String _tempKodePerkiraan = "";
String _tempNamaKodePerkiraan = "";
String _tempKodeMaster = "";
String _tempNamaKodeMaster = "";
String _tempKodePenanggungjawab = "";
String _tempkodekegiatangabungan = "";
String _singleList = "0000000";
String _masukAkalNominal = "";
String _harianNominal = "";
String _tempmulaiacara = "";
String _tempselesaiacara = "";
String _tempmulaikegiatan = "";
String _lokasiKegiatan = "";
String _tanggungjawabKegiatan = "";
String _keteranganKegiatan = "";
String _tempselesaikegiatan = "";

String _presentase = "0%";
String _totalreal = "";
String _totalbudget = "";
String _totalpemasukanreal = "";

final List _user = [];
final List _kodeMaster = [];
final List _kodeKegiatanbuatList = [];
final List _kodePerkiraan = [];
final List _kodePerkiraanSingleKegiatan = [];
final List _disimpen = [];

final List<DataRow> _rowListForm = List.empty(growable: true);
int _totalPemasukan = 0;
int _totalPengeluaran = 0;
int _totalSaldo = 0;

bool cekKodeMaster = false;

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
  final _controllerPageForm = PageController();

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
    _controllerPageForm.dispose();
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
                PageView(
                  controller: _controllerPageForm,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    HistoryKegiatan(
                      controllerHistoryPageKegiatan:
                          _controllerHistoryPageKegiatan,
                      controllerPageForm: _controllerPageForm,
                    ),
                    FormHistory(controllerPageForm: _controllerPageForm)
                  ],
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

  var stateOfDisable = true;
  DateTime tanggalUbahStatus = DateTime.now();
  String formattedtanggalUbahStatus = "";
  String datetanggalUbahStatus = "Date";

  @override
  void initState() {
    // TODO: implement initState
    kategoriProposalKegiatan = servicesUser.getAllProposalKegiatan(kodeGereja);
    _updateStatusKegiatan(kodeGereja).then((value) => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future _updateStatusKegiatanPakai(kodeKegGab, context) async {
    var response = await servicesUser.updateStatusRiwayat(kodeKegGab);
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

  Future _updateStatusKegiatan(kodeGereja) async {
    var response = await servicesUser.getAllProposalKegiatan(kodeGereja);
    if (mounted) {
      formattedtanggalUbahStatus =
          DateFormat('dd-MM-yyyy').format(tanggalUbahStatus);
      datetanggalUbahStatus = formattedtanggalUbahStatus;
      stateOfDisable = false;

      setState(() {});
    }
    if (response[0] != 404) {
      for (var element in response[1]) {
        debugPrint(element['tanggal_acara_selesai']);
        debugPrint(datetanggalUbahStatus);
        if (element['tanggal_acara_selesai'] == datetanggalUbahStatus) {
          _updateStatusKegiatanPakai(
              element['kode_kegiatan_gabungan'].toString(), context);
        }
      }
    }
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
              width: deviceWidth,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      responsiveText("Kegiatan", 26, FontWeight.w900, darkText),
                      const SizedBox(
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
                            icon: const Tooltip(
                              message: "Riwayat Kegiatan",
                              child: Icon(Icons.history_outlined),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          ElevatedButton(
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: buttonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            onPressed: () async {
                              kodestatus = await servicesUser.checkPrevilage(
                                  4, kodeGereja, kodeRole);
                              print(kodestatus[0]);
                              if (kodestatus[0] == 200) {
                                widget.controllerPageListKode.animateToPage(1,
                                    duration: const Duration(milliseconds: 250),
                                    curve: Curves.ease);
                              } else {
                                showAlertNoAkses();
                              }
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add_circle_outline_rounded,
                                  color: lightText,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                responsiveText("Kode Kegiatan", 15,
                                    FontWeight.w700, lightText)
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
                  const SizedBox(height: 15),
                  Column(
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Row(
                            children: [
                              ElevatedButton(
                                style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  backgroundColor: buttonColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                ),
                                onPressed: () async {
                                  kodestatus = await servicesUser
                                      .checkPrevilage(3, kodeGereja, kodeRole);
                                  print(kodestatus[0]);
                                  if (kodestatus[0] == 200) {
                                    widget.controllerPageKegiatan.animateToPage(
                                        1,
                                        duration:
                                            const Duration(milliseconds: 250),
                                        curve: Curves.ease);
                                  } else {
                                    showAlertNoAkses();
                                  }
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.add_circle_outline_rounded,
                                      color: lightText,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    responsiveText("Buat Data Kegiatan", 15,
                                        FontWeight.w700, lightText)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
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
                            future: kategoriProposalKegiatan,
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
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            side: BorderSide(
                                              color: navButtonPrimary
                                                  .withOpacity(0.4),
                                            ),
                                          ),
                                          color: scaffoldBackgroundColor,
                                          child: ListTile(
                                            title: responsiveText(
                                                snapData[1][index]
                                                    ['nama_kegiatan'],
                                                18,
                                                FontWeight.w700,
                                                darkText),
                                            subtitle: responsiveText(
                                                snapData[1][index]
                                                    ['kode_kegiatan'],
                                                16,
                                                FontWeight.w500,
                                                darkText),
                                            trailing: Tooltip(
                                              message: "Detail kegiatan",
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  padding:
                                                      const EdgeInsets.all(12),
                                                  shape: const CircleBorder(),
                                                ),
                                                onPressed: () async {
                                                  kodestatus =
                                                      await servicesUser
                                                          .checkPrevilage(
                                                              4,
                                                              kodeGereja,
                                                              kodeRole);
                                                  print(kodestatus[0]);
                                                  if (kodestatus[0] == 200) {
                                                    _namaKegiatan = snapData[1]
                                                            [index]
                                                        ['nama_kegiatan'];
                                                    _kodeKegiatan = snapData[1]
                                                            [index]
                                                        ['kode_kegiatan'];
                                                    _kodeKegiatanGabungan =
                                                        snapData[1][index][
                                                            'kode_kegiatan_gabungan'];
                                                    _tempmulaiacara = snapData[
                                                            1][index][
                                                        'tanggal_acara_dimulai'];
                                                    _tempselesaiacara = snapData[
                                                            1][index][
                                                        'tanggal_acara_selesai'];
                                                    _tempmulaikegiatan = snapData[
                                                            1][index][
                                                        'tanggal_kegiatan_dimulai'];
                                                    _tempselesaikegiatan =
                                                        snapData[1][index][
                                                            'tanggal_kegiatan_selesai'];
                                                    _lokasiKegiatan =
                                                        snapData[1][index]
                                                            ['lokasi_kegiatan'];
                                                    _tanggungjawabKegiatan =
                                                        snapData[1][index][
                                                            'nama_penanggungjawab'];
                                                    _keteranganKegiatan = snapData[
                                                            1][index]
                                                        ['keterangan_kegiatan'];
                                                    widget
                                                        .controllerDetailPageKegiatan
                                                        .animateToPage(1,
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        250),
                                                            curve: Curves.ease);
                                                  } else {
                                                    showAlertNoAkses();
                                                  }
                                                },
                                                child: const Tooltip(
                                                  message: "Detail Kegiatan",
                                                  child: Icon(Icons
                                                      .arrow_forward_rounded),
                                                ),
                                              ),
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
  final _controllerDropdownFilterKodePerkiraan = TextEditingController();

  final List _jabatanList = [];
  final List _namaAnggotaList = [];
  final List _kodeAnggotaList = [];

  final List _kodeKegiatanList = [];
  final List _kodeMasterList = [];
  final List _jenisKebutuhanList = [];
  final List _jenisMasterList = [];
  final List _saldoList = [];

  bool _kategoriNotEmpty = false;

  ServicesUser servicesUserItem = ServicesUser();
  late Future kategoriItemSingleRow;

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
    }
  }

  Future _getKodeMaster(kodeGereja) async {
    var response = await servicesUserItem.getMasterKode(kodeGereja);
    if (response[0] != 404) {
      _kodeMaster.clear();
      for (var element in response[1]) {
        if (element['status'] == "pengeluaran") {
          _kodeMaster.add(
              "${element['header_kode_perkiraan']} - ${element['nama_header']}");
        }
      }
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
    }
  }

  Future _getKodePerkiraanSingleKegiatan(kodeGereja, kodeKegiatan) async {
    _kodePerkiraanSingleKegiatan.clear();

    var response = await servicesUserItem
        .getKodePerkiraanSingleKegiatanBudgeting(kodeGereja, kodeKegiatan);
    if (response[0] != 404) {
      for (var element in response[1]) {
        debugPrint(element.toString());
        _kodePerkiraanSingleKegiatan.add(
            "${element['nama_kode_perkiraan']} - ${element['kode_perkiraan']}");
      }
    }
  }

  Future _getSingleRow(kodeGabungan) async {
    var response = await servicesUserItem.getsingleRow(kodeGabungan);
    if (response[0] != 404) {
      for (var element in response[1]) {
        _singleList = "${element['count_kode_kegiatan']}";
      }
    } else {
      throw "Gagal Mengambil Data";
    }
  }

  Future _updateCountKodeKegiatan(kodeGereja, kodeKegiatan, context) async {
    var response = await servicesUserItem.updateCountKodeKegiatan(
        kodeGereja, kodeKegiatan);
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

  Future _getMasukAkal(kodeMaster, kodeGereja, kodePerkiraan) async {
    var response = await servicesUserItem.getMasukAkal(
        kodeMaster, kodeGereja, kodePerkiraan);
    if (response[0] != 404) {
      _masukAkalNominal = response[1]['budget_kebutuhan_per_hari'].toString();
    } else {
      _masukAkalNominal = 0.toString();
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
    _getAllUser(kodeGereja);
    _getAllKodeKegiatanList(kodeGereja);
    _getKodeMaster(kodeGereja);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> selectDateDari(context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateDariAcara,
      firstDate: selectedDateDariAcara,
      lastDate: selectedDateSampaiAcara,
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: primaryColor, // header background color
                onPrimary: lightText, // header text color
                onSurface: darkText, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: navButtonPrimary, // button text color
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
      initialDate: selectedDateDariKegiatan,
      firstDate: selectedDateDariKegiatan,
      lastDate: selectedDateSampaiAcara,
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: primaryColor, // header background color
                onPrimary: lightText, // header text color
                onSurface: darkText, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: navButtonPrimary, // button text color
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
      firstDate: selectedDateDariAcara,
      lastDate: DateTime(2400, 12, 31),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: primaryColor, // header background color
                onPrimary: lightText, // header text color
                onSurface: darkText, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: navButtonPrimary, // button text color
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
      initialDate: selectedDateDariAcara,
      firstDate: selectedDateDariAcara,
      lastDate: DateTime(DateTime.now().year, 12, 31),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: primaryColor, // header background color
                onPrimary: lightText, // header text color
                onSurface: darkText, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: navButtonPrimary, // button text color
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
      kodekegiatan,
      kodegereja,
      namakegiatan,
      penanggungjawabkode,
      tanggalacaradimulai,
      tanggalacaraselesai,
      lokasikegiatan,
      keterangankegiatan,
      tanggalkegiatandimulai,
      tanggalkegiatanselesai,
      context) async {
    var response = await servicesUserItem.inputProposalKegiatan(
        kodekegiatan,
        kodegereja,
        namakegiatan,
        penanggungjawabkode,
        tanggalacaradimulai,
        tanggalacaraselesai,
        lokasikegiatan,
        keterangankegiatan,
        tanggalkegiatandimulai,
        tanggalkegiatanselesai);

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
      kodeItemProposalPerkiraan,
      kodeItemProposalKegiatan,
      kodeProposalGereja,
      budgetKebutuhan,
      kodeItemProposalMaster,
      context) async {
    var response = await servicesUserItem.inputItemKebutuhan(
        kodeItemProposalPerkiraan,
        kodeItemProposalKegiatan,
        kodeProposalGereja,
        budgetKebutuhan,
        kodeItemProposalMaster);

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

  Future postPICProposalKegiatan(
      kodeUserPIC, kodeKegiatanPIC, kodeGerejaPIC, peranPIC, context) async {
    var response = await servicesUserItem.inputPIC(
        kodeUserPIC, kodeKegiatanPIC, kodeGerejaPIC, peranPIC);

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
                              responsiveText("Tambah Kebutuhan", 26,
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
                                  responsiveText("Kode Master", 16,
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
                                                  _controllerDropdownFilterKodePerkiraan
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
                                                _controllerDropdownFilterKodePerkiraan,
                                          ),
                                        ),
                                        items: _kodeMaster,
                                        onChanged: (val) {
                                          debugPrint(val);
                                          debugPrint(_splitString(val));
                                          _tempNamaKodeMaster =
                                              _splitStringAkhir(val);
                                          _tempKodeMaster = _splitString(val);
                                          if (_kategoriNotEmpty == false) {
                                            _kategoriNotEmpty = true;
                                            if (mounted) {
                                              setState(() {});
                                            }
                                          }
                                          cekKodeMaster = true;
                                          _getKodePerkiraanSingleKegiatan(
                                                  kodeGereja, _tempKodeMaster)
                                              .whenComplete(
                                                  () => setState(() {}));
                                        },
                                        selectedItem: "Pilih Kode Master",
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Visibility(
                                    visible: cekKodeMaster,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        responsiveText("Kode Jenis Kebutuhan",
                                            16, FontWeight.w700, darkText),
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
                                                searchFieldProps:
                                                    TextFieldProps(
                                                  decoration: InputDecoration(
                                                    border:
                                                        const OutlineInputBorder(),
                                                    hintText: "Cari Disini",
                                                    suffixIcon: IconButton(
                                                      onPressed: () {
                                                        _controllerDropdownFilterKodePerkiraan
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
                                                      _controllerDropdownFilterKodePerkiraan,
                                                ),
                                              ),
                                              items:
                                                  _kodePerkiraanSingleKegiatan,
                                              onChanged: (val) {
                                                debugPrint(val);
                                                debugPrint(_splitString(val));
                                                _tempKodePerkiraan =
                                                    _splitStringAkhir(val);
                                                _tempNamaKodePerkiraan =
                                                    _splitString(val);
                                                if (_kategoriNotEmpty ==
                                                    false) {
                                                  _kategoriNotEmpty = true;
                                                  if (mounted) {
                                                    setState(() {});
                                                  }
                                                }
                                              },
                                              selectedItem:
                                                  "Pilih Kode Perkiraan",
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
                                  cekKodeMaster = false;
                                  Navigator.pop(context);
                                },
                                child: const Text("Batal"),
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  final differenceDate = selectedDateSampaiAcara
                                      .difference(selectedDateDariAcara)
                                      .inDays;
                                  print(differenceDate);
                                  await _getMasukAkal(_tempKodeMaster,
                                          kodeGereja, _tempKodePerkiraan)
                                      .whenComplete(() => setState(() {}));
                                  _harianNominal =
                                      (double.parse(_controllerSaldo.text) /
                                              differenceDate)
                                          .toString();

                                  if (double.parse(_harianNominal) >
                                      double.parse(_masukAkalNominal)) {
                                    showDialog(
                                      barrierDismissible: false,
                                      useRootNavigator: true,
                                      context: context,
                                      builder: (context) {
                                        return StatefulBuilder(
                                          builder: (context, setState) {
                                            return Dialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: ScrollConfiguration(
                                                behavior:
                                                    ScrollConfiguration.of(
                                                            context)
                                                        .copyWith(
                                                  dragDevices: {
                                                    PointerDeviceKind.touch,
                                                    PointerDeviceKind.mouse,
                                                  },
                                                ),
                                                child: SingleChildScrollView(
                                                  physics:
                                                      const ClampingScrollPhysics(),
                                                  controller:
                                                      ScrollController(),
                                                  child: SizedBox(
                                                    width: dw * 0.4,
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          width: dw * 0.4,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: primaryColor,
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(10),
                                                              topRight: Radius
                                                                  .circular(10),
                                                            ),
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              const SizedBox(
                                                                height: 16,
                                                              ),
                                                              responsiveText(
                                                                  "Peringatan",
                                                                  26,
                                                                  FontWeight
                                                                      .w700,
                                                                  darkText),
                                                              const SizedBox(
                                                                height: 16,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(16),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  // responsiveText(
                                                                  //     "Nominal budget melebihi perkiraan. Apakah anda yakin untuk melanjutkan penambahan ${_tempNamaKodePerkiraan} dengan nominal ${CurrencyFormat.convertToIdr(int.parse(_controllerSaldo.text), 2)} ?",
                                                                  //     16,
                                                                  //     FontWeight
                                                                  //         .w700,
                                                                  //     darkText),
                                                                  Text(
                                                                    "Nominal budget melebihi perkiraan. Apakah anda yakin untuk melanjutkan penambahan ${_tempNamaKodePerkiraan} dengan nominal ${CurrencyFormat.convertToIdr(int.parse(_controllerSaldo.text), 2)} ?",
                                                                    style: GoogleFonts
                                                                        .nunito(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(16),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    const Text(
                                                                        "Batal"),
                                                              ),
                                                              const SizedBox(
                                                                width: 25,
                                                              ),
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  if (mounted) {
                                                                    setState(
                                                                        () {
                                                                      _kodeKegiatanList
                                                                          .add(
                                                                              _tempKodePerkiraan);
                                                                      _kodeMasterList
                                                                          .add(
                                                                              _tempKodeMaster);
                                                                      _jenisKebutuhanList
                                                                          .add(
                                                                              _tempNamaKodePerkiraan);
                                                                      _jenisMasterList
                                                                          .add(
                                                                              _tempNamaKodeMaster);
                                                                      _saldoList.add(
                                                                          _controllerSaldo
                                                                              .text);
                                                                    });
                                                                  }
                                                                  _controllerJenisKebutuhan
                                                                      .clear();
                                                                  _controllerKodeJenisKebutuhan
                                                                      .clear();
                                                                  _controllerSaldo
                                                                      .clear();
                                                                  cekKodeMaster =
                                                                      false;

                                                                  Navigator.pop(
                                                                      context);
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: const Text(
                                                                    "Lanjutkan"),
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
                                    );
                                  } else {
                                    if (mounted) {
                                      setState(() {
                                        _kodeKegiatanList
                                            .add(_tempKodePerkiraan);
                                        _kodeMasterList.add(_tempKodeMaster);
                                        _jenisKebutuhanList
                                            .add(_tempNamaKodePerkiraan);
                                        _jenisMasterList
                                            .add(_tempNamaKodeMaster);
                                        _saldoList.add(_controllerSaldo.text);
                                      });
                                    }
                                    _controllerJenisKebutuhan.clear();
                                    _controllerKodeJenisKebutuhan.clear();
                                    _controllerSaldo.clear();
                                    cekKodeMaster = false;

                                    Navigator.pop(context);
                                  }
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
                              responsiveText("Tambah Anggota", 26,
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
                                          _tempKodeUserPIC = _splitString(val);
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
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  responsiveText(
                                      "Jabatan", 16, FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  responsiveTextField(
                                      dw, dh, _controllerJabatanAnggota),
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
                                      _kodeAnggotaList.add(_tempKodeUserPIC);
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

  _showTambahDialogKeteranganTanggal(dw, dh, text) {
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
                    width: dw * 0.4,
                    child: Column(
                      children: [
                        Container(
                          width: dw * 0.4,
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
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    responsiveText(
                                        "p", 26, FontWeight.w700, primaryColor),
                                    responsiveText(
                                        "Keterangan Pengisian Tanggal",
                                        26,
                                        FontWeight.w700,
                                        lightText),
                                    IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(
                                          Icons.close_outlined,
                                          color: lightText,
                                        ))
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  responsiveText(
                                      text, 16, FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  const Tooltip(
                                    message: "Gambar Contoh Pengisian Tanggal",
                                    child: Image(
                                      image: AssetImage(
                                        'lib/assets/images/tanggals.png',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
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
            image: const AssetImage(
              'lib/assets/images/budgeting2.png',
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
                          _singleList = "0000000";
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
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
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
                                      _tempkodekegiatangabungan =
                                          _splitString(val);
                                      if (_kategoriNotEmpty == false) {
                                        _kategoriNotEmpty = true;
                                        if (mounted) {
                                          setState(() {});
                                        }
                                      }
                                      _getSingleRow(kodeGereja +
                                              _tempkodekegiatangabungan)
                                          .whenComplete(() => setState(() {}));
                                    },
                                    selectedItem: "Pilih Kegiatan",
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              responsiveText(
                                  "-", 18, FontWeight.w500, darkText),
                              responsiveText(
                                  _singleList, 18, FontWeight.w500, darkText),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        responsiveText(
                            "Nama Kegiatan", 14, FontWeight.w700, darkText),
                        const SizedBox(
                          height: 10,
                        ),
                        responsiveTextField(
                            deviceWidth, deviceHeight, _controllerNamaKegiatan),
                        const SizedBox(
                          height: 15,
                        ),
                        responsiveText(
                            "Lokasi Kegiatan", 14, FontWeight.w700, darkText),
                        const SizedBox(
                          height: 10,
                        ),
                        responsiveTextField(
                            deviceWidth, deviceHeight, _controllerLokasi),
                        const SizedBox(
                          height: 15,
                        ),
                        responsiveText("Keterangan Kegiatan", 14,
                            FontWeight.w700, darkText),
                        const SizedBox(
                          height: 10,
                        ),
                        responsiveTextField(deviceWidth, deviceHeight,
                            _controllerKeteranganKegiatan),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(0),
                              width: deviceWidth / 2 * 0.5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  responsiveText("Tanggal Acara Mulai", 14,
                                      FontWeight.w700, darkText),
                                  const SizedBox(
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
                                              dateSampaiAcara = "Date";
                                              dateDariKegiatan = "Date";
                                              dateSampaiKegiatan = "Date";
                                            },
                                            icon: const Tooltip(
                                              message: "Tanggal Acara Mulai",
                                              child: Icon(Icons.calendar_month),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(0),
                              width: deviceWidth / 2 * 0.5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  responsiveText("Tanggal Acara Selesai", 14,
                                      FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 25),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(dateSampaiAcara),
                                                IconButton(
                                                  onPressed: () {
                                                    if (dateDariAcara !=
                                                        "Date") {
                                                      selectDateSampaiAcara(
                                                              context)
                                                          .then(
                                                        (value) =>
                                                            setState(() {}),
                                                      );
                                                    }
                                                    dateDariKegiatan = "Date";
                                                    dateSampaiKegiatan = "Date";
                                                  },
                                                  icon: const Tooltip(
                                                    message:
                                                        "Tanggal Acara Selesai",
                                                    child: Icon(
                                                        Icons.calendar_month),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.all(12),
                                          shape: const CircleBorder(),
                                        ),
                                        onPressed: () {
                                          _showTambahDialogKeteranganTanggal(
                                              deviceWidth,
                                              deviceHeight,
                                              "Pada pengisian tanggal untuk acara harus memiliki jangka waktu yang lebih panjang dibanding pengisian tanggal kegiatan. Seperti pada contoh dibawah ini.");
                                        },
                                        child: const Tooltip(
                                          message:
                                              "Keterangan Pengaturan Tanggal",
                                          child: Icon(Icons.question_mark),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(0),
                              width: deviceWidth / 2 * 0.5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  responsiveText("Tanggal Kegiatan Mulai", 14,
                                      FontWeight.w700, darkText),
                                  const SizedBox(
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
                                              if (dateDariAcara != "Date" &&
                                                  dateSampaiAcara != "Date") {
                                                selectDateDari(context).then(
                                                  (value) => setState(() {}),
                                                );
                                              }
                                              dateSampaiKegiatan = "Date";
                                            },
                                            icon: const Tooltip(
                                              message: "Tanggal Kegiatan Mulai",
                                              child: Icon(Icons.calendar_month),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(0),
                              width: deviceWidth / 2 * 0.5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  responsiveText("Tanggal Kegiatan Selesai", 14,
                                      FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 25),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(dateSampaiKegiatan),
                                                IconButton(
                                                  onPressed: () {
                                                    if (dateDariAcara !=
                                                            "Date" &&
                                                        dateSampaiAcara !=
                                                            "Date" &&
                                                        dateDariKegiatan !=
                                                            "Date") {
                                                      selectDateSampai(context)
                                                          .then(
                                                        (value) =>
                                                            setState(() {}),
                                                      );
                                                    }
                                                  },
                                                  icon: const Tooltip(
                                                    message:
                                                        "Tanggal Kegiatan Selesai",
                                                    child: Icon(
                                                        Icons.calendar_month),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.all(12),
                                          shape: const CircleBorder(),
                                        ),
                                        onPressed: () {
                                          _showTambahDialogKeteranganTanggal(
                                              deviceWidth,
                                              deviceHeight,
                                              "Pada pengisian tanggal untuk kegiatan harus memiliki jangka waktu yang lebih pendek dibanding pengisian tanggal acara. Seperti pada contoh dibawah ini.");
                                        },
                                        child: const Tooltip(
                                          message:
                                              "Keterangan Pengaturan Tanggal",
                                          child: Icon(Icons.question_mark),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        responsiveText(
                            "Penanggung Jawab", 14, FontWeight.w700, darkText),
                        const SizedBox(
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
                                _tempKodePenanggungjawab = _splitString(val);
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
                        const SizedBox(
                          height: 15,
                        ),
                        responsiveText(
                            "Anggota", 14, FontWeight.w700, darkText),
                        const SizedBox(
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
                                  ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    controller: ScrollController(),
                                    physics: const ClampingScrollPhysics(),
                                    itemCount: _jabatanList.length,
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
                                            _namaAnggotaList[index],
                                          ),
                                          subtitle: Text(_jabatanList[index]),
                                          trailing: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _namaAnggotaList
                                                    .removeAt(index);
                                                _jabatanList.removeAt(index);
                                                _kodeAnggotaList
                                                    .removeAt(index);
                                              });
                                            },
                                            icon: const Tooltip(
                                              message: "Hapus Anggota",
                                              child: Icon(Icons.close),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: deviceWidth * 0.5,
                                    child: Column(
                                      children: [
                                        ElevatedButton(
                                          style: TextButton.styleFrom(
                                            primary: Colors.white,
                                            backgroundColor: buttonColor,
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
                                              const Icon(Icons
                                                  .add_circle_outline_rounded),
                                              const SizedBox(
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
                        const SizedBox(
                          height: 15,
                        ),
                        const SizedBox(
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
                                  backgroundColor: buttonColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                ),
                                onPressed: () {
                                  if (dateDariAcara != "Date" &&
                                      dateSampaiAcara != "Date") {
                                    _showTambahDialogKebutuhan(
                                        deviceWidth, deviceHeight);
                                  }
                                },
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    const Icon(
                                        Icons.add_circle_outline_rounded),
                                    const SizedBox(
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
                        const SizedBox(
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
                                  ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    controller: ScrollController(),
                                    physics: const ClampingScrollPhysics(),
                                    itemCount: _kodeKegiatanList.length,
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
                                            _jenisMasterList[index] +
                                                " - " +
                                                _jenisKebutuhanList[index],
                                          ),
                                          subtitle: Text(
                                            CurrencyFormat.convertToIdr(
                                                int.parse(_saldoList[index]),
                                                2),
                                          ),
                                          trailing: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _kodeKegiatanList
                                                    .removeAt(index);
                                                _jenisKebutuhanList
                                                    .removeAt(index);
                                                _kodeMasterList.removeAt(index);
                                                _jenisMasterList
                                                    .removeAt(index);
                                                _saldoList.removeAt(index);
                                              });
                                            },
                                            icon: const Tooltip(
                                              message: "Hapus Kebutuhan",
                                              child: Icon(Icons.close),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: (MediaQuery.of(context).size.width) * 0.5,
                          child: Column(
                            children: [
                              ElevatedButton(
                                style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  backgroundColor: buttonColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                ),
                                onPressed: () {
                                  _updateCountKodeKegiatan(kodeGereja,
                                      _tempkodekegiatangabungan, context);

                                  postProposalKegiatan(
                                      _tempkodekegiatangabungan + _singleList,
                                      kodeGereja,
                                      _controllerNamaKegiatan.text.capitalize(),
                                      _tempKodePenanggungjawab,
                                      dateDariAcara,
                                      dateSampaiAcara,
                                      _controllerLokasi.text.capitalize(),
                                      _controllerKeteranganKegiatan.text
                                          .capitalize(),
                                      dateDariKegiatan,
                                      dateSampaiKegiatan,
                                      context);

                                  for (int i = 0;
                                      i < _kodeKegiatanList.length;
                                      i++) {
                                    // postItemProposalKegiatan(
                                    //     _kodeKegiatanList[i],
                                    //     _controllerKodeKegiatan.text,
                                    //     "gms001",
                                    //     _jenisKebutuhanList[i],
                                    //     _saldoList[i],
                                    //     context);
                                    postItemProposalKegiatan(
                                        _kodeKegiatanList[i],
                                        _tempkodekegiatangabungan + _singleList,
                                        kodeGereja,
                                        _saldoList[i],
                                        _kodeMasterList[i],
                                        context);
                                  }

                                  for (int i = 0;
                                      i < _namaAnggotaList.length;
                                      i++) {
                                    postPICProposalKegiatan(
                                        _kodeAnggotaList[i],
                                        _tempkodekegiatangabungan + _singleList,
                                        kodeGereja,
                                        _jabatanList[i],
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
                                  _singleList = "";

                                  widget.controllerPageKegiatan.animateToPage(0,
                                      duration:
                                          const Duration(milliseconds: 700),
                                      curve: Curves.easeOut);
                                },
                                child: const Padding(
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
  late Future kategoriDetailAnggotaPIC;
  late Future kategoriDetailpre;
  late Future kategoriDetailPemasukan;

  @override
  void initState() {
    // TODO: implement initState
    kategoriDetailItemProposalKegiatan =
        servicesUserItem.getAllItemProposalKegiatan(
            _kodeKegiatanGabungan, _kodeKegiatan, kodeGereja);
    kategoriDetailAnggotaPIC = servicesUserItem.getPIC(_kodeKegiatanGabungan);
    kategoriDetailPemasukan =
        servicesUserItem.getPemasukanDetail(kodeGereja, _kodeKegiatan);
    _getPresentase(_kodeKegiatanGabungan, _kodeKegiatan, kodeGereja)
        .whenComplete(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future _getPresentase(kodepregabungan, kodeprekeg, kodepregre) async {
    var response = await servicesUserItem.getPersentase(
        kodepregabungan, kodeprekeg, kodepregre);
    if (response[0] != 404) {
      _presentase = response[1]['presentase_global'].toString();
      _totalreal = response[1]['total_pengeluaran'].toString();
      _totalbudget = response[1]['total_budgeting'].toString();
    } else {
      throw "Gagal Mengambil Data";
    }
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

  disimpen(val) {
    _disimpen.add(val);
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
        physics: const ClampingScrollPhysics(),
        controller: ScrollController(),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16),
            width: deviceWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Detail Kegiatan $_namaKegiatan",
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(
                  thickness: 1,
                  height: 56,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: navButtonPrimary,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    responsiveText(
                        "Periode Kegiatan : $_tempmulaikegiatan sampai $_tempselesaikegiatan",
                        18,
                        FontWeight.w600,
                        darkText),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Icon(Icons.people_alt_outlined, color: navButtonPrimary),
                    const SizedBox(
                      width: 5,
                    ),
                    responsiveText("Penanggung Jawab : $_tanggungjawabKegiatan",
                        18, FontWeight.w600, darkText),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Icon(Icons.location_on_rounded, color: navButtonPrimary),
                    const SizedBox(
                      width: 5,
                    ),
                    responsiveText("Lokasi Kegiatan : $_lokasiKegiatan", 18,
                        FontWeight.w600, darkText),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Icon(Icons.description_outlined, color: navButtonPrimary),
                    const SizedBox(
                      width: 5,
                    ),
                    responsiveText(
                        "Keterangan Kegiatan :", 18, FontWeight.w600, darkText),
                    Tooltip(
                        message: _keteranganKegiatan,
                        child: responsiveText(
                            _keteranganKegiatan.length > 24
                                ? '${_keteranganKegiatan.substring(0, 24)}...'
                                : _keteranganKegiatan,
                            18,
                            FontWeight.w600,
                            darkText)),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                          onPressed: () {
                            widget.controllerPageAbsensiKegiatan.animateToPage(
                                1,
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.ease);
                          },
                          style: TextButton.styleFrom(
                            elevation: 1,
                            primary: Colors.white,
                            backgroundColor: buttonColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: responsiveText(
                              "Absen", 15, FontWeight.w700, lightText)),
                    ),
                    Text(
                      "Kode : $_kodeKegiatan",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    responsiveText(
                        "Anggota Kegiatan", 20, FontWeight.w700, darkText),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: deviceWidth,
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                      //width: deviceWidth / 2,
                      padding: const EdgeInsets.all(10),
                      child: FutureBuilder(
                        future: kategoriDetailAnggotaPIC,
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
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(
                                          color:
                                              navButtonPrimary.withOpacity(0.4),
                                        ),
                                      ),
                                      color: scaffoldBackgroundColor,
                                      child: ListTile(
                                        title: responsiveText(
                                            snapData[1][index]['kode_user'],
                                            18,
                                            FontWeight.w700,
                                            darkText),
                                        subtitle: responsiveText(
                                            snapData[1][index]['peran'],
                                            15,
                                            FontWeight.w400,
                                            darkText),
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
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              responsiveText(
                                  "Budget", 20, FontWeight.w700, darkText),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: cardColor,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  border: Border.all(
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                                width: deviceWidth / 2 * 0.68,
                                padding: const EdgeInsets.all(10),
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
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ListView.builder(
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                controller: ScrollController(),
                                                physics:
                                                    const ClampingScrollPhysics(),
                                                itemCount: snapData[1].length,
                                                itemBuilder: (context, index) {
                                                  return Card(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      side: BorderSide(
                                                        color: navButtonPrimary
                                                            .withOpacity(0.4),
                                                      ),
                                                    ),
                                                    color:
                                                        scaffoldBackgroundColor,
                                                    child: ListTile(
                                                      title: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(snapData[1]
                                                                  [index][
                                                              'jenis_kebutuhan']),
                                                          Text(
                                                            CurrencyFormat
                                                                .convertToIdr(
                                                                    snapData[1][
                                                                            index]
                                                                        [
                                                                        'budget_kebutuhan'],
                                                                    2),
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        15),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                              Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 15, 0, 0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      responsiveText(
                                                          "Total Budget",
                                                          16,
                                                          FontWeight.w600,
                                                          darkText),
                                                      responsiveText(
                                                          CurrencyFormat
                                                              .convertToIdr(
                                                                  int.parse(
                                                                      _totalbudget),
                                                                  2),
                                                          16,
                                                          FontWeight.w600,
                                                          darkText),
                                                    ],
                                                  ))
                                            ],
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
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              responsiveText(
                                  "Realisasi", 20, FontWeight.w700, darkText),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: cardColor,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  border: Border.all(
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                                width: deviceWidth / 2 * 0.68,
                                padding: const EdgeInsets.all(10),
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
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ListView.builder(
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
                                                                    .circular(
                                                                        10),
                                                            side: BorderSide(
                                                              color: navButtonPrimary
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
                                                                      snapData[1]
                                                                              [
                                                                              index]
                                                                          [
                                                                          'jenis_kebutuhan'],
                                                                    ),
                                                                    Text(
                                                                      CurrencyFormat.convertToIdr(
                                                                          snapData[1][index]
                                                                              [
                                                                              'sum_kebutuhan'],
                                                                          2),
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              15),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    const SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        _tempKodePerkiraan =
                                                                            snapData[1][index]['kode_perkiraan'].toString();
                                                                        _namaItemKebutuhan =
                                                                            snapData[1][index]['jenis_kebutuhan'].toString();
                                                                        _tempKodeMaster =
                                                                            snapData[1][index]['header_kode_perkiraan'].toString();
                                                                        widget.controllerDetailPengeluaranKebutuhan.animateToPage(
                                                                            1,
                                                                            duration:
                                                                                const Duration(milliseconds: 250),
                                                                            curve: Curves.ease);
                                                                      },
                                                                      icon:
                                                                          const Tooltip(
                                                                        message:
                                                                            "Detail Kebutuhan",
                                                                        child: Icon(
                                                                            Icons.arrow_forward_outlined),
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
                                                },
                                              ),
                                              Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 15, 0, 0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      responsiveText(
                                                          "Total Realisasi",
                                                          16,
                                                          FontWeight.w600,
                                                          darkText),
                                                      responsiveText(
                                                          CurrencyFormat
                                                              .convertToIdr(
                                                                  int.parse(
                                                                      _totalreal),
                                                                  2),
                                                          16,
                                                          FontWeight.w600,
                                                          darkText),
                                                    ],
                                                  ))
                                            ],
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
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                responsiveText("Presentase", 20,
                                    FontWeight.w700, darkText),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: cardColor,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    border: Border.all(
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ),
                                  //width: deviceWidth / 2,
                                  padding: const EdgeInsets.all(10),
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
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ListView.builder(
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  controller:
                                                      ScrollController(),
                                                  physics:
                                                      const ClampingScrollPhysics(),
                                                  itemCount: snapData[1].length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Row(
                                                      children: [
                                                        Expanded(
                                                          child: Card(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              side: BorderSide(
                                                                color: navButtonPrimary
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
                                                                        snapData[1][index]
                                                                            [
                                                                            'jenis_kebutuhan'],
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          snapData[1][index]['persentase_kebutuhan'] >= 100
                                                                              ? Row(
                                                                                  children: [
                                                                                    responsiveText(snapData[1][index]['persentase_kebutuhan'].toString().length > 5 ? snapData[1][index]['persentase_kebutuhan'].toString().substring(0, 5) : snapData[1][index]['persentase_kebutuhan'].toString(), 15, FontWeight.normal, Colors.red),
                                                                                    responsiveText("%", 15, FontWeight.normal, Colors.red),
                                                                                    //disimpen(snapData[1][index]['jenis_kebutuhan'])
                                                                                  ],
                                                                                )
                                                                              : Row(
                                                                                  children: [
                                                                                    responsiveText(snapData[1][index]['persentase_kebutuhan'].toString().length > 5 ? snapData[1][index]['persentase_kebutuhan'].toString().substring(0, 5) : snapData[1][index]['persentase_kebutuhan'].toString(), 15, FontWeight.normal, Colors.green),
                                                                                    responsiveText("%", 15, FontWeight.normal, Colors.green)
                                                                                  ],
                                                                                )
                                                                        ],
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
                                                  },
                                                ),
                                                Container(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(10, 15, 0, 0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        responsiveText(
                                                            "Total Presentase",
                                                            16,
                                                            FontWeight.w600,
                                                            darkText),
                                                        Wrap(
                                                          children: [
                                                            responsiveText(
                                                                _presentase.length >
                                                                        5
                                                                    ? _presentase
                                                                        .substring(
                                                                            0,
                                                                            5)
                                                                    : _presentase,
                                                                16,
                                                                FontWeight.w600,
                                                                darkText),
                                                            responsiveText(
                                                                "%",
                                                                16,
                                                                FontWeight.w600,
                                                                darkText),
                                                          ],
                                                        ),
                                                      ],
                                                    ))
                                              ],
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
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
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
  final PageController controllerPageForm;
  final PageController controllerHistoryPageKegiatan;
  const HistoryKegiatan(
      {Key? key,
      required this.controllerHistoryPageKegiatan,
      required this.controllerPageForm})
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
    kategoriTransaksiRiwayat = servicesUser.getAllRiwayat(kodeGereja);
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
              padding: const EdgeInsets.all(16),
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
                                            _kodeKegiatanHistory = snapData[1]
                                                [index]['kode_kegiatan'];
                                            _namaKegiatanRiwayat = snapData[1]
                                                [index]['nama_kegiatan'];
                                            widget.controllerPageForm
                                                .animateToPage(
                                                    1,
                                                    duration: const Duration(
                                                        milliseconds: 250),
                                                    curve: Curves.ease);
                                          },
                                          child: const Tooltip(
                                            message: "Form Riwayat Kegiatan",
                                            child: Icon(Icons
                                                .format_list_bulleted_outlined),
                                          ),
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
  late Future kategoriDetailAbsensiKegiatanCek;

  var stateOfDisable = true;
  DateTime tanggalUbahAbsen = DateTime.now();
  String formattedtanggalUbahAbsen = "";
  String datetanggalUbahAbsen = "Date";

  @override
  void initState() {
    // TODO: implement initState
    kategoriAbsensiKegiatan =
        servicesUser.getTanggalAbsen(kodeGereja, _kodeKegiatan);
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
              padding: const EdgeInsets.all(16),
              width: deviceWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        "Absensi Kegiatan $_namaKegiatan",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ],
                  ),
                  const Divider(
                    thickness: 1,
                    height: 56,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: navButtonPrimary,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      responsiveText(
                          "Periode Acara : $_tempmulaiacara sampai $_tempselesaiacara",
                          18,
                          FontWeight.w600,
                          darkText),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
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
                      child: Container(
                        width: deviceWidth / 2,
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
                                        child: ExpansionTile(
                                          initiallyExpanded: false,
                                          expandedCrossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          expandedAlignment:
                                              Alignment.centerLeft,
                                          childrenPadding:
                                              const EdgeInsets.all(16),
                                          textColor: darkText,
                                          iconColor: navButtonPrimary,
                                          collapsedTextColor: darkText,
                                          collapsedIconColor: navButtonPrimary,
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              responsiveText(
                                                  snapData[1][index]
                                                      ['tanggal_absen'],
                                                  17,
                                                  FontWeight.w600,
                                                  darkText),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  padding: EdgeInsets.all(12),
                                                  shape: CircleBorder(),
                                                ),
                                                onPressed: () {
                                                  if (mounted) {
                                                    formattedtanggalUbahAbsen =
                                                        DateFormat('dd-MM-yyyy')
                                                            .format(
                                                                tanggalUbahAbsen);
                                                    datetanggalUbahAbsen =
                                                        formattedtanggalUbahAbsen;
                                                    stateOfDisable = false;

                                                    setState(() {});
                                                  }

                                                  if (snapData[1][index]
                                                              ['tanggal_absen']
                                                          .toString() ==
                                                      datetanggalUbahAbsen) {
                                                    _tanggalAbsensi =
                                                        snapData[1][index]
                                                            ['tanggal_absen'];
                                                    widget
                                                        .controllerPageDetailAbsensiKegiatan
                                                        .animateToPage(1,
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        250),
                                                            curve: Curves.ease);
                                                    setState(() {});
                                                  }
                                                },
                                                child: Tooltip(
                                                  message:
                                                      "Absensi Tanggal ${snapData[1][index]['tanggal_absen']}",
                                                  child: const Icon(Icons
                                                      .arrow_forward_outlined),
                                                ),
                                              ),
                                            ],
                                          ),
                                          children: [
                                            AbsorbPointer(
                                              child: FutureBuilder(
                                                future: kategoriDetailAbsensiKegiatanCek =
                                                    servicesUser.getUserAbsen(
                                                        kodeGereja,
                                                        _kodeKegiatan,
                                                        snapData[1][index]
                                                            ['tanggal_absen']),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    List snapData =
                                                        snapshot.data! as List;
                                                    if (snapData[0] != 404) {
                                                      return ScrollConfiguration(
                                                        behavior:
                                                            ScrollConfiguration
                                                                    .of(context)
                                                                .copyWith(
                                                          dragDevices: {
                                                            PointerDeviceKind
                                                                .touch,
                                                            PointerDeviceKind
                                                                .mouse,
                                                          },
                                                        ),
                                                        child: ListView.builder(
                                                          shrinkWrap: true,
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          controller:
                                                              ScrollController(),
                                                          physics:
                                                              const ClampingScrollPhysics(),
                                                          itemCount: snapData[1]
                                                              .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return ListTile(
                                                              title: Text(
                                                                snapData[1]
                                                                        [index][
                                                                    'nama_user'],
                                                              ),
                                                              trailing:
                                                                  ToggleSwitch(
                                                                minWidth: 40,
                                                                initialLabelIndex:
                                                                    snapData[1][
                                                                            index]
                                                                        [
                                                                        'status_user_absensi'],
                                                                cornerRadius:
                                                                    10,
                                                                activeFgColor:
                                                                    Colors
                                                                        .white,
                                                                inactiveBgColor:
                                                                    surfaceColor,
                                                                inactiveFgColor:
                                                                    Colors
                                                                        .white,
                                                                totalSwitches:
                                                                    2,
                                                                activeBgColors: [
                                                                  [
                                                                    errorColor
                                                                        .withOpacity(
                                                                            0.5)
                                                                  ],
                                                                  [
                                                                    correctColor
                                                                        .withOpacity(
                                                                            0.8),
                                                                  ],
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    } else if (snapData[0] ==
                                                        404) {
                                                      return noData();
                                                    }
                                                  }
                                                  return loadingIndicator();
                                                },
                                              ),
                                            ),
                                          ],
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
  late Future kategoriDetailAnggotaPICAbsen;

  final List _kodeUserList = [];
  final List _statusUserAbsensiList = [];

  final _controllerJumlahHadir = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    kategoriDetailAbsensiKegiatan =
        servicesUser.getUserAbsen(kodeGereja, _kodeKegiatan, _tanggalAbsensi);
    widget.controllerPageDetailAbsensiKegiatan.addListener(() {
      debugPrint("Refreshed");
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future _updateAbsensi(kodeGereja, kodeKegiatan, tanggalAbsen, kodeUser,
      statusUserAbsensi, context) async {
    var response = await servicesUser.updateUserAbsensi(
        kodeGereja, kodeKegiatan, tanggalAbsen, kodeUser, statusUserAbsensi);
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
              padding: const EdgeInsets.all(16),
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
                        "Detail Absensi Kegiatan Tanggal $_tanggalAbsensi",
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
                          color: cardColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          border: Border.all(
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                        padding: const EdgeInsets.all(10),
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
                                          title: Text(
                                            snapData[1][index]['nama_user'],
                                          ),
                                          trailing: ToggleSwitch(
                                            minWidth: 40,
                                            initialLabelIndex: snapData[1]
                                                [index]['status_user_absensi'],
                                            cornerRadius: 10,
                                            activeFgColor: Colors.white,
                                            inactiveBgColor: surfaceColor,
                                            inactiveFgColor: Colors.white,
                                            totalSwitches: 2,
                                            activeBgColors: [
                                              [errorColor.withOpacity(0.5)],
                                              [
                                                correctColor.withOpacity(0.8),
                                              ],
                                            ],
                                            onToggle: (indextoggle) {
                                              // debugPrint('switched to: $indextoggle');
                                              // debugPrint('User to: ' +
                                              //     snapData[1][index]
                                              //         ['kode_user']);
                                              _kodeUserList.add(snapData[1]
                                                  [index]['kode_user']);
                                              _statusUserAbsensiList
                                                  .add(indextoggle);
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
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          for (int i = 0; i < _kodeUserList.length; i++) {
                            print(_kodeUserList);
                            print(_statusUserAbsensiList);
                            _updateAbsensi(
                                    kodeGereja,
                                    _kodeKegiatan,
                                    _tanggalAbsensi,
                                    _kodeUserList[i],
                                    _statusUserAbsensiList[i],
                                    context)
                                .whenComplete(() {
                              kategoriDetailAbsensiKegiatan =
                                  servicesUser.getUserAbsen(kodeGereja,
                                      _kodeKegiatan, _tanggalAbsensi);
                            });
                          }
                          _kodeUserList.clear();
                          _statusUserAbsensiList.clear();
                          widget.controllerPageDetailAbsensiKegiatan
                              .animateToPage(0,
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.ease)
                              .whenComplete(() => setState(() {}));
                        },
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
    kategoriDetailPengeluaran = servicesUser.getDetailKebutuhanKegiatan(
        _kodeKegiatan, kodeGereja, _tempKodePerkiraan, _tempKodeMaster);
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
          padding: const EdgeInsets.all(16),
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
                      color: cardColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      border: Border.all(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                    padding: const EdgeInsets.all(10),
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
                                        snapData[1][index]['uraian_transaksi'],
                                      ),
                                      subtitle: Text(
                                        CurrencyFormat.convertToIdr(
                                            snapData[1][index]['nominal'], 2),
                                      ),
                                      trailing: Text(
                                        snapData[1][index]['tanggal_transaksi'],
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

  Future deleteKodeKegiatan(kodeGereja, kodeKegiatan, context) async {
    var response =
        await servicesUser.deleteKodeKegiatan(kodeGereja, kodeKegiatan);

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
    kategoriDetailPengeluaran = servicesUser.getKodeKegiatan(kodeGereja);
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

  responsiveTextFieldMax(deviceWidth, deviceHeight, controllerText, size) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        width: deviceWidth * 0.5,
        child: TextField(
          controller: controllerText,
          autofocus: false,
          maxLength: size,
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
                              responsiveText("Tambah Kode Kegiatan", 26,
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
                                  responsiveText("Kode Kegiatan", 16,
                                      FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  responsiveTextFieldMax(
                                      dw, dh, _controllerBuatKodeKegiatan, 5),
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
                                  _controllerBuatKodeKegiatan.clear();
                                  _controllerBuatNamaKegiatan.clear();
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
                                              _controllerBuatKodeKegiatan.text
                                                  .toUpperCase(),
                                              _controllerBuatNamaKegiatan.text
                                                  .capitalize(),
                                              kodeGereja,
                                              context)
                                          .then((value) {
                                        _controllerBuatKodeKegiatan.clear();
                                        _controllerBuatNamaKegiatan.clear();
                                        Navigator.pop(context);
                                      });
                                    });
                                  }
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
      kategoriDetailPengeluaran = servicesUser.getKodeKegiatan(kodeGereja);
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
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse}),
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
                    backgroundColor: buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  onPressed: () async {
                    kodestatus = await servicesUser.checkPrevilage(
                        3, kodeGereja, kodeRole);
                    print(kodestatus[0]);
                    if (kodestatus[0] == 200) {
                      _showTambahDialogKodeKegiatan(deviceWidth, deviceHeight);
                    } else {
                      showAlertNoAkses();
                    }
                  },
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Icon(Icons.add_circle_outline_rounded),
                      const SizedBox(
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
              const SizedBox(
                height: 15,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: deviceWidth / 2,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      border: Border.all(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                    padding: const EdgeInsets.all(10),
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
                                      trailing: IconButton(
                                        onPressed: () async {
                                          kodestatus =
                                              await servicesUser.checkPrevilage(
                                                  2, kodeGereja, kodeRole);
                                          print(kodestatus[0]);
                                          if (kodestatus[0] == 200) {
                                            deleteKodeKegiatan(
                                                    kodeGereja,
                                                    snapData[1][index][
                                                        'kode_kategori_kegiatan'],
                                                    context)
                                                .whenComplete(() {
                                              kategoriDetailPengeluaran =
                                                  servicesUser.getKodeKegiatan(
                                                      kodeGereja);
                                              setState(() {});
                                            });
                                          } else {
                                            showAlertNoAkses();
                                          }
                                        },
                                        icon: const Tooltip(
                                          message: "Hapus Kode Kegiatan",
                                          child: Icon(Icons.delete_forever),
                                        ),
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FormHistory extends StatefulWidget {
  final PageController controllerPageForm;
  const FormHistory({super.key, required this.controllerPageForm});

  @override
  State<FormHistory> createState() => _FormHistoryState();
}

class _FormHistoryState extends State<FormHistory> {
  ServicesUser servicesUser = ServicesUser();
  late Future kategoriDetailItemProposalKegiatan;

  @override
  void initState() {
    _rowListForm.clear();
    _totalPemasukan = 0;
    _totalPengeluaran = 0;
    _totalSaldo = 0;
    _getTransaksi(kodeGereja);
    _getTransaksi2(kodeGereja);
    kategoriDetailItemProposalKegiatan =
        servicesUser.getAllItemProposalKegiatan(
            kodeGereja + _kodeKegiatanHistory,
            _kodeKegiatanHistory,
            kodeGereja);
    _getPresentase(
            kodeGereja + _kodeKegiatanHistory, _kodeKegiatanHistory, kodeGereja)
        .whenComplete(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future _getPresentase(kodepregabungan, kodeprekeg, kodepregre) async {
    var response = await servicesUser.getPersentase(
        kodepregabungan, kodeprekeg, kodepregre);
    if (response[0] != 404) {
      _presentase = response[1]['presentase_global'].toString();
      _totalreal = response[1]['total_pengeluaran'].toString();
      _totalbudget = response[1]['total_budgeting'].toString();
      _totalpemasukanreal = response[1]['total_pemasukan'].toString();
    } else {
      throw "Gagal Mengambil Data";
    }
  }

  _cardInfo(title, nominal) {
    return Expanded(
      child: Card(
        elevation: 3,
        color: cardInfoColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: navButtonPrimary.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              responsiveText(title, 16, FontWeight.w700, darkText),
              Divider(
                color: navButtonPrimary.withOpacity(0.5),
                thickness: 1,
                height: 10,
              ),
              responsiveText(CurrencyFormat.convertToIdr(nominal, 2), 16,
                  FontWeight.w700, darkText),
            ],
          ),
        ),
      ),
    );
  }

  Future _getTransaksi(kodeGereja) async {
    _rowListForm.clear();
    var response =
        await servicesUser.getPemasukanDetail(kodeGereja, _kodeKegiatanHistory);
    if (response[0] != 404) {
      for (var element in response[1]) {
        _addRowTransaksi(
            element['kode_transaksi'],
            element['kode_perkiraan'],
            element['tanggal_transaksi'],
            element['uraian_transaksi'],
            element['jenis_transaksi'],
            element['nominal']);
      }
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future _getTransaksi2(kodeGereja) async {
    _rowListForm.clear();
    var response =
        await servicesUser.getPengeluaranForm(kodeGereja, _kodeKegiatanHistory);
    if (response[0] != 404) {
      for (var element in response[1]) {
        _addRowTransaksi(
            element['kode_transaksi'],
            element['kode_perkiraan'],
            element['tanggal_transaksi'],
            element['uraian_transaksi'],
            element['jenis_transaksi'],
            element['nominal']);
      }
      if (mounted) {
        setState(() {});
      }
    }
  }

  void _addRowTransaksi(kode1, kode2, tanggal, deskripsi, jenis, nominal) {
    _rowListForm.add(
      DataRow(
        cells: [
          DataCell(
            Text(
              kode1.toString(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          DataCell(
            Text(
              kode2.toString(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          DataCell(
            Text(
              tanggal.toString(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          DataCell(
            Text(
              deskripsi.toString(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          DataCell(
            Text(
              jenis == "pemasukan" ? nominal.toString() : "-",
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse}),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        controller: ScrollController(),
        child: Container(
          padding: const EdgeInsets.all(16),
          width: deviceWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: () {
                      widget.controllerPageForm.animateToPage(0,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.ease);
                    },
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Text(
                    "Form Riwayat Kegiatan $_namaKegiatanRiwayat",
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
              SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                controller: ScrollController(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: deviceWidth < 1280
                              ? SingleChildScrollView(
                                  physics: const ClampingScrollPhysics(),
                                  controller: ScrollController(),
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    border: TableBorder.all(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.black.withOpacity(0.5),
                                      style: BorderStyle.solid,
                                    ),
                                    headingRowHeight: 70,
                                    dataRowHeight: 56,
                                    columns: [
                                      DataColumn(
                                        label: Text(
                                          "Kode Transaksi",
                                          style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          "Kode Perkiraan",
                                          style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          "Tanggal",
                                          style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          "Deskripsi",
                                          style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          "Total",
                                          style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                    rows: List.generate(
                                      _rowListForm.length,
                                      (index) {
                                        return DataRow(
                                            color:
                                                MaterialStateColor.resolveWith(
                                              (states) {
                                                return index % 2 == 1
                                                    ? Colors.white
                                                    : primaryColor
                                                        .withOpacity(0.2);
                                              },
                                            ),
                                            cells: _rowListForm[index].cells);
                                      },
                                    ),
                                  ),
                                )
                              : DataTable(
                                  border: TableBorder.all(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.black.withOpacity(0.5),
                                    style: BorderStyle.solid,
                                  ),
                                  headingRowHeight: 70,
                                  dataRowHeight: 56,
                                  columns: [
                                    DataColumn(
                                      label: Text(
                                        "Kode Transaksi",
                                        style: GoogleFonts.nunito(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "Kode Perkiraan",
                                        style: GoogleFonts.nunito(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "Tanggal",
                                        style: GoogleFonts.nunito(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "Deskripsi",
                                        style: GoogleFonts.nunito(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "Total",
                                        style: GoogleFonts.nunito(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                  rows: List.generate(
                                    _rowListForm.length,
                                    (index) {
                                      return DataRow(
                                          color: MaterialStateColor.resolveWith(
                                            (states) {
                                              return index % 2 == 1
                                                  ? Colors.white
                                                  : primaryColor
                                                      .withOpacity(0.2);
                                            },
                                          ),
                                          cells: _rowListForm[index].cells);
                                    },
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _cardInfo(
                    "Total Budget",
                    int.parse(_totalbudget),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  _cardInfo(
                    "Total Realisasi",
                    int.parse(_totalreal),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 15, 5, 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    responsiveText(
                        "Presentase Item", 20, FontWeight.w700, darkText),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                      width: deviceWidth / 2,
                      padding: const EdgeInsets.all(10),
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      controller: ScrollController(),
                                      physics: const ClampingScrollPhysics(),
                                      itemCount: snapData[1].length,
                                      itemBuilder: (context, index) {
                                        return Row(
                                          children: [
                                            Expanded(
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  side: BorderSide(
                                                    color: navButtonPrimary
                                                        .withOpacity(0.4),
                                                  ),
                                                ),
                                                color: scaffoldBackgroundColor,
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
                                                            snapData[1][index][
                                                                    'jenis_kebutuhan'] +
                                                                " " +
                                                                "(" +
                                                                snapData[1]
                                                                        [index][
                                                                    'kode_perkiraan'] +
                                                                ")",
                                                          ),
                                                          Row(
                                                            children: [
                                                              snapData[1][index]
                                                                          [
                                                                          'persentase_kebutuhan'] >=
                                                                      100
                                                                  ? Row(
                                                                      children: [
                                                                        responsiveText(
                                                                            snapData[1][index]['persentase_kebutuhan'].toString().length > 5
                                                                                ? snapData[1][index]['persentase_kebutuhan'].toString().substring(0, 5)
                                                                                : snapData[1][index]['persentase_kebutuhan'].toString(),
                                                                            15,
                                                                            FontWeight.normal,
                                                                            Colors.red),
                                                                        responsiveText(
                                                                            "%",
                                                                            15,
                                                                            FontWeight.normal,
                                                                            Colors.red)
                                                                      ],
                                                                    )
                                                                  : Row(
                                                                      children: [
                                                                        responsiveText(
                                                                            snapData[1][index]['persentase_kebutuhan'].toString().length > 5
                                                                                ? snapData[1][index]['persentase_kebutuhan'].toString().substring(0, 5)
                                                                                : snapData[1][index]['persentase_kebutuhan'].toString(),
                                                                            15,
                                                                            FontWeight.normal,
                                                                            Colors.green),
                                                                        responsiveText(
                                                                            "%",
                                                                            15,
                                                                            FontWeight.normal,
                                                                            Colors.green)
                                                                      ],
                                                                    )
                                                            ],
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
                                      },
                                    ),
                                  ],
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
