import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:mistreci/models/products.model.dart';
import 'package:mistreci/variables.dart';
import '../../models/products.model.dart';
import '../jobs/jobpage.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({Key? key}) : super(key: key);

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List products = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getAllProducts();
  }

  // var url = "http://192.168.1.6:4000/api/v1/mistreci/categories/marketplace/products/";

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: LiquidPullToRefresh(
        showChildOpacityTransition: true,
        onRefresh: refreshDataProducts,
        child: FutureBuilder<List<Products>>(
          future: getAllProducts(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int i) {
                        return GestureDetector(
                          onTap: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => JobDetailScreen(
                                  category: snapshot.data![i].category,
                                  title: snapshot.data![i].productName,
                                  description: snapshot.data![i].description,
                                  contactNr: snapshot.data![i].contactNr,
                                  createdAt: snapshot.data![i].createdAt,
                                  jobimage: snapshot.data![i].productImage,
                                  postedBy: snapshot.data![i].postedBy,
                                ),
                              ),
                            )
                          },
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20)),
                              height: MediaQuery.of(context).size.height * 0.2,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.15,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(Variables
                                                        .imageApiEndpoint +
                                                    snapshot
                                                        .data![i].productImage),
                                                fit: BoxFit.contain))),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Text(
                                        snapshot.data![i].productName,
                                        style: GoogleFonts.robotoMono(
                                            color: Colors.black, fontSize: 17),
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                        maxLines: 1,
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.15,
                                          child: Text(
                                            snapshot.data![i].postedBy,
                                            style: GoogleFonts.robotoMono(
                                                color: Colors.black),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }));
            } else if (snapshot.hasError) {
              return LiquidPullToRefresh(
                showChildOpacityTransition: true,
                onRefresh: refreshDataProducts,
                child: ListView(
                  children: [
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Dicka shkoi keq, provoni perseri!",
                          style:
                              TextStyle(color: Colors.deepOrange, fontSize: 17),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width,
                      child: SvgPicture.asset(
                        "assets/web.svg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              );
            }

            // By default, show a loading spinner.
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Future<List<Products>> getAllProducts() async {
    String productUri = Variables.getAllProductsApiEndpoint;

    final response = await http.get(Uri.parse(productUri));
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((products) => Products.fromJson(products)).toList();
  }

  Future<void> refreshDataProducts() async {
    setState(() {
      getAllProducts();
    });
  }
}
