import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '/http/networks.dart';
import 'package:http/http.dart' as http;
import '/pages/detail_poduct.dart';

class CategoryOne extends StatefulWidget {
  var nama_kategori;
  CategoryOne({super.key, this.nama_kategori});

  @override
  State<CategoryOne> createState() => _CategoryOneState();
}

class _CategoryOneState extends State<CategoryOne> {
  Networks network = Networks();

  Map<String, dynamic> resultKategori = {};
  List listKat = [];

  Map<String, dynamic> resultProduk = {};
  List listProduk = [];
  Future<void> getProduk() async {
    // api get kategori
    Uri url2 = Uri.parse("${network.get_kategori}");
    var response2 = await http.get(url2);
    resultKategori = jsonDecode(response2.body);
    listKat = resultKategori['result'];

    // Api get produk
    Uri url = Uri.parse(
        "${network.get_produk_kategori}?nama_kategori=${listKat[0]['nama_kategori']}");
    var response = await http.get(url);
    resultProduk = jsonDecode(response.body);
    listProduk = resultProduk['result'];
    // print(listProduk);
    setState(() {});
  }

  @override
  void initState() {
    getProduk();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
              color: const Color(0xFFF9F8F8),
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      base64Decode(listProduk[index]['foto_produk']),
                    )),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      SizedBox(height: 5),
                      Text(
                        "Rp${NumberFormat('#,###').format(listProduk[index]['harga'])}"
                            .replaceAll(",", "."),
                        style: TextStyle(
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
    );
  }
}
