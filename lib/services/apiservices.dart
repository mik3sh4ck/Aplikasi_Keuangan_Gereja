//ignore_for_file: todo

import 'dart:convert';
import 'package:http/http.dart' as http;

var _linkPath = "http://cfin.crossnet.co.id:1323/";

class ServicesUser {
  Future getAllUser(kodeGereja) async {
    final response = await http.get(
      Uri.parse("${_linkPath}user?kode_gereja=$kodeGereja"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];

      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Get User
  Future getSingleUser(kodeuser) async {
    final response = await http.get(
      Uri.parse("${_linkPath}get-profile?kode_user=$kodeuser"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];

      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Login
  Future getAuth(username, password) async {
    final response = await http.get(
      Uri.parse("${_linkPath}login?username=$username&password=$password"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Get Kode Gereja
  Future getKodeGereja(kodeuser) async {
    final response = await http.get(
      Uri.parse("${_linkPath}get-kode-gereja?kode_user=$kodeuser"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: get kode Transaksi
  Future getKodeTransaksi(kodeGereja) async {
    final response = await http.get(
      Uri.parse("${_linkPath}kode-transaksi?kode_gereja=$kodeGereja"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: get kode Sub Transaksi
  Future getKodeSubTransaksi(idKodeTransaksi) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}kode-sub-transaksi?id_kode_transaksi=$idKodeTransaksi"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Input Kode Transaksi
  Future inputKodeTransaksi(kodeGereja, namaTransaksi, kodeTransaksi) async {
    final response = await http.post(
      Uri.parse(
          "${_linkPath}input-kode-transaksi?kode_gereja=$kodeGereja&nama_transaksi=$namaTransaksi&kode_transaksi=$kodeTransaksi"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespMessage = json.decode(response.body)['message'];
      return [jsonRespStatus, jsonRespMessage];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Input Kode Sub Transaksi
  Future inputKodeSubTransaksi(
      idKodeTransaksi, namaSubTransaksi, kodeSubTransaksi) async {
    final response = await http.post(
      Uri.parse(
          "${_linkPath}input-kode-sub-transaksi?id_kode_transaksi=$idKodeTransaksi&nama_sub_transaksi=$namaSubTransaksi&kode_sub_transaksi=$kodeSubTransaksi"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespMessage = json.decode(response.body)['message'];
      return [jsonRespStatus, jsonRespMessage];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Get Role
  Future getRole(kodeGereja) async {
    final response = await http.get(
      Uri.parse("${_linkPath}role?kode_gereja=$kodeGereja"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Input Role
  Future inputRole(kodeGereja, idPrivilege, namaRole) async {
    final response = await http.post(
      Uri.parse(
          "${_linkPath}input-role?kode_gereja=$kodeGereja&id_previlage=$idPrivilege&nama_role=$namaRole"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespMessage = json.decode(response.body)['message'];
      return [jsonRespStatus, jsonRespMessage];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Get Proposal Kegiatan
  Future getAllProposalKegiatan(kodeGereja) async {
    final response = await http.get(
      Uri.parse("${_linkPath}proposal-kegiatan?kode_gereja=$kodeGereja"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];

      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Get Item Proposal Kegiatan
  Future getAllItemProposalKegiatan(kodeKegiatan) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}item-proposal-kegiatan?kode_kegiatan_gabungan=$kodeKegiatan"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];

      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Input Kegiatan
Future inputProposalKegiatan(kodeProposalKegiatan, kodeProposalGereja, namaProposalKegiatan, penanggungjawabProposalKegiatan, mulaiProposalKegiatan, selesaiProposalKegiatan, lokasiProposalKegiatan, keteranganProposalKegiatan) async {
    final response = await http.post(
      Uri.parse(
          "${_linkPath}input-proposal-kegiatan?kode_kegiatan=$kodeProposalKegiatan&kode_gereja=$kodeProposalGereja&nama_kegiatan=$namaProposalKegiatan&penanggungjawab_1=$penanggungjawabProposalKegiatan&tanggal_acara_dimulai=$mulaiProposalKegiatan&tanggal_acara_selesai=$selesaiProposalKegiatan&lokasi_kegiatan=$lokasiProposalKegiatan&keterangan_kegiatan=$keteranganProposalKegiatan"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespMessage = json.decode(response.body)['message'];
      return [jsonRespStatus, jsonRespMessage];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Input Item Kebutuhan 
  Future inputItemKebutuhan(kodeItemProposalKegiatan, kodeProposalKegiatan, kodeProposalGereja, jenisKebutuhan, budgetKebutuhan) async {
    final response = await http.post(
      Uri.parse(
          "${_linkPath}input-item-proposal-kegiatan?kode_item_proposal_kegiatan=$kodeItemProposalKegiatan&kode_kegiatan=$kodeProposalKegiatan&kode_gereja=$kodeProposalGereja&jenis_kebutuhan=$jenisKebutuhan&budget_kebutuhan=$budgetKebutuhan"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespMessage = json.decode(response.body)['message'];
      return [jsonRespStatus, jsonRespMessage];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Input PIC
  Future inputPIC(kodeUserPIC, kodeKegiatanPIC, kodeGerejaPIC, peranPIC) async {
    final response = await http.post(
      Uri.parse(
          "${_linkPath}input-PIC?kode_user=$kodeUserPIC&kode_kegiatan=$kodeKegiatanPIC&kode_gereja=$kodeGerejaPIC&peran=$peranPIC"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespMessage = json.decode(response.body)['message'];
      return [jsonRespStatus, jsonRespMessage];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Input kebutuhan kegiatan
  Future inputKebutuhanKegiatan(tanggalKebutuhan, keteranganPengeluaran, pengeluaranKebutuhan, kodeItemProposalKegiatan) async {
    final response = await http.post(
      Uri.parse(
          "${_linkPath}input-kebutuhan-kegiatan?tanggal_kebutuhan=$tanggalKebutuhan&keterangan_pengeluaran_kebutuhan=$keteranganPengeluaran&pengeluaran_kebutuhan=$pengeluaranKebutuhan&kode_item_proposal_gabungan=$kodeItemProposalKegiatan"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespMessage = json.decode(response.body)['message'];
      return [jsonRespStatus, jsonRespMessage];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

    //TODO: Get pengeluaran item kebutuhan
  Future getPengeluaranKebutuhan(kodeGabunganPengeluaran) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}kebutuhan-kegiatan?kode_item_proposal_gabungan=$kodeGabunganPengeluaran"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];

      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }
}

