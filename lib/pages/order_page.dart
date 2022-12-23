import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:project_madbuah/widgets/loading.dart';
import '/http/networks.dart';
import '/pages/detail_pesanan.dart';
import 'package:http/http.dart' as http;
import '/pages/search_page.dart';

class OrderPage extends StatefulWidget {
  var id_user;
  OrderPage({Key? key, this.id_user}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  bool isLoading = false;
  Networks network = Networks();

  List result = [];
  int? getCode;
  Future<void> _getTransaksi() async {
    setState(() {
      isLoading = true;
    });
    try {
      Uri url = Uri.parse("${network.get_transaksi}?id_user=${widget.id_user}");
      var response = await http.get(url);
      var cek = jsonDecode(response.body);
      result = cek['result'];
      getCode = cek['code'];
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
            backgroundColor: Color(0xFFF0F0F0),
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Color(0xFFFFC085),
              iconTheme: const IconThemeData(
                color: Color(0xffF2861E),
              ),
              centerTitle: true,
              title: const Text(
                "Pesanan Saya",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xffF2861E),
                ),
              ),
            ),
            body: (getCode != 200)
                ? Center(
                    child: Column(
                      children: [
                        Container(
                          width: 230,
                          // color: Colors.amber,
                          child: Column(
                            children: [
                              Lottie.asset(
                                  'assets/lottie/transaction-failed.json'),
                              const Text(
                                "Transaksi Masih kosong silahkan order sesuatu yang anda suka!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff727272),
                                ),
                              ),
                              const SizedBox(height: 7),
                              ElevatedButton(
                                onPressed: () {
                                  Get.to(SearchPage());
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xffF2861E),
                                ),
                                child: const Text("Cari barang"),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          child: GridView.builder(
                            shrinkWrap: true,
                            itemCount: result.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              mainAxisSpacing: 5,
                              childAspectRatio: 10 / 2.1,
                            ),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Get.to(DetailPesanan(
                                    id_transaksi: result[index]['id_transaksi'],
                                    id_user: result[index]['users']['id_user'],
                                  ));
                                },
                                child: Container(
                                  width: double.infinity,
                                  color: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 17, vertical: 18),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "MD-${result[index]['id_transaksi']}",
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xff727272),
                                            ),
                                          ),
                                          Text(
                                            "${DateFormat("dd-MMM-yyyy HH:mm").format(DateTime.parse(result[index]['transaksi']['tanggal_beli']))}",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xff727272),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "${result[index]['produk'].length} Macam",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xff000000),
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              const Text(
                                                "pesanan",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xff727272),
                                                ),
                                              )
                                            ],
                                          ),
                                          const Icon(
                                            Icons.navigate_next_rounded,
                                            size: 25,
                                            color: Color(0xFFA0A0A0),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
          );
  }
}
