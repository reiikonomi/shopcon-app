import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;
import 'package:mistreci/models/products.model.dart';
import 'package:mistreci/screens/jobs/jobpage.dart';
import 'package:mistreci/variables.dart';
import 'package:mistreci/widgets/searchbar.dart';

import '../screens/jobs/jobpage.dart';

class SearchScreenProduct extends StatefulWidget {
  const SearchScreenProduct({Key? key}) : super(key: key);

  @override
  SearchScreenProductState createState() => SearchScreenProductState();
}

class SearchScreenProductState extends State<SearchScreenProduct> {
  List<Products> products = [];
  String query = '';
  Timer? debouncer;

  @override
  void initState() {
    super.initState();

    init();
  }

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  Future init() async {
    final products = await getProductsByQuery(query);

    setState(() => this.products = products);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.deepOrange,
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            buildSearch(),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];

                  return buildProducts(product);
                },
              ),
            ),
          ],
        ),
      );

  Widget buildSearch() => Padding(
        padding: const EdgeInsets.only(top: 0, left: 20, right: 20),
        child: SearchWidget(
          text: query,
          hintText: 'Kerko',
          onChanged: searchProducts,
        ),
      );

  Future searchProducts(String query) async => debounce(() async {
        final products = await getProductsByQuery(query);

        if (!mounted) return;

        setState(() {
          this.query = query;
          this.products = products;
        });
      });

  Widget buildProducts(Products products) => Padding(
        padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
        child: GestureDetector(
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JobDetailScreen(
                  category: products.category,
                  title: products.productName,
                  description: products.description,
                  contactNr: products.contactNr,
                  createdAt: products.createdAt,
                  jobimage: products.productImage,
                  postedBy: products.postedBy,
                ),
              ),
            )
          },
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 10,
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              height: MediaQuery.of(context).size.height * 0.2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                        height: MediaQuery.of(context).size.height * 0.15,
                        width: MediaQuery.of(context).size.width * 0.25,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    Variables.imageApiEndpoint + products.productImage),
                                fit: BoxFit.contain))),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Text(
                        products.productName,
                        style: GoogleFonts.robotoMono(
                            color: Colors.black, fontSize: 20),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: Text(
                            products.postedBy,
                            style: GoogleFonts.robotoMono(
                              color: Colors.black,
                            ),
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
        ),
      );
}

Future<List<Products>> getProductsByQuery(String query) async {
  final url = Uri.parse(Variables.searchProductApiEndoint + query);
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List products = json.decode(response.body);

    return products.map((json) => Products.fromJson(json)).where((products) {
      final titleLower = products.productName.toLowerCase();
      final descriptionLower = products.description.toLowerCase();
      final searchLower = query.toLowerCase();

      return titleLower.contains(searchLower) ||
          descriptionLower.contains(searchLower);
    }).toList();
  } else {
    throw Exception();
  }
}
