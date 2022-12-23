import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:project_madbuah/widgets/loading.dart';
import '/pages/detail_poduct.dart';
import '/http/networks.dart';
import 'package:http/http.dart' as http;

class SearchResults extends StatefulWidget {
  var nama_produk;
  SearchResults({super.key, this.nama_produk});

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  var controllerRusults = TextEditingController();
  bool isLoading = false;

  Networks network = Networks();

  Map<String, dynamic> resultProduk = {};
  List listProduk = [];
  Future<void> getProduk() async {
    setState(() {
      isLoading = true;
    });
    try {
      Uri url = Uri.parse(
          "${network.search_produk}?nama_produk=${widget.nama_produk}");
      var response = await http.get(url);
      resultProduk = jsonDecode(response.body);
      listProduk = resultProduk['result'];
      print(resultProduk['type']);
    } catch (e) {
      log(e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getProduk();
    setState(() {
      controllerRusults.text = widget.nama_produk;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const LoadingWidget()
        : Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: const Color(0xFFFFC085),
              iconTheme: const IconThemeData(
                color: Color(0xffF2861E),
              ),
              centerTitle: true,
              title: const Text(
                "Hasil Pencarian",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xffF2861E),
                ),
              ),
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      margin: EdgeInsets.all(20),
                      child: TextField(
                        enabled: false,
                        controller: controllerRusults,
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Cari Buah',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Color(0xffF2861E)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: (resultProduk['type'] == false)
                        ? Container(
                            width: 300,
                            height: 270,
                            // color: Colors.amber,
                            child: Column(
                              children: [
                                Container(
                                  width: 200,
                                  child: Lottie.asset(
                                      'assets/lottie/search-failed.json'),
                                ),
                                const Text(
                                  "Hasil tidak ditemukan!!!",
                                  style: TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "Hasil tidak Produk kosong atau coba cari produk yang lain!",
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xffF2861E),
                                  ),
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text("Cari Produk"),
                                ),
                              ],
                            ),
                          )
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 20,
                              childAspectRatio: 8 / 9,
                            ),
                            itemCount: listProduk.length,
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  Get.to(DetailProduct(
                                    id_produk: listProduk[index]['id_produk'],
                                  ));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF9F8F8),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0xFFC2C2C2),
                                        blurRadius: 2,
                                        offset: Offset(0, 0), // Shadow position
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFECECEC),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          ),
                                          image: DecorationImage(
                                              image: MemoryImage(
                                            base64Decode(listProduk[index]
                                                ['foto_produk']),
                                          )),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 7,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${listProduk[index]['nama_produk']}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xff727272),
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              "Rp${NumberFormat('#,###').format(listProduk[index]['harga'])}"
                                                  .replaceAll(",", "."),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w900,
                                                color: Color(0xffF2861E),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
  }
}
