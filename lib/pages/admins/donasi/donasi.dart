// //ignore_for_file: todo
// import 'dart:typed_data';

// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker_web/image_picker_web.dart';

// import '../../../services/apiservices.dart';
// import '../../../themes/colors.dart';
// import '../../../widgets/loadingindicator.dart';
// import '../../../widgets/responsivetext.dart';

// class AdminControllerDonasiPage extends StatefulWidget {
//   const AdminControllerDonasiPage({Key? key}) : super(key: key);

//   @override
//   State<AdminControllerDonasiPage> createState() =>
//       _AdminControllerDonasiPageState();
// }

// class _AdminControllerDonasiPageState extends State<AdminControllerDonasiPage> {
//   final _controllerBuatDonasi = PageController();
//   final _controllerDetailDonasi = PageController();
//   final _controllerHistoryDonasi = PageController();

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     _controllerBuatDonasi.dispose();
//     _controllerDetailDonasi.dispose();
//     _controllerHistoryDonasi.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PageView(
//       controller: _controllerBuatDonasi,
//       physics: const NeverScrollableScrollPhysics(),
//       children: [
//         PageView(
//           controller: _controllerDetailDonasi,
//           physics: const NeverScrollableScrollPhysics(),
//           children: [
//             PageView(
//               controller: _controllerHistoryDonasi,
//               physics: const NeverScrollableScrollPhysics(),
//               children: [
//                 AdminDonasiPage(
//                     controllerBuatDonasi: _controllerBuatDonasi,
//                     controllerDetailDonasi: _controllerDetailDonasi,
//                     controllerHistoryDonasi: _controllerHistoryDonasi),
//                 HistoryDonasiPage(
//                     controllerHistoryDonasi: _controllerHistoryDonasi)
//               ],
//             ),
//             DetailDonasiPage(controllerDetailDonasi: _controllerDetailDonasi)
//           ],
//         ),
//         BuatDonasiPage(controllerBuatDonasi: _controllerBuatDonasi)
//       ],
//     );
//   }
// }

// //TODO: Donasi page
// class AdminDonasiPage extends StatefulWidget {
//   final PageController controllerBuatDonasi;
//   final PageController controllerDetailDonasi;
//   final PageController controllerHistoryDonasi;
//   const AdminDonasiPage(
//       {Key? key,
//       required this.controllerBuatDonasi,
//       required this.controllerDetailDonasi,
//       required this.controllerHistoryDonasi})
//       : super(key: key);

//   @override
//   State<AdminDonasiPage> createState() => _AdminDonasiPageState();
// }

// class _AdminDonasiPageState extends State<AdminDonasiPage> {
//   ServicesUser servicesUser = ServicesUser();
//   late Future kategoriDonasi;

