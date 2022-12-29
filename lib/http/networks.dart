import 'package:get/get.dart';

class Networks {
  final get_produk =
      "http://192.168.1.4/restApi_madBuah/produk/get_produk.php".obs;
  final get_user =
      "http://192.168.1.4/restApi_madBuah/data_user/get_user.php".obs;
  final login_user =
      "http://192.168.1.4/restApi_madBuah/data_user/login.php".obs;
  final register_user =
      "http://192.168.1.4/restApi_madBuah/data_user/post_user.php".obs;
  final get_kategori =
      "http://192.168.1.4/restApi_madBuah/kategori/get_kategori.php".obs;
  final search_produk =
      "http://192.168.1.4/restApi_madBuah/produk/search_produk.php".obs;
  final get_produk_kategori =
      "http://192.168.1.4/restApi_madBuah/kategori/get_produk_kategori.php".obs;
  final put_user =
      "http://192.168.1.4/restApi_madBuah/data_user/put_user.php".obs;
  final get_transaksi =
      "http://192.168.1.4/restApi_madBuah/transaksi/get_transaksi.php".obs;
  final get_metode_pembayaran =
      "http://192.168.1.4/restApi_madBuah/motode_pembayaran/get_metode_pembayaran.php"
          .obs;
  final get_idTransaksi =
      "http://192.168.1.4/restApi_madBuah/transaksi/get_idTransaksi.php".obs;
  final post_transaksi =
      "http://192.168.1.4/restApi_madBuah/transaksi/post_transaksi.php".obs;
  final post_detail_transaksi =
      "http://192.168.1.4/restApi_madBuah/transaksi/post_detail_transaksi.php"
          .obs;
  final update_bukti_pembayaran =
      "http://192.168.1.4/restApi_madBuah/transaksi/update_bukti_pembayaran.php"
          .obs;
  final update_status_transaksi =
      "http://192.168.1.4/restApi_madBuah/transaksi/update_status_transaksi.php"
          .obs;
}
