import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:mistreci/models/jobs.model.dart';
import 'package:http/http.dart' as http;
import 'package:mistreci/variables.dart';
import 'package:mistreci/widgets/searchbar.dart';

import '../screens/jobs/jobpage.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  List<Jobs> jobs = [];
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
    final jobs = await getJobsByQuery(query);

    setState(() => this.jobs = jobs);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.deepOrange,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            buildSearch(),
            Expanded(
              child: ListView.builder(
                itemCount: jobs.length,
                itemBuilder: (context, index) {
                  final job = jobs[index];

                  return buildJob(job);
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
          onChanged: searchJob,
        ),
      );

  Future searchJob(String query) async => debounce(() async {
        final jobs = await getJobsByQuery(query);

        if (!mounted) return;

        setState(() {
          this.query = query;
          this.jobs = jobs;
        });
      });

  Widget buildJob(Jobs jobs) => Padding(
        padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
        child: GestureDetector(
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JobDetailScreen(
                  category: jobs.category,
                  title: jobs.title,
                  description: jobs.description,
                  contactNr: jobs.contactNr,
                  createdAt: jobs.createdAt,
                  jobimage: jobs.jobimage,
                  postedBy: jobs.postedBy,
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
                                    Variables.imageApiEndpoint + jobs.jobimage),
                                fit: BoxFit.contain))),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Text(
                        jobs.title,
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
                            jobs.postedBy,
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

Future<List<Jobs>> getJobsByQuery(String query) async {
  final url = Uri.parse(Variables.searchJobsApiEndpoint + query);
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List jobs = json.decode(response.body);

    return jobs.map((json) => Jobs.fromJson(json)).where((jobs) {
      final titleLower = jobs.title.toLowerCase();
      final descriptionLower = jobs.description.toLowerCase();
      final searchLower = query.toLowerCase();

      return titleLower.contains(searchLower) ||
          descriptionLower.contains(searchLower);
    }).toList();
  } else {
    throw Exception();
  }
}
