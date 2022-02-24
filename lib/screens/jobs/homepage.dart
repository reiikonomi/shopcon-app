import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mistreci/ads/admob_service.dart';
import 'package:mistreci/screens/jobs/addjob.dart';
import 'package:mistreci/screens/jobs/joblistpage.dart';
import 'package:mistreci/screens/jobs/joblistpagescaffolf.dart';
import 'package:mistreci/screens/auth/login_screen.dart';
import 'package:mistreci/widgets/search_screen.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();
  final GlobalKey _four = GlobalKey();
  final GlobalKey _five = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance!.addPostFrameCallback((_) =>
    //     ShowCaseWidget.of(context)!
    //         .startShowCase([_one, _two, _three, _four, _five]));
    SharedPreferences preferences;

    displayShowcase() async {
      preferences = await SharedPreferences.getInstance();
      bool? showcaseVisibilityStatus = preferences.getBool("showShowcase");

      if (showcaseVisibilityStatus == null) {
        preferences.setBool("showShowcase", false).then((bool success) {
          if (success) {
            return null;
          } else {
            return null;
          }
        });

        return true;
      }

      return false;
    }

    displayShowcase().then((status) {
      if (status) {
        ShowCaseWidget.of(context)!.startShowCase([
          _one,
          _two,
          _three,
          _four,
          _five,
        ]);
      }
    });

    final firebaseUser = context.watch<User?>();
    return Scaffold(
        body: ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(left:20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      text: "Shopcon",
                      style: GoogleFonts.robotoMono(
                          color: Colors.deepOrange, fontSize: 30),
                      children: [
                        TextSpan(
                          text: "/Pune;",
                          style: GoogleFonts.robotoMono(
                              color: Colors.black, fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      firebaseUser != null
                          ? Showcase(
                              key: _one,
                              description:
                                  "Ky buton ju lejon te shkonni ne faqen e identifikimit! I cili ju jep mundesine te postoni.",
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height * 0.1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () => {
                                        context
                                            .read<AuthenticationProvider>()
                                            .signOut()
                                      },
                                      icon: const Icon(Icons.logout_sharp, color: Colors.deepOrange,
                                          size: 30),
                                    ),
                                    Text(
                                      "Logout",
                                      style: GoogleFonts.robotoMono(
                                        color: Colors.deepOrange,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Showcase(
                              key: _one,
                              description:
                                  "Ky buton ju lejon te shkonni ne faqen e identifikimit! I cili ju jep mundesine te postoni.",
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () => {
                                      Navigator.of(context).push(
                                        MaterialPageRoute<void>(
                                          builder: (BuildContext context) =>
                                              const LoginScreen(),
                                        ),
                                      )
                                    },
                                    icon: const Icon(
                                      Icons.login,
                                      size: 30,
                                      color: Colors.deepOrange,
                                    ),
                                  ),
                                  Text(
                                    "Login",
                                    style: GoogleFonts.robotoMono(
                                      color: Colors.deepOrange,
                                    ),
                                  ),
                                ],
                              ),
                            )
                    ],
                  )
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
                    child: SvgPicture.asset("assets/jobs.svg"),
                  )
                ],
              ),
              Showcase(
                radius: BorderRadius.circular(20),
                key: _two,
                description:
                    "Duke shtypur këtë buton ju mund të kërkoni për një pune ose produkt.",
                child: GestureDetector(
                    onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SearchScreen()),
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
                            "Kerko pune...",
                            style: GoogleFonts.robotoMono(color: Colors.black),
                          ),
                        ],
                      ),
                      height: MediaQuery.of(context).size.height * 0.06,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(20)),
                    )),
              ),
              const SizedBox(
                height: 25,
              ),
              Showcase(
                radius: BorderRadius.circular(20),
                key: _three,
                description:
                    "Shkoni në faqen ku mund të postoni! Në fillim duhet të identifikoheni!",
                child: GestureDetector(
                  onTap: () => {
                    firebaseUser != null
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddJob()),
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
                        "Posto nje pune",
                        style: GoogleFonts.robotoMono(
                            color: Colors.white, fontSize: 15),
                      ),
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
              Showcase(
                radius: BorderRadius.circular(20),
                key: _four,
                description:
                    "Pasi të shtypni këte buton ju mund te shikoni të gjitha punët ose produktet dhe të kerkoni sipas kategorive!",
                child: GestureDetector(
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const JobListPageScaffold()),
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
                        "Shiko te gjitha punet",
                        style: GoogleFonts.robotoMono(
                            color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Showcase(
          radius: BorderRadius.circular(10),
          key: _five,
          description: "Këtu mund të shikoni punët ose produktet më të reja.",
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 2, color: Colors.deepOrange)),
              height: MediaQuery.of(context).size.height * 0.4,
              child: const JobListPage(),
            ),
          ),
        )
      ],
    ));
  }
}

class AuthenticateJob extends StatelessWidget {
  const AuthenticateJob({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return const AddJob();
    } else {
      return const LoginScreen();
    }
  }
}
