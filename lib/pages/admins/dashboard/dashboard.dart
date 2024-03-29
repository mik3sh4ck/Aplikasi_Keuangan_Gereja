//ignore_for_file: todo
import 'package:aplikasi_keuangan_gereja/dataclass/dataclass.dart';
import 'package:aplikasi_keuangan_gereja/themes/colors.dart';
import 'package:aplikasi_keuangan_gereja/services/apiservices.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../globals.dart';
import '../../../widgets/responsivetext.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../widgets/string_extension.dart';

TextStyle welcomeText = GoogleFonts.nunito(
  color: darkText,
  fontWeight: FontWeight.bold,
  fontSize: 36,
);

final List<DataRow> _rowList = List.empty(growable: true);

int _totalPemasukan = 0;
int _totalPengeluaran = 0;
int _totalSaldo = 0;

List _dataChart = List.empty(growable: true);
List<TransactionData> _dataPengeluaranChart = List.empty(growable: true);
List<TransactionData> _dataPemasukanChart = List.empty(growable: true);
List<TransactionData> _dataSaldoChart = List.empty(growable: true);

class AdminDashboardControllerPage extends StatefulWidget {
  const AdminDashboardControllerPage({Key? key}) : super(key: key);

  @override
  State<AdminDashboardControllerPage> createState() =>
      _AdminDashboardControllerPageState();
}

class _AdminDashboardControllerPageState
    extends State<AdminDashboardControllerPage> {
  final _controllerDashboardPage = PageController();
  @override
  void initState() {
    // TODO: implement initState
    _dataPemasukanChart.clear();
    _dataPengeluaranChart.clear();
    _dataSaldoChart.clear();
    _dataChart.clear();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controllerDashboardPage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controllerDashboardPage,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        AdminDashboardPage(
          controllerDashboardPage: _controllerDashboardPage,
        ),
        AdminBuatBeritaPage(
          controllerDashboardPage: _controllerDashboardPage,
        )
      ],
    );
  }
}

class AdminDashboardPage extends StatefulWidget {
  final PageController controllerDashboardPage;
  const AdminDashboardPage({Key? key, required this.controllerDashboardPage})
      : super(key: key);

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  ServicesUser servicesUser = ServicesUser();
  String nama = "";

