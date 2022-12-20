import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:lottie/lottie.dart';
import '/controller/controll.dart';
import '/http/networks.dart';
import 'package:http/http.dart' as http;
import '/pages/payment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutPage extends StatefulWidget {
  var id_produk;
  int? qty;
  CheckoutPage({Key? key, this.id_produk, this.qty}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool loading = false;
  bool isChecked = true;
  var active = 0;

  Networks network = Networks();

  Map<String, dynamic> result = {};
  List listUser = [];
  String? alamat;
  String? currentId;
  Future<void> _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastValueId = await Controller1.getCheckIdUser();
    setState(() {
      currentId = lastValueId as String?;
    });
    Uri url = Uri.parse("${network.get_user}?id_user=${currentId}");
    var response = await http.get(url);
    result = jsonDecode(response.body);
    listUser = result['result'];
    alamat = result['result'][0]['alamat'];
    setState(() {});
    // print(listUser);
  }

  Map<String, dynamic> resultProduk = {};
  List listProduk = [];
  int? harga;
  Future<void> getProduk() async {
    Uri url = Uri.parse("${network.get_produk}?id_produk=${widget.id_produk}");
    var response = await http.get(url);
    resultProduk = jsonDecode(response.body);
    listProduk = resultProduk['result'];
    harga = listProduk[0]['harga'] * widget.qty;
    // print(listProduk);
    setState(() {});
  }

  var idTrans;
  Future<void> TransaksiId() async {
    Uri url = Uri.parse("${network.get_idTransaksi}");
    var response = await http.get(url);
    var resultId = json.decode(response.body)['result'][0]['id_transaksi'];
    idTrans = resultId + 1;
    print(" t : ${idTrans}");
  }

  List resultPayment = [];
  Future<void> _getPembayaran() async {
    Uri url = Uri.parse("${network.get_metode_pembayaran}");
    var response = await http.get(url);
    resultPayment = jsonDecode(response.body)['result'];
    print(resultPayment);
  }

  Future<void> _postTransaksi() async {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    String tanggal_beli = dateFormat.format(DateTime.now());
    Uri url2 = Uri.parse("${network.post_transaksi}");
    var data = {
      'id_transaksi': "${idTrans}",
      'id_user': "${currentId}",
      'bukti_pembayaran': "",
      'pembayaran': "${resultPayment[0]['nama_pembayaran']}",
      'tanggal_beli': "$tanggal_beli",
      'tanggal_terima': "",
      'total_pembayaran': "$harga",
      'status': "Belum dibayar",
    };
    var response = await http.post(url2, body: data);
    var resultTransaksi = jsonDecode(response.body)[0]['type'];
    print(resultTransaksi);
    if (resultTransaksi == true) {
      _postDetailTransaksi();
      Get.offAll(
        Payment(
          id_transaksi: "${idTrans}",
          id_user: "${currentId}",
        ),
      );
    } else {
      print("gagal menambahkan transaksi");
    }
  }

  Future<void> _postDetailTransaksi() async {
    Uri url = Uri.parse("${network.post_detail_transaksi}");
    var data = {
      'id_transaksi': "${idTrans}",
      'id_produk': "${widget.id_produk}",
      'qty': "${widget.qty}",
      'total': "$harga",
    };
    var response = await http.post(url, body: data);
    print("post detail transaksi ${response.body}");
  }

  @override
  void initState() {
    _getUser();
    getProduk();
    TransaksiId();
    _getPembayaran();
    print("qty ${widget.qty}");
    print("object ${widget.id_produk}");
    Timer(
      Duration(seconds: 2),
      () {
        setState(() {
          loading = true;
        });
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (loading == false)
        ? Scaffold(
            body: Center(
              child: Container(
                width: 250,
                child: Lottie.asset('assets/lottie/loading.json'),
              ),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            bottomNavigationBar: Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xffF2861E),
                    blurRadius: 3,
                    offset: Offset(0, 0), // Shadow position
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "Total : ",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff727272)),
                      ),
                      Text(
                        "Rp${NumberFormat('#,###').format(harga)}"
                            .replaceAll(",", "."),
                        // "",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Colors.black),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _postTransaksi();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffF2861E),
                        // maximumSize: Size(100, 40),
                        fixedSize: Size(140, 40)),
                    child: const Text("Bayar"),
                  )
                ],
              ),
            ),
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Color(0xFFFFC085),
              iconTheme: const IconThemeData(
                color: Color(0xffF2861E),
              ),
              centerTitle: true,
              title: const Text(
                "Checkout",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xffF2861E),
                ),
              ),
            ),
            body: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      color: Color(0xFFEFEFEF),
                      width: double.infinity,
                      child: const Text(
                        "Tujuan",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF3C3C3C),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      color: Color(0xFFFFFFFF),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${listUser[0]['fullname']}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff727272),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "+(62) ${listUser[0]['no_telp']}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff727272),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "${alamat}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff727272),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      color: Color(0xFFEFEFEF),
                      width: double.infinity,
                      child: Text(
                        "Rincian Pesanan",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF3C3C3C),
                        ),
                      ),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: 1,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 2,
                        childAspectRatio: 10 / 2.1,
                      ),
                      itemBuilder: (context, index) {
                        return Container(
                          color: const Color(0xFFFFFFFF),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                        color: Color(0xFFD8D8D8),
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: MemoryImage(
                                            base64Decode(listProduk[index]
                                                ['foto_produk']),
                                          ),
                                        )),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${listProduk[index]['nama_produk']}",
                                        // "",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        "Rp${NumberFormat('#,###').format(listProduk[index]['harga'])}"
                                            .replaceAll(",", "."),
                                        // "",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xffF2861E),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Text(
                                "x${widget.qty}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF656565),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      color: Color(0xFFEFEFEF),
                      width: double.infinity,
                      child: const Text(
                        "Metode Pembayaran",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF3C3C3C),
                        ),
                      ),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      itemCount: resultPayment.length,
                      physics: const ScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 1,
                        childAspectRatio: 10 / 1.3,
                      ),
                      itemBuilder: (context, index) {
                        return Container(
                          color: Color(0xFFF9F9F9),
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${resultPayment[index]['nama_pembayaran']}",
                              ),
                              Icon(
                                Icons.check,
                                color: Color(0xffF2861E),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      color: Color(0xFFEFEFEF),
                      width: double.infinity,
                      child: const Text(
                        "Ringkasan Pembayaran",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF3C3C3C),
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 17),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Subtotal produk (${widget.qty} item)",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                "Rp${NumberFormat('#,###').format(harga)}"
                                    .replaceAll(",", "."),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            height: 20,
                            color: Color(0xffF2861E),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Subtotal Pembayaran",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                "Rp${NumberFormat('#,###').format(harga)}"
                                    .replaceAll(",", "."),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            "*Bukan termasuk ongkos kirim",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff727272),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}