//   @override
//   void initState() {
//     // TODO: implement initState
//     kategoriDonasi = servicesUser.getAllProposalKegiatan("gms001");
//     super.initState();
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final deviceWidth = MediaQuery.of(context).size.width;
//     final deviceHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       body: ScrollConfiguration(
//         behavior: ScrollConfiguration.of(context).copyWith(
//           dragDevices: {
//             PointerDeviceKind.touch,
//             PointerDeviceKind.mouse,
//           },
//         ),
//         child: SingleChildScrollView(
//           physics: const ClampingScrollPhysics(),
//           controller: ScrollController(),
//           child: SafeArea(
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
//               width: deviceWidth,
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       responsiveText("Donasi", 26, FontWeight.w900, darkText),
//                       const SizedBox(
//                         width: 25,
//                       ),
//                       Row(
//                         children: [
//                           IconButton(
//                             onPressed: () {
//                               widget.controllerHistoryDonasi.animateToPage(1,
//                                   duration: const Duration(milliseconds: 250),
//                                   curve: Curves.ease);
//                             },
//                             icon: const Icon(Icons.history_rounded),
//                           ),
//                           const SizedBox(
//                             width: 25,
//                           ),
//                           ElevatedButton(
//                             style: TextButton.styleFrom(
//                               primary: Colors.white,
//                               backgroundColor: const Color(0xFFf9ab27),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(40),
//                               ),
//                             ),
//                             onPressed: () {
//                               widget.controllerBuatDonasi.animateToPage(1,
//                                   duration: const Duration(milliseconds: 250),
//                                   curve: Curves.ease);
//                             },
//                             child: Row(
//                               children: [
//                                 const Icon(Icons.add_circle_outline_rounded),
//                                 const SizedBox(
//                                   width: 5,
//                                 ),
//                                 Text(
//                                   'Buat Data Donasi',
//                                   style: GoogleFonts.nunito(
//                                       fontWeight: FontWeight.w700,
//                                       fontSize: 14),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   const Divider(
//                     height: 56,
//                   ),
//                   const SizedBox(height: 25),
//                   Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       side: BorderSide(
//                         color: navButtonPrimary.withOpacity(0.4),
//                       ),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: FutureBuilder(
//                         future: kategoriDonasi,
//                         builder: (context, snapshot) {
//                           if (snapshot.hasData) {
//                             List snapData = snapshot.data! as List;
//                             if (snapData[0] != 404) {
//                               return ScrollConfiguration(
//                                 behavior:
//                                     ScrollConfiguration.of(context).copyWith(
//                                   dragDevices: {
//                                     PointerDeviceKind.touch,
//                                     PointerDeviceKind.mouse,
//                                   },
//                                 ),
//                                 child: ListView.builder(
//                                   shrinkWrap: true,
//                                   scrollDirection: Axis.vertical,
//                                   controller: ScrollController(),
//                                   physics: const ClampingScrollPhysics(),
//                                   itemCount: snapData[1].length,
//                                   itemBuilder: (context, index) {
//                                     return Card(
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(20),
//                                         side: BorderSide(
//                                           color:
//                                               navButtonPrimary.withOpacity(0.4),
//                                         ),
//                                       ),
//                                       color: scaffoldBackgroundColor,
//                                       child: ListTile(
//                                         title: responsiveText(
//                                             snapData[1][index]['nama_kegiatan'],
//                                             18,
//                                             FontWeight.w700,
//                                             darkText),
//                                         subtitle: responsiveText(
//                                             snapData[1][index]['kode_kegiatan'],
//                                             12,
//                                             FontWeight.w400,
//                                             darkText),
//                                         trailing: ElevatedButton(
//                                           style: ElevatedButton.styleFrom(
//                                             padding: const EdgeInsets.all(12),
//                                             shape: const CircleBorder(),
//                                           ),
//                                           onPressed: () {
//                                             widget.controllerDetailDonasi
//                                                 .animateToPage(1,
//                                                     duration: const Duration(
//                                                         milliseconds: 250),
//                                                     curve: Curves.ease);
//                                           },
//                                           child: const Icon(
//                                               Icons.arrow_forward_rounded),
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               );
//                             }
//                           }
//                           return loadingIndicator();
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// //TODO: Buat donasi page
// class BuatDonasiPage extends StatefulWidget {
//   final PageController controllerBuatDonasi;
//   const BuatDonasiPage({Key? key, required this.controllerBuatDonasi})
//       : super(key: key);

//   @override
//   State<BuatDonasiPage> createState() => _BuatDonasiPageState();
// }

// class _BuatDonasiPageState extends State<BuatDonasiPage> {
//   final _controllerJudulDonasi = TextEditingController();
//   final _controllerRekeningDonasi = TextEditingController();
//   final _controllerKeteranganDonasi = TextEditingController();

//   bool imageAvailable = false;
//   late Uint8List imageFile;

