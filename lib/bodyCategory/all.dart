import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project_madbuah/controller/controll.dart';
import 'package:project_madbuah/widgets/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/http/networks.dart';
import '/pages/detail_poduct.dart';
import 'package:http/http.dart' as http;

class AllCategory extends StatefulWidget {
  var idUser;
  AllCategory({this.idUser, super.key});

  @override
  State<AllCategory> createState() => _AllCategoryState();
}

class _AllCategoryState extends State<AllCategory> {
  bool isLoading = false;
  Networks network = Networks();

  Map<String, dynamic> resultProduk = {};
  List listProduk = [];
  Future<void> getProduk() async {
    setState(() {
      isLoading = true;
    });
    try {
      Uri url = Uri.parse("${network.get_produk_kategori}");
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
  String? currentId;
  Future<void> getUser() async {
    setState(() {
      loadingUser = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastValueId = await Controller1.getCheckIdUser();
    setState(() {
      currentId = lastValueId as String?;
    });
    print("currend $currentId");

    setState(() {
      loadingUser = false;
    });
  }

  @override
  void initState() {
    getProduk();
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const LoadingWidget()
        : GridView.builder(
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
              return loadingUser
                  ? const LoadingWidget()
                  : InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        Get.to(DetailProduct(
                          id_produk: listProduk[index]['id_produk'],
                          id_user: currentId,
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
                                  base64Decode(
                                      listProduk[index]['foto_produk']),
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
          );
  }
}
