import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vajro/products.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  List<Product> summa = [];

  @override
  void initState() {
    super.initState();
    callApi();
  }

  callApi() async {
    String url = "https://www.mocky.io/v2/5def7b172f000063008e0aa2";
    var response = await http.get(Uri.parse(url));
    // debugPrint(response.body);

    // n.putIfAbsent("products", () => jsonDecode(response.body));
    // debugPrint("$n");
    Map<String, dynamic> n = {};
    n = jsonDecode(response.body);
    summa = n["products"].map<Product>((x) => Product.fromJson(x)).toList();
    debugPrint(summa[1].toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fruits"),
      ),
      body: summa.isEmpty
          ? const Center(child: LinearProgressIndicator())
          : ListView.builder(
              shrinkWrap: true,
              itemCount: summa.length,
              itemBuilder: (ctx, i) {
                // return ListTile(
                //   title: Text("${summa[i].name}"),
                // );
                return eachCard(summa[i]);
              }),
    );
  }

  Widget eachCard(Product a) {
    int count = 0;
    int price = 0;
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
                Text("${a.name}"),
                Text("${a.price}"),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          if (count == 0) {
                          } else {
                            setState(() {
                              count = count - 1;
                              // price = (a.price! * count);
                            });
                          }
                        },
                        icon: const Icon(Icons.remove)),
                    Text("${count}"),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            count = count + 1;
                            print(a.price);
                            String b = (a.price)!.substring(1); // + ".00";
                            print(b);
                            var c = b.split(",");
                            String temp = "";
                            for (var i = 0; i < c.length; i++) {
                              temp = temp + c[i];
                            }
                            var d = temp.trim();
                            print(d);
                            price = (int.parse(d) * count);
                            print(price);
                          });
                        },
                        icon: const Icon(Icons.add))
                  ],
                ),
              ],
            ),
            Text("$price")
          ]),
        ),
      ),
    );
  }
}