//   responsiveTextField(deviceWidth, deviceHeight, controllerText) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: SizedBox(
//         width: deviceWidth * 0.5,
//         child: TextField(
//           controller: controllerText,
//           autofocus: false,
//           decoration: InputDecoration(
//             filled: true,
//             fillColor: surfaceColor,
//             contentPadding:
//                 const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: const BorderSide(
//                 color: Colors.transparent,
//               ),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: const BorderSide(
//                 color: Colors.transparent,
//               ),
//             ),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: const BorderSide(
//                 color: Colors.transparent,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final deviceWidth = MediaQuery.of(context).size.width;
//     final deviceHeight = MediaQuery.of(context).size.height;
//     return Stack(
//       children: [
//         Positioned(
//           bottom: 0,
//           right: 0,
//           child: Image(
//             width: (MediaQuery.of(context).size.width) * 0.35,
//             image: const AssetImage('lib/assets/images/tangan.png'),
//           ),
//         ),
//         ScrollConfiguration(
//           behavior: ScrollConfiguration.of(context).copyWith(
//             dragDevices: {
//               PointerDeviceKind.touch,
//               PointerDeviceKind.mouse,
//             },
//           ),
//           child: SingleChildScrollView(
//             physics: const ClampingScrollPhysics(),
//             controller: ScrollController(),
//             child: Container(
//               padding: const EdgeInsets.all(16),
//               width: deviceWidth,
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.arrow_back_ios_new_rounded),
//                         onPressed: () {
//                           widget.controllerBuatDonasi.animateToPage(0,
//                               duration: const Duration(milliseconds: 250),
//                               curve: Curves.ease);
//                         },
//                       ),
//                       const SizedBox(
//                         width: 25,
//                       ),
//                       Text(
//                         "Buat Donasi",
//                         style: Theme.of(context).textTheme.headline5,
//                       ),
//                     ],
//                   ),
//                   const Divider(
//                     thickness: 1,
//                     height: 56,
//                   ),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Align(
//                         alignment: Alignment.centerLeft,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             responsiveText(
//                                 "Judul Donasi", 16, FontWeight.w700, darkText),
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             responsiveTextField(deviceWidth, deviceHeight,
//                                 _controllerJudulDonasi),
//                             const SizedBox(
//                               height: 15,
//                             ),
//                             responsiveText("Nomor Rekening Donasi", 16,
//                                 FontWeight.w700, darkText),
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             responsiveTextField(deviceWidth, deviceHeight,
//                                 _controllerRekeningDonasi),
//                             const SizedBox(
//                               height: 15,
//                             ),
//                             responsiveText("Keterangan Donasi", 16,
//                                 FontWeight.w700, darkText),
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             responsiveTextField(deviceWidth, deviceHeight,
//                                 _controllerKeteranganDonasi),
//                             const SizedBox(
//                               height: 15,
//                             ),
//                             ElevatedButton(
//                               onPressed: () {
//                                 if (mounted) {
//                                   setState(() {});
//                                 }
//                                 Navigator.pop(context);
//                               },
//                               style: TextButton.styleFrom(
//                                 elevation: 1,
//                                 primary: Colors.white,
//                                 backgroundColor: const Color(0xFFf9ab27),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                               ),
//                               child: const Text("Simpan"),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 15,
//                       ),
//                       Column(
//                         children: [
//                           responsiveText(
//                               "Unggah Kode QR", 16, FontWeight.w700, darkText),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           ElevatedButton(
//                             onPressed: () async {
//                               final image =
//                                   await ImagePickerWeb.getImageAsBytes();
//                               setState(() {
//                                 imageFile = image!;
//                                 imageAvailable = true;
//                               });
//                             },
//                             style: TextButton.styleFrom(
//                               elevation: 1,
//                               primary: Colors.white,
//                               backgroundColor: const Color(0xFFf9ab27),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                             ),
//                             child: const Text("Tambah Gambar"),
//                           ),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           Padding(
//                               padding: const EdgeInsets.all(0),
//                               child: Container(
//                                 width: deviceWidth * 0.15,
//                                 height: deviceHeight * 0.3,
//                                 decoration: const BoxDecoration(
//                                   color: Color(0xFFfef5e5),
//                                   borderRadius: BorderRadius.all(
//                                     Radius.circular(10),
//                                   ),
//                                 ),
//                                 child: imageAvailable
//                                     ? Image.memory(imageFile)
//                                     : const SizedBox(),
//                               ))
//                         ],
//                       )
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// //TODO: Detail donasi page
// class DetailDonasiPage extends StatefulWidget {
//   final PageController controllerDetailDonasi;
//   const DetailDonasiPage({Key? key, required this.controllerDetailDonasi})
//       : super(key: key);

//   @override
//   State<DetailDonasiPage> createState() => _DetailDonasiPageState();
// }

// class _DetailDonasiPageState extends State<DetailDonasiPage> {
//   final _controllerNominalDonasi = TextEditingController();

//   responsiveTextField(deviceWidth, deviceHeight, controllerText) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: SizedBox(
//         width: deviceWidth * 0.5,
//         child: TextField(
//           controller: controllerText,
//           autofocus: false,
//           decoration: InputDecoration(
//             filled: true,
//             fillColor: surfaceColor,
//             contentPadding:
//                 const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: const BorderSide(
//                 color: Colors.transparent,
//               ),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: const BorderSide(
//                 color: Colors.transparent,
//               ),
//             ),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: const BorderSide(
//                 color: Colors.transparent,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   _showTambahDialogNominalDonasi(dw, dh) {
//     showDialog(
//       useRootNavigator: true,
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Dialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: ScrollConfiguration(
//                 behavior: ScrollConfiguration.of(context).copyWith(
//                   dragDevices: {
//                     PointerDeviceKind.touch,
//                     PointerDeviceKind.mouse,
//                   },
//                 ),
//                 child: SingleChildScrollView(
//                   physics: const ClampingScrollPhysics(),
//                   controller: ScrollController(),
//                   child: SizedBox(
//                     width: dw * 0.5,
//                     child: Column(
//                       children: [
//                         Container(
//                           width: dw * 0.5,
//                           decoration: BoxDecoration(
//                             color: primaryColor,
//                             borderRadius: const BorderRadius.only(
//                               topLeft: Radius.circular(10),
//                               topRight: Radius.circular(10),
//                             ),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               const SizedBox(
//                                 height: 16,
//                               ),
//                               responsiveText("Nominal Donasi", 26,
//                                   FontWeight.w700, darkText),
//                               const SizedBox(
//                                 height: 16,
//                               ),
//                             ],
//                           ),
//                         ),
//                         Container(
//                           padding: const EdgeInsets.all(16),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   responsiveText("Nominal Donasi", 16,
//                                       FontWeight.w700, darkText),
//                                   const SizedBox(
//                                     height: 10,
//                                   ),
//                                   responsiveTextField(
//                                       dw, dh, _controllerNominalDonasi),
//                                   const SizedBox(
//                                     height: 15,
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(
//                                 height: 25,
//                               ),
//                             ],
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(16),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               ElevatedButton(
//                                 onPressed: () {
//                                   if (mounted) {
//                                     setState(() {});
//                                   }
//                                   Navigator.pop(context);
//                                 },
//                                 child: const Text("Batal"),
//                               ),
//                               const SizedBox(
//                                 width: 25,
//                               ),
//                               ElevatedButton(
//                                 onPressed: () {
//                                   if (mounted) {
//                                     setState(() {});
//                                   }
//                                   Navigator.pop(context);
//                                 },
//                                 child: const Text("Tambah"),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 25,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final deviceWidth = MediaQuery.of(context).size.width;
//     final deviceHeight = MediaQuery.of(context).size.height;
//     return Stack(
//       children: [
//         ScrollConfiguration(
//           behavior: ScrollConfiguration.of(context).copyWith(
//             dragDevices: {
//               PointerDeviceKind.touch,
//               PointerDeviceKind.mouse,
//             },
//           ),
//           child: SingleChildScrollView(
//             physics: const ClampingScrollPhysics(),
//             controller: ScrollController(),
//             child: Container(
//               padding: const EdgeInsets.all(16),
//               width: deviceWidth,
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.arrow_back_ios_new_rounded),
//                         onPressed: () {
//                           widget.controllerDetailDonasi.animateToPage(0,
//                               duration: const Duration(milliseconds: 250),
//                               curve: Curves.ease);
//                         },
//                       ),
//                       const SizedBox(
//                         width: 25,
//                       ),
//                       Text(
//                         "Detail Donasi",
//                         style: Theme.of(context).textTheme.headline5,
//                       ),
//                     ],
//                   ),
//                   const Divider(
//                     thickness: 1,
//                     height: 56,
//                   ),
//                   Container(
//                     margin: const EdgeInsets.all(20),
//                     padding: const EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8),
//                       color: const Color(0xFFfef5e5),
//                       border: Border.all(
//                         color: Colors.black.withOpacity(0.5),
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           flex: 2,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               responsiveText("Judul Donasi", 25,
//                                   FontWeight.w800, const Color(0xFF000000)),
//                               const SizedBox(
//                                 height: 15,
//                               ),
//                               responsiveTextNoMax(
//                                   "is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
//                                   15,
//                                   FontWeight.w600,
//                                   const Color(0xFF000000)),
//                               const SizedBox(
//                                 height: 15,
//                               ),
//                               Row(
//                                 children: [
//                                   responsiveText("Total Donasi : Rp. 0", 16,
//                                       FontWeight.w800, const Color(0xFF000000)),
//                                   IconButton(
//                                     icon: const Icon(
//                                       Icons.edit,
//                                     ),
//                                     onPressed: () {
//                                       _showTambahDialogNominalDonasi(
//                                           deviceWidth, deviceHeight);
//                                     },
//                                   )
//                                 ],
//                               ),
//                               const SizedBox(
//                                 height: 15,
//                               ),
//                               ElevatedButton(
//                                   style: TextButton.styleFrom(
//                                     primary: Colors.white,
//                                     backgroundColor: const Color(0xFFf9ab27),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(40),
//                                     ),
//                                   ),
//                                   onPressed: () {},
//                                   child: const Text("Tutup Donasi")),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(
//                           width: 10,
//                         ),
//                         Expanded(
//                           flex: 1,
//                           child: Column(
//                             children: [
//                               Image.network(
//                                 "https://images.tokopedia.net/img/cache/700/product-1/2018/11/8/39617213/39617213_91fd0f0c-03c2-43b4-861a-64e9f04e8f24_700_700.jpeg",
//                               )
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// //TODO: History donasi page
// class HistoryDonasiPage extends StatefulWidget {
//   final PageController controllerHistoryDonasi;
//   const HistoryDonasiPage({Key? key, required this.controllerHistoryDonasi})
//       : super(key: key);

//   @override
//   State<HistoryDonasiPage> createState() => _HistoryDonasiPageState();
// }

// class _HistoryDonasiPageState extends State<HistoryDonasiPage> {
//   ServicesUser servicesUser = ServicesUser();
//   late Future kategoriHistoryDonasi;

//   @override
//   void initState() {
//     // TODO: implement initState
//     kategoriHistoryDonasi =
//         servicesUser.getAllItemProposalKegiatan("dns007gms001");
//     super.initState();
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final deviceWidth = MediaQuery.of(context).size.width;
//     final deviceHeight = MediaQuery.of(context).size.height;
//     return Stack(
//       children: [
//         ScrollConfiguration(
//           behavior: ScrollConfiguration.of(context).copyWith(
//             dragDevices: {
//               PointerDeviceKind.touch,
//               PointerDeviceKind.mouse,
//             },
//           ),
//           child: SingleChildScrollView(
//             physics: const ClampingScrollPhysics(),
//             controller: ScrollController(),
//             child: Container(
//               padding: const EdgeInsets.all(16),
//               width: deviceWidth,
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.arrow_back_ios_new_rounded),
//                         onPressed: () {
//                           widget.controllerHistoryDonasi.animateToPage(0,
//                               duration: const Duration(milliseconds: 250),
//                               curve: Curves.ease);
//                         },
//                       ),
//                       const SizedBox(
//                         width: 25,
//                       ),
//                       Text(
//                         "Riwayat Donasi",
//                         style: Theme.of(context).textTheme.headline5,
//                       ),
//                     ],
//                   ),
//                   const Divider(
//                     thickness: 1,
//                     height: 56,
//                   ),
//                   Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       side: BorderSide(
//                         color: navButtonPrimary.withOpacity(0.4),
//                       ),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: FutureBuilder(
//                         future: kategoriHistoryDonasi,
//                         builder: (context, snapshot) {
//                           if (snapshot.hasData) {
//                             List snapData = snapshot.data! as List;
//                             if (snapData[0] != 404) {
//                               return ScrollConfiguration(
//                                 behavior:
//                                     ScrollConfiguration.of(context).copyWith(
//                                   dragDevices: {
//                                     PointerDeviceKind.touch,
//                                     PointerDeviceKind.mouse,
//                                   },
//                                 ),
//                                 child: ListView.builder(
//                                   shrinkWrap: true,
//                                   scrollDirection: Axis.vertical,
//                                   controller: ScrollController(),
//                                   physics: const ClampingScrollPhysics(),
//                                   itemCount: snapData[1].length,
//                                   itemBuilder: (context, index) {
//                                     return Card(
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(20),
//                                         side: BorderSide(
//                                           color:
//                                               navButtonPrimary.withOpacity(0.4),
//                                         ),
//                                       ),
//                                       color: scaffoldBackgroundColor,
//                                       child: ListTile(
//                                         title: responsiveText(
//                                             snapData[1][index]
//                                                 ['jenis_kebutuhan'],
//                                             18,
//                                             FontWeight.w700,
//                                             darkText),
//                                         subtitle: responsiveText(
//                                             snapData[1][index]
//                                                 ['kode_proposal_kegiatan'],
//                                             12,
//                                             FontWeight.w400,
//                                             darkText),
//                                         trailing: Container(
//                                           width: deviceWidth / 2 * 0.2,
//                                           child: responsiveText(
//                                               "Rp. ${snapData[1][index]['budget_kebutuhan']}",
//                                               16,
//                                               FontWeight.w700,
//                                               darkText),
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               );
//                             }
//                           }
//                           return loadingIndicator();
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
