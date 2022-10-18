// ignore_for_file: todo

import 'dart:typed_data';

import 'package:aplikasi_keuangan_gereja/globals.dart';
import 'package:aplikasi_keuangan_gereja/services/apiservices.dart';
import 'package:aplikasi_keuangan_gereja/widgets/string_extension.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../../themes/colors.dart';
import '../../../widgets/loadingindicator.dart';
import '../../../widgets/responsivetext.dart';
import 'package:pdf/widgets.dart' as pw;

final List _kodeMaster = List.empty(growable: true);
final List _kodePerkiraan = List.empty(growable: true);
final List _kodeTransaksiAdded = List.empty(growable: true);
final List _kodeTransaksi = List.empty(growable: true);
final List _kodeRefKegiatan = List.empty(growable: true);
final List _kodePerkiraanSingleKegiatan = List.empty(growable: true);

final List _dataNeraca = List.empty(growable: true);
final List _dataBukuBesar = List.empty(growable: true);
final List _dataJurnal = List.empty(growable: true);

final List<DataRow> _saldoAwal = List.empty(growable: true);
final List<DataRow> _rowList = List.empty(growable: true);

int _totalPemasukan = 0;
int _totalPengeluaran = 0;
int _totalSaldo = 0;
int _akunSaldo = 0;

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
    _akunSaldo = 0;
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
    _akunSaldo = 0;

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
    _getKodePerkiraan(kodeGereja, "", "");
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

  Future _getKodePerkiraan(kodeGereja, kodeKegiatan, kodeTransaksi) async {
    _kodePerkiraan.clear();

    var response = await servicesUser.getKodePerkiraanSingleKegiatan(
        kodeGereja, kodeKegiatan, kodeTransaksi);

    if (response[0] != 404) {
      for (var element in response[1]) {
        debugPrint(element.toString());
        _kodePerkiraan.add(
            "${element['kode_perkiraan']} - ${element['nama_kode_perkiraan']}");
      }
    } else {
      throw "Gagal Mengambil Data";
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
    } else {
      throw "Gagal Mengambil Data";
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
            .add("${element['kode_kegiatan']} - ${element['nama_kegiatan']}");
      }
    } else {
      throw "Gagal Mengambil Data";
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
                  primary: navButtonPrimary, // button text color
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
                  primary: navButtonPrimary, // button text color
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
                  primary: navButtonPrimary, // button text color
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
                  primary: navButtonPrimary, // button text color
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
            responsiveText(CurrencyFormat.convertToIdr(nominal, 2), 16,
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

  Future _getSaldoAkun(kodeGereja, kodePerkiraan) async {
    var response = await servicesUser.getSaldoAkun(kodeGereja, kodePerkiraan);
    _akunSaldo = 0;
    if (response[0] != 404) {
      _akunSaldo = response[1]['nominal'];
      debugPrint(response[1].toString());
    } else {
      _akunSaldo = 0;
    }
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
                responsiveText("Transaksi", 32, FontWeight.w800, darkText),
                Row(
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
                          const SizedBox(
                            width: 16,
                          ),
                          SizedBox(
                            width: 300,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ToggleSwitch(
                                  initialLabelIndex: _indexFilterTanggal,
                                  totalSwitches: 4,
                                  labels: const [
                                    'Semua',
                                    'Hari',
                                    'Minggu',
                                    'Bulan'
                                  ],
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
                                    debugPrint(
                                        'switched to: $_indexFilterTanggal');
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
                                responsiveText("Filter Transaksi", 14,
                                    FontWeight.w700, darkText),
                                Card(
                                  color: primaryColor,
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
                                              _controllerDropdownFilter.clear();
                                            },
                                            icon: Icon(
                                              Icons.clear,
                                              color:
                                                  Colors.black.withOpacity(0.5),
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
                                      _queryTransaksiKode(kodeGereja,
                                              kodeTransaksiFilter, "")
                                          .whenComplete(() => setState(() {}));
                                      debugPrint(_buatKodeGabungan(val));
                                    },
                                    selectedItem: "pilih Transaksi",
                                  ),
                                ),
                                responsiveText("Filter Kode Perkiraan", 14,
                                    FontWeight.w700, darkText),
                                Card(
                                  color: primaryColor,
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
                                              _controllerDropdownFilter.clear();
                                            },
                                            icon: Icon(
                                              Icons.clear,
                                              color:
                                                  Colors.black.withOpacity(0.5),
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
                                      _queryTransaksiKode(kodeGereja, "",
                                              kodePerkiraanFilter)
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
                                    _queryTransaksiKode(
                                            kodeGereja,
                                            kodeTransaksiFilter,
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
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  height: 56,
                                ),
                                _cardInfo(
                                  "Pemasukan",
                                  _totalPemasukan,
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                _cardInfo(
                                  "Pengeluaran",
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
                                  height: 25,
                                ),
                                const SizedBox(
                                  height: 25,
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
            ),
          ],
        ),
      ),
    );
  }
}

