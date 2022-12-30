import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project_madbuah/widgets/loading.dart';
import '/http/networks.dart';
import '/pages/category.dart';
import '/pages/detail_poduct.dart';
import '/pages/search_page.dart';
import 'package:http/http.dart' as http;

class DashboardPage extends StatefulWidget {
  var id_user;
  DashboardPage({Key? key, this.id_user}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _cardController = PageController();
  Networks network = Networks();

  int _current = 0;
  final CarouselController _controller = CarouselController();

  final List<String> imgList = [
    'assets/bg/bg4.webp',
    'assets/bg/bg2.jpeg',
    'assets/bg/bg3.jpeg',
  ];

  bool isLoading = false;

  Map<String, dynamic> result = {};
  String? listUser;
  Future<void> _getUser() async {
    setState(() {
      isLoading = true;
    });
    try {
      Uri url = Uri.parse("${network.get_user}?id_user=${widget.id_user}");
      var response = await http.get(url);
      result = jsonDecode(response.body);
      listUser = result['result'][0]['fullname'];
      print(listUser);
    } catch (e) {
      log(e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  Map<String, dynamic> resultProduk = {};
  List listProduk = [];
  Future<void> getProduk() async {
    setState(() {
      isLoading = true;
    });
    try {
      Uri url = Uri.parse("${network.get_produk}");
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

  Map<String, dynamic> resultKategori = {};
  List listKategori = [];
  Future<void> getKategori() async {
    setState(() {
      isLoading = true;
    });
    _getUser();
    try {
      Uri url = Uri.parse("${network.get_kategori}");
      var response = await http.get(url);
      resultKategori = jsonDecode(response.body);
      listKategori = resultKategori['result'];
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
    getKategori();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(
            body: LoadingWidget(),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 25),
                    child: Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 15),
                      padding: const EdgeInsets.only(left: 15, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: const Icon(
                                  Icons.person,
                                  size: 40,
                                  color: Color(0xffF2861E),
                                ),
                                // color: Colors.amber,
                              ),
                              const SizedBox(width: 2),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Hallo",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff727272)),
                                  ),
                                  Text(
                                    "${listUser}",
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff000000)),
                                  ),
                                  // Text("${resultUser[index]['fullname']}")
                                ],
                              ),
                            ],
                          ),
                          Container(
                            width: 45,
                            height: 45,
                            child: IconButton(
                              onPressed: () {
                                Get.to(SearchPage());
                              },
                              icon: Icon(Icons.search),
                              color: Colors.white,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Color(0xffF2861E)),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: CarouselSlider(
                      carouselController: _controller,
                      options: CarouselOptions(
                          autoPlay: true,
                          enlargeCenterPage: true,
                          aspectRatio: 1.7,
                          viewportFraction: 1.0,
                          onPageChanged: (index, reason) {
                            _current = index;
                            setState(() {});
                          }),
                      items: imgList
                          .map((item) => Container(
                                child: Container(
                                  margin: const EdgeInsets.all(5.0),
                                  child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(7.0)),
                                      child: Stack(
                                        children: <Widget>[
                                          Image(
                                            image: AssetImage(
                                              item,
                                            ),
                                            fit: BoxFit.cover,
                                            width: 1000.0,
                                          ),
                                          Positioned(
                                            bottom: 0.0,
                                            left: 0.0,
                                            right: 0.0,
                                            child: Container(
                                              decoration: const BoxDecoration(),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 20.0),
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: imgList.asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () => _controller.animateToPage(entry.key),
                        child: Container(
                          width: 9.0,
                          height: 8.0,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : const Color(0xffF2861E))
                                  .withOpacity(
                                      _current == entry.key ? 0.9 : 0.4)),
                        ),
                      );
                    }).toList(),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 5, left: 20, right: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Kategori",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.to(CategoryPage());
                              },
                              child: const Text(
                                "Lihat Semua >",
                                style: TextStyle(color: Color(0xffF2861E)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 80,
                    padding: EdgeInsets.symmetric(horizontal: 19),
                    child: ListView.builder(
                      itemCount: listKategori.length,
                      shrinkWrap: false,
                      physics: const ScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.to(CategoryPage(
                                  id_body: index + 1,
                                ));
                              },
                              borderRadius: BorderRadius.circular(20),
                              splashColor: Color(0xffF2861E),
                              child: Container(
                                width: 220,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 7),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 4),
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
                                child: Row(
                                  children: [
                                    Container(
                                      width: 55,
                                      height: 55,
                                      decoration: BoxDecoration(
                                        color: Color(0xffF2861E),
                                        borderRadius: BorderRadius.circular(12),
                                        image: DecorationImage(
                                          image: MemoryImage(
                                            base64Decode(listKategori[index]
                                                ['gambar_kategori']),
                                          ),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 140,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${listKategori[index]['nama_kategori']}",
                                            maxLines: 1,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            "${listKategori[index]['keterangan_kategori']}",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xff727272),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10)
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Semua Buah",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        GridView.builder(
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
                                  id_user: widget.id_user,
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
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          );
  }
}
