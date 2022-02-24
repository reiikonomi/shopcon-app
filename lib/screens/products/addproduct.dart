import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as http;
import 'package:mistreci/ads/admob_service.dart';
import 'package:mistreci/screens/products/productpage.dart';
import 'package:mistreci/variables.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _globalkey = GlobalKey<FormState>();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _createdAt = TextEditingController();
  final TextEditingController _postedBy = TextEditingController();
  final TextEditingController _contactNr = TextEditingController();
  XFile? _image;
  final picker = ImagePicker();
  bool showSpinner = false;
  final items = [
    'Automjete',
    'Veshje',
    'ProdukteKozmetike',
    'ProdukteBio',
    'Elektronike',
    'Elektroshtepiake',
    'TeTjera'
  ];
  String? value;

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = XFile(pickedFile.path);
        iconphoto = Icons.done;
        photoText = Text(
          'Fotoja u zgjodh',
          style: GoogleFonts.robotoMono(color: Colors.deepOrange, fontSize: 30),
        );
      } else {}
    });
  }

  Future<void> updateProfileImage() async {
    // setState(() {
    //   showSpinner = true;
    // });
    // ignore: prefer_typing_uninitialized_variables
    var result;

    var stream = http.ByteStream(_image!.openRead());
    stream.cast();
    var length = await _image!.length();

    var uri = Uri.parse(Variables.postProduct);

    var request = http.MultipartRequest("POST", uri);

    request.fields["product_name"] = _title.text;
    request.fields["description"] = _description.text;
    request.fields["posted_by"] = _postedBy.text;
    // request.fields["created_at"] = _createdAt.text;
    request.fields["created_at"] = DateTime.now().toLocal().toString();
    request.fields["contact_nr"] = _contactNr.text;
    request.fields["category"] = value!.trim().toLowerCase();

    var multipartFile = http.MultipartFile("product_image", stream, length,
        filename: _image!.path);

    request.files.add(multipartFile);
    var response = await request.send();

    var respStr = await response.stream.bytesToString();
    var responseJson = json.decode(respStr);

    Map<String, dynamic> map = responseJson;

    return result;
  }

  IconData iconphoto = Icons.image;
  Text photoText = Text(
    "Zgjidhni nje foto",
    style: GoogleFonts.robotoMono(color: Colors.deepOrange, fontSize: 30),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.deepOrange,
        elevation: 0,
      ),
      body: Form(
        key: _globalkey,
        child: ListView(
          children: <Widget>[
            choosePhoto(),
            const SizedBox(
              height: 10,
            ),
            titleTextField(),
            const SizedBox(
              height: 10,
            ),
            bodyTextField(),
            const SizedBox(
              height: 10,
            ),
            contactNrTextField(),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(20)),
                child: DropdownButtonHideUnderline(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: DropdownButtonFormField<String>(
                        icon: const Icon(
                          Icons.arrow_downward_sharp,
                          color: Colors.deepOrange,
                        ),
                        hint: Text(
                          "Kategoria",
                          style:
                              GoogleFonts.robotoMono(color: Colors.deepOrange),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return " nuk mund te jete bosh!";
                          }
                          return null;
                        },
                        value: value,
                        items: items.map(buildmenuitem).toList(),
                        onChanged: (value) => setState(() {
                              this.value = value;
                            })),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            postedByTextField(),
            const SizedBox(
              height: 20,
            ),
            addButton(context),
            const SizedBox(
              height: 5,
            ),
            Container(
              height: 50,
              alignment: Alignment.center,
              child: AdWidget(
                  key: UniqueKey(), ad: AdMobService.createBannerAd()..load()),
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildmenuitem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(fontSize: 20),
        ),
      );

  Widget choosePhoto() {
    return GestureDetector(
        onTap: () {
          getImage();
        },
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.transparent,
          ),
          height: 100,
          width: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                iconphoto,
                size: 40,
                color: Colors.deepOrange,
              ),
              photoText
            ],
          ),
        ));
  }

  Widget titleTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: TextFormField(
        // key: _globalkey,
        cursorColor: Colors.deepOrange,
        controller: _title,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Emri i produktit nuk mund te jete bosh!";
          } else if (value.length > 50) {
            return "Gjatesia e emrit duhet te jete <=50";
          }
          return null;
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.title,
            color: Colors.deepOrange,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Colors.deepOrange,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Colors.deepOrange,
              width: 2,
            ),
          ),
          labelText: "Emri i produktit",
          labelStyle: GoogleFonts.robotoMono(color: Colors.deepOrange),
        ),
        maxLength: 50,
        maxLines: null,
      ),
    );
  }

  Widget bodyTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: TextFormField(
        // key: _globalkey,
        cursorColor: Colors.deepOrange,
        controller: _description,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Pershkrimi nuk duhet te jete bosh!";
          }
          return null;
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.description,
            color: Colors.deepOrange,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Colors.deepOrange,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Colors.deepOrange,
              width: 2,
            ),
          ),
          labelText: "Pershkrimi",
          labelStyle: GoogleFonts.robotoMono(color: Colors.deepOrange),
        ),
        maxLines: null,
      ),
    );
  }

  Widget createdAtTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: TextFormField(
        // key: _globalkey,
        cursorColor: Colors.deepOrange,
        controller: _createdAt,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Dita nuk duhet te jete bosh!";
          }
          return null;
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Colors.deepOrange,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Colors.deepOrange,
              width: 2,
            ),
          ),
          labelText: "Dita",
          labelStyle: const TextStyle(color: Colors.deepOrange),
        ),
        maxLength: 20,
      ),
    );
  }

  Widget postedByTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: TextFormField(
        // key: _globalkey,
        cursorColor: Colors.deepOrange,
        controller: _postedBy,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Shitesi nuk mund te jete bosh";
          }
          return null;
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.account_box_rounded,
            color: Colors.deepOrange,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Colors.deepOrange,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Colors.deepOrange,
              width: 2,
            ),
          ),
          labelText: "Shitesi",
          labelStyle: GoogleFonts.robotoMono(color: Colors.deepOrange),
        ),
        maxLines: null,
      ),
    );
  }

  Widget contactNrTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: TextFormField(
        // key: _globalkey,
        cursorColor: Colors.deepOrange,
        controller: _contactNr,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Nr. i kontaktit nuk mund te jete bosh!";
          }
          return null;
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.phone,
            color: Colors.deepOrange,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Colors.deepOrange,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Colors.deepOrange,
              width: 2,
            ),
          ),
          labelText: "Nr. Kontakti",
          labelStyle: GoogleFonts.robotoMono(
            color: Colors.deepOrange,
          ),
        ),
      ),
    );
  }

  Widget addButton(context) {
    return InkWell(
      onTap: () async {
        if (_globalkey.currentState!.validate() && _image != null) {
          updateProfileImage();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Duke u postuar!',
                  style:
                      GoogleFonts.robotoMono(color: Colors.white, fontSize: 20),
                ),
              ),
              backgroundColor: Colors.deepOrange,
            ),
          );
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const ProductPage(),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Ju lutem plortesoni te gjitha fushat me siper dhe zgjidhni nje foto!',
                  style:
                      GoogleFonts.robotoMono(color: Colors.white, fontSize: 15),
                ),
              ),
              backgroundColor: Colors.deepOrange,
            ),
          );
        }
      },
      child: Center(
        child: Container(
          height: 50,
          width: 200,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.deepOrange),
          child: Center(
              child: Text(
            "Posto",
            style: GoogleFonts.robotoMono(color: Colors.white, fontSize: 19),
          )),
        ),
      ),
    );
  }

  void takeCoverPhoto() async {
    await getImage();
    setState(() {
      iconphoto = Icons.done;
      photoText = Text(
        "Fotoja u zgjodh",
        style: GoogleFonts.robotoMono(color: Colors.deepOrange, fontSize: 30),
      );
    });
  }
}
