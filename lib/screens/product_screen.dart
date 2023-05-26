import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_app/local_db/db_helper.dart';
import 'package:shopping_app/screens/cart_screen.dart';
import 'package:shopping_app/utils/color.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final BASEURL = "https://mocki.io/v1/";
  final endpoint = "9598715b-2a0b-4f27-b249-806240828aec";
  List<dynamic> alldata = [];
  List<dynamic> _localallData = [];

  // Api Call
  void getData() async {
    var response = await http.get(Uri.parse(BASEURL + endpoint));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      alldata = data["data"];
      // print(alldata);
      setState(() {});
    } else {
      print("Error");
      setState(() {});
    }
  }

  // Add  local data
  Future<void> addData(
      int id, String imgUrl, String name, String desc, String price) async {
    await SQLHelper.insertData(id, imgUrl, name, desc, price);
  }

  void getLocalData() async {
    final data = await SQLHelper.getAllDate();
    setState(() {
      _localallData = data;
      print(_localallData.length);
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    getLocalData();
  }

  @override
  Widget build(BuildContext context) {
    getLocalData();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Catalog App",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    "Trending Products",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: cardColor, borderRadius: BorderRadius.circular(20)),
                child: const TextField(
                  cursorColor: themeColor,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.black45,
                      ),
                      hintText: "Search Product",
                      hintStyle: TextStyle(color: Colors.black45)),
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // Product List
            Expanded(
              child: alldata == null || alldata.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: themeColor,
                      ),
                    )
                  : ListView.builder(
                      itemCount: alldata.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Card(
                            elevation: 0,
                            color: cardColor,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 8.0),
                              child: ListTile(
                                leading: Image.network(alldata[index]["image"]),
                                title: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        alldata[index]["name"],
                                        style: const TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        alldata[index]["description"],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black45),
                                      )
                                    ],
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 0.0, horizontal: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        alldata[index]["price"],
                                        style: const TextStyle(
                                            fontSize: 19.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: themeColor,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20))),
                                        onPressed: () async {
                                          addData(
                                              alldata[index]["id"],
                                              alldata[index]["image"],
                                              alldata[index]["name"],
                                              alldata[index]["description"],
                                              alldata[index]["price"]);

                                              setState(() {
                                                getLocalData();
                                            
                                              });
                                        },
                                        child: const Icon(
                                          Icons.shopping_cart,
                                          size: 20,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      // floating button of cart products
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CartScreen(),
            ),
          );
        },
        child: Stack(
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 15,
                height: 15,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    _localallData.length.toString(),
                    style: TextStyle(color: Colors.black, fontSize: 10),
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100)),
              ),
            ),
          ],
        ),
        backgroundColor: themeColor,
      ),
    );
  }
}
