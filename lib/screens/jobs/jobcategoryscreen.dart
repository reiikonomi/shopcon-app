import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mistreci/models/jobs.model.dart';
import 'package:http/http.dart' as http;
import 'package:mistreci/variables.dart';
import 'jobpage.dart';

class JobCategory extends StatefulWidget {
  final String category;
  const JobCategory({Key? key, required this.category}) : super(key: key);

  @override
  _JobCategoryState createState() => _JobCategoryState();
}

class _JobCategoryState extends State<JobCategory> {
  List jobs = [];
  // List refreshedJob = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getAllJobsByCategory(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.deepOrange,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<List<Jobs>>(
        future: getAllJobsByCategory(widget.category),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int i) {
                      return GestureDetector(
                        onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => JobDetailScreen(
                                category: snapshot.data![i].category,
                                title: snapshot.data![i].title,
                                description: snapshot.data![i].description,
                                contactNr: snapshot.data![i].contactNr,
                                createdAt: snapshot.data![i].createdAt,
                                jobimage: snapshot.data![i].jobimage,
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
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(Variables
                                                      .imageApiEndpoint +
                                                  snapshot.data![i].jobimage),
                                              fit: BoxFit.contain))),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: Text(
                                      snapshot.data![i].title,
                                      style: GoogleFonts.robotoMono(
                                          color: Colors.black, fontSize: 20),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        snapshot.data![i].postedBy,
                                        style: GoogleFonts.robotoMono(
                                          color: Colors.black,
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
            return ListView(
              children: [
                const SizedBox(
                  height: 90,
                ),
                Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Dicka shkoi keq, provoni perseri!",
                        style: GoogleFonts.robotoMono(
                            color: Colors.deepOrange, fontSize: 17),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width,
                      child: SvgPicture.asset(
                        "assets/web.svg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ))
              ],
            );
          }

          // By default, show a loading spinner.
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<List<Jobs>> getAllJobsByCategory(String category) async {
    String jobUri = Variables.jobCategoryApiEndpoint + category;

    final response = await http.get(Uri.parse(jobUri));
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((job) => Jobs.fromJson(job)).toList();
  }

  // Future<void> refreshData(category) async {
  //   setState(() {
  //     getAllJobsByCategory(category);
  //   });
  // }
}
