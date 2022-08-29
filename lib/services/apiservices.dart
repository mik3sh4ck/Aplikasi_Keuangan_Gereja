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
}
