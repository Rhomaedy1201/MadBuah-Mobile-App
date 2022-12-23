import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_madbuah/helper_widget/botnavbar.dart';
import 'package:project_madbuah/pages/search_results.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFFFC085),
        iconTheme: const IconThemeData(
          color: Color(0xffF2861E),
        ),
        centerTitle: true,
        title: const Text(
          "Cari Produk",
          style: TextStyle(
            fontSize: 16,
            color: Color(0xffF2861E),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              child: TextField(
                onSubmitted: (value) {
                  Get.to(SearchResults(
                    nama_produk: controller.text,
                  ));
                },
                controller: controller,
                enableInteractiveSelection: true,
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
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Pencarian Terdahulu',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Hapus Pencarian',
                      style: TextStyle(color: Color(0xffF2861E)),
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView.builder(
                  itemCount: 3,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return const Card(
                      child: ListTile(
                        title: Text('Apel'),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