  @override
  void initState() {
    // TODO: implement initState
    getUserName(kodeUser);
    _getPemasukanChart(
        kodeGereja, "${DateTime.now().month}-${DateTime.now().year}");
    _getPengeluaranChart(
        kodeGereja, "${DateTime.now().month}-${DateTime.now().year}");
    _getSaldoChart(
        kodeGereja, "${DateTime.now().month}-${DateTime.now().year}");
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  _cardInfo(title, nominal) {
    return SizedBox(
      width: 250,
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

  cardNews(judul, isi) {
    return Container(
      padding: const EdgeInsets.all(0),
      width: 350,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 350,
            decoration: BoxDecoration(
              color: primaryColor,
              border: Border.all(color: Colors.black),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            padding: const EdgeInsets.all(10),
            child: Text("$judul"),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15)),
              border: Border.all(color: Colors.black),
            ),
            child: Text("$isi"),
          )
        ],
      ),
    );
  }

  Future getUserName(userStatus) async {
    var response = await servicesUser.getSingleUser(userStatus);
    nama = response[1]['nama_lengkap_user'].toString();
    if (mounted) {
      setState(() {});
    }
  }

  getBulanForChart(String tanggal) {
    var getdash = tanggal.indexOf("-");
    var temp = tanggal.substring(getdash + 1, getdash + 3);
    if (temp[0] == "0") {
      debugPrint(temp[1]);
      return temp[1];
    } else {
      debugPrint(temp);
      return temp;
    }
  }

  convertBulan(val) {
    if (val == "01") {
      return "Jan";
    } else if (val == "02") {
      return "Feb";
    } else if (val == "03") {
      return "Mar";
    } else if (val == "04") {
      return "Apr";
    } else if (val == "05") {
      return "May";
    } else if (val == "06") {
      return "Jun";
    } else if (val == "07") {
      return "Jul";
    } else if (val == "08") {
      return "Aug";
    } else if (val == "09") {
      return "Sep";
    } else if (val == "10") {
      return "Okt";
    } else if (val == "11") {
      return "Nov";
    } else {
      return "Des";
    }
  }

  Future _getPemasukanChart(kodeGereja, tanggal) async {
    _dataPemasukanChart.clear();
    var temp = List.empty(growable: true);
    var response = await servicesUser.getPemasukanChart(kodeGereja, tanggal);
    if (response[0] != 404) {
      for (var element in response[1]) {
        _dataPemasukanChart.add(
          TransactionData(
            convertBulan(element['bulan']),
            double.parse(element['nominal'].toString()),
          ),
        );

        temp.clear();
      }
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future _getPengeluaranChart(kodeGereja, tanggal) async {
    _dataPengeluaranChart.clear();
    var temp = List.empty(growable: true);
    var response = await servicesUser.getPengeluaranChart(kodeGereja, tanggal);
    if (response[0] != 404) {
      for (var element in response[1]) {
        _dataPengeluaranChart.add(
          TransactionData(
            convertBulan(element['bulan']),
            double.parse(element['nominal'].toString()),
          ),
        );

        temp.clear();
      }
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future _getSaldoChart(kodeGereja, tanggal) async {
    _dataSaldoChart.clear();
    var temp = List.empty(growable: true);
    var response = await servicesUser.getSaldoChart(kodeGereja, tanggal);
    if (response[0] != 404) {
      for (var element in response[1]) {
        _dataSaldoChart.add(
          TransactionData(
            convertBulan(element['bulan']),
            double.parse(element['nominal'].toString()),
          ),
        );

        temp.clear();
      }
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    print(_dataPemasukanChart);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat Datang, ',
                      style: GoogleFonts.nunito(
                        color: darkText,
                        fontWeight: FontWeight.w900,
                        fontSize: 36,
                      ),
                    ),
                    Text(
                      nama,
                      style: GoogleFonts.nunito(
                        color: darkText,
                        fontWeight: FontWeight.w800,
                        fontSize: 36,
                      ),
                    ),
                  ],
                ),
                // Padding(
                //   padding: const EdgeInsets.only(right: 25),
                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //       primary: buttonColor,
                //       padding: const EdgeInsets.symmetric(
                //           horizontal: 24, vertical: 16),
                //       textStyle: GoogleFonts.nunito(
                //           color: lightText,
                //           fontWeight: FontWeight.w800,
                //           fontSize: 14,
                //           letterSpacing: 0.125),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //     ),
                //     onPressed: () {
                //       widget.controllerDashboardPage.animateToPage(1,
                //           duration: const Duration(milliseconds: 250),
                //           curve: Curves.ease);
                //     },
                //     child: Row(
                //       children: [
                //         const Icon(Icons.add),
                //         const SizedBox(
                //           width: 10,
                //         ),
                //         Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: const [
                //             Text("Buat"),
                //             Text("Berita"),
                //           ],
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
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
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Expanded(
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       cardNews('judul news',
                            //           'Telah diterima donasi sebesar 3.000.000 dari Gereja ABCDE, Tuhan Yesus memberkati.'),
                            //       const SizedBox(
                            //         height: 20,
                            //       ),
                            //       cardNews('judul news',
                            //           'Telah diterima donasi sebesar 3.000.000 dari Gereja ABCDE, Tuhan Yesus memberkati.'),
                            //       const SizedBox(
                            //         height: 20,
                            //       ),
                            //       cardNews('judul news',
                            //           'Telah diterima donasi sebesar 3.000.000 dari Gereja ABCDE, Tuhan Yesus memberkati.')
                            //     ],
                            //   ),
                            // ),
                            // const SizedBox(
                            //   width: 20,
                            // ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(0),
                                    width: double.infinity,
                                    height: deviceHeight * 0.70,
                                    child: SfCartesianChart(
                                      enableAxisAnimation: true,
                                      legend: Legend(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .subtitle2,
                                        isVisible: true,
                                        position: LegendPosition.top,
                                        alignment: ChartAlignment.center,
                                        overflowMode:
                                            LegendItemOverflowMode.scroll,
                                        isResponsive: true,
                                        // title: LegendTitle(
                                        //     text:
                                        //         "Grafik Keuangan Tahun ${DateTime.now().year}",
                                        //     textStyle: Theme.of(context)
                                        //         .textTheme
                                        //         .headline4),
                                      ),

                                      // Initialize category axis
                                      primaryXAxis: CategoryAxis(),
                                      series: <
                                          LineSeries<TransactionData, String>>[
                                        LineSeries<TransactionData, String>(
                                            // Bind data source
                                            color: Colors.green,
                                            name: "Pemasukan",
                                            dataSource: _dataPemasukanChart,
                                            xValueMapper:
                                                (TransactionData sales, _) =>
                                                    sales.year,
                                            yValueMapper:
                                                (TransactionData sales, _) =>
                                                    sales.amount),
                                        LineSeries<TransactionData, String>(
                                            // Bind data source
                                            color: Colors.red,
                                            name: "Pengeluaran",
                                            dataSource: _dataPengeluaranChart,
                                            xValueMapper:
                                                (TransactionData sales, _) =>
                                                    sales.year,
                                            yValueMapper:
                                                (TransactionData sales, _) =>
                                                    sales.amount),
                                        LineSeries<TransactionData, String>(
                                            // Bind data source
                                            color: Colors.yellow,
                                            name: "Saldo",
                                            dataSource: _dataSaldoChart,
                                            xValueMapper:
                                                (TransactionData sales, _) =>
                                                    sales.year,
                                            yValueMapper:
                                                (TransactionData sales, _) =>
                                                    sales.amount)
                                      ],
                                    ),
                                  )
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
            ),
          ],
        ),
      ),
    );
  }
}

