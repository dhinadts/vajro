import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vajro/products.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

import 'bloc/total.dart';
import 'dbhelper.dart';
import 'package:retrofit/retrofit.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  List<Product> summa = [];
  late Database db1;
  var db = DatabaseHelper();
  late List<Map<String, dynamic>> newData1;
  var counts;
  List<int> samplCount = [];
  double total = 0.0;
  var tt = CalculateTotalBloc();

  @override
  void initState() {
    super.initState();
    dbmove();
    callApi();
  }

  dbmove() async {
    await db.db_move();
    newData1 = await db.any_query(
      "select * from products",
    );
    print(newData1.toString());
    if (newData1.isEmpty) {
    } else {
      for (int i = 0; i < newData1.length; i++) {
        total = total + newData1[i]["price"];
        setState(() {});
      }
    }
  }

  callApi() async {
    String url = "https://www.mocky.io/v2/5def7b172f000063008e0aa2";
    var response = await http.get(Uri.parse(url));

    Map<String, dynamic> n = {};
    n = jsonDecode(response.body);
    summa =
        await n["products"].map<Product>((x) => Product.fromJson(x)).toList();
    // var aa = await summa[1].toJson();
    // debugPrint(aa.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fruits"),
      ),
      body: summa.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: summa.length + 1,
                    itemBuilder: (ctx, i) {
                      // return ListTile(
                      //   title: Text("${summa[i].name}"),
                      // );
                      int count = 0;
                      samplCount.add(0);
                      if (i < summa.length) {
                        return eachCard(summa[i], count);
                      } else {
                        return const SizedBox(height: 110.0);
                      }
                    }),

                // if (false)
                Positioned(
                    bottom: 8.0,
                    // top: MediaQuery.of(context).size.height - 100,
                    left: 8.0,
                    right: 8.0,
                    child: Container(
                      height: 100.0,
                      width: MediaQuery.of(context).size.width - 8.0,
                      color: Colors.red,
                      child: Center(
                        child: Text("Total: ₹${total}"),
                      ),
                    ))
              ],
            ),
    );
  }

  Future<dynamic> fun(Product a) async {
    int dummy = 0;
    List<Map<dynamic, dynamic>> aa = await db.any_query(
        "select total_counts, price from products where product_id = \'${a.productId}\'");
    // print("tttt ----  $aa");
    // print(aa.isEmpty ? "0" : aa[0]["total_counts"]);
    setState(() {
      dummy = aa.isEmpty ? 0 : int.parse(aa[0]["total_counts"].toString());

      // int.parse(aa[0]["total_counts"].toString());
    });
    return dummy;
  }

  Widget eachCard(Product a, int count) {
    int totalCounts = 0;
    List<Map<dynamic, dynamic>> aa = [];
    // fun(a).then((value) {
    //   aa = value;
    // });
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Container(
          color: Colors.white,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Image.network("${a.image}", height: 100, width: 80),
            ),
            Column(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: Text(
                      "${a.name}",
                      overflow: TextOverflow.ellipsis,
                    )),
                Text("${a.price}"),
                Row(
                  children: [
                    IconButton(
                        onPressed: () async {
                          count = count - 1;
                          aa = await db.any_query(
                              "select total_counts, price from products where product_id = \'${a.productId}\'");

                          if (aa.isEmpty && count <= 0) {
                            // await db.any_query(
                            //   "INSERT INTO products (product_name, product_id, total_counts, price) VALUES (\'${a.name.toString()}\', \'${int.tryParse(a.id.toString())}\', \'$count\', \'${a.price.toString()}\')",
                            // );
                          } else {
                            count =
                                int.parse(aa[0]["total_counts"].toString()) - 1;

                            double price1 =
                                count * double.parse(aa[0]["price"].toString());
                            if (count == 0) {
                              await db.any_query(
                                  "DELETE FROM products WHERE product_id = \'${a.productId}\'");
                            } else {
                              await db.any_query(
                                  "UPDATE products SET total_counts=\'$count\', price=\'$price1\' WHERE product_id = \'${a.productId}\'");
                            }
                          }
                          aa = await db.any_query(
                              "select total_counts from products where product_id = \'${a.productId}\'");
                        },
                        icon: const Icon(Icons.remove)),
                    Text("$count"),
                    IconButton(
                        onPressed: () async {
                          count = count + 1;
                          aa = await db.any_query(
                              "select total_counts, price from products where product_id = \'${a.productId}\'");
                          if (aa.isEmpty && count == 1) {
                            String pp = "";
                            for (int i = 0;
                                i < a.price.toString().length;
                                i++) {
                              if (i == 0) {
                              } else {
                                if (a.price.toString()[i] == ",") {
                                } else {
                                  pp = pp + a.price.toString()[i];
                                }
                              }
                            }
                            double price1 = count * double.parse(pp.trim());
                            await db.any_query(
                              "INSERT INTO products (product_name, product_id, total_counts, price) VALUES (\'${a.name.toString()}\', \'${int.tryParse(a.id.toString())}\', \'$count\', \'${price1}\')",
                            );
                          } else {
                            count =
                                1 + int.parse(aa[0]["total_counts"].toString());
                            String pp = "";
                            for (int i = 0;
                                i < aa[0]["price"].toString().length;
                                i++) {
                              if (i == 0) {
                              } else {
                                if (aa[0]["price"].toString()[i] == ",") {
                                } else {
                                  pp = pp + aa[0]["price"].toString()[i];
                                }
                              }
                            }
                            double price1 = count * double.parse(pp.trim());
                            await db.any_query(
                                "UPDATE products SET total_counts=\'$count\', price=\'$price1\' WHERE product_id = \'${a.productId}\'");
                          }
                          aa = await db.any_query(
                              "select total_counts from products where product_id = \'${a.productId}\'");
                        },
                        icon: const Icon(Icons.add))
                  ],
                ),
              ],
            ),
            Text(aa.isEmpty ? "₹0" : "₹+${aa[0]["price"].toString()}")
          ]),
        ),
      ),
    );
  }
}
