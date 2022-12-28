import 'package:flutter/material.dart';
import '/bodyCategory/all.dart';
import '/bodyCategory/category_one.dart';
import '/bodyCategory/category_two.dart';

class CategoryPage extends StatefulWidget {
  var id_body;
  CategoryPage({Key? key, this.id_body}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<String> listKategori = [
    'All',
    'Parcel Buah',
    'Buah - Buahan',
  ];

  List<Widget> bodyCategory = [
    AllCategory(),
    CategoryOne(),
    CategoryTwo(),
  ];

  var active = 0;

  @override
  void initState() {
    if (widget.id_body == null) {
      setState(() {
        active = 0;
      });
    } else {
      setState(() {
        active = widget.id_body;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFFFC085),
        iconTheme: const IconThemeData(
          color: Color(0xffF2861E),
        ),
        centerTitle: true,
        title: InkWell(
          onTap: () {
            print(widget.id_body);
          },
          child: const Text(
            "Kategori Produk",
            style: TextStyle(
              fontSize: 16,
              color: Color(0xffF2861E),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 10 / 4.2,
                  ),
                  itemCount: listKategori.length,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          active = index;
                        });
                      },
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      child: Column(
                        children: [
                          Container(
                            height: 35,
                            decoration: BoxDecoration(
                              color: const Color(0xffF2861E),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0xFFC2C2C2),
                                  blurRadius: 2,
                                  offset: Offset(0, 0), // Shadow position
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                "${listKategori[index]}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          active == index
                              ? Container(
                                  height: 4,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                )
                              : Container()
                        ],
                      ),
                    );
                  }),
            ),
            Container(
              height: 3,
              color: Color(0xFFE0E0E0),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: bodyCategory[active],
            ),
          ],
        ),
      ),
    );
  }
}
