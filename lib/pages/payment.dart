import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:project_madbuah/widgets/loading.dart';
import 'package:url_launcher/url_launcher.dart';
import '/controller/controll.dart';
import '/http/networks.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/helper_widget/botnavbar.dart';
import 'package:whatsapp/whatsapp.dart';
import 'package:http/http.dart' as http;

class Payment extends StatefulWidget {
  var id_user, id_transaksi;
  Payment({super.key, this.id_user, this.id_transaksi});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  WhatsApp whatsapp = WhatsApp();
  int phoneNumber = 6285259822974;

  bool isLoading = false;

  File? image;

  Future getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? imagePicked =
        await _picker.pickImage(source: ImageSource.gallery);
    if (imagePicked != null) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        text: 'Apakah kamu yakin ingin Menggunakan Bukti Pembayaran ini?',
        confirmBtnText: "Iya",
        onConfirmBtnTap: () async {
          setState(() {
            image = File(imagePicked.path);
            updateBuktiPembayaran();
            updateStatusTransaksi();
            Get.back();
          });
        },
        cancelBtnText: "Batal",
        showCancelBtn: true,
        onCancelBtnTap: () {
          Get.back();
        },
        title: "Warning!",
      );
    } else {
      log("upload gambar dibatalkan");
    }
    _getTransaksi();
    _getPembayaran();
  }

  Networks network = Networks();

  // update bukti Pembayaran
  GetConnect connect = GetConnect();
  Future<void> updateBuktiPembayaran() async {
    setState(() {
      isLoading = true;
    });

    try {
      Uint8List imageBytes = await image!.readAsBytesSync();
      final form = FormData({
        'bukti_pembayaran':
            MultipartFile(image, filename: 'bukti_pembayaran.png'),
      });
      final response = await connect.post(
          '${network.update_bukti_pembayaran}?id_transaksi=${widget.id_transaksi}&id_user=${widget.id_user}',
          form);
      // print(response.body);
    } catch (e) {
      print(e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  bool loadingUpdateStatus = false;
  // update status transaksi
  Future<void> updateStatusTransaksi() async {
    setState(() {
      loadingUpdateStatus = true;
    });

    try {
      Uri url = Uri.parse(
          "${network.update_status_transaksi}?status=Sudah dibayar&id_transaksi=${widget.id_transaksi}");
      var response = await http.put(url);
      print(response.body);
    } catch (e) {
      log(e.toString());
    }

    setState(() {
      loadingUpdateStatus = false;
    });
  }

  bool loadingGetTransaksi = false;
  // mangambil data transaksi
  List result = [];
  int? getCode;
  num? no_telp;
  Future<void> _getTransaksi() async {
    setState(() {
      loadingGetTransaksi = true;
    });

    try {
      Uri url = Uri.parse(
          "${network.get_transaksi}?id_transaksi=${widget.id_transaksi}&id_user=${widget.id_user}");
      var response = await http.get(url);
      var cek = jsonDecode(response.body);
      result = cek['result'];
      no_telp = num.parse(result[0]['users']['no_telp']);
      getCode = cek['code'];
    } catch (e) {
      log(e.toString());
    }

    setState(() {
      loadingGetTransaksi = false;
    });
  }

  bool loadingGetPay = false;
  // mengambil data pembayaran
  List resultPayment = [];
  Future<void> _getPembayaran() async {
    setState(() {
      loadingGetPay = true;
    });

    try {
      Uri url = Uri.parse("${network.get_metode_pembayaran}");
      var response = await http.get(url);
      resultPayment = jsonDecode(response.body)['result'];
    } catch (e) {
      log(e.toString());
    }

    setState(() {
      loadingGetPay = false;
    });
  }

  void launchWhatsapp({@required number, @required message}) async {
    String url = "whatsapp://send?phone=$number&text=$message";
    var cek = Uri.parse(url);
    launchUrl(cek);
    print(cek);
  }

  @override
  void initState() {
    _getTransaksi();
    _getPembayaran();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loadingGetPay
        ? const Scaffold(
            body: LoadingWidget(),
          )
        : Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Color(0xFFFFC085),
              iconTheme: const IconThemeData(
                color: Color(0xffF2861E),
              ),
              centerTitle: true,
              title: InkWell(
                onTap: () {},
                child: const Text(
                  "Pembayaran",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xffF2861E),
                  ),
                ),
              ),
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                _getTransaksi();
                _getPembayaran();
              },
              child: ListView(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: result.length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          (result[index]['transaksi']['bukti_pembayaran'] == "")
                              ? Container()
                              : Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 17, vertical: 10),
                                  color: const Color(0xFF1EBA8E),
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.credit_score_rounded,
                                        size: 23,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Pembayaran Berhasil!",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 13,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Total yang harus dibayar : ",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF565656),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Rp ${NumberFormat('#,###').format(result[index]['transaksi']['total_pembayaran'])}"
                                      .replaceAll(",", "."),
                                  // "Rp",
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF565656),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  "*Belum termasuk ongkos kirim",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF565656),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  Container(
                    width: double.infinity,
                    height: 3,
                    color: Color(0xFFF5E2D0),
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 13,
                      ),
                      child: loadingGetPay
                          ? const LoadingWidget()
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: resultPayment.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Metode Pembayaran :",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF565656),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "${resultPayment[index]['nama_pembayaran']}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF565656),
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      "No.Rek : ${resultPayment[index]['no_rekening']}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF565656),
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      "Nama : ${resultPayment[index]['nama_pemilik']}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF565656),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            )),
                  Container(
                    width: double.infinity,
                    height: 3,
                    color: const Color(0xFFF5E2D0),
                  ),
                  const SizedBox(height: 10),
                  Container(
                      child: loadingGetTransaksi
                          ? const LoadingWidget()
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: result.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 5),
                                    const Text(
                                      "Bukti Pembayaran",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF565656),
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    InkWell(
                                      onTap: () async {
                                        getImage();
                                        _getPembayaran();
                                        _getTransaksi();
                                      },
                                      child: Container(
                                        width: 170,
                                        height: 200,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE7E7E7),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: (result[index]['transaksi']
                                                    ['bukti_pembayaran'] !=
                                                "")
                                            ? image != null
                                                ? Image.file(
                                                    image!,
                                                    fit: BoxFit.contain,
                                                  )
                                                : Image(
                                                    image: MemoryImage(
                                                        base64Decode(result[
                                                                    index]
                                                                ['transaksi'][
                                                            'bukti_pembayaran'])),
                                                  )
                                            : image != null
                                                ? Image.file(
                                                    image!,
                                                    fit: BoxFit.contain,
                                                  )
                                                : const Icon(
                                                    Icons
                                                        .add_photo_alternate_outlined,
                                                    size: 55,
                                                    color: Color(0xFF7D7D7D),
                                                  ),
                                      ),
                                    )
                                  ],
                                );
                              },
                            )),
                  const SizedBox(height: 10),
                  loadingGetTransaksi
                      ? const LoadingWidget()
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: result.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xffF2861E),
                                  ),
                                  onPressed: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    String? lastValueId =
                                        await Controller1.getCheckIdUser();
                                    String? currentId = lastValueId as String?;
                                    setState(() {});
                                    Get.offAll(Navbar(
                                      id_user: currentId,
                                    ));
                                  },
                                  child: (result[index]['transaksi']
                                              ['bukti_pembayaran'] ==
                                          "")
                                      ? const Text("Kembali dan Upload Nanti")
                                      : const Text("Kembali ke halaman utama"),
                                ),
                                (result[index]['transaksi']
                                            ['bukti_pembayaran'] ==
                                        "")
                                    ? Container()
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: resultPayment.length,
                                        itemBuilder: (context, indexPay) {
                                          return ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Color(0xFF1CC127),
                                            ),
                                            onPressed: () async {
                                              launchWhatsapp(
                                                  number: 6282131802740,
                                                  message: "Hallo gan\nsaya sudah melakukan order dan pembayaran dengan\nNo Transaksi : MD-${result[0]['id_transaksi']}" +
                                                      "\n" +
                                                      "Nama Barang : " +
                                                      "${result[index]['produk'][0]['nama_produk']}" +
                                                      "\nJumlah : ${result[index]['detail_transaksi']['qty']}\nTotal : Rp${NumberFormat('#,###').format(result[0]['detail_transaksi']['total'])}"
                                                          .replaceAll(
                                                              ",", ".") +
                                                      "\nKe Rekening : ${resultPayment[indexPay]['nama_pembayaran']}" +
                                                      "\nNo : ${resultPayment[indexPay]['no_rekening']}" +
                                                      "\nNama : ${resultPayment[indexPay]['nama_pemilik']}");
                                            },
                                            child: const Text("Chat Penjual"),
                                          );
                                        },
                                      )
                              ],
                            );
                          },
                        )
                ],
              ),
            ),
          );
  }
}