enum RadioJenisTransaksi { pemasukan, pengeluaran }

enum RadioJenisMaster { pemasukan, pengeluaran }

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
  String _status = "";
  String _statusMaster = "";
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  responsiveText("Kode Perkiraan", 16,
                                      FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  responsiveTextField(
                                      dw, dh, _controllerKodePerkiraan, null),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  responsiveText("Nama Kode Perkiraan", 16,
                                      FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  responsiveTextField(dw, dh,
                                      _controllerNamaKodePerkiraan, null),
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
                                    _controllerKodePerkiraan.clear();
                                    _controllerNamaKodePerkiraan.clear();
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
                                    postKodePerkiraan(
                                            kodeGereja,
                                            _controllerNamaKodePerkiraan.text
                                                .capitalize(),
                                            _controllerKodePerkiraan.text
                                                .toUpperCase(),
                                            headerKodePerkiraan,
                                            context)
                                        .then(
                                      (value) {
                                        postSaldoAwal(
                                                kodeGereja,
                                                headerKodePerkiraan,
                                                _controllerKodePerkiraan.text
                                                    .toUpperCase(),
                                                0,
                                                context)
                                            .then((value) {
                                          _controllerKodePerkiraan.clear();
                                          _controllerNamaKodePerkiraan.clear();
                                          Navigator.pop(context);
                                        });
                                      },
                                    );
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  responsiveText("Kode Master", 16,
                                      FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  responsiveTextField(
                                      dw, dh, _controllerMasterKode, null),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  responsiveText("Nama Kode Master", 16,
                                      FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  responsiveTextField(
                                      dw, dh, _controllerNamaMasterKode, null),
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
                                              radio = val as RadioJenisMaster?;
                                              if (mounted) {
                                                setState(() {});
                                                _statusMaster = "pemasukan";
                                              }
                                            },
                                          ),
                                          responsiveText("Pemasukan", 14,
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
                                            value: RadioJenisMaster.pengeluaran,
                                            groupValue: radio,
                                            activeColor: primaryColorVariant,
                                            onChanged: (val) {
                                              radio = val as RadioJenisMaster?;
                                              _statusMaster = "pengeluaran";

                                              if (mounted) {
                                                setState(() {});
                                              }
                                            },
                                          ),
                                          responsiveText("Pengeluaran", 14,
                                              FontWeight.w700, darkText),
                                        ],
                                      )
                                    ],
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
                                    _controllerMasterKode.clear();
                                    _controllerNamaMasterKode.clear();
                                    _statusMaster = "";
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
                                    postMasterKode(
                                            kodeGereja,
                                            _controllerNamaMasterKode.text
                                                .capitalize(),
                                            _controllerMasterKode.text
                                                .toUpperCase(),
                                            _statusMaster,
                                            context)
                                        .then(
                                      (value) {
                                        _controllerKodePerkiraan.clear();
                                        _controllerNamaKodePerkiraan.clear();
                                        _statusMaster = "";
                                        Navigator.pop(context);
                                      },
                                    );
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
    RadioJenisTransaksi? radio;
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  responsiveText("Kode Transaksi", 16,
                                      FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  responsiveTextField(
                                      dw, dh, _controllerKodeTransaksi, null),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  responsiveText("Nama Kode Transaksi", 16,
                                      FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  responsiveTextField(dw, dh,
                                      _controllerNamaKodeTransaksi, null),
                                  const SizedBox(
                                    height: 10,
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
                                            value:
                                                RadioJenisTransaksi.pemasukan,
                                            groupValue: radio,
                                            activeColor: primaryColorVariant,
                                            onChanged: (val) {
                                              radio =
                                                  val as RadioJenisTransaksi?;
                                              if (mounted) {
                                                setState(() {});
                                                _status = "pemasukan";
                                              }
                                            },
                                          ),
                                          responsiveText("Pemasukan", 14,
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
                                                RadioJenisTransaksi.pengeluaran,
                                            groupValue: radio,
                                            activeColor: primaryColorVariant,
                                            onChanged: (val) {
                                              radio =
                                                  val as RadioJenisTransaksi?;
                                              _status = "pengeluaran";

                                              if (mounted) {
                                                setState(() {});
                                              }
                                            },
                                          ),
                                          responsiveText("Pengeluaran", 14,
                                              FontWeight.w700, darkText),
                                        ],
                                      )
                                    ],
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
                                    _controllerKodeTransaksi.clear();
                                    _controllerNamaKodeTransaksi.clear();
                                    _status = "";
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
                                    postKodeTransaksi(
                                            kodeGereja,
                                            _controllerNamaKodeTransaksi.text
                                                .capitalize(),
                                            _controllerKodeTransaksi.text
                                                .toUpperCase(),
                                            _status,
                                            context)
                                        .then(
                                      (value) {
                                        _controllerNamaKodeTransaksi.clear();
                                        _controllerKodeTransaksi.clear();
                                        _status = "";
                                        Navigator.pop(context);
                                      },
                                    );
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
      statusKode, context) async {
    var response = await servicesUser.inputMasterKode(
        kodeGereja, namaMasterKode, masterKodePerkiraan, statusKode);

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

  Future deleteMasterKode(kodeGereja, kodePerkiraan, context) async {
    var response =
        await servicesUser.deleteKodePerkiraan(kodeGereja, kodePerkiraan);

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

  Future deleteKodePerkiraan(kodeGereja, kodePerkiraan, context) async {
    var response =
        await servicesUser.deleteKodePerkiraan(kodeGereja, kodePerkiraan);

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
      kodeGereja, namaKodeTransaksi, kodeTransaksi, status, context) async {
    var response = await servicesUser.inputKodeTransaksi(
        kodeGereja, namaKodeTransaksi, kodeTransaksi, status);

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

  confirmDialogDelKode(dw, dh, kode, type) {
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
                                  primary: cancelButtonColor,
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
                                  } else {
                                    // deleteKodePerkiraan(
                                    //         kodeGereja, kode, context)
                                    //     .whenComplete(() {
                                    //   Navigator.pop(context);
                                    //   kodePerkiraan = servicesUser
                                    //       .getKodePerkiraan(kodeGereja);
                                    //   setState(() {});
                                    // });
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
                                                          1);
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
    ).whenComplete(() {
      setState(() {});
    });
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
                                                                      0);
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
                                                                      1);
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
                                                                      0);
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
                                                                      1);
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
    _getKodePerkiraanSingleKegiatan(kodeGereja, "", "");

    formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
    date = formattedDate;

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
    } else {
      throw "Gagal Mengambil Data";
    }
  }

  Future _getKodePerkiraan(kodeGereja, headerKodePerkiraan) async {
    _kodePerkiraan.clear();

    var response =
        await servicesUser.getKodePerkiraan(kodeGereja, headerKodePerkiraan);
    if (response[0] != 404) {
      for (var element in response[1]) {
        debugPrint(element.toString());
        _kodePerkiraan.add(
            "${element['kode_perkiraan']} - ${element['nama_kode_perkiraan']}");
      }
    } else {
      throw "Gagal Mengambil Data";
    }
  }

  Future _getKodePerkiraanSingleKegiatan(
      kodeGereja, kodeKegiatan, kodeTransaksi) async {
    _kodePerkiraanSingleKegiatan.clear();

    var response = await servicesUser.getKodePerkiraanSingleKegiatan(
        kodeGereja, kodeKegiatan, kodeTransaksi);
    if (response[0] != 404) {
      for (var element in response[1]) {
        debugPrint(element.toString());
        _kodePerkiraanSingleKegiatan.add(
            "${element['header_kode_perkiraan']}.${element['kode_perkiraan']} - ${element['nama_kode_perkiraan']}");
      }
    } else {
      throw "Gagal Mengambil Data";
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
    } else {
      throw "Gagal Mengambil Data";
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
            .add("${element['kode_kegiatan']} - ${element['nama_kegiatan']}");
      }
    } else {
      throw "Gagal Mengambil Data";
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
      context) async {
    var response = await servicesUser.inputTransaksi(
        kodeGereja,
        kodeTransaksi,
        kodeMaster,
        kodePerkiraan,
        kodeRefKegiatan,
        tanggalTransaksi,
        deskripsiTransaksi,
        nominalTransaksi);

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
    var splitDot = value.indexOf(".");
    var splitSpace = value.indexOf(" ");
    var master = value.substring(0, splitDot);
    var perkiraan = value.substring(splitDot + 1, splitSpace);
    return [master, perkiraan];
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
                  primary: navButtonPrimary, // button text color
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

//TODO: Show Tambah Transaksi Dialog
  _showTambahDialog(dw, dh, kodeTransaksi) {
    selectedKodePerkiraan = "Pilih Kode Perkiraan";
    selectedKodeRefKegiatan = "Pilih Kode Referensi";
    _controllerKeterangan.clear();
    _controllerNominal.clear();
    date = formattedDate;
    kodeRefKegiatan = "";
    kodePerkiraan = "";
    kodeMaster = "";
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  responsiveText("Kode Transaksi", 16,
                                      FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  //TODO: Kode Transaksi
                                  responsiveText(kodeTransaksi, 16,
                                      FontWeight.w700, darkText),
                                  const Divider(
                                    height: 25,
                                  ),
                                  //TODO: Input Kode Referensi Dialog
                                  responsiveText("Kode Referensi Kegiatan", 16,
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
                                            border: const OutlineInputBorder(),
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
                                          controller: _controllerDropdownFilter,
                                        ),
                                      ),
                                      items: _kodeRefKegiatan,
                                      onChanged: (val) {
                                        if (val == null) {
                                          selectedKodeRefKegiatan =
                                              "Pilih Kode Referensi";
                                          kodeRefKegiatan = "";
                                          selectedKodePerkiraan =
                                              "Pilih Kode Perkiraan";
                                          kodePerkiraan = "";
                                          _getKodePerkiraanSingleKegiatan(
                                            kodeGereja,
                                            "",
                                            _splitStringKode(kodeTransaksi),
                                          ).whenComplete(() => setState(() {}));
                                        } else {
                                          selectedKodePerkiraan =
                                              "Pilih Kode Perkiraan";
                                          _kodePerkiraanSingleKegiatan.clear();
                                          selectedKodeRefKegiatan = val;
                                          debugPrint(selectedKodeRefKegiatan);
                                          debugPrint(_splitString(
                                              selectedKodeRefKegiatan));
                                          debugPrint(_buatKodeGabungan(
                                              selectedKodeRefKegiatan));
                                          kodeRefKegiatan = _splitString(
                                              selectedKodeRefKegiatan);
                                          _getKodePerkiraanSingleKegiatan(
                                            kodeGereja,
                                            kodeRefKegiatan,
                                            _splitStringKode(kodeTransaksi),
                                          ).whenComplete(() {
                                            setState(() {});
                                          });
                                        }
                                        debugPrint(kodeRefKegiatan);
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
                                              debugPrint(selectedKodePerkiraan);
                                              debugPrint(_splitString(
                                                  selectedKodePerkiraan));
                                              debugPrint(_buatKodeGabungan(
                                                  selectedKodePerkiraan));
                                              kodeMaster =
                                                  _splitKodeMasterDanPerkiraan(
                                                      val)[0];
                                              kodePerkiraan =
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
                                  responsiveText(
                                      "Tanggal", 16, FontWeight.w700, darkText),
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(date),
                                              const IconButton(
                                                onPressed: null,
                                                icon:
                                                    Icon(Icons.calendar_month),
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
                                  responsiveText(
                                      "Nominal", 16, FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextField(
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
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                      ),
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
                                  responsiveTextField(
                                      dw, dh, _controllerKeterangan),
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
                                  debugPrint(kodeTransaksi);
                                  debugPrint(kodePerkiraan);
                                  debugPrint(kodeRefKegiatan);
                                  debugPrint(date);
                                  debugPrint(_controllerNominal.text);
                                  debugPrint(_controllerKeterangan.text);
                                  _getKodePerkiraanSingleKegiatan(
                                    kodeGereja,
                                    "",
                                    _splitStringKode(kodeTransaksi),
                                  ).whenComplete(() => setState(() {}));

                                  Navigator.pop(context);
                                },
                                child: const Text("Batal"),
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (kodePerkiraan == "" || kodeMaster == "") {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Silahkan Pilih Kode Perkiraan Terlebih Dahulu"),
                                      ),
                                    );
                                  } else {
                                    //Print
                                    debugPrint(kodeTransaksi);
                                    debugPrint(kodeMaster);
                                    debugPrint(kodePerkiraan);
                                    debugPrint(kodeRefKegiatan);
                                    debugPrint(date);
                                    debugPrint(_controllerNominal.text);
                                    debugPrint(_controllerKeterangan.text);

                                    //Add
                                    tempItemTransaksi.add(kodeTransaksi);
                                    tempItemTransaksi.add(kodeMaster);
                                    tempItemTransaksi.add(kodePerkiraan);
                                    tempItemTransaksi.add(kodeRefKegiatan);
                                    tempItemTransaksi.add(date);
                                    tempItemTransaksi
                                        .add(_controllerNominal.text);
                                    tempItemTransaksi
                                        .add(_controllerKeterangan.text);

                                    debugPrint(tempItemTransaksi.toString());
                                    itemTransaksi
                                        .add(tempItemTransaksi.toList());
                                    if (mounted) {
                                      setState(() {});
                                    }

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
                                _showTambahDialog(deviceWidth, deviceHeight,
                                    "$_singleKodeTransaksi-$_kodeTransaksiCount");
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
                                              flex: 1,
                                              child: responsiveText(
                                                  "${itemTransaksi[index][0]}-${itemTransaksi[index][2]}",
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
                                              flex: 1,
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
                                              flex: 3,
                                              child: responsiveText(
                                                  itemTransaksi[index][6]
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
                                              flex: 1,
                                              child: responsiveText(
                                                  CurrencyFormat.convertToIdr(
                                                      int.parse(
                                                          itemTransaksi[index]
                                                              [5]),
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
                          int ctr = 0;
                          String tempKodeTransaksi = "";
                          for (var element in itemTransaksi) {
                            tempKodeTransaksi = _splitStringKode(element[0]);
                            debugPrint(tempKodeTransaksi);
                            debugPrint(
                                "${element[0]} - ${element[1]} - ${element[2]} - ${element[3]} - ${element[4]} - ${element[5]}");

                            _postTransaksi(
                                    kodeGereja,
                                    element[0],
                                    element[1],
                                    element[2],
                                    element[3],
                                    element[4],
                                    element[6],
                                    element[5],
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
                                        () => widget.controllerPageBuatTransaksi
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

  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(length: 3, vsync: this);
    formattedMonth = DateFormat('MM-yyyy').format(selectedMonth);
    month = formattedMonth;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
                  primary: navButtonPrimary, // button text color
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
            kodeGereja, month, element['kode_kegiatan']);

        for (var element in responseData[1]) {
          tempData.add(element['kode_perkiraan']);
          tempData.add(element['nama_kode_perkiraan']);
          tempData.add(element['status']);
          tempData.add(element['jurnal']);
          tempData.add(element['nama_kegiatan']);
          tempData.add(element['kode_kegiatan']);
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
                    primary: const Color(0xff960000),
                  ),
                  onPressed: () {
                    _getJurnalData(kodeGereja, month).whenComplete(
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return AdminLaporanPreviewPDF(
                                tipe: 0,
                                month: month,
                              );
                            },
                          ),
                        );
                      },
                    );
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
                  future: servicesUser.getKodeKegiatanJurnal(kodeGereja, month),
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
                                    snapData[1][index]['kode_kegiatan']
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
                                          future: servicesUser.getJurnal(
                                              kodeGereja,
                                              month,
                                              snapData[1][index]
                                                  ['kode_kegiatan']),
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
                                                              "Kode",
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
                                                                          'kode_perkiraan']
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
                                                                child: snapData[1][index]
                                                                            [
                                                                            'status'] ==
                                                                        "pemasukan"
                                                                    ? Text(
                                                                        CurrencyFormat.convertToIdr(snapData[1][index]['jurnal'].abs(),
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
                                                                            'status'] ==
                                                                        "pengeluaran"
                                                                    ? Text(
                                                                        CurrencyFormat.convertToIdr(snapData[1][index]['jurnal'].abs(),
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
                                                    ),
                                                  ],
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
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(
                              height: 32,
                              color: dividerColor.withOpacity(0.5),
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
                    primary: const Color(0xff960000),
                  ),
                  onPressed: () {
                    _getBukuBesarData(kodeGereja, month).whenComplete(
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return AdminLaporanPreviewPDF(
                                tipe: 1,
                                month: month,
                              );
                            },
                          ),
                        );
                      },
                    );
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
                                                                        CurrencyFormat.convertToIdr(snapData[1][index]['nominal'].abs(),
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
                                                                        CurrencyFormat.convertToIdr(snapData[1][index]['nominal'].abs(),
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
                                                                  CurrencyFormat.convertToIdr(
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

  Future _getNeracaData(kodeGereja, month) async {
    _dataNeraca.clear();
    var temp = List.empty(growable: true);
    var response = await servicesUser.getNeracaSaldo(kodeGereja, month);
    if (response[0] != 404) {
      for (var element in response[1]) {
        temp.add(element['nama_kode_perkiraan']);
        temp.add(element['kode_perkiraan']);
        temp.add(element['status']);
        temp.add(element['saldo']);
        _dataNeraca.add(temp.toList());
        temp.clear();
      }
      debugPrint(_dataNeraca.toString());
    } else {
      throw "Gagal Mengambil Data";
    }
  }

  neracaSaldoView(dw, dh) {
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
                    primary: const Color(0xff960000),
                  ),
                  onPressed: () {
                    _getNeracaData(kodeGereja, month).whenComplete(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return AdminLaporanPreviewPDF(
                              tipe: 2,
                              month: month,
                            );
                          },
                        ),
                      );
                    });
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
                              "Kode",
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
                              "Nama Kode",
                              style: GoogleFonts.nunito(
                                  color: darkText,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  letterSpacing: 0.125),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
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
                      height: 32,
                      color: dividerColor.withOpacity(0.5),
                    ),
                    FutureBuilder(
                      future: servicesUser.getNeracaSaldo(kodeGereja, month),
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
                                return ListTile(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          snapData[1][index]['kode_perkiraan'],
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
                                          snapData[1][index]
                                              ['nama_kode_perkiraan'],
                                          style: GoogleFonts.nunito(
                                              color: darkText,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16,
                                              letterSpacing: 0.125),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: snapData[1][index]['status'] ==
                                                "pemasukan"
                                            ? Text(
                                                CurrencyFormat.convertToIdr(
                                                        snapData[1][index]
                                                                ['saldo']
                                                            .abs(),
                                                        2)
                                                    .toString(),
                                                style: GoogleFonts.nunito(
                                                    color: darkText,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16,
                                                    letterSpacing: 0.125),
                                              )
                                            : const Text(""),
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: snapData[1][index]['status'] ==
                                                "pengeluaran"
                                            ? Text(
                                                CurrencyFormat.convertToIdr(
                                                        snapData[1][index]
                                                                ['saldo']
                                                            .abs(),
                                                        2)
                                                    .toString(),
                                                style: GoogleFonts.nunito(
                                                    color: darkText,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16,
                                                    letterSpacing: 0.125),
                                              )
                                            : const Text(""),
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
                          } else {
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
                  neracaSaldoView(deviceWidth, deviceHeight),
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

class AdminLihatSaldoAwal extends StatefulWidget {
  final PageController controllerPageLihatSaldoAwal;
  const AdminLihatSaldoAwal(
      {super.key, required this.controllerPageLihatSaldoAwal});

  @override
  State<AdminLihatSaldoAwal> createState() => _AdminLihatSaldoAwalState();
}

class _AdminLihatSaldoAwalState extends State<AdminLihatSaldoAwal> {
  ServicesUser servicesUser = ServicesUser();
  @override
  void initState() {
    // TODO: implement initState
    _getSaldoAwal(kodeGereja);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
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

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () {},
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
  const AdminLaporanPreviewPDF(
      {super.key, required this.tipe, required this.month});

  @override
  State<AdminLaporanPreviewPDF> createState() => _AdminLaporanPreviewPDFState();
}

class _AdminLaporanPreviewPDFState extends State<AdminLaporanPreviewPDF> {
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
            pw.Table(
              border: pw.TableBorder.all(
                style: pw.BorderStyle.solid,
                width: 1,
              ),
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
                          "Nama Kode",
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

                for (int i = 0; i < _dataNeraca.length; i++)
                  pw.TableRow(
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        children: [
                          pw.Padding(
                            padding:
                                const pw.EdgeInsets.symmetric(horizontal: 5),
                            child: pw.Text(
                              "${_dataNeraca[i][1]}",
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
                            padding:
                                const pw.EdgeInsets.symmetric(horizontal: 5),
                            child: pw.Text(
                              "${_dataNeraca[i][0]}",
                              style: pw.TextStyle(
                                font: regularFont,
                                fontSize: 12,
                              ),
                            ),
                          )
                        ],
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        children: [
                          _dataNeraca[i][2] == "pemasukan"
                              ? pw.Padding(
                                  padding: const pw.EdgeInsets.symmetric(
                                      horizontal: 5),
                                  child: pw.Text(
                                    CurrencyFormat.convertToIdr(
                                            _dataNeraca[i][3].abs(), 2)
                                        .toString(),
                                    style: pw.TextStyle(
                                      font: regularFont,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              : pw.Padding(
                                  padding: const pw.EdgeInsets.symmetric(
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
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        children: [
                          _dataNeraca[i][2] == "pengeluaran"
                              ? pw.Padding(
                                  padding: const pw.EdgeInsets.symmetric(
                                      horizontal: 5),
                                  child: pw.Text(
                                    CurrencyFormat.convertToIdr(
                                            _dataNeraca[i][3].abs(), 2)
                                        .toString(),
                                    style: pw.TextStyle(
                                      font: regularFont,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              : pw.Padding(
                                  padding: const pw.EdgeInsets.symmetric(
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
                    ],
                  ),
              ],
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
                                              CurrencyFormat.convertToIdr(
                                                      _dataBukuBesar[index][i]
                                                              [3]
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
                                              CurrencyFormat.convertToIdr(
                                                      _dataBukuBesar[index][i]
                                                              [3]
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
                                        CurrencyFormat.convertToIdr(
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
                itemCount: _dataBukuBesar.length)
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
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        children: [
                          pw.Text(
                            "${_dataJurnal[index][0][5]}  ${_dataJurnal[index][0][4]}",
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
                                        "${_dataJurnal[index][i][0]}",
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
                                    _dataJurnal[index][i][2] == "pemasukan"
                                        ? pw.Padding(
                                            padding:
                                                const pw.EdgeInsets.symmetric(
                                                    horizontal: 5),
                                            child: pw.Text(
                                              CurrencyFormat.convertToIdr(
                                                      _dataJurnal[index][i][3]
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
                                    _dataJurnal[index][i][2] == "pengeluaran"
                                        ? pw.Padding(
                                            padding:
                                                const pw.EdgeInsets.symmetric(
                                                    horizontal: 5),
                                            child: pw.Text(
                                              CurrencyFormat.convertToIdr(
                                                      _dataJurnal[index][i][3]
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
                itemCount: _dataJurnal.length)
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
        build: (format) => checkTipe(widget.tipe, format),
      ),
    );
  }
}
