import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mistreci/variables.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class JobDetailScreen extends StatelessWidget {
  const JobDetailScreen(
      {Key? key,
      required this.title,
      required this.description,
      required this.contactNr,
      required this.createdAt,
      required this.jobimage,
      required this.postedBy,
      required this.category})
      : super(key: key);

  final String title;
  final String description;
  final String jobimage;
  final String createdAt;
  final String postedBy;
  final String contactNr;
  final String category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.deepOrange,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(children: [
          GestureDetector(
            onTap: () {
              showImageViewer(
                  context, NetworkImage(Variables.imageApiEndpoint + jobimage));
            },
            child: Container(
              height: MediaQuery.of(context).size.width * 0.7,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(Variables.imageApiEndpoint + jobimage),
                    fit: BoxFit.contain),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style:
                      GoogleFonts.robotoMono(color: Colors.black, fontSize: 30),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => launch("tel:$contactNr"),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: Text(
                  "Kontakto",
                  style:
                      GoogleFonts.robotoMono(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Data e postimit:${DateFormat("dd-MM-yyyy, HH-mm").format(DateTime.parse(createdAt))}",
                  // DateFormat("dd-MM-yyyy, HH-mm")
                  //     .format(DateTime.parse(createdAt)),
                  style:
                      GoogleFonts.robotoMono(color: Colors.black, fontSize: 17),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  "Postuar nga: $postedBy",
                  style:
                      GoogleFonts.robotoMono(color: Colors.black, fontSize: 17),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  "Kategoria: $category",
                  style:
                      GoogleFonts.robotoMono(color: Colors.black, fontSize: 17),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: 2, color: Colors.deepOrange)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          'Pershkrimi:',
                          style: GoogleFonts.robotoMono(
                              color: Colors.black, fontSize: 20),
                        ),
                        Text(
                          description,
                          style: GoogleFonts.robotoMono(
                              color: Colors.black, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
