import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:project_madbuah/widgets/loading.dart';
import '/pages/checkout_page.dart';
import 'package:quickalert/quickalert.dart';
import '/http/networks.dart';

class DetailProduct extends StatefulWidget {
  var id_produk, id_user;
  DetailProduct({super.key, this.id_produk, this.id_user});

  @override
  State<DetailProduct> createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  Networks network = Networks();
  int jml = 1;
  bool isLoading = false;

  Map<String, dynamic> resultProduk = {};
  List listProduk = [];
  Future<void> getProduk() async {
    setState(() {
      isLoading = true;
    });

    try {
      Uri url =
          Uri.parse("${network.get_produk}?id_produk=${widget.id_produk}");
      var response = await http.get(url);
      resultProduk = jsonDecode(response.body);
      listProduk = resultProduk['result'];
    } catch (e) {
      log(e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  bool loadingUser = false;
  Map<String, dynamic> result = {};
  Future<void> _getUser() async {
    setState(() {
      loadingUser = true;
    });

    try {
      Uri url = Uri.parse("${network.get_user}?id_user=${widget.id_user}");
      var response = await http.get(url);
      result = jsonDecode(response.body);
      print(result['result'][0]['status']);
    } catch (e) {
      log(e.toString());
    }

    setState(() {
      loadingUser = false;
    });
  }

  @override
  void initState() {
    getProduk();
    _getUser();
    print(widget.id_user);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(
            body: LoadingWidget(),
          )
        : Scaffold(
            bottomNavigationBar: ListView.builder(
              shrinkWrap: true,
              itemCount: result.length,
              itemBuilder: (context, index) {
                return loadingUser
                    ? const LoadingWidget()
                    : Container(
                        width: double.infinity,
                        height: 80,
                        padding: const EdgeInsets.symmetric(
                            vertical: 13, horizontal: 25),
                        child: ElevatedButton(
                          onPressed: () {
                            (result['result'][index]['status'] == "admin")
                                ? QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.warning,
                                    text:
                                        'Anda sebagai penjual,\ntidak bisa melakukan transaksi!',
                                    confirmBtnText: "Iya",
                                    confirmBtnColor: const Color(0xffF2861E),
                                    onConfirmBtnTap: () async {
                                      Get.back();
                                    },
                                    title: "Warning!",
                                  )
                                : Get.to(CheckoutPage(
                                    id_produk: widget.id_produk,
                                    qty: jml.toInt(),
                                  ));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffF2861E),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              )),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            decoration: BoxDecoration(
                              // color: Color(0xffF2861E),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: const Icon(
                                    Icons.navigate_next_rounded,
                                    size: 40,
                                    color: Color(0xffF2861E),
                                  ),
                                ),
                                Text(
                                  "Beli Sekarang".toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                                Container(
                                  width: 35,
                                )
                              ],
                            ),
                          ),
                        ),
                      );
              },
            ),
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Color(0xFFFFC085),
              iconTheme: const IconThemeData(
                color: Color(0xffF2861E),
              ),
              centerTitle: true,
              title: const Text(
                "Detail Produk",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xffF2861E),
                ),
              ),
            ),
            body: ListView.builder(
              itemCount: resultProduk.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 320,
                      width: double.infinity,
                      color: const Color(0xFFECECEC),
                      child: Image(
                        image: MemoryImage(
                            base64Decode(listProduk[index]['foto_produk'])),
                        fit: BoxFit.contain,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 30,
                        horizontal: 25,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 210,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${listProduk[index]['nama_produk']}",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Text(
                                      "Rp${NumberFormat('#,###').format(listProduk[index]['harga'])}"
                                          .replaceAll(",", "."),
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "/${listProduk[index]['kategori']}",
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff727272),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: 80,
                            height: 35,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 2, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0xFFEBEBEB),
                                  blurRadius: 2,
                                  offset: Offset(0, 0), // Shadow position
                                ),
                              ],
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (jml <= 1) {
                                      } else {
                                        jml -= 1;
                                      }
                                    });
                                  },
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFDBB9),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: const Icon(
                                      Icons.remove,
                                      size: 20,
                                      color: Color(0xffF2861E),
                                    ),
                                  ),
                                ),
                                Text(
                                  "$jml",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (jml >= listProduk[index]['qty']) {
                                      } else {
                                        jml += 1;
                                      }
                                    });
                                  },
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffF2861E),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                "Stok",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(width: 100),
                              Row(
                                children: [
                                  Text(
                                    "${listProduk[index]['qty']}",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    "/${listProduk[index]['kategori']}",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff727272),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "Keterangan",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            width: double.infinity,
                            child: Text("${listProduk[index]['keterangan']}"),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          );
  }
}
