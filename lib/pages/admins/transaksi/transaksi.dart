// ignore_for_file: todo

import 'dart:typed_data';

import 'package:aplikasi_keuangan_gereja/globals.dart';
import 'package:aplikasi_keuangan_gereja/services/apiservices.dart';
import 'package:aplikasi_keuangan_gereja/widgets/string_extension.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:signature/signature.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../../themes/colors.dart';
import '../../../widgets/loadingindicator.dart';
import '../../../widgets/responsivetext.dart';
import 'package:pdf/widgets.dart' as pw;

final List _kodeMaster = List.empty(growable: true);
final List _kodePerkiraan = List.empty(growable: true);

final List _kodeMasterSA = List.empty(growable: true);
final List _kodePerkiraanSA = List.empty(growable: true);

final List _kodeTransaksiAdded = List.empty(growable: true);
final List _kodeTransaksi = List.empty(growable: true);
final List _kodeRefKegiatan = List.empty(growable: true);
final List _kodePerkiraanSingleKegiatan = List.empty(growable: true);

final List _dataNeraca = List.empty(growable: true);
final List _dataBukuBesar = List.empty(growable: true);
final List _dataJurnal = List.empty(growable: true);

final List<DataRow> _saldoAwal = List.empty(growable: true);
final List<DataRow> _rowList = List.empty(growable: true);

final List<DataRow> _neracaTable = List.empty(growable: true);
final List<DataRow> _JurnalTable = List.empty(growable: true);
final List<DataRow> _BukuBesarTable = List.empty(growable: true);

int _totalPemasukan = 0;
int _totalPengeluaran = 0;
int _totalSaldo = 0;

String _singleKodeTransaksi = "";
String _kodeTransaksiCount = "000";

int kodeQueryTanggal = 0;

class AdminControllerTransaksiPage extends StatefulWidget {
  const AdminControllerTransaksiPage({Key? key}) : super(key: key);

  @override
  State<AdminControllerTransaksiPage> createState() =>
      _AdminControllerTransaksiPageState();
}

class _AdminControllerTransaksiPageState
    extends State<AdminControllerTransaksiPage> {
  final _controllerPageKodeKeuangan = PageController();
  final _controllerPageBuatTransaksi = PageController();
  final _controllerPageLihatLaporan = PageController();
  final _controllerPageLihatSaldoAwal = PageController();
  @override
  void initState() {
    // TODO: implement initState
    _rowList.clear();
    _saldoAwal.clear();

    _totalPemasukan = 0;
    _totalPengeluaran = 0;
    _totalSaldo = 0;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controllerPageKodeKeuangan.dispose();
    _controllerPageBuatTransaksi.dispose();
    _controllerPageLihatLaporan.dispose();
    _controllerPageLihatSaldoAwal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controllerPageKodeKeuangan,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        PageView(
          controller: _controllerPageBuatTransaksi,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            PageView(
              controller: _controllerPageLihatLaporan,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                AdminTransaksiPage(
                  controllerPageKategori: _controllerPageKodeKeuangan,
                  controllerPageBuatTransaksi: _controllerPageBuatTransaksi,
                  controllerPageLihatLaporan: _controllerPageLihatLaporan,
                ),
                PageView(
                  controller: _controllerPageLihatSaldoAwal,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    AdminLaporanKeuangan(
                        controllerPageLihatLaporan: _controllerPageLihatLaporan,
                        controllerPageLihatSaldoAwal:
                            _controllerPageLihatSaldoAwal),
                    AdminLihatSaldoAwal(
                        controllerPageLihatSaldoAwal:
                            _controllerPageLihatSaldoAwal)
                  ],
                ),
              ],
            ),
            AdminBuatTransaksiPage(
              controllerPageBuatTransaksi: _controllerPageBuatTransaksi,
            )
          ],
        ),
        BuatKodeKeuanganPage(
          controllerPageKategori: _controllerPageKodeKeuangan,
        ),
      ],
    );
  }
}

class AdminTransaksiPage extends StatefulWidget {
  final PageController controllerPageKategori;
  final PageController controllerPageBuatTransaksi;
  final PageController controllerPageLihatLaporan;
  const AdminTransaksiPage(
      {Key? key,
      required this.controllerPageKategori,
      required this.controllerPageBuatTransaksi,
      required this.controllerPageLihatLaporan})
      : super(key: key);

  @override
  State<AdminTransaksiPage> createState() => _AdminTransaksiPageState();
}

class _AdminTransaksiPageState extends State<AdminTransaksiPage> {
  ServicesUser servicesUser = ServicesUser();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _controllerDropdownFilter = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String formattedDate = "";
  String date = "Date";

  DateTime selectedDate1 = DateTime.now();
  String formattedDate1 = "";
  String dateFrom = "Date";

  DateTime selectedDate2 = DateTime.now();
  String formattedDate2 = "";
  String dateTo = "Date";

  DateTime selectedMonth = DateTime.now();
  String formattedMonth = "";
  String month = "Month";

  int dayOfWeek = DateTime.now().weekday - 1;
  DateTime firstDay = DateTime.now();
  DateTime lastDay = DateTime.now();

  int _indexFilterTanggal = 0;

  String kodeTransaksiFilter = "";
  String kodePerkiraanFilter = "";

  String selectedKodePerkiraan = "Pilih Akun";

  @override
  void initState() {
    // TODO: implement initState
    _rowList.clear();
    _saldoAwal.clear();
    _totalPemasukan = 0;
    _totalPengeluaran = 0;
    _totalSaldo = 0;

    kodeTransaksiFilter = "";
    kodePerkiraanFilter = "";

    selectedKodePerkiraan = "Pilih Akun";

    widget.controllerPageBuatTransaksi.addListener(() {
      debugPrint("Refreshed");
      if (mounted) {
        setState(() {});
      }
    });

    _getKodeTransaksiAdded(kodeGereja);
    _getKodePerkiraan(kodeGereja, "", "", "pengeluaran");
    _getMasterKode(kodeGereja);
    _getTransaksi(kodeGereja);

    formattedDate1 = DateFormat('dd-MM-yyyy').format(selectedDate1);
    dateFrom = formattedDate1;

    formattedDate2 = DateFormat('dd-MM-yyyy').format(selectedDate2);
    dateTo = formattedDate2;

    formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
    date = formattedDate;

    formattedMonth = DateFormat('MM-yyyy').format(selectedMonth);
    month = formattedMonth;

    dayOfWeek = DateTime.now().weekday - 1;
    firstDay = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day - dayOfWeek);
    lastDay = firstDay.add(
      const Duration(days: 6, hours: 23, minutes: 59),
    );

    _controllerDropdownFilter.addListener(_changedSearch);

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controllerDropdownFilter.dispose();

