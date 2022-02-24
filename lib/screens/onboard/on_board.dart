

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mistreci/widgets/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onBoard_model.dart';

class OnBoard extends StatefulWidget {
  const OnBoard({Key? key}) : super(key: key);

  @override
  _OnBoardState createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  int currentIndex = 0;
  late PageController _pageController;
  List<OnboardModel> screens = <OnboardModel>[
    OnboardModel(
      img: 'assets/onboard1.svg',
      text: "Përshëndetje!",
      desc:
          "Shopcon është një platformë interaktive e cila fton përdoruesin të bëhet pjesë e një komuniteti të gjerë punëdhënësish, punëdashësish dhe shit-blerësve! ",
      bg: Colors.white,
    ),
    OnboardModel(
      img: 'assets/onboard2.svg',
      text: "Punë",
      desc:
          "Kërkoni dhe postoni punë ne profile te ndryshme. Qëllimi ynë është që ju të ngriheni në karrierë dhe të ndiqni pasionet tuaja!",
      bg: Colors.deepOrange,
    ),
    OnboardModel(
      img: 'assets/shopping.svg',
      text: "Shit-Blerje",
      desc:
          "Kërkoni dhe postoni produkte te ndryshme. Ju urojmë një eksperiencë të kënaqshme në platformën tonë! :)",
      bg: Colors.white,
    ),
  ];

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  _storeOnboardInfo() async {
    int isViewed = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onBoard', isViewed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: currentIndex % 2 == 0 ? Colors.white : Colors.deepOrange,
      appBar: AppBar(
        backgroundColor:
            currentIndex % 2 == 0 ? Colors.white : Colors.deepOrange,
        elevation: 0.0,
        actions: [
          TextButton(
            onPressed: () {
              _storeOnboardInfo();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NavBar()));
            },
            child: Text(
              "Anashkalo",
              style: GoogleFonts.robotoMono(
                color: currentIndex % 2 == 0 ? Colors.black : Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: PageView.builder(
            itemCount: screens.length,
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (int index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (_, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Image.asset(screens[index].img),
                  SizedBox(
                    child: SvgPicture.asset(screens[index].img),
                    height: MediaQuery.of(context).size.height * 0.4,
                  ),
                  SizedBox(
                    height: 10.0,
                    child: ListView.builder(
                      itemCount: screens.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 3.0),
                                width: currentIndex == index ? 25 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: currentIndex == index
                                      ? Colors.grey
                                      : Colors.orange,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ]);
                      },
                    ),
                  ),
                  Text(
                    screens[index].text,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.robotoMono(
                      fontSize: 27.0,
                      fontWeight: FontWeight.bold,
                      color: index % 2 == 0 ? Colors.black : Colors.white,
                    ),
                  ),
                  Text(
                    screens[index].desc,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.robotoMono(
                      fontSize: 19,
                      color: index % 2 == 0 ? Colors.black : Colors.white,
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      if (index == screens.length - 1) {
                        await _storeOnboardInfo();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NavBar()));
                      }

                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.bounceIn,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10),
                      decoration: BoxDecoration(
                          color:
                              index % 2 == 0 ? Colors.deepOrange : Colors.white,
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Text(
                          "Më tej",
                          style: GoogleFonts.robotoMono(
                              fontSize: 16.0,
                              color: index % 2 == 0
                                  ? Colors.white
                                  : Colors.deepOrange),
                        ),
                        const SizedBox(
                          width: 15.0,
                        ),
                        Icon(
                          Icons.arrow_forward_sharp,
                          color:
                              index % 2 == 0 ? Colors.white : Colors.deepOrange,
                        )
                      ]),
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }
}
