import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mistreci/ads/admob_service.dart';
import 'package:mistreci/screens/products/addproduct.dart';
import 'package:mistreci/screens/products/productlistpage.dart';
import 'package:mistreci/screens/products/productlistpagescaffold.dart';
import 'package:mistreci/widgets/searchscreenproduct.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    return Scaffold(
        body: ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Shopcon',
                    style: GoogleFonts.robotoMono(
                        color: Colors.deepOrange, fontSize: 30),
                  ),
                  Text(
                    '/Produkte;',
                    style: GoogleFonts.robotoMono(
                        color: Colors.black, fontSize: 30),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width * 0.4,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                "assets/shopcon-logos_transparent.png"),
                            fit: BoxFit.contain)),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.transparent,
                    ),
                    child: SvgPicture.asset("assets/products.svg"),
                  ),
                ],
              ),
              GestureDetector(
                  onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const SearchScreenProduct()),
                        )
                      },
                  child: Container(
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(Icons.search_sharp),
                        ),
                        Text(
                          "Kerko produkte...",
                          style: GoogleFonts.robotoMono(color: Colors.black),
                        ),
                      ],
                    ),
                    height: MediaQuery.of(context).size.height * 0.06,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20)),
                  )),
              const SizedBox(
                height: 25,
              ),
              GestureDetector(
                onTap: () => {
                  firebaseUser != null
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddProduct()),
                        )
                      : Fluttertoast.showToast(
                          msg:
                              "Rregjistrohuni ose identifikohuni perpara se te postoni!",
                          backgroundColor: Colors.deepOrange,
                        )
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: Text(
                      "Posto nje produkt",
                      style: GoogleFonts.robotoMono(
                          color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                height: 50,
                alignment: Alignment.center,
                child: AdWidget(
                    key: UniqueKey(),
                    ad: AdMobService.createBannerAd()..load()),
              ),
              const SizedBox(
                height: 5,
              ),
              GestureDetector(
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProductListPageScaffold()),
                  )
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: Text(
                      "Shiko te gjitha produktet",
                      style: GoogleFonts.robotoMono(
                          color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 2, color: Colors.deepOrange)),
            height: MediaQuery.of(context).size.height * 0.4,
            child: const ProductListPage(),
          ),
        )
      ],
    ));
  }
}