    super.dispose();
  }

  Future _getKodePerkiraan(
      kodeGereja, kodeKegiatan, kodeTransaksi, status) async {
    _kodePerkiraan.clear();

    var response = await servicesUser.getKodePerkiraanSingleKegiatan(
        kodeGereja, kodeKegiatan, kodeTransaksi, status);

    if (response[0] != 404) {
      for (var element in response[1]) {
        debugPrint(element.toString());
        _kodePerkiraan.add(
            "${element['kode_perkiraan']} ~ ${element['nama_kode_perkiraan']}");
      }
    }
  }

  Future _getMasterKode(kodeGereja) async {
    _kodeMaster.clear();

    var response = await servicesUser.getMasterKode(kodeGereja);
    if (response[0] != 404) {
      for (var element in response[1]) {
        debugPrint(element.toString());
        _kodeMaster.add(
            "${element['header_kode_perkiraan']} - ${element['nama_header']}");
      }
    }
  }

  Future _getKodeTransaksiAdded(kodeGereja) async {
    _kodeTransaksiAdded.clear();
    var response = await servicesUser.getKodeTransaksiAdded(kodeGereja);
    if (response[0] != 404) {
      for (var element in response[1]) {
        debugPrint(element.toString());
        _kodeTransaksiAdded
            .add("${element['kode_transaksi']} - ${element['nama_transaksi']}");
      }
    }
  }

  Future _getTransaksi(kodeGereja) async {
    _rowList.clear();
    _totalPemasukan = 0;
    _totalPengeluaran = 0;
    _totalSaldo = 0;
    var response = await servicesUser.getTransaksi(kodeGereja);
    if (response[0] != 404) {
      for (var element in response[1]) {
        _addRowTransaksi(
            element['kode_transaksi'],
            element['tanggal_transaksi'],
            element['uraian_transaksi'],
            element['jenis_transaksi'],
            element['nominal']);
        if (element['jenis_transaksi'] == "pemasukan") {
          _totalPemasukan += element['nominal'] as int;
        } else {
          _totalPengeluaran += element['nominal'] as int;
        }
      }
      _totalSaldo = _totalPemasukan - _totalPengeluaran;
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future _queryTransaksiTanggal(kodeGereja, tanggal1, tanggal2, kode) async {
    _rowList.clear();
    _totalPemasukan = 0;
    _totalPengeluaran = 0;
    _totalSaldo = 0;
    var response = await servicesUser.queryTransaksiTanggal(
        kodeGereja, kode, tanggal1, tanggal2);
    if (response[0] != 404) {
      for (var element in response[1]) {
        _addRowTransaksi(
            element['kode_transaksi'],
            element['tanggal_transaksi'],
            element['uraian_transaksi'],
            element['jenis_transaksi'],
            element['nominal']);
        if (element['jenis_transaksi'] == "pemasukan") {
          _totalPemasukan += element['nominal'] as int;
        } else {
          _totalPengeluaran += element['nominal'] as int;
        }
      }
      _totalSaldo = _totalPemasukan - _totalPengeluaran;
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future _queryTransaksiKode(kodeGereja, kodeTransaksi, kodePerkiraan) async {
    _rowList.clear();
    _totalPemasukan = 0;
    _totalPengeluaran = 0;
    _totalSaldo = 0;
    var response = await servicesUser.queryTransaksiKode(
        kodeGereja, kodeTransaksi, kodePerkiraan);
    if (response[0] != 404) {
      for (var element in response[1]) {
        _addRowTransaksi(
            element['kode_transaksi'],
            element['tanggal_transaksi'],
            element['uraian_transaksi'],
            element['jenis_transaksi'],
            element['nominal']);
        if (element['jenis_transaksi'] == "pemasukan") {
          _totalPemasukan += element['nominal'] as int;
        } else {
          _totalPengeluaran += element['nominal'] as int;
        }
      }
      _totalSaldo = _totalPemasukan - _totalPengeluaran;
      if (mounted) {
        setState(() {});
      }
    }
  }

  void _addRowTransaksi(kode, tanggal, deskripsi, jenis, nominal) {
    _rowList.add(
      DataRow(
        cells: [
          DataCell(
            Text(
              kode.toString(),
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
              jenis == "pemasukan"
                  ? CurrencyFormatAkuntansi.convertToIdr(
                      int.parse(nominal.toString()), 2)
                  : "-",
              overflow: TextOverflow.ellipsis,
            ),
          ),
          DataCell(
            Text(
              jenis == "pengeluaran"
                  ? CurrencyFormatAkuntansi.convertToIdr(
                      int.parse(nominal.toString()), 2)
                  : "-",
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ], 
      ),
    );
  }

  responsiveTextField(deviceWidth, deviceHeight, controllerText) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
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
    );
  }

  Future<void> selectMonth(context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5, 1, 1),
      lastDate: DateTime(DateTime.now().year, 12, 31),
      initialDate: selectedMonth,
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
                  foregroundColor: navButtonPrimary, // button text color
                ),
              ),
            ),
            child: child!);
      },
    );
    if (picked != null && picked != selectedMonth) {
      if (mounted) {
        selectedMonth = picked;
        formattedMonth = DateFormat('MM-yyyy').format(selectedMonth);
        month = formattedMonth;
        debugPrint("Selected Month $month");
        setState(() {});
      }
    }
  }

  Future<void> selectDate(context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(DateTime.now().year - 5, 1, 1),
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
                  foregroundColor: navButtonPrimary, // button text color
                ),
              ),
            ),
            child: child!);
      },
    );
    if (picked != null && picked != selectedDate) {
      if (mounted) {
        selectedDate = picked;
        formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
        date = formattedDate;
        debugPrint("Selected Date From $selectedDate");

        setState(() {});
      }
    }
  }

  Future<void> selectDateFrom(context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: firstDay,
      firstDate: DateTime(DateTime.now().year - 5, 1, 1),
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
                  foregroundColor: navButtonPrimary, // button text color
                ),
              ),
            ),
            child: child!);
      },
    );
    if (picked != null && picked != selectedDate1) {
      if (mounted) {
        dayOfWeek = picked.weekday - 1;
        firstDay = DateTime(picked.year, picked.month, picked.day - dayOfWeek);
        lastDay = firstDay.add(
          const Duration(days: 6, hours: 23, minutes: 59),
        );
        selectedDate1 = firstDay;
        selectedDate2 = lastDay;
        formattedDate1 = DateFormat('dd-MM-yyyy').format(selectedDate1);
        formattedDate2 = DateFormat('dd-MM-yyyy').format(selectedDate2);
        dateFrom = formattedDate1;
        dateTo = formattedDate2;
        debugPrint("$dateFrom, $dateTo");
        setState(() {});
      }
    }
  }

  Future<void> selectDateTo(context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate2,
      firstDate: DateTime(DateTime.now().year - 5, 1, 1),
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
                  foregroundColor: navButtonPrimary, // button text color
                ),
              ),
            ),
            child: child!);
      },
    );
    if (picked != null && picked != selectedDate1) {
      if (mounted) {
        dayOfWeek = picked.weekday - 1;
        firstDay = DateTime(picked.year, picked.month, picked.day - dayOfWeek);
        lastDay = firstDay.add(
          const Duration(days: 6, hours: 23, minutes: 59),
        );
        selectedDate1 = firstDay;
        selectedDate2 = lastDay;
        formattedDate1 = DateFormat('dd-MM-yyyy').format(selectedDate1);
        formattedDate2 = DateFormat('dd-MM-yyyy').format(selectedDate2);
        dateFrom = formattedDate1;
        dateTo = formattedDate2;
        debugPrint("$dateFrom, $dateTo");
        setState(() {});
      }
    }
  }

  _filterTanggalField() {
    if (_indexFilterTanggal == 0) {
      return Column(
        children: const [],
      );
    } else if (_indexFilterTanggal == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          responsiveText("Tanggal", 14, FontWeight.w700, darkText),
          GestureDetector(
            onTap: () {
              selectDate(context);
            },
            child: Card(
              color: primaryColor,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    responsiveText(date, 14, FontWeight.w700, lightText),
                    const IconButton(
                      onPressed: null,
                      icon: Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
            //TODO: search btn
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              _queryTransaksiTanggal(kodeGereja, date, "", _indexFilterTanggal)
                  .whenComplete(() => setState(() {}));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.search),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "Cari",
                  style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      );
    } else if (_indexFilterTanggal == 2) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          responsiveText("Dari Tanggal", 14, FontWeight.w700, darkText),
          GestureDetector(
            onTap: () {
              selectDateFrom(context);
            },
            child: Card(
              color: primaryColor,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    responsiveText(dateFrom, 14, FontWeight.w700, lightText),
                    const IconButton(
                      onPressed: null,
                      icon: Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              ),
            ),
          ),
          responsiveText("Sampai Tanggal", 14, FontWeight.w700, darkText),
          GestureDetector(
            onTap: () {
              selectDateTo(context);
            },
            child: Card(
              color: primaryColor,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    responsiveText(dateTo, 14, FontWeight.w700, lightText),
                    const IconButton(
                      onPressed: null,
                      icon: Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
            //TODO: search btn
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              _queryTransaksiTanggal(
                      kodeGereja, dateFrom, dateTo, _indexFilterTanggal)
                  .whenComplete(() => setState(() {}));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.search),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "Cari",
                  style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      );
    } else if (_indexFilterTanggal == 3) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          responsiveText("Bulan", 14, FontWeight.w700, darkText),
          GestureDetector(
            onTap: () {
              selectMonth(context);
            },
            child: Card(
              color: primaryColor,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    responsiveText(month, 14, FontWeight.w700, lightText),
                    const IconButton(
                      onPressed: null,
                      icon: Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
            //TODO: search btn
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              _queryTransaksiTanggal(kodeGereja, month, "", _indexFilterTanggal)
                  .whenComplete(() => setState(() {}));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.search),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "Cari",
                  style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return Column();
    }
  }

  _cardInfo(title, nominal) {
    return Card(
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
            responsiveText(CurrencyFormatAkuntansi.convertToIdr(nominal, 2), 16,
                FontWeight.w700, darkText),
          ],
        ),
      ),
    );
  }

  void _changedSearch() {
    debugPrint(_controllerDropdownFilter.text);
  }

  _splitString(val) {
    var value = val.toString();
    var split = value.indexOf(" ");
    var temp = value.substring(0, split);
    return temp;
  }

  _buatKodeGabungan(val) {
    var temp = kodeGereja + _splitString(val);
    return temp;
  }

  drawerFilter() {
    return Container(
      color: scaffoldBackgroundColor,
      width: 350,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 56,
                ),
                ToggleSwitch(
                  initialLabelIndex: _indexFilterTanggal,
                  totalSwitches: 4,
                  labels: const ['Semua', 'Hari', 'Minggu', 'Bulan'],
                  activeBgColor: [primaryColorVariant],
                  activeFgColor: darkText,
                  inactiveBgColor: Colors.grey[200],
                  inactiveFgColor: darkText,
                  dividerColor: Colors.white,
                  animate: true,
                  animationDuration: 250,
                  onToggle: (index) {
                    setState(() {
                      _indexFilterTanggal = index!;
                    });
                    debugPrint('switched to: $_indexFilterTanggal');
                    if (_indexFilterTanggal == 0) {
                      _getTransaksi(kodeGereja)
                          .whenComplete(() => setState(() {}));
                    }
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                _filterTanggalField(),
                const Divider(
                  height: 56,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: responsiveText(
                      "Filter Transaksi", 14, FontWeight.w700, darkText),
                ),
                Card(
                  color: primaryColor,
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
                              _controllerDropdownFilter.clear();
                            },
                            icon: Icon(
                              Icons.clear,
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ),
                        ),
                        controller: _controllerDropdownFilter,
                      ),
                    ),
                    items: _kodeTransaksiAdded,
                    onChanged: (val) {
                      debugPrint(val);
                      debugPrint(_splitString(val));
                      kodeTransaksiFilter = _splitString(val);
                      _queryTransaksiKode(kodeGereja, kodeTransaksiFilter, "")
                          .whenComplete(() => setState(() {}));
                      debugPrint(_buatKodeGabungan(val));
                    },
                    selectedItem: "pilih Transaksi",
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: responsiveText(
                      "Filter Kode Perkiraan", 14, FontWeight.w700, darkText),
                ),
                Card(
                  color: primaryColor,
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
                              _controllerDropdownFilter.clear();
                            },
                            icon: Icon(
                              Icons.clear,
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ),
                        ),
                        controller: _controllerDropdownFilter,
                      ),
                    ),
                    items: _kodePerkiraan,
                    onChanged: (val) {
                      debugPrint(val);
                      debugPrint(_splitString(val));
                      kodePerkiraanFilter = _splitString(val);
                      _queryTransaksiKode(kodeGereja, "", kodePerkiraanFilter)
                          .whenComplete(() => setState(() {}));
                      debugPrint(_buatKodeGabungan(val));
                    },
                    selectedItem: "pilih Kode Perkiraan",
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  //TODO: search btn
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    _queryTransaksiKode(kodeGereja, kodeTransaksiFilter,
                            kodePerkiraanFilter)
                        .whenComplete(() => setState(() {}));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.search),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Cari",
                        style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 56,
                ),
                _cardInfo(
                  "Debit",
                  _totalPemasukan,
                ),
                const SizedBox(
                  height: 25,
                ),
                _cardInfo(
                  "Kredit",
                  _totalPengeluaran,
                ),
                const SizedBox(
                  height: 25,
                ),
                _cardInfo(
                  "Saldo",
                  _totalSaldo,
                ),
                const SizedBox(
                  height: 56,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  visibleFilter(deviceWidth, context) {
    return Wrap(
      children: [
        const SizedBox(
          width: 16,
        ),
        deviceWidth < 1280
            ? IconButton(
                onPressed: () {
                  _scaffoldKey.currentState!.openEndDrawer();
                },
                icon: const Icon(Icons.filter_alt_outlined),
              )
            : Visibility(
                visible: false,
                child: Column(),
              ),
        const SizedBox(
          width: 16,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      endDrawerEnableOpenDragGesture: false,
      endDrawer: drawerFilter(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                responsiveText("Transaksi", 32, FontWeight.w800, darkText),
                Expanded(
                  child: Wrap(
                    runSpacing: 16.0,
                    alignment: WrapAlignment.end,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runAlignment: WrapAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          widget.controllerPageLihatLaporan.animateToPage(1,
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.ease);
                        },
                        child: Text(
                          "Laporan Keuangan",
                          style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          widget.controllerPageKategori.animateToPage(1,
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.ease);
                        },
                        child: Text(
                          "Kode Keuangan",
                          style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          widget.controllerPageBuatTransaksi.animateToPage(1,
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.ease);
                        },
                        child: Text(
                          "Buat Transaksi",
                          style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                    ],
                  ),
                ),
                visibleFilter(deviceWidth, context),
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
                                            "Kode",
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
                                            "Debit",
                                            style: GoogleFonts.nunito(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            "Kredit",
                                            style: GoogleFonts.nunito(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: List.generate(
                                        _rowList.length,
                                        (index) {
                                          return DataRow(
                                              color: MaterialStateColor
                                                  .resolveWith(
                                                (states) {
                                                  return index % 2 == 1
                                                      ? Colors.white
                                                      : primaryColor
                                                          .withOpacity(0.2);
                                                },
                                              ),
                                              cells: _rowList[index].cells);
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
                                          "Kode",
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
                                          "Pemasukan",
                                          style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          "Pengeluaran",
                                          style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                    rows: List.generate(
                                      _rowList.length,
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
                                            cells: _rowList[index].cells);
                                      },
                                    ),
                                  ),
                          ),
                          deviceWidth > 1280 ? drawerFilter() : Column(),
                        ],
                      ),
                    ],
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

enum RadioStatusTransaksi { pemasukan, pengeluaran }

enum RadioJenisMaster { pemasukan, pengeluaran }

enum RadioAktivaPasiva {
  aktivalancar,
  aktivatetap,
  pasivalancar,
  pasivajangkapanjang
}

//TODO: buat Kategori
class BuatKodeKeuanganPage extends StatefulWidget {
  final PageController controllerPageKategori;
  const BuatKodeKeuanganPage({Key? key, required this.controllerPageKategori})
      : super(key: key);

  @override
  State<BuatKodeKeuanganPage> createState() => _BuatKodeKeuanganPageState();
}

class _BuatKodeKeuanganPageState extends State<BuatKodeKeuanganPage> {
  ServicesUser servicesUser = ServicesUser();
  late Future kodeMaster;
  late Future kodePerkiraan;
  late Future kodeTransaksi;

  final _controllerMasterKode = TextEditingController();
  final _controllerNamaMasterKode = TextEditingController();

  final _controllerKodePerkiraan = TextEditingController();
  final _controllerNamaKodePerkiraan = TextEditingController();

  final _controllerKodeTransaksi = TextEditingController();
  final _controllerNamaKodeTransaksi = TextEditingController();
  String _statusMaster = "";
  String _statusAktivaPasiva = "";

  bool _visibleAktivaPasiva = false;

  final _kodePerkiraanForm = GlobalKey<FormState>();
  final _kodeMasterForm = GlobalKey<FormState>();
  final _kodeTransaksiForm = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState

    kodeMaster = servicesUser.getMasterKode(kodeGereja);
    kodeTransaksi = servicesUser.getKodeTransaksi(kodeGereja);
    kodePerkiraan = servicesUser.getKodePerkiraan(kodeGereja, "M001");

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controllerMasterKode.dispose();
    _controllerNamaMasterKode.dispose();
    _controllerKodePerkiraan.dispose();
    _controllerNamaKodePerkiraan.dispose();
    _controllerKodeTransaksi.dispose();
    _controllerNamaKodeTransaksi.dispose();
    super.dispose();
  }

  responsiveTextField(deviceWidth, deviceHeight, controllerText, mLength) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        maxLength: mLength,
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
    );
  }

  _showBuatKodePerkiraanDialog(dw, dh, headerKodePerkiraan) {
    _controllerKodePerkiraan.clear();
    _controllerNamaKodePerkiraan.clear();
    showDialog(
      barrierDismissible: false,
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
                    width: dw < 800 ? dw * 0.8 : dw * 0.4,
                    child: Column(
                      children: [
                        Container(
                          width: dw < 800 ? dw * 0.8 : dw * 0.4,
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
                              responsiveText("Tambah Kode Perkiraan", 26,
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
                              Form(
                                key: _kodePerkiraanForm,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    responsiveText("Kode Perkiraan", 16,
                                        FontWeight.w700, darkText),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextFormField(
                                        controller: _controllerKodePerkiraan,
                                        autofocus: false,
                                        decoration: InputDecoration(
                                          prefix: Text("$headerKodePerkiraan-"),
                                          filled: true,
                                          fillColor: surfaceColor,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 0, horizontal: 25),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Harus Diisi";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    responsiveText("Nama Kode Perkiraan", 16,
                                        FontWeight.w700, darkText),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextFormField(
                                        controller:
                                            _controllerNamaKodePerkiraan,
                                        autofocus: false,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: surfaceColor,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 0, horizontal: 25),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Harus Diisi";
                                          }
                                          return null;
                                        },
                                      ),
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
                                  if (_kodePerkiraanForm.currentState!
                                      .validate()) {
                                    if (mounted) {
                                      postKodePerkiraan(
                                              kodeGereja,
                                              _controllerNamaKodePerkiraan.text
                                                  .capitalize(),
                                              "$headerKodePerkiraan-${_controllerKodePerkiraan.text}"
                                                  .toUpperCase(),
                                              headerKodePerkiraan,
                                              context)
                                          .then(
                                        (value) {
                                          postSaldoAwal(
                                                  kodeGereja,
                                                  headerKodePerkiraan,
                                                  "$headerKodePerkiraan-${_controllerKodePerkiraan.text}"
                                                      .toUpperCase(),
                                                  0,
                                                  context)
                                              .then(
                                            (value) {
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                          );
                                        },
                                      );
                                    }
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
    ).then((value) {
      if (mounted) {
        kodePerkiraan = servicesUser
            .getKodePerkiraan(kodeGereja, headerKodePerkiraan)
            .whenComplete(() => setState(() {}));
      }
    });
  }

  _showBuatMasterKodeDialog(dw, dh) {
    RadioJenisMaster? radio;
    RadioAktivaPasiva? radioAktivaPasiva;
    _visibleAktivaPasiva = false;
    _controllerMasterKode.clear();
    _controllerNamaMasterKode.clear();
    _statusMaster = "";
    showDialog(
      barrierDismissible: false,
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
                    width: dw < 800 ? dw * 0.8 : dw * 0.4,
                    child: Column(
                      children: [
                        Container(
                          width: dw < 800 ? dw * 0.8 : dw * 0.4,
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
                              responsiveText("Tambah Kode Master", 26,
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
                              Form(
                                key: _kodeMasterForm,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    responsiveText("Kode Master", 16,
                                        FontWeight.w700, darkText),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextFormField(
                                        controller: _controllerMasterKode,
                                        autofocus: false,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: surfaceColor,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 0, horizontal: 25),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Harus Diisi";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    responsiveText("Nama Kode Master", 16,
                                        FontWeight.w700, darkText),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextFormField(
                                        controller: _controllerNamaMasterKode,
                                        autofocus: false,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: surfaceColor,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 0, horizontal: 25),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Harus Diisi";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            Radio(
                                              value: RadioJenisMaster.pemasukan,
                                              groupValue: radio,
                                              activeColor: primaryColorVariant,
                                              onChanged: (val) {
                                                radio =
                                                    val as RadioJenisMaster?;
                                                _visibleAktivaPasiva = true;
                                                _statusMaster = "pemasukan";
                                                if (mounted) {
                                                  setState(() {});
                                                }
                                              },
                                            ),
                                            responsiveText("Debit", 14,
                                                FontWeight.w700, darkText),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 25,
                                        ),
                                        Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            Radio(
                                              value:
                                                  RadioJenisMaster.pengeluaran,
                                              groupValue: radio,
                                              activeColor: primaryColorVariant,
                                              onChanged: (val) {
                                                radio =
                                                    val as RadioJenisMaster?;
                                                _visibleAktivaPasiva = true;
                                                _statusMaster = "pengeluaran";

                                                if (mounted) {
                                                  setState(() {});
                                                }
                                              },
                                            ),
                                            responsiveText("Kredit", 14,
                                                FontWeight.w700, darkText),
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Visibility(
                                      visible: _visibleAktivaPasiva,
                                      child: Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: [
                                              Radio(
                                                value:
                                                    _statusMaster == "pemasukan"
                                                        ? RadioAktivaPasiva
                                                            .aktivalancar
                                                        : RadioAktivaPasiva
                                                            .pasivalancar,
                                                groupValue: radioAktivaPasiva,
                                                activeColor:
                                                    primaryColorVariant,
                                                onChanged: (val) {
                                                  radioAktivaPasiva =
                                                      val as RadioAktivaPasiva?;
                                                  if (mounted) {
                                                    setState(() {});
                                                    _statusAktivaPasiva =
                                                        "lancar";
                                                  }
                                                },
                                              ),
                                              responsiveText(
                                                  _statusMaster == "pemasukan"
                                                      ? "Aktiva Lancar"
                                                      : "Pasiva Lancar",
                                                  14,
                                                  FontWeight.w700,
                                                  darkText),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 25,
                                          ),
                                          Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: [
                                              Radio(
                                                value:
                                                    _statusMaster == "pemasukan"
                                                        ? RadioAktivaPasiva
                                                            .aktivatetap
                                                        : RadioAktivaPasiva
                                                            .pasivajangkapanjang,
                                                groupValue: radioAktivaPasiva,
                                                activeColor:
                                                    primaryColorVariant,
                                                onChanged: (val) {
                                                  radioAktivaPasiva =
                                                      val as RadioAktivaPasiva?;
                                                  if (mounted) {
                                                    setState(() {});
                                                    if (_statusMaster ==
                                                        "pemasukan") {
                                                      _statusAktivaPasiva =
                                                          "tetap";
                                                    } else {
                                                      _statusAktivaPasiva =
                                                          "Jangka Panjang";
                                                    }
                                                  }
                                                },
                                              ),
                                              responsiveText(
                                                  _statusMaster == "pemasukan"
                                                      ? "Aktiva Tetap"
                                                      : "Pasiva Jangka Panjang",
                                                  14,
                                                  FontWeight.w700,
                                                  darkText),
                                            ],
                                          ),
                                        ],
                                      ),
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
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  _visibleAktivaPasiva = false;
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
                                  if (_kodeMasterForm.currentState!
                                      .validate()) {
                                    if (_statusMaster == "") {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text("Status Kode Harus Diisi"),
                                        ),
                                      );
                                    } else {
                                      if (_statusAktivaPasiva == "") {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "Jenis Status Harus Diisi"),
                                          ),
                                        );
                                      } else {
                                        if (mounted) {
                                          postMasterKode(
                                                  kodeGereja,
                                                  _controllerNamaMasterKode.text
                                                      .capitalize(),
                                                  _controllerMasterKode.text
                                                      .toUpperCase(),
                                                  _statusMaster,
                                                  _statusAktivaPasiva,
                                                  context)
                                              .then(
                                            (value) {
                                              Navigator.pop(context);
                                            },
                                          );
                                        }
                                      }
                                    }
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
    ).then((value) {
      if (mounted) {
        kodeMaster = servicesUser
            .getMasterKode(kodeGereja)
            .whenComplete(() => setState(() {}));
      }
    });
  }

  _showBuatKodeTransaksiDialog(dw, dh) {
    _controllerNamaKodeTransaksi.clear();
    _controllerKodeTransaksi.clear();
    showDialog(
      barrierDismissible: false,
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
                    width: dw < 800 ? dw * 0.8 : dw * 0.4,
                    child: Column(
                      children: [
                        Container(
                          width: dw < 800 ? dw * 0.8 : dw * 0.4,
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
                              responsiveText("Tambah Kode Transaksi", 26,
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
                              Form(
                                key: _kodeTransaksiForm,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    responsiveText("Kode Transaksi", 16,
                                        FontWeight.w700, darkText),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextFormField(
                                        controller: _controllerKodeTransaksi,
                                        autofocus: false,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: surfaceColor,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 0, horizontal: 25),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Harus Diisi";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    responsiveText("Nama Kode Transaksi", 16,
                                        FontWeight.w700, darkText),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextFormField(
                                        controller:
                                            _controllerNamaKodeTransaksi,
                                        autofocus: false,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: surfaceColor,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 0, horizontal: 25),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Harus Diisi";
                                          }
                                          return null;
                                        },
                                      ),
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
                                    if (_kodeTransaksiForm.currentState!
                                        .validate()) {
                                      postKodeTransaksi(
                                              kodeGereja,
                                              _controllerNamaKodeTransaksi.text
                                                  .capitalize(),
                                              _controllerKodeTransaksi.text
                                                  .toUpperCase(),
                                              context)
                                          .then(
                                        (value) {
                                          Navigator.pop(context);
                                        },
                                      );
                                    }
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
    ).then((value) {
      if (mounted) {
        kodeTransaksi = servicesUser
            .getKodeTransaksi(kodeGereja)
            .whenComplete(() => setState(() {}));
      }
    });
  }

  Future postMasterKode(kodeGereja, namaMasterKode, masterKodePerkiraan,
      statusKode, statusNeraca, context) async {
    var response = await servicesUser.inputMasterKode(kodeGereja,
        namaMasterKode, masterKodePerkiraan, statusKode, statusNeraca);

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

  Future deleteMasterKode(kodeGereja, kodeMaster, context) async {
    var response = await servicesUser.deleteKodeMaster(kodeGereja, kodeMaster);

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

  Future postKodePerkiraan(kodeGereja, namaKodePerkiraan, kodePerkiraan,
      headerKodePerkiraan, context) async {
    var response = await servicesUser.inputKodePerkiraan(
        kodeGereja, namaKodePerkiraan, kodePerkiraan, headerKodePerkiraan);

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

  Future postSaldoAwal(
      kodeGereja, headerKodePerkiraan, kodePerkiraan, saldo, context) async {
    var response = await servicesUser.inputSaldoAwal(
        kodeGereja, headerKodePerkiraan, kodePerkiraan, saldo);

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

  Future deleteKodePerkiraan(
      kodeGereja, kodePerkiraan, kodeMaster, context) async {
    var response = await servicesUser.deleteKodePerkiraan(
        kodeGereja, kodePerkiraan, kodeMaster);

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

  Future postKodeTransaksi(
      kodeGereja, namaKodeTransaksi, kodeTransaksi, context) async {
    var response = await servicesUser.inputKodeTransaksi(
        kodeGereja, namaKodeTransaksi, kodeTransaksi);

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

  Future deleteKodeTransaksi(kodeGereja, kodeTransaksi, context) async {
    var response =
        await servicesUser.deleteKodeTransaksi(kodeGereja, kodeTransaksi);

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

  confirmDialogDelKode(dw, dh, kode, type, headerKodePerkiraan) {
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
                    width: dw < 800 ? dw * 0.8 : dw * 0.4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 56, horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              responsiveText("Anda Yakin Ingin Menghapus", 24,
                                  FontWeight.w800, darkText),
                              responsiveText("Kode $kode ?", 24,
                                  FontWeight.w800, darkText),
                            ],
                          ),
                          const SizedBox(
                            height: 56,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: cancelButtonColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32, vertical: 16),
                                  textStyle: GoogleFonts.nunito(
                                      color: lightText,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                      letterSpacing: 0.125),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Batal"),
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (type == 0) {
                                    deleteKodeTransaksi(
                                            kodeGereja, kode, context)
                                        .whenComplete(() {
                                      Navigator.pop(context);
                                      kodeTransaksi = servicesUser
                                          .getKodeTransaksi(kodeGereja);
                                      setState(() {});
                                    });
                                  } else if (type == 1) {
                                    deleteMasterKode(kodeGereja, kode, context)
                                        .whenComplete(() {
                                      Navigator.pop(context);
                                      kodeMaster = servicesUser
                                          .getMasterKode(kodeGereja);
                                      setState(() {});
                                    });
                                  } else if (type == 2) {
                                    deleteKodePerkiraan(kodeGereja, kode,
                                            headerKodePerkiraan, context)
                                        .whenComplete(() {
                                      Navigator.pop(context);
                                      kodePerkiraan =
                                          servicesUser.getKodePerkiraan(
                                              kodeGereja, headerKodePerkiraan);
                                      setState(() {});
                                    });
                                  }
                                },
                                child: const Text("Hapus"),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      setState(() {});
    });
  }

  showKodePerkiraan(dw, dh, headerKodePerkiraan) {
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
                    width: dw < 800 ? dw * 0.8 : dw * 0.4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 25, horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                    Icons.arrow_back_ios_new_rounded),
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              responsiveText("Kode Master $headerKodePerkiraan",
                                  26, FontWeight.w900, darkText),
                              const Spacer(),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                ),
                                onPressed: () {
                                  _showBuatKodePerkiraanDialog(
                                      dw, dh, headerKodePerkiraan);
                                },
                                child: const Icon(Icons.add),
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
                                future: kodePerkiraan,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    List snapData = snapshot.data! as List;
                                    debugPrint(snapData.toString());
                                    if (snapData[0] != 404) {
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        controller: ScrollController(),
                                        physics: const ClampingScrollPhysics(),
                                        itemCount: snapData[1].length,
                                        itemBuilder: (context, index) {
                                          return Card(
                                            color: scaffoldBackgroundColor,
                                            child: ListTile(
                                              dense: true,
                                              minLeadingWidth: 85,
                                              leading: responsiveText(
                                                  snapData[1][index]
                                                      ['kode_perkiraan'],
                                                  16,
                                                  FontWeight.w600,
                                                  darkText),
                                              title: Row(
                                                children: [
                                                  SizedBox(
                                                    height: 25,
                                                    child: VerticalDivider(
                                                      color: dividerColor,
                                                    ),
                                                  ),
                                                  responsiveText(
                                                      snapData[1][index][
                                                          'nama_kode_perkiraan'],
                                                      16,
                                                      FontWeight.w600,
                                                      darkText),
                                                  const Spacer(),
                                                  IconButton(
                                                    onPressed: () {
                                                      confirmDialogDelKode(
                                                          dw,
                                                          dh,
                                                          snapData[1][index][
                                                              'kode_perkiraan'],
                                                          2,
                                                          headerKodePerkiraan);
                                                    },
                                                    icon: const Icon(
                                                        Icons.delete_rounded),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
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
            );
          },
        );
      },
    ).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        widget.controllerPageKategori.animateToPage(0,
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.ease);
                      },
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    responsiveText(
                        "Buat Kode Keuangan", 26, FontWeight.w900, darkText),
                  ],
                ),
                const Divider(
                  thickness: 1,
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
                      child: deviceWidth < 1280
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: deviceWidth,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          responsiveText("Kode Transaksi", 20,
                                              FontWeight.w700, darkText),
                                          ElevatedButton(
                                            onPressed: () {
                                              _showBuatKodeTransaksiDialog(
                                                  deviceWidth, deviceHeight);
                                            },
                                            child: Row(
                                              children: const [
                                                Text("Buat Kode Transaksi"),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          side: BorderSide(
                                            color: navButtonPrimary
                                                .withOpacity(0.4),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: FutureBuilder(
                                            future: kodeTransaksi,
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                List snapData =
                                                    snapshot.data! as List;
                                                debugPrint(snapData.toString());
                                                if (snapData[0] != 404) {
                                                  return ListView.builder(
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    controller:
                                                        ScrollController(),
                                                    physics:
                                                        const ClampingScrollPhysics(),
                                                    itemCount:
                                                        snapData[1].length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Card(
                                                        color:
                                                            scaffoldBackgroundColor,
                                                        child: ListTile(
                                                          dense: true,
                                                          minLeadingWidth: 85,
                                                          leading: responsiveText(
                                                              snapData[1][index]
                                                                  [
                                                                  'kode_transaksi'],
                                                              16,
                                                              FontWeight.w600,
                                                              darkText),
                                                          title: Row(
                                                            children: [
                                                              SizedBox(
                                                                height: 25,
                                                                child:
                                                                    VerticalDivider(
                                                                  color:
                                                                      dividerColor,
                                                                ),
                                                              ),
                                                              responsiveText(
                                                                  snapData[1][
                                                                          index]
                                                                      [
                                                                      'nama_transaksi'],
                                                                  16,
                                                                  FontWeight
                                                                      .w600,
                                                                  darkText),
                                                              const Spacer(),
                                                              IconButton(
                                                                onPressed: () {
                                                                  confirmDialogDelKode(
                                                                      deviceWidth,
                                                                      deviceHeight,
                                                                      snapData[1]
                                                                              [
                                                                              index]
                                                                          [
                                                                          'kode_transaksi'],
                                                                      0,
                                                                      "");
                                                                },
                                                                icon: const Icon(
                                                                    Icons
                                                                        .delete_rounded),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
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
                                const SizedBox(
                                  height: 25,
                                ),
                                SizedBox(
                                  width: deviceWidth,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          responsiveText("Kode Master", 20,
                                              FontWeight.w700, darkText),
                                          ElevatedButton(
                                            onPressed: () {
                                              _showBuatMasterKodeDialog(
                                                  deviceWidth, deviceHeight);
                                            },
                                            child: Row(
                                              children: const [
                                                Text("Buat Kode Master"),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          side: BorderSide(
                                            color: navButtonPrimary
                                                .withOpacity(0.4),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: FutureBuilder(
                                            future: kodeMaster,
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                List snapData =
                                                    snapshot.data! as List;
                                                debugPrint(snapData.toString());
                                                if (snapData[0] != 404) {
                                                  return ListView.builder(
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    controller:
                                                        ScrollController(),
                                                    physics:
                                                        const ClampingScrollPhysics(),
                                                    itemCount:
                                                        snapData[1].length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Card(
                                                        color:
                                                            scaffoldBackgroundColor,
                                                        child: ListTile(
                                                          dense: true,
                                                          minLeadingWidth: 85,
                                                          leading: responsiveText(
                                                              snapData[1][index]
                                                                  [
                                                                  'header_kode_perkiraan'],
                                                              16,
                                                              FontWeight.w600,
                                                              darkText),
                                                          title: Row(
                                                            children: [
                                                              SizedBox(
                                                                height: 25,
                                                                child:
                                                                    VerticalDivider(
                                                                  color:
                                                                      dividerColor,
                                                                ),
                                                              ),
                                                              responsiveText(
                                                                  snapData[1][
                                                                          index]
                                                                      [
                                                                      'nama_header'],
                                                                  16,
                                                                  FontWeight
                                                                      .w600,
                                                                  darkText),
                                                              const Spacer(),
                                                              IconButton(
                                                                onPressed: () {
                                                                  confirmDialogDelKode(
                                                                      deviceWidth,
                                                                      deviceHeight,
                                                                      snapData[1]
                                                                              [
                                                                              index]
                                                                          [
                                                                          'header_kode_perkiraan'],
                                                                      1,
                                                                      "");
                                                                },
                                                                icon: const Icon(
                                                                    Icons
                                                                        .delete_rounded),
                                                              ),
                                                              ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(12),
                                                                  shape:
                                                                      const CircleBorder(),
                                                                ),
                                                                onPressed: () {
                                                                  kodePerkiraan = servicesUser.getKodePerkiraan(
                                                                      kodeGereja,
                                                                      snapData[1]
                                                                              [
                                                                              index]
                                                                          [
                                                                          'header_kode_perkiraan']);
                                                                  showKodePerkiraan(
                                                                      deviceWidth,
                                                                      deviceHeight,
                                                                      snapData[1]
                                                                              [
                                                                              index]
                                                                          [
                                                                          'header_kode_perkiraan']);
                                                                },
                                                                child: const Icon(
                                                                    Icons
                                                                        .arrow_forward_rounded),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
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
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          responsiveText("Kode Transaksi", 20,
                                              FontWeight.w700, darkText),
                                          ElevatedButton(
                                            onPressed: () {
                                              _showBuatKodeTransaksiDialog(
                                                  deviceWidth, deviceHeight);
                                            },
                                            child: Row(
                                              children: const [
                                                Text("Buat Kode Transaksi"),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          side: BorderSide(
                                            color: navButtonPrimary
                                                .withOpacity(0.4),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: FutureBuilder(
                                            future: kodeTransaksi,
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                List snapData =
                                                    snapshot.data! as List;
                                                debugPrint(snapData.toString());
                                                if (snapData[0] != 404) {
                                                  return ListView.builder(
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    controller:
                                                        ScrollController(),
                                                    physics:
                                                        const ClampingScrollPhysics(),
                                                    itemCount:
                                                        snapData[1].length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Card(
                                                        color:
                                                            scaffoldBackgroundColor,
                                                        child: ListTile(
                                                          dense: true,
                                                          minLeadingWidth: 85,
                                                          leading: responsiveText(
                                                              snapData[1][index]
                                                                  [
                                                                  'kode_transaksi'],
                                                              16,
                                                              FontWeight.w600,
                                                              darkText),
                                                          title: Row(
                                                            children: [
                                                              SizedBox(
                                                                height: 25,
                                                                child:
                                                                    VerticalDivider(
                                                                  color:
                                                                      dividerColor,
                                                                ),
                                                              ),
                                                              responsiveText(
                                                                  snapData[1][
                                                                          index]
                                                                      [
                                                                      'nama_transaksi'],
                                                                  16,
                                                                  FontWeight
                                                                      .w600,
                                                                  darkText),
                                                              const Spacer(),
                                                              IconButton(
                                                                onPressed: () {
                                                                  confirmDialogDelKode(
                                                                      deviceWidth,
                                                                      deviceHeight,
                                                                      snapData[1]
                                                                              [
                                                                              index]
                                                                          [
                                                                          'kode_transaksi'],
                                                                      0,
                                                                      "");
                                                                },
                                                                icon: const Icon(
                                                                    Icons
                                                                        .delete_rounded),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
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
                                const SizedBox(
                                  width: 25,
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          responsiveText("Kode Master", 20,
                                              FontWeight.w700, darkText),
                                          ElevatedButton(
                                            onPressed: () {
                                              _showBuatMasterKodeDialog(
                                                  deviceWidth, deviceHeight);
                                            },
                                            child: Row(
                                              children: const [
                                                Text("Buat Kode Master"),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          side: BorderSide(
                                            color: navButtonPrimary
                                                .withOpacity(0.4),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: FutureBuilder(
                                            future: kodeMaster,
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                List snapData =
                                                    snapshot.data! as List;
                                                debugPrint(snapData.toString());
                                                if (snapData[0] != 404) {
                                                  return ListView.builder(
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    controller:
                                                        ScrollController(),
                                                    physics:
                                                        const ClampingScrollPhysics(),
                                                    itemCount:
                                                        snapData[1].length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Card(
                                                        color:
                                                            scaffoldBackgroundColor,
                                                        child: ListTile(
                                                          dense: true,
                                                          minLeadingWidth: 85,
                                                          leading: responsiveText(
                                                              snapData[1][index]
                                                                  [
                                                                  'header_kode_perkiraan'],
                                                              16,
                                                              FontWeight.w600,
                                                              darkText),
                                                          title: Row(
                                                            children: [
                                                              SizedBox(
                                                                height: 25,
                                                                child:
                                                                    VerticalDivider(
                                                                  color:
                                                                      dividerColor,
                                                                ),
                                                              ),
                                                              responsiveText(
                                                                  snapData[1][
                                                                          index]
                                                                      [
                                                                      'nama_header'],
                                                                  16,
                                                                  FontWeight
                                                                      .w600,
                                                                  darkText),
                                                              const Spacer(),
                                                              IconButton(
                                                                onPressed: () {
                                                                  confirmDialogDelKode(
                                                                      deviceWidth,
                                                                      deviceHeight,
                                                                      snapData[1]
                                                                              [
                                                                              index]
                                                                          [
                                                                          'header_kode_perkiraan'],
                                                                      1,
                                                                      "");
                                                                },
                                                                icon: const Icon(
                                                                    Icons
                                                                        .delete_rounded),
                                                              ),
                                                              ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(12),
                                                                  shape:
                                                                      const CircleBorder(),
                                                                ),
                                                                onPressed: () {
                                                                  kodePerkiraan = servicesUser.getKodePerkiraan(
                                                                      kodeGereja,
                                                                      snapData[1]
                                                                              [
                                                                              index]
                                                                          [
                                                                          'header_kode_perkiraan']);
                                                                  showKodePerkiraan(
                                                                      deviceWidth,
                                                                      deviceHeight,
                                                                      snapData[1]
                                                                              [
                                                                              index]
                                                                          [
                                                                          'header_kode_perkiraan']);
                                                                },
                                                                child: const Icon(
                                                                    Icons
                                                                        .arrow_forward_rounded),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
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
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//TODO: Buat Transaksi Page
class AdminBuatTransaksiPage extends StatefulWidget {
  final PageController controllerPageBuatTransaksi;
  const AdminBuatTransaksiPage(
      {super.key, required this.controllerPageBuatTransaksi});

  @override
  State<AdminBuatTransaksiPage> createState() => _AdminBuatTransaksiPageState();
}

class _AdminBuatTransaksiPageState extends State<AdminBuatTransaksiPage> {
  ServicesUser servicesUser = ServicesUser();

  String _status = "";

  final _controllerNominal = TextEditingController();
  final _controllerKeterangan = TextEditingController();
  String kodeMaster = "";
  String kodePerkiraan = "";
  String kodeRefKegiatan = "";

  final _controllerDropdownFilter = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String formattedDate = "";
  String date = "Date";

  final itemTransaksi = List.empty(growable: true);
  final tempItemTransaksi = List.empty(growable: true);

  String selectedKodePerkiraan = "Pilih Kode Perkiraan";
  String selectedKodeRefKegiatan = "Pilih Kode Referensi";
  String selectedKodeTransaksi = "Pilih Kode Transaksi";

  final clearKodeRef =
      const ClearButtonProps(icon: Icon(Icons.clear), isVisible: true);
  final clearKodePerkiraan =
      const ClearButtonProps(icon: Icon(Icons.clear), isVisible: true);

  int budgetNotif = 0;
  int sumNotif = 0;

  var stateOfDisable = true;
  DateTime tanggalMulaiAcaraBatas = DateTime.now();
  DateTime temptanggalMulaiAcaraBatas = DateTime(DateTime.now().year - 5, 1, 1);

  DateTime tanggalSelesaiAcaraBatas = DateTime.now();
  DateTime temptanggalSelesaiAcaraBatas = DateTime(DateTime.now().year, 12, 31);

  int totalPemasukanStatus = 0;
  int totalPengeluaranStatus = 0;

  final _buatTransaksiform = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    _rowList.clear();
    _totalPemasukan = 0;
    _totalPengeluaran = 0;
    _totalSaldo = 0;
    itemTransaksi.clear();
    selectedKodePerkiraan = "Pilih Kode Perkiraan";
    selectedKodeRefKegiatan = "Pilih Kode Referensi";
    selectedKodeTransaksi = "Pilih Kode Transaksi";

    _singleKodeTransaksi = "";
    _kodeTransaksiCount = "000";
    _getMasterKode(kodeGereja);
    _getKodeTransaksi(kodeGereja);
    _getKodeRefKegiatan(kodeGereja);
    _getKodePerkiraanSingleKegiatan(kodeGereja, "", "", "");

    formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
    date = formattedDate;

    budgetNotif = 0;
    sumNotif = 0;

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controllerNominal.dispose();
    _controllerKeterangan.dispose();
    _controllerDropdownFilter.dispose();
    super.dispose();
  }

  Future _getBatasTanggal(kodeGer, kodeKegiatanBatas) async {
    var response = await servicesUser.getAllProposalKegiatan(kodeGer);
    if (response[0] != 404) {
      for (var element in response[1]) {
        if (kodeKegiatanBatas == element['kode_kegiatan']) {
          tanggalMulaiAcaraBatas =
              DateFormat("dd-MM-yyyy").parse(element['tanggal_acara_dimulai']);
          temptanggalMulaiAcaraBatas =
              DateTime.parse(tanggalMulaiAcaraBatas.toString());

          tanggalSelesaiAcaraBatas =
              DateFormat("dd-MM-yyyy").parse(element['tanggal_acara_selesai']);
          temptanggalSelesaiAcaraBatas =
              DateTime.parse(tanggalSelesaiAcaraBatas.toString());
        }
      }
    } else {
      throw "Gagal Mengambil Data";
    }
  }

  Future _getPerbandinganPeringatan(
      kodeKegiatangab, kodeKeg, kodeGer, kodePerkiraanNotif) async {
    //_kodeMaster.clear();

    var response = await servicesUser.getAllItemProposalKegiatan(
        kodeKegiatangab, kodeKeg, kodeGer);
    if (response[0] != 404) {
      for (var element in response[1]) {
        // _kodeMaster.add(
        //     "${element['header_kode_perkiraan']} - ${element['nama_header']}");
        debugPrint(element.toString());
        debugPrint("asu$kodePerkiraanNotif");
        debugPrint(element['kode_perkiraan']);
        if (kodePerkiraanNotif == element['kode_perkiraan']) {
          debugPrint('dd' + kodePerkiraanNotif);
          sumNotif = element['sum_kebutuhan'];
          budgetNotif = element['budget_kebutuhan'];
        }
      }
    } else {
      throw "Gagal Mengambil Data";
    }
  }

  responsiveTextField(deviceWidth, deviceHeight, controllerText) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
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
    );
  }

  Future _getTransaksi(kodeGereja) async {
    _rowList.clear();
    _totalPemasukan = 0;
    _totalPengeluaran = 0;
    _totalSaldo = 0;
    var response = await servicesUser.getTransaksi(kodeGereja);
    if (response[0] != 404) {
      for (var element in response[1]) {
        _addRowTransaksi(
            element['kode_transaksi'],
            element['tanggal_transaksi'],
            element['uraian_transaksi'],
            element['jenis_transaksi'],
            element['nominal']);
        if (element['jenis_transaksi'] == "pemasukan") {
          _totalPemasukan += element['nominal'] as int;
        } else {
          _totalPengeluaran += element['nominal'] as int;
        }
      }
      _totalSaldo = _totalPemasukan - _totalPengeluaran;
      if (mounted) {
        setState(() {});
      }
    }
  }

  void _addRowTransaksi(kode, tanggal, deskripsi, jenis, nominal) {
    _rowList.add(
      DataRow(
        cells: [
          DataCell(
            Text(
              kode.toString(),
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
          DataCell(
            Text(
              jenis == "pengeluaran" ? nominal.toString() : "-",
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Future _getMasterKode(kodeGereja) async {
    _kodeMaster.clear();

    var response = await servicesUser.getMasterKode(kodeGereja);
    if (response[0] != 404) {
      for (var element in response[1]) {
        debugPrint(element.toString());
        _kodeMaster.add(
            "${element['header_kode_perkiraan']} - ${element['nama_header']}");
      }
    }
  }

  Future _getKodePerkiraanSingleKegiatan(
      kodeGereja, kodeKegiatan, kodeTransaksi, status) async {
    _kodePerkiraanSingleKegiatan.clear();

    var response = await servicesUser.getKodePerkiraanSingleKegiatan(
        kodeGereja, kodeKegiatan, kodeTransaksi, status);
    if (response[0] != 404) {
      for (var element in response[1]) {
        debugPrint(element.toString());
        _kodePerkiraanSingleKegiatan.add(
            "${element['kode_perkiraan']} ~ ${element['nama_kode_perkiraan']}");
      }
    }
  }

  Future _getKodeTransaksi(kodeGereja) async {
    _kodeTransaksi.clear();
    var response = await servicesUser.getKodeTransaksi(kodeGereja);
    if (response[0] != 404) {
      for (var element in response[1]) {
        debugPrint(element.toString());
        _kodeTransaksi
            .add("${element['kode_transaksi']} - ${element['nama_transaksi']}");
      }
    }
  }

  Future _getKodeTransaksiCount(kodeTransaksiGabungan) async {
    _kodeTransaksiCount = "000";
    var response =
        await servicesUser.getSingleKodeTransaksi(kodeTransaksiGabungan);
    if (response[0] != 404) {
      for (var element in response[1]) {
        debugPrint(element['count_kode_transaksi'].toString());
        _kodeTransaksiCount = element['count_kode_transaksi'].toString();
      }
    } else {
      throw "Gagal Mengambil Data";
    }
  }

  Future _getKodeRefKegiatan(kodeGereja) async {
    _kodeRefKegiatan.clear();
    var response = await servicesUser.getAllProposalKegiatan(kodeGereja);
    if (response[0] != 404) {
      for (var element in response[1]) {
        debugPrint(element.toString());
        _kodeRefKegiatan
            .add("${element['kode_kegiatan']} ~ ${element['nama_kegiatan']}");
      }
    }
  }

  Future _postTransaksi(
      kodeGereja,
      kodeTransaksi,
      kodeMaster,
      kodePerkiraan,
      kodeRefKegiatan,
      tanggalTransaksi,
      deskripsiTransaksi,
      nominalTransaksi,
      jenisTransaksi,
      context) async {
    var response = await servicesUser.inputTransaksi(
        kodeGereja,
        kodeTransaksi,
        kodeMaster,
        kodePerkiraan,
        kodeRefKegiatan,
        tanggalTransaksi,
        deskripsiTransaksi,
        nominalTransaksi,
        jenisTransaksi);

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

  Future _updateCountKodeTransaksi(kodeTransaksi, kodeGereja, context) async {
    var response =
        await servicesUser.updateCountKodeTransaksi(kodeGereja, kodeTransaksi);
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

  _splitString(val) {
    var value = val.toString();
    var split = value.indexOf(" ");
    var temp = value.substring(0, split);
    return temp;
  }

  _splitStringKode(val) {
    var value = val.toString();
    var split = value.indexOf("-");
    var temp = value.substring(0, split);
    return temp;
  }

  _buatKodeGabungan(val) {
    var temp = kodeGereja + _splitString(val);
    return temp;
  }

  _splitKodeMasterDanPerkiraan(val) {
    var value = val.toString();
    var splitDot = value.indexOf("-");
    var splitSpace = value.indexOf(" ");
    var master = value.substring(0, splitDot);
    var perkiraan = value.substring(splitDot + 1, splitSpace);
    return [master, perkiraan];
  }

  Future<void> selectDate(context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: temptanggalMulaiAcaraBatas,
      firstDate: temptanggalMulaiAcaraBatas,
      lastDate: temptanggalSelesaiAcaraBatas,
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
                  foregroundColor: navButtonPrimary, // button text color
                ),
              ),
            ),
            child: child!);
      },
    );
    if (picked != null && picked != selectedDate) {
      if (mounted) {
        selectedDate = picked;
        formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
        date = formattedDate;
        debugPrint("Selected Date From $selectedDate");

        setState(() {});
      }
    }
  }

  final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');
//TODO: Show Tambah Transaksi Dialog
  _showTambahDialog(dw, dh, kodeTransaksi, kodeRef, context) {
    if (kodeRef == "Pilih") {
      kodeRef = "";
    }
    RadioStatusTransaksi? radio;
    selectedKodePerkiraan = "Pilih Kode Perkiraan";
    _controllerKeterangan.clear();
    _controllerNominal.clear();
    date = formattedDate;
    kodePerkiraan = "";
    kodeMaster = "";
    _status = "";
    tempItemTransaksi.clear();

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
                    width: dw < 800 ? dw * 0.8 : dw * 0.4,
                    child: Column(
                      children: [
                        Container(
                          width: dw < 800 ? dw * 0.8 : dw * 0.4,
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
                              responsiveText("Tambah Item Transaksi", 26,
                                  FontWeight.w700, lightText),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Form(
                                key: _buatTransaksiform,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              responsiveText(
                                                  "Kode Transaksi",
                                                  16,
                                                  FontWeight.w700,
                                                  darkText),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              //TODO: Kode Transaksi
                                              responsiveText("Kode Ref", 16,
                                                  FontWeight.w700, darkText),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            responsiveText(" : ", 16,
                                                FontWeight.w700, darkText),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            //TODO: Kode Transaksi
                                            responsiveText(" : ", 16,
                                                FontWeight.w700, darkText),
                                          ],
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              responsiveText(kodeTransaksi, 16,
                                                  FontWeight.w700, darkText),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              //TODO: Kode Transaksi
                                              responsiveText(
                                                  kodeRef == "" ? "-" : kodeRef,
                                                  16,
                                                  FontWeight.w700,
                                                  darkText),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: dw < 800 ? dw * 0.75 : dw * 0.35,
                                      child: const Divider(
                                        height: 25,
                                      ),
                                    ),
                                    Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            Radio(
                                              value: RadioStatusTransaksi
                                                  .pemasukan,
                                              groupValue: radio,
                                              activeColor: primaryColorVariant,
                                              onChanged: (val) async {
                                                radio = val
                                                    as RadioStatusTransaksi?;
                                                if (mounted) {
                                                  if (kodeRef != "") {
                                                    await _getKodePerkiraanSingleKegiatan(
                                                      kodeGereja,
                                                      kodeRefKegiatan,
                                                      _splitStringKode(
                                                          kodeTransaksi),
                                                      "pengeluaran",
                                                    ).whenComplete(() {
                                                      setState(() {});
                                                    });
                                                  } else {
                                                    await _getKodePerkiraanSingleKegiatan(
                                                      kodeGereja,
                                                      kodeRefKegiatan,
                                                      _splitStringKode(
                                                          kodeTransaksi),
                                                      "pemasukan",
                                                    ).whenComplete(() {
                                                      setState(() {});
                                                    });
                                                  }

                                                  setState(() {});
                                                }
                                                _status = "pemasukan";
                                                debugPrint(_status);
                                              },
                                            ),
                                            responsiveText("Debit", 14,
                                                FontWeight.w700, darkText),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 25,
                                        ),
                                        Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            Radio(
                                              value: RadioStatusTransaksi
                                                  .pengeluaran,
                                              groupValue: radio,
                                              activeColor: primaryColorVariant,
                                              onChanged: (val) async {
                                                radio = val
                                                    as RadioStatusTransaksi?;

                                                if (mounted) {
                                                  if (kodeRef != "") {
                                                    await _getKodePerkiraanSingleKegiatan(
                                                      kodeGereja,
                                                      kodeRefKegiatan,
                                                      _splitStringKode(
                                                          kodeTransaksi),
                                                      "pemasukan",
                                                    ).whenComplete(() {
                                                      setState(() {});
                                                    });
                                                  } else {
                                                    await _getKodePerkiraanSingleKegiatan(
                                                      kodeGereja,
                                                      kodeRefKegiatan,
                                                      _splitStringKode(
                                                          kodeTransaksi),
                                                      "pengeluaran",
                                                    ).whenComplete(() {
                                                      setState(() {});
                                                    });
                                                  }

                                                  setState(() {});
                                                }
                                                _status = "pengeluaran";
                                                debugPrint(_status);
                                              },
                                            ),
                                            responsiveText("Kredit", 14,
                                                FontWeight.w700, darkText),
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    //
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        //TODO: Input Kode Perkiraan Dialog
                                        responsiveText("Kode Perkiraan", 16,
                                            FontWeight.w700, darkText),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Card(
                                          color: surfaceColor,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: DropdownSearch<dynamic>(
                                            clearButtonProps: clearKodeRef,
                                            popupProps: PopupProps.menu(
                                              showSearchBox: true,
                                              searchFieldProps: TextFieldProps(
                                                decoration: InputDecoration(
                                                  border:
                                                      const OutlineInputBorder(),
                                                  hintText: "Cari Disini",
                                                  suffixIcon: IconButton(
                                                    onPressed: () {
                                                      _controllerDropdownFilter
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
                                                    _controllerDropdownFilter,
                                              ),
                                            ),
                                            items: _kodePerkiraanSingleKegiatan,
                                            onChanged: (val) {
                                              if (val == null) {
                                                selectedKodePerkiraan =
                                                    "Pilih Kode Perkiraan";
                                                kodePerkiraan = "";
                                              } else {
                                                selectedKodePerkiraan = val;
                                                debugPrint(
                                                    selectedKodePerkiraan);
                                                debugPrint(_splitString(
                                                    selectedKodePerkiraan));
                                                debugPrint(_buatKodeGabungan(
                                                    selectedKodePerkiraan));
                                                kodeMaster =
                                                    _splitKodeMasterDanPerkiraan(
                                                        val)[0];
                                                kodePerkiraan =
                                                    _splitKodeMasterDanPerkiraan(
                                                            val)[0] +
                                                        "-" +
                                                        _splitKodeMasterDanPerkiraan(
                                                            val)[1];
                                              }
                                              debugPrint(kodeMaster);
                                              debugPrint(kodePerkiraan);
                                              if (mounted) {
                                                setState(() {});
                                              }
                                            },
                                            selectedItem: selectedKodePerkiraan,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(
                                      height: 10,
                                    ),
                                    responsiveText("Tanggal", 16,
                                        FontWeight.w700, darkText),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      width: dw,
                                      child: GestureDetector(
                                        onTap: () {
                                          selectDate(context).then(
                                            (value) => setState(() {}),
                                          );
                                        },
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
                                                Text(date),
                                                const IconButton(
                                                  onPressed: null,
                                                  icon: Icon(
                                                      Icons.calendar_month),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 10,
                                    ),
                                    responsiveText("Nominal", 16,
                                        FontWeight.w700, darkText),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextFormField(
                                        controller: _controllerNominal,
                                        autofocus: false,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: surfaceColor,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 0, horizontal: 25),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Harus Diisi";
                                          }

                                          if (!numericRegex.hasMatch(value)) {
                                            return "Hanya Angka ";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 10,
                                    ),
                                    responsiveText("Deskripsi", 16,
                                        FontWeight.w700, darkText),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextFormField(
                                        controller: _controllerKeterangan,
                                        autofocus: false,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: surfaceColor,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 0, horizontal: 25),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Harus Diisi";
                                          }
                                          return null;
                                        },
                                      ),
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
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  debugPrint(kodeTransaksi);
                                  debugPrint(kodePerkiraan);
                                  debugPrint(kodeRefKegiatan);
                                  debugPrint(date);
                                  debugPrint(_controllerNominal.text);
                                  debugPrint(_controllerKeterangan.text);
                                  await _getKodePerkiraanSingleKegiatan(
                                          kodeGereja, "", "", "")
                                      .whenComplete(
                                          () => Navigator.pop(context));
                                },
                                child: const Text("Batal"),
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (kodeRefKegiatan != "") {
                                    _getPerbandinganPeringatan(
                                            kodeGereja + kodeRefKegiatan,
                                            kodeRefKegiatan,
                                            kodeGereja,
                                            kodePerkiraan)
                                        .then((value) {
                                      debugPrint(
                                          "............................................");
                                      debugPrint(kodeRefKegiatan);
                                      debugPrint(kodeGereja);
                                      debugPrint(kodePerkiraan);
                                      debugPrint(budgetNotif.toString());
                                      debugPrint(sumNotif.toString());
                                      debugPrint(
                                          "............................................");
                                    });
                                  }

                                  if (_buatTransaksiform.currentState!
                                      .validate()) {
                                    if (_status == "") {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "Silahkan pilih Status Pemasukan / Pengeluaran"),
                                        ),
                                      );
                                    } else {
                                      if (kodePerkiraan == "" ||
                                          kodeMaster == "") {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "Silahkan Pilih Kode Perkiraan Terlebih Dahulu"),
                                          ),
                                        );
                                      } else {
                                        if (kodeRefKegiatan != "") {
                                          if (budgetNotif <
                                              (sumNotif +
                                                  int.parse(_controllerNominal
                                                      .text))) {
                                            //alert
                                            if (_status == "pengeluaran") {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      "Nominal untuk item ini sudah melebihi budget yang ditentukan"),
                                                ),
                                              );
                                            }
                                            //Add
                                            tempItemTransaksi
                                                .add(kodeTransaksi);
                                            tempItemTransaksi.add(kodeMaster);
                                            tempItemTransaksi
                                                .add(kodePerkiraan);
                                            tempItemTransaksi
                                                .add(kodeRefKegiatan);
                                            tempItemTransaksi.add(date);
                                            tempItemTransaksi
                                                .add(_controllerNominal.text);
                                            tempItemTransaksi.add(
                                                _controllerKeterangan.text);
                                            tempItemTransaksi.add(_status);

                                            debugPrint(
                                                tempItemTransaksi.toString());
                                            itemTransaksi.add(
                                                tempItemTransaksi.toList());
                                            if (_status == "pemasukan") {
                                              totalPemasukanStatus += int.parse(
                                                  _controllerNominal.text);
                                            } else if (_status ==
                                                "pengeluaran") {
                                              totalPengeluaranStatus +=
                                                  int.parse(
                                                      _controllerNominal.text);
                                            }

                                            if (mounted) {
                                              setState(() {});
                                            }
                                            Navigator.pop(context);
                                          } else {
                                            //Print
                                            debugPrint(kodeTransaksi);
                                            debugPrint(kodeMaster);
                                            debugPrint(kodePerkiraan);
                                            debugPrint(kodeRefKegiatan);
                                            debugPrint(date);
                                            debugPrint(_controllerNominal.text);
                                            debugPrint(
                                                _controllerKeterangan.text);

                                            //Add
                                            tempItemTransaksi
                                                .add(kodeTransaksi);
                                            tempItemTransaksi.add(kodeMaster);
                                            tempItemTransaksi
                                                .add(kodePerkiraan);
                                            tempItemTransaksi
                                                .add(kodeRefKegiatan);
                                            tempItemTransaksi.add(date);
                                            tempItemTransaksi
                                                .add(_controllerNominal.text);
                                            tempItemTransaksi.add(
                                                _controllerKeterangan.text);
                                            tempItemTransaksi.add(_status);

                                            debugPrint(
                                                tempItemTransaksi.toString());
                                            itemTransaksi.add(
                                                tempItemTransaksi.toList());
                                            if (_status == "pemasukan") {
                                              totalPemasukanStatus += int.parse(
                                                  _controllerNominal.text);
                                            } else if (_status ==
                                                "pengeluaran") {
                                              totalPengeluaranStatus +=
                                                  int.parse(
                                                      _controllerNominal.text);
                                            }
                                            if (mounted) {
                                              setState(() {});
                                            }
                                            Navigator.pop(context);
                                          }
                                        } else {
                                          //Add
                                          tempItemTransaksi.add(kodeTransaksi);
                                          tempItemTransaksi.add(kodeMaster);
                                          tempItemTransaksi.add(kodePerkiraan);
                                          tempItemTransaksi
                                              .add(kodeRefKegiatan);
                                          tempItemTransaksi.add(date);
                                          tempItemTransaksi
                                              .add(_controllerNominal.text);
                                          tempItemTransaksi
                                              .add(_controllerKeterangan.text);
                                          tempItemTransaksi.add(_status);

                                          debugPrint(
                                              tempItemTransaksi.toString());
                                          itemTransaksi
                                              .add(tempItemTransaksi.toList());
                                          if (_status == "pemasukan") {
                                            totalPemasukanStatus += int.parse(
                                                _controllerNominal.text);
                                          } else if (_status == "pengeluaran") {
                                            totalPengeluaranStatus += int.parse(
                                                _controllerNominal.text);
                                          }
                                          if (mounted) {
                                            setState(() {});
                                          }
                                          Navigator.pop(context);
                                        }
                                      }
                                    }
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
      debugPrint(itemTransaksi.toString());
      setState(() {});
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
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    _rowList.clear();
                    _totalPemasukan = 0;
                    _totalPengeluaran = 0;
                    _totalSaldo = 0;
                    _getTransaksi(kodeGereja).whenComplete(
                      () => widget.controllerPageBuatTransaksi.animateToPage(0,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.ease),
                    );
                  },
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                ),
                const SizedBox(
                  width: 25,
                ),
                responsiveText("Buat Transaksi", 26, FontWeight.w900, darkText),
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
                  physics: const ClampingScrollPhysics(),
                  controller: ScrollController(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //TODO: Input Kode Transaksi Dialog
                      responsiveText(
                          "Kode Transaksi", 16, FontWeight.w700, darkText),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
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
                                          _controllerDropdownFilter.clear();
                                        },
                                        icon: Icon(
                                          Icons.clear,
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                    controller: _controllerDropdownFilter,
                                  ),
                                ),
                                items: _kodeTransaksi,
                                onChanged: (val) {
                                  selectedKodeTransaksi = val;
                                  itemTransaksi.clear();
                                  debugPrint(selectedKodeTransaksi);
                                  debugPrint(
                                      _splitString(selectedKodeTransaksi));
                                  debugPrint(
                                      _buatKodeGabungan(selectedKodeTransaksi));
                                  _singleKodeTransaksi =
                                      _splitString(selectedKodeTransaksi);
                                  String tempKodeGabungan =
                                      _buatKodeGabungan(selectedKodeTransaksi)
                                          .toString();
                                  _getKodeTransaksiCount(tempKodeGabungan)
                                      .whenComplete(() => setState(() {}));
                                },
                                selectedItem: selectedKodeTransaksi,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const SizedBox(
                            width: 10,
                            child: Divider(
                              thickness: 2,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          responsiveText(_kodeTransaksiCount, 16,
                              FontWeight.w700, darkText),
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
//
                      //TODO: Input Kode Referensi Dialog
                      responsiveText("Kode Referensi Kegiatan", 16,
                          FontWeight.w700, darkText),
                      const SizedBox(
                        height: 10,
                      ),
                      Card(
                        color: surfaceColor,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: DropdownSearch<dynamic>(
                          clearButtonProps: clearKodeRef,
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                            searchFieldProps: TextFieldProps(
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                hintText: "Cari Disini",
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    _controllerDropdownFilter.clear();
                                  },
                                  icon: Icon(
                                    Icons.clear,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                              ),
                              controller: _controllerDropdownFilter,
                            ),
                          ),
                          items: _kodeRefKegiatan,
                          onChanged: (val) {
                            if (val == null) {
                              itemTransaksi.clear();
                              selectedKodeRefKegiatan = "Pilih Kode Referensi";
                              kodeRefKegiatan = "";
                              selectedKodePerkiraan = "Pilih Kode Perkiraan";
                              kodePerkiraan = "";
                              _getKodePerkiraanSingleKegiatan(
                                kodeGereja,
                                "",
                                _singleKodeTransaksi,
                                "",
                              ).whenComplete(() => setState(() {}));
                            } else {
                              selectedKodePerkiraan = "Pilih Kode Perkiraan";
                              _kodePerkiraanSingleKegiatan.clear();
                              selectedKodeRefKegiatan = val;

                              kodeRefKegiatan =
                                  _splitString(selectedKodeRefKegiatan);
                            }
                            _getBatasTanggal(kodeGereja, kodeRefKegiatan);
                            if (mounted) {
                              setState(() {});
                            }
                          },
                          selectedItem: selectedKodeRefKegiatan,
                        ),
                      ),
                      responsiveText("*Biarkan Kalau Tidak Ada", 12,
                          FontWeight.w700, Colors.red),
                      const SizedBox(
                        height: 10,
                      ),
//
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              debugPrint(_singleKodeTransaksi);
                              if (_singleKodeTransaksi != "") {
                                _showTambahDialog(
                                    deviceWidth,
                                    deviceHeight,
                                    "$_singleKodeTransaksi-$_kodeTransaksiCount",
                                    _splitString(selectedKodeRefKegiatan),
                                    context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Silahkan Pilih Kode Transaksi Terlebih Dahulu"),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              "Tambah Item",
                              style: GoogleFonts.nunito(
                                  fontWeight: FontWeight.w700, fontSize: 14),
                            ),
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
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            controller: ScrollController(),
                            physics: const ClampingScrollPhysics(),
                            itemCount: itemTransaksi.length,
                            itemBuilder: (context, index) {
                              return Card(
                                color: scaffoldBackgroundColor,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        dense: true,
                                        minLeadingWidth: 85,
                                        minVerticalPadding: 16,
                                        title: Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  responsiveText(
                                                      "${itemTransaksi[index][0]}-${itemTransaksi[index][2]}",
                                                      16,
                                                      FontWeight.w600,
                                                      darkText),
                                                  responsiveText(
                                                    "Ref : ${itemTransaksi[index][3]}",
                                                    14,
                                                    FontWeight.w500,
                                                    darkText.withOpacity(0.5),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 25,
                                              child: VerticalDivider(
                                                color: dividerColor,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: responsiveText(
                                                  itemTransaksi[index][4]
                                                      .toString(),
                                                  16,
                                                  FontWeight.w600,
                                                  darkText),
                                            ),
                                            SizedBox(
                                              height: 25,
                                              child: VerticalDivider(
                                                color: dividerColor,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 5,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  responsiveText(
                                                      itemTransaksi[index][6]
                                                          .toString(),
                                                      16,
                                                      FontWeight.w600,
                                                      darkText),
                                                  responsiveText(
                                                      itemTransaksi[index][7]
                                                          .toString(),
                                                      16,
                                                      FontWeight.w600,
                                                      itemTransaksi[index][7]
                                                                  .toString() ==
                                                              "pemasukan"
                                                          ? Colors.green
                                                          : Colors.red),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 25,
                                              child: VerticalDivider(
                                                color: dividerColor,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: responsiveText(
                                                  CurrencyFormatAkuntansi
                                                      .convertToIdr(
                                                          int.parse(
                                                              itemTransaksi[
                                                                  index][5]),
                                                          2),
                                                  16,
                                                  FontWeight.w600,
                                                  darkText),
                                            ),
                                            SizedBox(
                                              height: 25,
                                              child: VerticalDivider(
                                                color: dividerColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        trailing: IconButton(
                                          onPressed: () {
                                            if (itemTransaksi[index][7] ==
                                                "pemasukan") {
                                              totalPemasukanStatus -= int.parse(
                                                  itemTransaksi[index][5]);
                                            } else {
                                              totalPengeluaranStatus -=
                                                  int.parse(
                                                      itemTransaksi[index][5]);
                                            }
                                            debugPrint(totalPemasukanStatus
                                                .toString());
                                            debugPrint(totalPengeluaranStatus
                                                .toString());

                                            itemTransaksi.removeAt(index);
                                            if (mounted) {
                                              setState(() {});
                                            }
                                          },
                                          icon:
                                              const Icon(Icons.delete_rounded),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          print(totalPemasukanStatus);
                          print(totalPengeluaranStatus);
                          if (totalPemasukanStatus != totalPengeluaranStatus) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "Pemasukan dan Pengeluaran Belum Seimbang, Silahkan Periksa Lagi"),
                              ),
                            );
                          } else {
                            int ctr = 0;
                            String tempKodeTransaksi = "";
                            for (var element in itemTransaksi) {
                              tempKodeTransaksi = _splitStringKode(element[0]);
                              debugPrint(tempKodeTransaksi);
                              debugPrint(
                                  "${element[0]} - ${element[1]} - ${element[2]} - ${element[3]} - ${element[4]} - ${element[5]} - ${element[6]} - ${element[7]}");

                              _postTransaksi(
                                      kodeGereja,
                                      element[0],
                                      element[1],
                                      element[2],
                                      element[3],
                                      element[4],
                                      element[6],
                                      element[5],
                                      element[7],
                                      context)
                                  .whenComplete(
                                () {
                                  ctr++;
                                  if (ctr == itemTransaksi.length) {
                                    _updateCountKodeTransaksi(tempKodeTransaksi,
                                            kodeGereja, context)
                                        .whenComplete(
                                      () {
                                        _rowList.clear();
                                        _totalPemasukan = 0;
                                        _totalPengeluaran = 0;
                                        _totalSaldo = 0;
                                        _getTransaksi(kodeGereja).whenComplete(
                                          () => widget
                                              .controllerPageBuatTransaksi
                                              .animateToPage(0,
                                                  duration: const Duration(
                                                      milliseconds: 250),
                                                  curve: Curves.ease),
                                        );
                                      },
                                    );
                                  }
                                },
                              );
                            }
                          }
                        },
                        child: Text(
                          "Simpan Transaksi",
                          style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                      ),
                    ],
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

final _pemasukanLancar = List.empty(growable: true);
final _pemasukanTetap = List.empty(growable: true);
final _pengeluaranLancar = List.empty(growable: true);
final _pengeluaranJangkaPanjang = List.empty(growable: true);

class AdminLaporanKeuangan extends StatefulWidget {
  final PageController controllerPageLihatLaporan;
  final PageController controllerPageLihatSaldoAwal;
  const AdminLaporanKeuangan(
      {super.key,
      required this.controllerPageLihatLaporan,
      required this.controllerPageLihatSaldoAwal});

  @override
  State<AdminLaporanKeuangan> createState() => _AdminLaporanKeuanganState();
}

class _AdminLaporanKeuanganState extends State<AdminLaporanKeuangan>
    with TickerProviderStateMixin {
  ServicesUser servicesUser = ServicesUser();
  late TabController _tabController;

  DateTime selectedMonth = DateTime.now();
  String formattedMonth = "";
  String month = "Month";

  late SignatureController controller;
  int _currentValue = 5;
  Color pickerColor = darkText;
  Color currentColor = darkText;

  Uint8List? exportedImage;

  String nama = "User";

  late Future getAktivaLancar;
  late Future getAktivaTetap;
  late Future getPasivaLancar;
  late Future getPasivaJangkaPanjang;

  @override
  void initState() {
    // TODO: implement initState
    getUserName(kodeUser);
    _tabController = TabController(length: 3, vsync: this);
    formattedMonth = DateFormat('MM-yyyy').format(selectedMonth);
    month = formattedMonth;
    controller = SignatureController(
        penStrokeWidth: 5,
        penColor: currentColor,
        exportBackgroundColor: Colors.transparent);
    getAktivaLancar =
        servicesUser.getNeraca(kodeGereja, month, "pemasukan", "lancar");
    getAktivaTetap =
        servicesUser.getNeraca(kodeGereja, month, "pemasukan", "tetap");
    getPasivaLancar =
        servicesUser.getNeraca(kodeGereja, month, "pengeluaran", "lancar");
    getPasivaJangkaPanjang = servicesUser.getNeraca(
        kodeGereja, month, "pengeluaran", "jangka panjang");

    _getNeracaTable(kodeGereja);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future getUserName(userStatus) async {
    var response = await servicesUser.getSingleUser(userStatus);
    nama = response[1]['nama_lengkap_user'].toString();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> selectMonth(context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5, 1, 1),
      lastDate: DateTime(DateTime.now().year, 12, 31),
      initialDate: selectedMonth,
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
                  foregroundColor: navButtonPrimary, // button text color
                ),
              ),
            ),
            child: child!);
      },
    );
    if (picked != null && picked != selectedMonth) {
      if (mounted) {
        selectedMonth = picked;
        formattedMonth = DateFormat('MM-yyyy').format(selectedMonth);
        month = formattedMonth;
        debugPrint("Selected Month $month");
        setState(() {});
      }
    }
  }

  Future _getJurnalData(kodeGereja, month) async {
    _dataJurnal.clear();
    var tempKode = List.empty(growable: true);
    var tempData = List.empty(growable: true);
    var responseKode =
        await servicesUser.getKodeKegiatanJurnal(kodeGereja, month);
    if (responseKode[0] != 404) {
      for (var element in responseKode[1]) {
        var responseData = await servicesUser.getJurnal(
            kodeGereja, month, element['kode_transaksi']);

        for (var element in responseData[1]) {
          tempData.add(DateFormat('dd MMM').format(
            DateTime.parse(element['tanggal_transaksi']),
          ));
          tempData.add(element['nama_kode_perkiraan']);
          tempData.add(element['kode_kegiatan']);
          tempData.add(element['status']);
          tempData.add(element['jurnal']);
          tempKode.add(tempData.toList());
          tempData.clear();
        }
        _dataJurnal.add(tempKode.toList());
        tempKode.clear();
      }
    } else {
      throw "Gagal Mengambil Data";
    }
    debugPrint(_dataJurnal.toString());
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  Future showPicker() {
    return showDialog(
      builder: (context) => AlertDialog(
        title: const Text('Pilih Warna Garis'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: changeColor,
          ),
          // Use Material color picker:
          //
          // child: MaterialPicker(
          //     pickerColor: pickerColor, onColorChanged: changeColor),
          //
          // Use Block color picker:
          //
          // child: BlockPicker(
          //   pickerColor: currentColor,
          //   onColorChanged: changeColor,
          // ),
          //
          // child: MultipleChoiceBlockPicker(
          //   pickerColors: currentColors,
          //   onColorsChanged: changeColors,
          // ),
        ),
        actions: <Widget>[
          ElevatedButton(
              child: const Text('Ok'),
              onPressed: () {
                currentColor = pickerColor;
                Navigator.of(context).pop();
                controller = SignatureController(
                  penStrokeWidth: double.parse(_currentValue.toString()),
                  penColor: currentColor,
                );
                setState(() {});
              }),
        ],
      ),
      context: context,
    ).whenComplete(() {
      setState(() {});
    });
  }

  showAsign(dw, dh, tipe) {
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
                    width: dw < 800 ? dw * 0.8 : dw * 0.4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 25, horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  controller.clear();
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                    Icons.arrow_back_ios_new_rounded),
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              responsiveText("Tanda Tangan", 26,
                                  FontWeight.w900, darkText),
                              const Spacer(),
                            ],
                          ),
                          const Divider(
                            thickness: 1,
                            height: 56,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              responsiveText(
                                  "Warna Garis", 16, FontWeight.w600, darkText),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    showPicker();
                                    controller = SignatureController(
                                      penStrokeWidth: double.parse(
                                          _currentValue.toString()),
                                      penColor: currentColor,
                                    );
                                  });
                                },
                                icon: const Icon(Icons.color_lens),
                              ),
                            ],
                          ),
                          Center(
                            child: SizedBox(
                              height: 300,
                              width: dw,
                              child: Signature(
                                backgroundColor: primaryColor,
                                controller: controller,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          responsiveText(
                              "Ketebalan Garis", 16, FontWeight.w600, darkText),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 15.0,
                                  vertical: 15.0,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFFFFF),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0,
                                ),
                                alignment: Alignment.center,
                                height: 40,
                              ),
                              Positioned(
                                  child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade300,
                                      blurRadius: 15.0,
                                      spreadRadius: 1.0,
                                      offset: const Offset(
                                        0.0,
                                        0.0,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                              Container(
                                alignment: Alignment.center,
                                child: NumberPicker(
                                  axis: Axis.horizontal,
                                  itemHeight: 45,
                                  itemWidth: 45.0,
                                  step: 1,
                                  selectedTextStyle: const TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12.0,
                                  ),
                                  itemCount: 7,
                                  value: _currentValue,
                                  minValue: 1,
                                  maxValue: 10,
                                  onChanged: (v) {
                                    setState(() {
                                      _currentValue = v;
                                    });
                                    controller = SignatureController(
                                      penStrokeWidth: double.parse(
                                          _currentValue.toString()),
                                      penColor: currentColor,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    controller.clear();
                                  },
                                  child: Text(
                                    "Hapus",
                                    style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () async {
                                    // exportedImage =
                                    //     await controller.toPngBytes();
                                    //API
                                    if (controller.isNotEmpty) {
                                      exportSignature(tipe);

                                      controller.clear();
                                    }
                                    setState(() {});
                                  },
                                  child: Text(
                                    "Lanjutkan",
                                    style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      setState(() {});
    });
  }

  exportSignature(int tipe) async {
    final exportController = SignatureController(
      penStrokeWidth: double.parse(_currentValue.toString()),
      penColor: currentColor,
      exportBackgroundColor: Colors.white,
      points: controller.points,
    );

    exportController.toPngBytes().then((value) {
      if (tipe == 0) {
        _getJurnalData(kodeGereja, month).whenComplete(
          () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return AdminLaporanPreviewPDF(
                    tipe: tipe,
                    month: month,
                    signature: value as Uint8List,
                    nama: nama,
                  );
                },
              ),
            );
          },
        );
      } else if (tipe == 1) {
        _getBukuBesarData(kodeGereja, month).whenComplete(
          () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return AdminLaporanPreviewPDF(
                    tipe: tipe,
                    month: month,
                    signature: value as Uint8List,
                    nama: nama,
                  );
                },
              ),
            );
          },
        );
      } else {
        _getNeraca(kodeGereja, month).whenComplete(
          () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return AdminLaporanPreviewPDF(
                    tipe: tipe,
                    month: month,
                    signature: value as Uint8List,
                    nama: nama,
                  );
                },
              ),
            );
          },
        );
      }
    });
    exportController.dispose();
  }

  jurnalUmumView(dw, dh) {
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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    selectMonth(context);
                  },
                  child: Card(
                    color: primaryColor,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          responsiveText(month, 14, FontWeight.w700, lightText),
                          const IconButton(
                            onPressed: null,
                            icon: Icon(Icons.calendar_month),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  //TODO: search btn
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: const Color(0xff960000),
                  ),
                  onPressed: () {
                    showAsign(dw, dh, 0);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: FaIcon(FontAwesomeIcons.solidFilePdf),
                  ),
                ),
              ],
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Text(
                              "Tanggal",
                              style: GoogleFonts.nunito(
                                  color: darkText,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  letterSpacing: 0.125),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Keterangan",
                              style: GoogleFonts.nunito(
                                  color: darkText,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  letterSpacing: 0.125),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Ref",
                              style: GoogleFonts.nunito(
                                  color: darkText,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  letterSpacing: 0.125),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Debit",
                              style: GoogleFonts.nunito(
                                  color: darkText,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  letterSpacing: 0.125),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Kredit",
                              style: GoogleFonts.nunito(
                                  color: darkText,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  letterSpacing: 0.125),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: darkText.withOpacity(0.2),
                    ),
                    FutureBuilder(
                      future:
                          servicesUser.getKodeKegiatanJurnal(kodeGereja, month),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List snapData = snapshot.data! as List;
                          debugPrint(snapData.toString());
                          debugPrint(snapData[1].length.toString());

                          if (snapData[0] != 404) {
                            return ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              controller: ScrollController(),
                              physics: const ClampingScrollPhysics(),
                              itemCount: snapData[1].length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 25,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Text(
                                      //   snapData[1][index]['kode_transaksi']
                                      //       .toString(),
                                      //   style: GoogleFonts.nunito(
                                      //       color: darkText,
                                      //       fontWeight: FontWeight.w800,
                                      //       fontSize: 18,
                                      //       letterSpacing: 0.125),
                                      // ),
                                      // const SizedBox(
                                      //   height: 16,
                                      // ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: FutureBuilder(
                                              future: servicesUser.getJurnal(
                                                  kodeGereja,
                                                  month,
                                                  snapData[1][index]
                                                      ['kode_transaksi']),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  List snapData =
                                                      snapshot.data! as List;
                                                  debugPrint(
                                                      snapData.toString());
                                                  debugPrint(snapData[1]
                                                      .length
                                                      .toString());
                                                  if (snapData[0] != 404) {
                                                    return ListView.builder(
                                                      shrinkWrap: true,
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      controller:
                                                          ScrollController(),
                                                      physics:
                                                          const ClampingScrollPhysics(),
                                                      itemCount:
                                                          snapData[1].length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return ListTile(
                                                          title: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  index != 0
                                                                      ? ""
                                                                      : DateFormat(
                                                                              'dd MMM')
                                                                          .format(
                                                                          DateTime.parse(snapData[1][index]
                                                                              [
                                                                              'tanggal_transaksi']),
                                                                        ),
                                                                  style: GoogleFonts.nunito(
                                                                      color:
                                                                          darkText,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          16,
                                                                      letterSpacing:
                                                                          0.125),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 5),
                                                              Expanded(
                                                                flex: 2,
                                                                child: Text(
                                                                  snapData[1][index]
                                                                          [
                                                                          'nama_kode_perkiraan']
                                                                      .toString(),
                                                                  style: GoogleFonts.nunito(
                                                                      color:
                                                                          darkText,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          16,
                                                                      letterSpacing:
                                                                          0.125),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 5),
                                                              Expanded(
                                                                flex: 2,
                                                                child: Text(
                                                                  snapData[1][index]
                                                                          [
                                                                          'kode_kegiatan']
                                                                      .toString(),
                                                                  style: GoogleFonts.nunito(
                                                                      color:
                                                                          darkText,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          16,
                                                                      letterSpacing:
                                                                          0.125),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 5),
                                                              Expanded(
                                                                flex: 2,
                                                                child: snapData[1][index]
                                                                            [
                                                                            'status'] ==
                                                                        "pemasukan"
                                                                    ? Text(
                                                                        CurrencyFormatAkuntansi.convertToIdr(snapData[1][index]['jurnal'].abs(),
                                                                                2)
                                                                            .toString(),
                                                                        style: GoogleFonts.nunito(
                                                                            color:
                                                                                darkText,
                                                                            fontWeight: FontWeight
                                                                                .w600,
                                                                            fontSize:
                                                                                16,
                                                                            letterSpacing:
                                                                                0.125),
                                                                      )
                                                                    : const Text(
                                                                        ""),
                                                              ),
                                                              const SizedBox(
                                                                  width: 5),
                                                              Expanded(
                                                                flex: 2,
                                                                child: snapData[1][index]
                                                                            [
                                                                            'status'] ==
                                                                        "pengeluaran"
                                                                    ? Text(
                                                                        CurrencyFormatAkuntansi.convertToIdr(snapData[1][index]['jurnal'].abs(),
                                                                                2)
                                                                            .toString(),
                                                                        style: GoogleFonts.nunito(
                                                                            color:
                                                                                darkText,
                                                                            fontWeight: FontWeight
                                                                                .w600,
                                                                            fontSize:
                                                                                16,
                                                                            letterSpacing:
                                                                                0.125),
                                                                      )
                                                                    : const Text(
                                                                        ""),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
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
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return Divider(
                                  height: 0,
                                  color: dividerColor.withOpacity(0.1),
                                );
                              },
                            );
                          }
                          if (snapData[0] == 404) {
                            return noData();
                          }
                        }
                        return loadingIndicator();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _getBukuBesarData(kodeGereja, month) async {
    _dataBukuBesar.clear();
    var tempKode = List.empty(growable: true);
    var tempData = List.empty(growable: true);
    var responseKode = await servicesUser.getKodeBukuBesar(kodeGereja);
    if (responseKode[0] != 404) {
      for (var element in responseKode[1]) {
        var responseData = await servicesUser.getItemBukuBesar(kodeGereja,
            month, element['header_kode_perkiraan'], element['kode_perkiraan']);
        if (responseData[0] != 404) {
          for (var element in responseData[1]) {
            tempData.add(element['tanggal_transaksi']);
            tempData.add(element['uraian_transaksi']);
            tempData.add(element['jenis_transaksi']);
            tempData.add(element['nominal']);
            tempData.add(element['saldo']);
            tempData.add(element['kode_perkiraan']);
            tempKode.add(tempData.toList());
            tempData.clear();
          }
          _dataBukuBesar.add(tempKode.toList());
          tempKode.clear();
        } else {
          throw "Gagal Mengambil Data";
        }
      }
    } else {
      throw "Gagal Mengambil Data";
    }
  }

  bukuBesarView(dw, dh) {
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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    selectMonth(context);
                  },
                  child: Card(
                    color: primaryColor,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          responsiveText(month, 14, FontWeight.w700, lightText),
                          const IconButton(
                            onPressed: null,
                            icon: Icon(Icons.calendar_month),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  //TODO: search btn
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: const Color(0xff960000),
                  ),
                  onPressed: () {
                    showAsign(dw, dh, 1);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: FaIcon(FontAwesomeIcons.solidFilePdf),
                  ),
                ),
              ],
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FutureBuilder(
                  future: servicesUser.getKodeBukuBesar(kodeGereja),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List snapData = snapshot.data! as List;
                      debugPrint(snapData.toString());
                      debugPrint(snapData[1].length.toString());

                      if (snapData[0] != 404) {
                        return ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          controller: ScrollController(),
                          physics: const ClampingScrollPhysics(),
                          itemCount: snapData[1].length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: 25,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapData[1][index]['kode_perkiraan']
                                        .toString(),
                                    style: GoogleFonts.nunito(
                                        color: darkText,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 18,
                                        letterSpacing: 0.125),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: FutureBuilder(
                                          future: servicesUser.getItemBukuBesar(
                                              kodeGereja,
                                              month,
                                              snapData[1][index]
                                                  ['header_kode_perkiraan'],
                                              snapData[1][index]
                                                  ['kode_perkiraan']),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              List snapData =
                                                  snapshot.data! as List;
                                              debugPrint(snapData.toString());
                                              debugPrint(snapData[1]
                                                  .length
                                                  .toString());
                                              if (snapData[0] != 404) {
                                                return Column(
                                                  children: [
                                                    ListTile(
                                                      title: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              "Tanggal",
                                                              style: GoogleFonts.nunito(
                                                                  color:
                                                                      darkText,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize: 16,
                                                                  letterSpacing:
                                                                      0.125),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          Expanded(
                                                            flex: 2,
                                                            child: Text(
                                                              "Uraian",
                                                              style: GoogleFonts.nunito(
                                                                  color:
                                                                      darkText,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize: 16,
                                                                  letterSpacing:
                                                                      0.125),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          Expanded(
                                                            child: Text(
                                                              "Debit",
                                                              style: GoogleFonts.nunito(
                                                                  color:
                                                                      darkText,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize: 16,
                                                                  letterSpacing:
                                                                      0.125),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          Expanded(
                                                            child: Text(
                                                              "Kredit",
                                                              style: GoogleFonts.nunito(
                                                                  color:
                                                                      darkText,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize: 16,
                                                                  letterSpacing:
                                                                      0.125),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          Expanded(
                                                            child: Text(
                                                              "Saldo",
                                                              style: GoogleFonts.nunito(
                                                                  color:
                                                                      darkText,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize: 16,
                                                                  letterSpacing:
                                                                      0.125),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Divider(color: lightText),
                                                    ListView.builder(
                                                      shrinkWrap: true,
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      controller:
                                                          ScrollController(),
                                                      physics:
                                                          const ClampingScrollPhysics(),
                                                      itemCount:
                                                          snapData[1].length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return ListTile(
                                                          title: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  snapData[1][index]
                                                                          [
                                                                          'tanggal_transaksi']
                                                                      .toString(),
                                                                  style: GoogleFonts.nunito(
                                                                      color:
                                                                          darkText,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          16,
                                                                      letterSpacing:
                                                                          0.125),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 5),
                                                              Expanded(
                                                                flex: 2,
                                                                child: Text(
                                                                  snapData[1][index]
                                                                          [
                                                                          'uraian_transaksi']
                                                                      .toString(),
                                                                  style: GoogleFonts.nunito(
                                                                      color:
                                                                          darkText,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          16,
                                                                      letterSpacing:
                                                                          0.125),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 5),
                                                              Expanded(
                                                                child: snapData[1][index]
                                                                            [
                                                                            'jenis_transaksi'] ==
                                                                        "pemasukan"
                                                                    ? Text(
                                                                        CurrencyFormatAkuntansi.convertToIdr(snapData[1][index]['nominal'].abs(),
                                                                                2)
                                                                            .toString(),
                                                                        style: GoogleFonts.nunito(
                                                                            color:
                                                                                darkText,
                                                                            fontWeight: FontWeight
                                                                                .w600,
                                                                            fontSize:
                                                                                16,
                                                                            letterSpacing:
                                                                                0.125),
                                                                      )
                                                                    : const Text(
                                                                        ""),
                                                              ),
                                                              const SizedBox(
                                                                  width: 5),
                                                              Expanded(
                                                                child: snapData[1][index]
                                                                            [
                                                                            'jenis_transaksi'] ==
                                                                        "pengeluaran"
                                                                    ? Text(
                                                                        CurrencyFormatAkuntansi.convertToIdr(snapData[1][index]['nominal'].abs(),
                                                                                2)
                                                                            .toString(),
                                                                        style: GoogleFonts.nunito(
                                                                            color:
                                                                                darkText,
                                                                            fontWeight: FontWeight
                                                                                .w600,
                                                                            fontSize:
                                                                                16,
                                                                            letterSpacing:
                                                                                0.125),
                                                                      )
                                                                    : const Text(
                                                                        ""),
                                                              ),
                                                              const SizedBox(
                                                                  width: 5),
                                                              Expanded(
                                                                child: Text(
                                                                  CurrencyFormatAkuntansi.convertToIdr(
                                                                          snapData[1][index]['saldo']
                                                                              .abs(),
                                                                          2)
                                                                      .toString(),
                                                                  style: GoogleFonts.nunito(
                                                                      color:
                                                                          darkText,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          16,
                                                                      letterSpacing:
                                                                          0.125),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                );
                                              } else {
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
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(
                              height: 32,
                              color: dividerColor.withOpacity(0.5),
                            );
                          },
                        );
                      } else {
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
    );
  }

  Future _getNeraca(kodeGereja, month) async {
    _pemasukanLancar.clear();
    _pemasukanTetap.clear();
    _pengeluaranLancar.clear();
    _pengeluaranJangkaPanjang.clear();

    var tempAktiva1 = List.empty(growable: true);
    var tempAktiva2 = List.empty(growable: true);
    var tempPasiva1 = List.empty(growable: true);
    var tempPasiva2 = List.empty(growable: true);

    var responseAktivaLancar =
        await servicesUser.getNeraca(kodeGereja, month, "pemasukan", "lancar");
    if (responseAktivaLancar[0] != 404) {
      for (var element in responseAktivaLancar[1]) {
        tempAktiva1.add(element['nama_kode_perkiraan']);
        tempAktiva1.add(element['saldo']);
        _pemasukanLancar.add(tempAktiva1.toList());
        tempAktiva1.clear();
      }
    }

    var responseAktivaTetap =
        await servicesUser.getNeraca(kodeGereja, month, "pemasukan", "tetap");
    if (responseAktivaTetap[0] != 404) {
      for (var element in responseAktivaTetap[1]) {
        tempAktiva2.add(element['nama_kode_perkiraan']);
        tempAktiva2.add(element['saldo']);
        _pemasukanTetap.add(tempAktiva2.toList());
        tempAktiva2.clear();
      }
    }

    var responsePasivaLancar = await servicesUser.getNeraca(
        kodeGereja, month, "pengeluaran", "lancar");
    if (responsePasivaLancar[0] != 404) {
      for (var element in responsePasivaLancar[1]) {
        tempPasiva1.add(element['nama_kode_perkiraan']);
        tempPasiva1.add(element['saldo']);
        _pengeluaranLancar.add(tempPasiva1.toList());
        tempPasiva1.clear();
      }
    }

    var responsePasivaJangkaPanjang = await servicesUser.getNeraca(
        kodeGereja, month, "pengeluaran", "jangka panjang");
    if (responsePasivaJangkaPanjang[0] != 404) {
      for (var element in responsePasivaJangkaPanjang[1]) {
        tempPasiva2.add(element['nama_kode_perkiraan']);
        tempPasiva2.add(element['saldo']);
        _pengeluaranJangkaPanjang.add(tempPasiva2.toList());
        tempPasiva2.clear();
      }
    }
  }

  neracaView(dw, dh) {
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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    selectMonth(context).whenComplete(() {
                      getAktivaLancar = servicesUser.getNeraca(
                          kodeGereja, month, "pemasukan", "lancar");
                      getAktivaTetap = servicesUser.getNeraca(
                          kodeGereja, month, "pemasukan", "tetap");
                      getPasivaLancar = servicesUser.getNeraca(
                          kodeGereja, month, "pengeluaran", "lancar");
                      getPasivaJangkaPanjang = servicesUser.getNeraca(
                          kodeGereja, month, "pengeluaran", "jangka panjang");
                    });
                  },
                  child: Card(
                    color: primaryColor,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          responsiveText(month, 14, FontWeight.w700, lightText),
                          const IconButton(
                            onPressed: null,
                            icon: Icon(Icons.calendar_month),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  //TODO: search btn
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: const Color(0xff960000),
                  ),
                  onPressed: () {
                    showAsign(dw, dh, 2);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: FaIcon(FontAwesomeIcons.solidFilePdf),
                  ),
                ),
              ],
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "Aktiva Lancar",
                                style: GoogleFonts.nunito(
                                    color: darkText,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18,
                                    letterSpacing: 0.125),
                              ),
                              Divider(
                                height: 16,
                                color: dividerColor,
                              ),
                              FutureBuilder(
                                future: getAktivaLancar,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    List snapData = snapshot.data! as List;
                                    if (snapData[0] != 404) {
                                      return ListView.separated(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        controller: ScrollController(),
                                        physics: const ClampingScrollPhysics(),
                                        itemCount: snapData.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    snapData[1][index]
                                                        ['nama_kode_perkiraan'],
                                                    style: GoogleFonts.nunito(
                                                        color: darkText,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16,
                                                        letterSpacing: 0.125),
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Expanded(
                                                  child: Text(
                                                    CurrencyFormatAkuntansi
                                                            .convertToIdr(
                                                                snapData[1][index]
                                                                        [
                                                                        'saldo']
                                                                    .abs(),
                                                                2)
                                                        .toString(),
                                                    style: GoogleFonts.nunito(
                                                        color: darkText,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16,
                                                        letterSpacing: 0.125),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return Divider(
                                            height: 32,
                                            color: lightText.withOpacity(0.5),
                                          );
                                        },
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
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "Pasiva Lancar",
                                style: GoogleFonts.nunito(
                                    color: darkText,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18,
                                    letterSpacing: 0.125),
                              ),
                              Divider(
                                height: 16,
                                color: dividerColor,
                              ),
                              FutureBuilder(
                                future: getPasivaLancar,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    List snapData = snapshot.data! as List;
                                    if (snapData[0] != 404) {
                                      return ListView.separated(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        controller: ScrollController(),
                                        physics: const ClampingScrollPhysics(),
                                        itemCount: snapData.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    snapData[1][index]
                                                        ['nama_kode_perkiraan'],
                                                    style: GoogleFonts.nunito(
                                                        color: darkText,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16,
                                                        letterSpacing: 0.125),
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Expanded(
                                                  child: Text(
                                                    CurrencyFormatAkuntansi
                                                            .convertToIdr(
                                                                snapData[1][index]
                                                                        [
                                                                        'saldo']
                                                                    .abs(),
                                                                2)
                                                        .toString(),
                                                    style: GoogleFonts.nunito(
                                                        color: darkText,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16,
                                                        letterSpacing: 0.125),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return Divider(
                                            height: 32,
                                            color: lightText.withOpacity(0.5),
                                          );
                                        },
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
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "Aktiva Tetap",
                                style: GoogleFonts.nunito(
                                    color: darkText,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18,
                                    letterSpacing: 0.125),
                              ),
                              Divider(
                                height: 16,
                                color: dividerColor,
                              ),
                              FutureBuilder(
                                future: getAktivaTetap,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    List snapData = snapshot.data! as List;
                                    if (snapData[0] != 404) {
                                      return ListView.separated(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        controller: ScrollController(),
                                        physics: const ClampingScrollPhysics(),
                                        itemCount: snapData.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    snapData[1][index]
                                                        ['nama_kode_perkiraan'],
                                                    style: GoogleFonts.nunito(
                                                        color: darkText,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16,
                                                        letterSpacing: 0.125),
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Expanded(
                                                  child: Text(
                                                    CurrencyFormatAkuntansi
                                                            .convertToIdr(
                                                                snapData[1][index]
                                                                        [
                                                                        'saldo']
                                                                    .abs(),
                                                                2)
                                                        .toString(),
                                                    style: GoogleFonts.nunito(
                                                        color: darkText,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16,
                                                        letterSpacing: 0.125),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return Divider(
                                            height: 32,
                                            color: lightText.withOpacity(0.5),
                                          );
                                        },
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
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "Pasiva Janga Panjang",
                                style: GoogleFonts.nunito(
                                    color: darkText,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18,
                                    letterSpacing: 0.125),
                              ),
                              Divider(
                                height: 16,
                                color: dividerColor,
                              ),
                              FutureBuilder(
                                future: getPasivaJangkaPanjang,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    List snapData = snapshot.data! as List;
                                    if (snapData[0] != 404) {
                                      return ListView.separated(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        controller: ScrollController(),
                                        physics: const ClampingScrollPhysics(),
                                        itemCount: snapData.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    snapData[1][index]
                                                        ['nama_kode_perkiraan'],
                                                    style: GoogleFonts.nunito(
                                                        color: darkText,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16,
                                                        letterSpacing: 0.125),
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Expanded(
                                                  child: Text(
                                                    CurrencyFormatAkuntansi
                                                            .convertToIdr(
                                                                snapData[1][index]
                                                                        [
                                                                        'saldo']
                                                                    .abs(),
                                                                2)
                                                        .toString(),
                                                    style: GoogleFonts.nunito(
                                                        color: darkText,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16,
                                                        letterSpacing: 0.125),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return Divider(
                                            height: 32,
                                            color: lightText.withOpacity(0.5),
                                          );
                                        },
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
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _getNeracaTable(kodeGereja) async {
    _neracaTable.clear();
    var response = await servicesUser.getTransaksi(kodeGereja);
    if (response[0] != 404) {
      for (var element in response[1]) {
        _addRowNeraca(
          element['kode_transaksi'],
          element['uraian_transaksi'],
          element['nominal'],
        );
      }
      if (mounted) {
        setState(() {});
      }
    }
  }

  void _addRowNeraca(kode, deskripsi, nominal) {
    _neracaTable.add(
      DataRow(
        cells: [
          DataCell(
            Text(
              kode.toString(),
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
              CurrencyFormatAkuntansi.convertToIdr(
                  int.parse(nominal.toString()), 2),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  neracaViewVer2(dw, dh) {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Card(
                    color: primaryColor,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          responsiveText(month, 14, FontWeight.w700, lightText),
                          const IconButton(
                            onPressed: null,
                            icon: Icon(Icons.calendar_month),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  //TODO: search btn
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: const Color(0xff960000),
                  ),
                  onPressed: () {
                    showAsign(dw, dh, 2);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: FaIcon(FontAwesomeIcons.solidFilePdf),
                  ),
                ),
              ],
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: dw > 1200
                    ? Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                DataTable(
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
                                        "KODE ANGGARAN",
                                        style: GoogleFonts.nunito(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "PENERIMAAN",
                                        style: GoogleFonts.nunito(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "JUMLAH",
                                        style: GoogleFonts.nunito(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                  rows: List.generate(
                                    _neracaTable.length,
                                    (index) {
                                      return DataRow(
                                          color: MaterialStateColor.resolveWith(
                                            (states) {
                                              return index % 2 == 1
                                                  ? primaryColor
                                                      .withOpacity(0.2)
                                                  : Colors.white;
                                            },
                                          ),
                                          cells: _neracaTable[index].cells);
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "2.500.000,00",
                                        style: GoogleFonts.nunito(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                DataTable(
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
                                        "KODE ANGGARAN",
                                        style: GoogleFonts.nunito(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "PENGELUARAN",
                                        style: GoogleFonts.nunito(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "JUMLAH",
                                        style: GoogleFonts.nunito(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                  rows: List.generate(
                                    _neracaTable.length,
                                    (index) {
                                      return DataRow(
                                          color: MaterialStateColor.resolveWith(
                                            (states) {
                                              return index % 2 == 1
                                                  ? primaryColor
                                                      .withOpacity(0.2)
                                                  : Colors.white;
                                            },
                                          ),
                                          cells: _neracaTable[index].cells);
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "2.500.000,00",
                                        style: GoogleFonts.nunito(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Column(children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  DataTable(
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
                                          "KODE ANGGARAN",
                                          style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          "PENERIMAAN",
                                          style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          "JUMLAH",
                                          style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                    rows: List.generate(
                                      _neracaTable.length,
                                      (index) {
                                        return DataRow(
                                            color:
                                                MaterialStateColor.resolveWith(
                                              (states) {
                                                return index % 2 == 1
                                                    ? primaryColor
                                                        .withOpacity(0.2)
                                                    : Colors.white;
                                              },
                                            ),
                                            cells: _neracaTable[index].cells);
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 16),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "2.500.000,00",
                                          style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  DataTable(
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
                                          "KODE ANGGARAN",
                                          style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          "PENGELUARAN",
                                          style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          "JUMLAH",
                                          style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                    rows: List.generate(
                                      _neracaTable.length,
                                      (index) {
                                        return DataRow(
                                            color:
                                                MaterialStateColor.resolveWith(
                                              (states) {
                                                return index % 2 == 1
                                                    ? primaryColor
                                                        .withOpacity(0.2)
                                                    : Colors.white;
                                              },
                                            ),
                                            cells: _neracaTable[index].cells);
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 16),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "2.500.000,00",
                                          style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ]),
              ),
            ),
          ],
        ),
      ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        widget.controllerPageLihatLaporan.animateToPage(0,
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.ease);
                      },
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    responsiveText(
                        "Laporan Keuangan", 26, FontWeight.w900, darkText),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    widget.controllerPageLihatSaldoAwal.animateToPage(1,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.ease);
                  },
                  child: Text(
                    "Saldo Awal",
                    style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                ),
              ],
            ),
            const Divider(
              height: 56,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  jurnalUmumView(deviceWidth, deviceHeight),
                  bukuBesarView(deviceWidth, deviceHeight),
                  neracaView(deviceWidth, deviceHeight),
                ],
              ),
            ),
            TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: darkText,
              indicatorColor: buttonColor,
              labelPadding: const EdgeInsets.symmetric(horizontal: 16),
              labelStyle: GoogleFonts.nunito(
                  color: lightText,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  letterSpacing: 0.125),
              tabs: const <Widget>[
                Tab(
                  text: "Jurnal",
                ),
                Tab(
                  text: "Buku Besar",
                ),
                Tab(
                  text: "Neraca",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SignaturePreviewPage extends StatelessWidget {
  final Uint8List signature;

  const SignaturePreviewPage({
    Key? key,
    required this.signature,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: const CloseButton(),
          title: const Text('Store Signature'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.done),
              onPressed: () {},
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Center(
          child: Image.memory(signature, width: double.infinity),
        ),
      );
}

class AdminLihatSaldoAwal extends StatefulWidget {
  final PageController controllerPageLihatSaldoAwal;
  const AdminLihatSaldoAwal(
      {super.key, required this.controllerPageLihatSaldoAwal});

  @override
  State<AdminLihatSaldoAwal> createState() => _AdminLihatSaldoAwalState();
}

class _AdminLihatSaldoAwalState extends State<AdminLihatSaldoAwal> {
  ServicesUser servicesUser = ServicesUser();

  final _saldoController = TextEditingController();
  final _controllerDropdownFilter = TextEditingController();

  String kodeMasterSaldoAwal = "";
  String kodePerkiraanSaldoAwal = "";
  @override
  void initState() {
    // TODO: implement initState
    _getSaldoAwal(kodeGereja);
    _getMasterKode(kodeGereja);
    kodeMasterSaldoAwal = "";
    kodePerkiraanSaldoAwal = "";
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _saldoController.dispose();
    _controllerDropdownFilter.dispose();
    super.dispose();
  }

  Future _getSaldoAwal(kodeGereja) async {
    _saldoAwal.clear();
    var response = await servicesUser.getSaldoAwal(kodeGereja);
    if (response[0] != 404) {
      for (var element in response[1]) {
        _addRowSaldoAwal(
          element['header_kode_perkiraan'],
          element['kode_perkiraan'],
          element['saldo_awal'],
        );
      }
      if (mounted) {
        setState(() {});
      }
    }
  }

  void _addRowSaldoAwal(kodeHeader, kodePerkiraan, saldo) {
    _saldoAwal.add(
      DataRow(
        cells: [
          DataCell(
            Text(
              kodeHeader.toString(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          DataCell(
            Text(
              kodePerkiraan.toString(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          DataCell(
            Text(
              saldo.toString(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  responsiveTextField(deviceWidth, deviceHeight, controllerText, mLength) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        maxLength: mLength,
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
    );
  }

  Future updateSaldoAwal(
      kodeGereja, headerKodePerkiraan, kodePerkiraan, saldo, context) async {
    var response = await servicesUser.updateSaldoAwal(
        kodeGereja, headerKodePerkiraan, kodePerkiraan, saldo);

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

  Future _getMasterKode(kodeGereja) async {
    _kodeMasterSA.clear();

    var response = await servicesUser.getMasterKode(kodeGereja);
    if (response[0] != 404) {
      for (var element in response[1]) {
        debugPrint(element.toString());
        _kodeMasterSA.add(
            "${element['header_kode_perkiraan']} - ${element['nama_header']}");
      }
    }
  }

  Future _getKodePerkiraan(kodeGereja, headerKodePerkiraan) async {
    _kodePerkiraanSA.clear();

    var response =
        await servicesUser.getKodePerkiraan(kodeGereja, headerKodePerkiraan);
    if (response[0] != 404) {
      for (var element in response[1]) {
        debugPrint(element.toString());
        _kodePerkiraanSA.add(
            "${element['kode_perkiraan']} - ${element['nama_kode_perkiraan']}");
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

  _buatKodeGabungan(val) {
    var temp = kodeGereja + _splitString(val);
    return temp;
  }

  _showUpdateSaldoAwalDialog(dw, dh) {
    showDialog(
      barrierDismissible: false,
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
                    width: dw < 800 ? dw * 0.8 : dw * 0.4,
                    child: Column(
                      children: [
                        Container(
                          width: dw < 800 ? dw * 0.8 : dw * 0.4,
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
                              responsiveText("Update Saldo Awal", 26,
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
                                  Card(
                                    color: primaryColor,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: DropdownSearch<dynamic>(
                                      popupProps: PopupProps.menu(
                                        showSearchBox: true,
                                        searchFieldProps: TextFieldProps(
                                          decoration: InputDecoration(
                                            border: const OutlineInputBorder(),
                                            hintText: "Kode Master",
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                _controllerDropdownFilter
                                                    .clear();
                                              },
                                              icon: Icon(
                                                Icons.clear,
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                          ),
                                          controller: _controllerDropdownFilter,
                                        ),
                                      ),
                                      items: _kodeMasterSA,
                                      onChanged: (val) {
                                        debugPrint(val);
                                        debugPrint(_splitString(val));
                                        kodeMasterSaldoAwal = _splitString(val);
                                        debugPrint(_buatKodeGabungan(val));

                                        _getKodePerkiraan(
                                                kodeGereja, kodeMasterSaldoAwal)
                                            .whenComplete(
                                                () => setState(() {}));
                                      },
                                      selectedItem: "pilih Kode Master",
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Visibility(
                                    visible: kodeMasterSaldoAwal != ""
                                        ? true
                                        : false,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        responsiveText("Kode Perkiraan", 16,
                                            FontWeight.w700, darkText),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Card(
                                          color: primaryColor,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: DropdownSearch<dynamic>(
                                            popupProps: PopupProps.menu(
                                              showSearchBox: true,
                                              searchFieldProps: TextFieldProps(
                                                decoration: InputDecoration(
                                                  border:
                                                      const OutlineInputBorder(),
                                                  hintText: "Kode Perkiraan",
                                                  suffixIcon: IconButton(
                                                    onPressed: () {
                                                      _controllerDropdownFilter
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
                                                    _controllerDropdownFilter,
                                              ),
                                            ),
                                            items: _kodePerkiraanSA,
                                            onChanged: (val) {
                                              debugPrint(val);
                                              debugPrint(_splitString(val));
                                              kodePerkiraanSaldoAwal =
                                                  _splitString(val);

                                              debugPrint(
                                                  _buatKodeGabungan(val));
                                              setState(() {});
                                            },
                                            selectedItem:
                                                "pilih Kode Perkiraan",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  responsiveText(
                                      "Saldo", 16, FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  responsiveTextField(
                                      dw, dh, _saldoController, null),
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
                                    kodeMasterSaldoAwal = "";
                                    kodePerkiraanSaldoAwal = "";
                                    _saldoController.clear();
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
                                    updateSaldoAwal(
                                            kodeGereja,
                                            kodeMasterSaldoAwal,
                                            kodePerkiraanSaldoAwal,
                                            _saldoController.text,
                                            context)
                                        .then((value) {
                                      kodeMasterSaldoAwal = "";
                                      kodePerkiraanSaldoAwal = "";
                                      _saldoController.clear();
                                      Navigator.pop(context);
                                    });
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
    ).then((value) {
      if (mounted) {
        _getSaldoAwal(kodeGereja).whenComplete(() => setState(() {}));
      }
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        widget.controllerPageLihatSaldoAwal.animateToPage(0,
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.ease);
                      },
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    responsiveText("Saldo Awal", 26, FontWeight.w900, darkText),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    _showUpdateSaldoAwalDialog(deviceWidth, deviceHeight);
                  },
                  child: Text(
                    "Update Saldo Awal",
                    style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                ),
              ],
            ),
            const Divider(
              height: 56,
            ),
            Expanded(
              child: Row(
                children: [
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
                                "Kode Master",
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
                                "Saldo",
                                style: GoogleFonts.nunito(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                          rows: List.generate(
                            _saldoAwal.length,
                            (index) {
                              return DataRow(
                                  color: MaterialStateColor.resolveWith(
                                    (states) {
                                      return index % 2 == 1
                                          ? Colors.white
                                          : primaryColor.withOpacity(0.2);
                                    },
                                  ),
                                  cells: _saldoAwal[index].cells);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminLaporanPreviewPDF extends StatefulWidget {
  final int tipe;
  final String month;
  final Uint8List signature;
  final String nama;
  const AdminLaporanPreviewPDF(
      {super.key,
      required this.tipe,
      required this.month,
      required this.signature,
      required this.nama});

  @override
  State<AdminLaporanPreviewPDF> createState() => _AdminLaporanPreviewPDFState();
}

class _AdminLaporanPreviewPDFState extends State<AdminLaporanPreviewPDF> {
  ServicesUser servicesUser = ServicesUser();

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

  splitMonth(String val) {
    var split = val.indexOf("-");
    var month = val.substring(0, split);
    var year = val.substring(split + 1, val.length);
    return [month, year];
  }

  getMonth(String val) {
    var dt = splitMonth(val);
    if (dt[0] == "01") {
      return "Januari ${dt[1]}";
    } else if (dt[0] == "02") {
      return "Febriari ${dt[1]}";
    } else if (dt[0] == "03") {
      return "Maret ${dt[1]}";
    } else if (dt[0] == "04") {
      return "April ${dt[1]}";
    } else if (dt[0] == "05") {
      return "Mei ${dt[1]}";
    } else if (dt[0] == "06") {
      return "Juni ${dt[1]}";
    } else if (dt[0] == "07") {
      return "Juli ${dt[1]}";
    } else if (dt[0] == "08") {
      return "Agustus ${dt[1]}";
    } else if (dt[0] == "09") {
      return "September ${dt[1]}";
    } else if (dt[0] == "10") {
      return "Oktober ${dt[1]}";
    } else if (dt[0] == "11") {
      return "November ${dt[1]}";
    } else if (dt[0] == "12") {
      return "Desember ${dt[1]}";
    }
  }

  Future<Uint8List> _generateNeraca(PdfPageFormat format) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final headingFont = await PdfGoogleFonts.nunitoBold();
    final boldHeadingFont = await PdfGoogleFonts.nunitoExtraBold();
    final regularFont = await PdfGoogleFonts.nunitoRegular();

    final image = pw.MemoryImage(widget.signature);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: format.portrait,
        build: (context) {
          return [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  "LAPORAN KEUANGAN GEREJA $kodeGereja",
                  style: pw.TextStyle(
                    font: boldHeadingFont,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  "NERACA SALDO",
                  style: pw.TextStyle(
                    font: boldHeadingFont,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  getMonth(widget.month),
                  style: pw.TextStyle(
                    font: boldHeadingFont,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            pw.Divider(
              height: 56,
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Column(
                  children: [
                    pw.Text(
                      "Aktiva Lancar",
                      style: pw.TextStyle(
                        font: headingFont,
                        fontSize: 14,
                      ),
                    ),
                    pw.SizedBox(
                      height: 10,
                    ),
                    pw.Table(
                      border: pw.TableBorder.all(
                        style: pw.BorderStyle.solid,
                        width: 1,
                      ),
                      columnWidths: {
                        0: const pw.FixedColumnWidth(110),
                        1: const pw.FixedColumnWidth(110),
                      },
                      children: [
                        //TODO: Header Table
                        pw.TableRow(
                          children: [
                            pw.Column(
                              children: [
                                pw.Text(
                                  "Kode",
                                  style: pw.TextStyle(
                                    font: headingFont,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            pw.Column(
                              children: [
                                pw.Text(
                                  "Saldo",
                                  style: pw.TextStyle(
                                    font: headingFont,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        //TODO: Data Pemasukan

                        for (int i = 0; i < _pemasukanLancar.length; i++)
                          pw.TableRow(
                            children: [
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                children: [
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: pw.Text(
                                      "${_pemasukanLancar[i][0]}",
                                      style: pw.TextStyle(
                                        font: regularFont,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                children: [
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: pw.Text(
                                      CurrencyFormatAkuntansi.convertToIdr(
                                              _pemasukanLancar[i][1].abs(), 2)
                                          .toString(),
                                      style: pw.TextStyle(
                                        font: regularFont,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
                pw.Column(
                  children: [
                    pw.Text(
                      "Pasiva Lancar",
                      style: pw.TextStyle(
                        font: headingFont,
                        fontSize: 14,
                      ),
                    ),
                    pw.SizedBox(
                      height: 10,
                    ),
                    pw.Table(
                      border: pw.TableBorder.all(
                        style: pw.BorderStyle.solid,
                        width: 1,
                      ),
                      columnWidths: {
                        0: const pw.FixedColumnWidth(110),
                        1: const pw.FixedColumnWidth(110),
                      },
                      children: [
                        //TODO: Header Table
                        pw.TableRow(
                          children: [
                            pw.Column(
                              children: [
                                pw.Text(
                                  "Kode",
                                  style: pw.TextStyle(
                                    font: headingFont,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            pw.Column(
                              children: [
                                pw.Text(
                                  "Saldo",
                                  style: pw.TextStyle(
                                    font: headingFont,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        //TODO: Data Pemasukan

                        for (int i = 0; i < _pengeluaranLancar.length; i++)
                          pw.TableRow(
                            children: [
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                children: [
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: pw.Text(
                                      "${_pengeluaranLancar[i][0]}",
                                      style: pw.TextStyle(
                                        font: regularFont,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                children: [
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: pw.Text(
                                      CurrencyFormatAkuntansi.convertToIdr(
                                              _pengeluaranLancar[i][1].abs(), 2)
                                          .toString(),
                                      style: pw.TextStyle(
                                        font: regularFont,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(
              height: 56,
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Column(
                  children: [
                    pw.Text(
                      "Aktiva Tetap",
                      style: pw.TextStyle(
                        font: headingFont,
                        fontSize: 14,
                      ),
                    ),
                    pw.SizedBox(
                      height: 10,
                    ),
                    pw.Table(
                      border: pw.TableBorder.all(
                        style: pw.BorderStyle.solid,
                        width: 1,
                      ),
                      columnWidths: {
                        0: const pw.FixedColumnWidth(110),
                        1: const pw.FixedColumnWidth(110),
                      },
                      children: [
                        //TODO: Header Table
                        pw.TableRow(
                          children: [
                            pw.Column(
                              children: [
                                pw.Text(
                                  "Kode",
                                  style: pw.TextStyle(
                                    font: headingFont,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            pw.Column(
                              children: [
                                pw.Text(
                                  "Saldo",
                                  style: pw.TextStyle(
                                    font: headingFont,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        //TODO: Data Pemasukan

                        for (int i = 0; i < _pemasukanTetap.length; i++)
                          pw.TableRow(
                            children: [
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                children: [
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: pw.Text(
                                      "${_pemasukanTetap[i][0]}",
                                      style: pw.TextStyle(
                                        font: regularFont,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                children: [
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: pw.Text(
                                      CurrencyFormatAkuntansi.convertToIdr(
                                              _pemasukanTetap[i][1].abs(), 2)
                                          .toString(),
                                      style: pw.TextStyle(
                                        font: regularFont,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
                pw.Column(
                  children: [
                    pw.Text(
                      "Pasiva Jangka Panjang",
                      style: pw.TextStyle(
                        font: headingFont,
                        fontSize: 14,
                      ),
                    ),
                    pw.SizedBox(
                      height: 10,
                    ),
                    pw.Table(
                      border: pw.TableBorder.all(
                        style: pw.BorderStyle.solid,
                        width: 1,
                      ),
                      columnWidths: {
                        0: const pw.FixedColumnWidth(110),
                        1: const pw.FixedColumnWidth(110),
                      },
                      children: [
                        //TODO: Header Table
                        pw.TableRow(
                          children: [
                            pw.Column(
                              children: [
                                pw.Text(
                                  "Kode",
                                  style: pw.TextStyle(
                                    font: headingFont,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            pw.Column(
                              children: [
                                pw.Text(
                                  "Saldo",
                                  style: pw.TextStyle(
                                    font: headingFont,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        //TODO: Data Pemasukan

                        for (int i = 0;
                            i < _pengeluaranJangkaPanjang.length;
                            i++)
                          pw.TableRow(
                            children: [
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                children: [
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: pw.Text(
                                      "${_pengeluaranJangkaPanjang[i][0]}",
                                      style: pw.TextStyle(
                                        font: regularFont,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                children: [
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: pw.Text(
                                      CurrencyFormatAkuntansi.convertToIdr(
                                              _pengeluaranJangkaPanjang[i][1]
                                                  .abs(),
                                              2)
                                          .toString(),
                                      style: pw.TextStyle(
                                        font: regularFont,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(
              height: 56,
            ),
            pw.Container(
              child: pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Container(),
                  ),
                  pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text("Penanggung Jawab, "),
                        ],
                      ),
                      pw.SizedBox(
                        height: 5,
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.SizedBox(
                            width: 200,
                            height: 200,
                            child: pw.Image(image),
                          ),
                        ],
                      ),
                      pw.SizedBox(
                        height: 5,
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text(widget.nama),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  Future<Uint8List> _generateBukuBesar(PdfPageFormat format) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final headingFont = await PdfGoogleFonts.nunitoBold();
    final boldHeadingFont = await PdfGoogleFonts.nunitoExtraBold();
    final regularFont = await PdfGoogleFonts.nunitoRegular();

    final image = pw.MemoryImage(widget.signature);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: format.portrait,
        build: (context) {
          return [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  "LAPORAN KEUANGAN GEREJA $kodeGereja",
                  style: pw.TextStyle(
                    font: boldHeadingFont,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  "BUKU BESAR",
                  style: pw.TextStyle(
                    font: boldHeadingFont,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  getMonth(widget.month),
                  style: pw.TextStyle(
                    font: boldHeadingFont,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            pw.Divider(
              height: 56,
            ),
            pw.ListView.separated(
                itemBuilder: (context, index) {
                  return pw.Column(
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        children: [
                          pw.Text(
                            "${_dataBukuBesar[index][0][5]}",
                            style: pw.TextStyle(
                              font: boldHeadingFont,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      pw.Table(
                        border: pw.TableBorder.all(
                          style: pw.BorderStyle.solid,
                          width: 1,
                        ),
                        columnWidths: {
                          0: const pw.FixedColumnWidth(80),
                          1: const pw.FlexColumnWidth(3),
                          2: const pw.FractionColumnWidth(.2),
                          3: const pw.FractionColumnWidth(.2),
                          4: const pw.FractionColumnWidth(.2),
                        },
                        children: [
                          //TODO: Header Table
                          pw.TableRow(
                            children: [
                              pw.Column(
                                children: [
                                  pw.Text(
                                    "Tanggal",
                                    style: pw.TextStyle(
                                      font: headingFont,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              pw.Column(
                                children: [
                                  pw.Text(
                                    "Uraian",
                                    style: pw.TextStyle(
                                      font: headingFont,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              pw.Column(
                                children: [
                                  pw.Text(
                                    "Debit",
                                    style: pw.TextStyle(
                                      font: headingFont,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              pw.Column(
                                children: [
                                  pw.Text(
                                    "Kredit",
                                    style: pw.TextStyle(
                                      font: headingFont,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              pw.Column(
                                children: [
                                  pw.Text(
                                    "Saldo",
                                    style: pw.TextStyle(
                                      font: headingFont,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          //TODO: Data Pemasukan

                          for (int i = 0; i < _dataBukuBesar[index].length; i++)
                            pw.TableRow(
                              children: [
                                pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: pw.Text(
                                        "${_dataBukuBesar[index][i][0]}",
                                        style: pw.TextStyle(
                                          font: regularFont,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: pw.Text(
                                        "${_dataBukuBesar[index][i][1]}",
                                        style: pw.TextStyle(
                                          font: regularFont,
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    _dataBukuBesar[index][i][2] == "pemasukan"
                                        ? pw.Padding(
                                            padding:
                                                const pw.EdgeInsets.symmetric(
                                                    horizontal: 5),
                                            child: pw.Text(
                                              CurrencyFormatAkuntansi
                                                      .convertToIdr(
                                                          _dataBukuBesar[index]
                                                                  [i][3]
                                                              .abs(),
                                                          2)
                                                  .toString(),
                                              style: pw.TextStyle(
                                                font: regularFont,
                                                fontSize: 12,
                                              ),
                                            ),
                                          )
                                        : pw.Padding(
                                            padding:
                                                const pw.EdgeInsets.symmetric(
                                                    horizontal: 5),
                                            child: pw.Text(
                                              "",
                                              style: pw.TextStyle(
                                                font: regularFont,
                                                fontSize: 12,
                                              ),
                                            ),
                                          )
                                  ],
                                ),
                                pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    _dataBukuBesar[index][i][2] == "pengeluaran"
                                        ? pw.Padding(
                                            padding:
                                                const pw.EdgeInsets.symmetric(
                                                    horizontal: 5),
                                            child: pw.Text(
                                              CurrencyFormatAkuntansi
                                                      .convertToIdr(
                                                          _dataBukuBesar[index]
                                                                  [i][3]
                                                              .abs(),
                                                          2)
                                                  .toString(),
                                              style: pw.TextStyle(
                                                font: regularFont,
                                                fontSize: 12,
                                              ),
                                            ),
                                          )
                                        : pw.Padding(
                                            padding:
                                                const pw.EdgeInsets.symmetric(
                                                    horizontal: 5),
                                            child: pw.Text(
                                              "",
                                              style: pw.TextStyle(
                                                font: regularFont,
                                                fontSize: 12,
                                              ),
                                            ),
                                          )
                                  ],
                                ),
                                pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: pw.Text(
                                        CurrencyFormatAkuntansi.convertToIdr(
                                                _dataBukuBesar[index][i][4]
                                                    .abs(),
                                                2)
                                            .toString(),
                                        style: pw.TextStyle(
                                          font: regularFont,
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return pw.Divider(height: 56, color: PdfColors.grey200);
                },
                itemCount: _dataBukuBesar.length),
            pw.SizedBox(
              height: 56,
            ),
            pw.Container(
              child: pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Container(),
                  ),
                  pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text("Penanggung Jawab, "),
                        ],
                      ),
                      pw.SizedBox(
                        height: 5,
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.SizedBox(
                            width: 200,
                            height: 200,
                            child: pw.Image(image),
                          ),
                        ],
                      ),
                      pw.SizedBox(
                        height: 5,
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text(widget.nama),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  Future<Uint8List> _generateJurnal(PdfPageFormat format) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final headingFont = await PdfGoogleFonts.nunitoBold();
    final boldHeadingFont = await PdfGoogleFonts.nunitoExtraBold();
    final regularFont = await PdfGoogleFonts.nunitoRegular();

    final image = pw.MemoryImage(widget.signature);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: format.portrait,
        build: (context) {
          return [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  "LAPORAN KEUANGAN GEREJA $kodeGereja",
                  style: pw.TextStyle(
                    font: boldHeadingFont,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  "JURNAL",
                  style: pw.TextStyle(
                    font: boldHeadingFont,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  getMonth(widget.month),
                  style: pw.TextStyle(
                    font: boldHeadingFont,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            pw.Divider(
              height: 56,
            ),
            pw.ListView.separated(
                itemBuilder: (context, index) {
                  return pw.Column(
                    children: [
                      pw.Table(
                        border: pw.TableBorder.all(
                          style: pw.BorderStyle.solid,
                          width: 1,
                        ),
                        columnWidths: {
                          0: const pw.FixedColumnWidth(80),
                          1: const pw.FlexColumnWidth(.3),
                          2: const pw.FlexColumnWidth(.3),
                          3: const pw.FractionColumnWidth(.2),
                          4: const pw.FractionColumnWidth(.2),
                        },
                        children: [
                          //TODO: Header Table
                          pw.TableRow(
                            children: [
                              pw.Column(
                                children: [
                                  pw.Text(
                                    "Tanggal",
                                    style: pw.TextStyle(
                                      font: headingFont,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              pw.Column(
                                children: [
                                  pw.Text(
                                    "Keterangan",
                                    style: pw.TextStyle(
                                      font: headingFont,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              pw.Column(
                                children: [
                                  pw.Text(
                                    "Ref",
                                    style: pw.TextStyle(
                                      font: headingFont,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              pw.Column(
                                children: [
                                  pw.Text(
                                    "Debit",
                                    style: pw.TextStyle(
                                      font: headingFont,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              pw.Column(
                                children: [
                                  pw.Text(
                                    "Kredit",
                                    style: pw.TextStyle(
                                      font: headingFont,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          //TODO: Data Pemasukan

                          for (int i = 0; i < _dataJurnal[index].length; i++)
                            pw.TableRow(
                              children: [
                                pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: pw.Text(
                                        i == 0
                                            ? "${_dataJurnal[index][i][0]}"
                                            : "",
                                        style: pw.TextStyle(
                                          font: regularFont,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: pw.Text(
                                        "${_dataJurnal[index][i][1]}",
                                        style: pw.TextStyle(
                                          font: regularFont,
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: pw.Text(
                                        "${_dataJurnal[index][i][2]}",
                                        style: pw.TextStyle(
                                          font: regularFont,
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    _dataJurnal[index][i][3] == "pemasukan"
                                        ? pw.Padding(
                                            padding:
                                                const pw.EdgeInsets.symmetric(
                                                    horizontal: 5),
                                            child: pw.Text(
                                              CurrencyFormatAkuntansi
                                                      .convertToIdr(
                                                          _dataJurnal[index][i]
                                                                  [4]
                                                              .abs(),
                                                          2)
                                                  .toString(),
                                              style: pw.TextStyle(
                                                font: regularFont,
                                                fontSize: 12,
                                              ),
                                            ),
                                          )
                                        : pw.Padding(
                                            padding:
                                                const pw.EdgeInsets.symmetric(
                                                    horizontal: 5),
                                            child: pw.Text(
                                              "",
                                              style: pw.TextStyle(
                                                font: regularFont,
                                                fontSize: 12,
                                              ),
                                            ),
                                          )
                                  ],
                                ),
                                pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    _dataJurnal[index][i][3] == "pengeluaran"
                                        ? pw.Padding(
                                            padding:
                                                const pw.EdgeInsets.symmetric(
                                                    horizontal: 5),
                                            child: pw.Text(
                                              CurrencyFormatAkuntansi
                                                      .convertToIdr(
                                                          _dataJurnal[index][i]
                                                                  [4]
                                                              .abs(),
                                                          2)
                                                  .toString(),
                                              style: pw.TextStyle(
                                                font: regularFont,
                                                fontSize: 12,
                                              ),
                                            ),
                                          )
                                        : pw.Padding(
                                            padding:
                                                const pw.EdgeInsets.symmetric(
                                                    horizontal: 5),
                                            child: pw.Text(
                                              "",
                                              style: pw.TextStyle(
                                                font: regularFont,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return pw.Divider(height: 56, color: PdfColors.grey200);
                },
                itemCount: _dataJurnal.length),
            pw.SizedBox(
              height: 56,
            ),
            pw.Container(
              child: pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Container(),
                  ),
                  pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text("Penanggung Jawab, "),
                        ],
                      ),
                      pw.SizedBox(
                        height: 10,
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.SizedBox(
                            width: 200,
                            height: 200,
                            child: pw.Image(image),
                          ),
                        ],
                      ),
                      pw.SizedBox(
                        height: 10,
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text(widget.nama),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  checkTipe(tipe, format) {
    if (tipe == 0) {
      return _generateJurnal(format);
    } else if (tipe == 1) {
      return _generateBukuBesar(format);
    } else {
      return _generateNeraca(format);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: PdfPreview(
        initialPageFormat: PdfPageFormat.a4,
        allowPrinting: false,
        pdfFileName: "Laporan_Keuangan_Gereja.pdf",
        dynamicLayout: false,
        build: (format) => checkTipe(widget.tipe, format),
      ),
    );
  }
}
