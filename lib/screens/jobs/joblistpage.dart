import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:mistreci/models/jobs.model.dart';
import 'package:mistreci/screens/jobs/jobpage.dart';
import 'package:mistreci/variables.dart';

class JobListPage extends StatefulWidget {
  const JobListPage({Key? key}) : super(key: key);

  @override
  _JobListPageState createState() => _JobListPageState();
}

class _JobListPageState extends State<JobListPage> {
  List jobs = [];
  List refreshedJob = [];

  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getAllJobs();
  }

  

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: LiquidPullToRefresh(
        showChildOpacityTransition: true,
        onRefresh: () async {
          await refreshData();
        },
        child: FutureBuilder<List<Jobs>>(
          future: getAllJobs(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  addAutomaticKeepAlives: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int i) {
                    //if (itemlist[i] is String) {
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
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 10,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                Variables.imageApiEndpoint +
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
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.15,
                                      child: Text(
                                        snapshot.data![i].postedBy,
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
                    );
                  },
                ),
              );
            } else if (snapshot.hasError) {
              return LiquidPullToRefresh(
                showChildOpacityTransition: true,
                onRefresh: refreshData,
                child: ListView(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Dicka shkoi keq, provoni perseri!",
                          style: GoogleFonts.robotoMono(
                              color: Colors.deepOrange, fontSize: 17),
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

  Future<List<Jobs>> getAllJobs() async {
    String jobUri = Variables.getAllJobsApiEndpoint;

    final response = await http.get(Uri.parse(jobUri));
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((job) => Jobs.fromJson(job)).toList();
  }

  Future<void> refreshData() async {
    setState(() {
      getAllJobs();
    });
  }
}
