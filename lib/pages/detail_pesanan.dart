import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:project_madbuah/http/networks.dart';
import 'package:http/http.dart' as http;
import 'package:project_madbuah/pages/payment.dart';
import 'package:project_madbuah/widgets/loading.dart';
import 'package:quickalert/quickalert.dart';

class DetailPesanan extends StatefulWidget {
  var id_user, id_transaksi;
  DetailPesanan({super.key, this.id_user, this.id_transaksi});

  @override
  State<DetailPesanan> createState() => _DetailPesananState();
}

class _DetailPesananState extends State<DetailPesanan> {
  bool isLoading = false;
  Networks network = Networks();

  List result = [];
  int? getCode;
  String? status;
  Future<void> _getTransaksi() async {
    setState(() {
      isLoading = true;
    });

    try {
      Uri url = Uri.parse(
          "${network.get_transaksi}?id_transaksi=${widget.id_transaksi}&id_user=${widget.id_user}");
      var response = await http.get(url);
      var cek = jsonDecode(response.body);
      result = cek['result'];
      getCode = cek['code'];
      status = result[0]['transaksi']['status'];
    } catch (e) {
      log(e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  // update status transaksi
  Future<void> updateStatusTransaksi() async {
    setState(() {
      isLoading = true;
    });

    try {
      Uri url = Uri.parse(
          "${network.update_status_transaksi}?status=Pesanan Selesai&id_transaksi=${widget.id_transaksi}");
      var response = await http.put(url);
      print(response.body);
    } catch (e) {
      log(e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    _getTransaksi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(
            body: LoadingWidget(),
          )
        : Scaffold(
            backgroundColor: const Color(0xFFF3F3F3),
            bottomNavigationBar: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ElevatedButton(
                onPressed: (status == "Sudah dibayar")
                    ? () {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.warning,
                          text: 'Apakah kamu yakin sudah menerima pesanan?',
                          confirmBtnText: "Iya",
                          onConfirmBtnTap: () async {
                            Get.back();
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.success,
                              title: "Berhasil menerima pesanan",
                              confirmBtnText: "👌",
                              confirmBtnColor: Color(0xFFE0E0E0),
                              onConfirmBtnTap: () {
                                _getTransaksi();
                                Get.back();
                              },
                            );
                            updateStatusTransaksi();
                          },
                          cancelBtnText: "Batal",
                          showCancelBtn: true,
                          animType: QuickAlertAnimType.slideInUp,
                          onCancelBtnTap: () {
                            Get.back();
                          },
                          title: "Warning!",
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffF2861E),
                  fixedSize: const Size(double.infinity, 45),
                ),
                child: const Text("Terima Pesanan"),
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
                "Detail Pesanan",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xffF2861E),
                ),
              ),
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                _getTransaksi();
              },
              child: ListView(
                children: [
                  Container(
                    width: double.infinity,
                    color: Color(0xFF19C2A6),
                    padding: EdgeInsets.symmetric(horizontal: 17, vertical: 15),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${result[0]['transaksi']['status']}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(Payment(
                                  id_transaksi: result[0]['id_transaksi'],
                                  id_user: result[0]['users']['id_user'],
                                ));
                              },
                              child: Row(
                                children: const [
                                  Text(
                                    "Lihat Pembayaran",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Icon(
                                    Icons.navigate_next_rounded,
                                    size: 25,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Tanggal Beli",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "${DateFormat("dd-MMM-yyyy HH:mm").format(DateTime.parse(result[0]['transaksi']['tanggal_beli']))}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                    child: Text(
                      "Barang pembelian",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1F1F1F),
                      ),
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    itemCount: result.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 0,
                      childAspectRatio: 10 / 2.17,
                    ),
                    itemBuilder: (context, index) {
                      return Container(
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 17,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 65,
                                  height: 65,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(5),
                                    image: DecorationImage(
                                      image: MemoryImage(
                                        base64Decode(result[index]['produk']
                                            [index]['foto_produk']),
                                      ),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 250,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 2,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${result[index]['produk'][index]['nama_produk']}",
                                        maxLines: 2,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Rp${NumberFormat('#,###').format(result[index]['produk'][index]['harga'])}"
                                                .replaceAll(",", "."),
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xffF2861E),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Text(
                              "${result.length}x",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 17),
                      child: Container(
                        width: double.infinity,
                        color: const Color(0xFFD4D4D4),
                        height: 1,
                      )),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 17, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total Pesanan",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Rp${NumberFormat('#,###').format(result[0]['transaksi']['total_pembayaran'])}"
                              .replaceAll(",", "."),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                    child: Text(
                      "Alamat Pengiriman",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1F1F1F),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 17, vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${result[0]['users']['fullname']}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "0${result[0]['users']['no_telp']}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${result[0]['users']['alamat']}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                    child: Text(
                      "Metode pembayaran",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1F1F1F),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 17, vertical: 15),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.payment,
                          size: 25,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "${result[0]['transaksi']['pembayaran']}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
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
