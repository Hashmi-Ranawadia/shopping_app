import 'package:flutter/material.dart';
import 'package:shopping_app/utils/color.dart';

import '../local_db/db_helper.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<dynamic> _allData = [];
  var totalPrice = 0;

  // Get Local Data
  void getLocalData() async {
    final data = await SQLHelper.getAllDate();
    setState(() {
      _allData = data;
      print(_allData);
    });
    if (totalPrice == 0) {
      for (int i = 0; i < _allData.length; i++) {
        totalPrice += int.parse(_allData[i]["price"].substring(1));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getLocalData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: themeColor,
          ),
        ),
        backgroundColor: Colors.white,
        title: const Text(
          "Cart",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // List of cart products
            Expanded(
              child: ListView.builder(
                itemCount: _allData.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.check,
                          color: Colors.black45,
                        ),
                        title: Text(_allData[index]["name"]),
                        trailing: IconButton(
                          onPressed: () {
                            SQLHelper.deletedata(_allData[index]["id"]);
                            setState(() {
                              getLocalData();
                              totalPrice -=
                                  int.parse(
                                      _allData[index]["price"].substring(1));
                              print(totalPrice);        
                            });
                          },
                          icon: const Icon(
                            Icons.remove_circle_outline_outlined,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                      const Divider()
                    ],
                  );
                },
              ),
            ),

            // Total price of cart and buy button
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${totalPrice}",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: themeColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      onPressed: () {},
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("Buy"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