class AdminBuatBeritaPage extends StatefulWidget {
  final PageController controllerDashboardPage;
  const AdminBuatBeritaPage({Key? key, required this.controllerDashboardPage})
      : super(key: key);

  @override
  State<AdminBuatBeritaPage> createState() => _AdminBuatBeritaPageState();
}

class _AdminBuatBeritaPageState extends State<AdminBuatBeritaPage> {
  final _controllerTemaBerita = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String formattedDate = "";
  String formattedTime = "";
  String time = "Time";
  String date = "Date";

  bool uploadCheck = false;
  String uploadImg = "";

  Future<void> getFileFromDir(context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;
      uploadCheck = false;
      uploadImg = file.path.toString();

      if (mounted) {
        setState(() {});
      }

      debugPrint(file.name.toString());
      debugPrint(file.bytes.toString());
      debugPrint(file.size.toString());
      debugPrint(file.extension.toString());
      debugPrint(file.path.toString());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal Mengambil Gambar"),
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
    date = formattedDate;

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        final localizations = MaterialLocalizations.of(context);
        formattedTime = localizations.formatTimeOfDay(selectedTime);
        time = formattedTime.toString();
      },
    );
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

  Future<void> selectDate(context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
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

  Future<void> selectTime(context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
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
    if (picked != null && picked != selectedTime) {
      if (mounted) {
        selectedTime = picked;
        final localizations = MaterialLocalizations.of(context);
        formattedTime = localizations.formatTimeOfDay(selectedTime);
        time = formattedTime.toString();
        debugPrint("Selected Date From $time");

        setState(() {});
      }
    }
  }

  checkGambar() {
    if (!uploadCheck) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: buttonColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
          getFileFromDir(context);
          if (mounted) {
            uploadCheck = true;
            setState(() {});
          }
        },
        child: const Text("Unggah Gambar"),
      );
    } else {
      return Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image(
              height: 250,
              image: AssetImage(uploadImg),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: buttonColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
              if (mounted) {
                uploadCheck = false;
                uploadImg = "";
                setState(() {});
              }
            },
            child: const Text("Hapus Gambar"),
          ),
        ],
      );
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
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    widget.controllerDashboardPage.animateToPage(0,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.ease);
                  },
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                ),
                const SizedBox(
                  width: 25,
                ),
                responsiveText("Buat Berita", 26, FontWeight.w900, darkText),
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
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                responsiveText(
                                    "Tema", 16, FontWeight.w700, darkText),
                                const SizedBox(
                                  height: 10,
                                ),
                                responsiveTextField(deviceWidth, deviceHeight,
                                    _controllerTemaBerita),
                                const SizedBox(
                                  height: 15,
                                ),
                                responsiveText(
                                    "Tanggal", 16, FontWeight.w700, darkText),
                                const SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    selectDate(context).then(
                                      (value) => setState(() {}),
                                    );
                                  },
                                  child: Card(
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
                                          Text(date),
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
                                  height: 15,
                                ),
                                responsiveText(
                                    "Jam", 16, FontWeight.w700, darkText),
                                const SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    selectTime(context).then(
                                      (value) => setState(() {}),
                                    );
                                  },
                                  child: Card(
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
                                          Text(time),
                                          const IconButton(
                                            onPressed: null,
                                            icon: Icon(Icons.alarm),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 56,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: buttonColor,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 16),
                                    textStyle: GoogleFonts.nunito(
                                        color: lightText,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 14,
                                        letterSpacing: 0.125),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: const Text("Simpan"),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                responsiveText("Gambar Berita", 16,
                                    FontWeight.w700, darkText),
                                const SizedBox(
                                  height: 15,
                                ),
                                checkGambar()
                              ],
                            ),
                          ),
                        ],
                      )
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
