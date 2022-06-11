import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:mytutor/constants.dart';
import 'package:mytutor/models/tutor.dart';

class TutorsPage extends StatefulWidget {
  const TutorsPage({Key? key}) : super(key: key);

  @override
  State<TutorsPage> createState() => _TutorsPageState();
}

class _TutorsPageState extends State<TutorsPage> {
  late double screenHeight, screenWidth, rWidth;
  String titlecenter = "";
  List<Tutor> tutorList = <Tutor>[];
  var numofpage, curpage = 1;
  var color;

  @override
  void initState() {
    super.initState();
    _loadTutors(1);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 700) {
      rWidth = screenWidth * 0.75;
    } else {
      rWidth = screenWidth;
    }

    return Scaffold(
      body: tutorList.isEmpty
          ? Padding(
              padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
              child: Column(
                children: [
                  Center(
                      child: Text(titlecenter,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                ],
              ),
            )
          : Column(children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
              ),
              const Text(
                'Tutors',
                style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
              ),
              Expanded(
                  child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: (1 / 2),
                      children: List.generate(tutorList.length, (index) {
                        return InkWell(
                          splashColor: Colors.red,
                          child: Card(
                              child: Column(
                            children: [
                              Flexible(
                                flex: 5,
                                child: CachedNetworkImage(
                                  imageUrl: CONSTANTS.server +
                                      "/mytutor/assets/tutors/" +
                                      tutorList[index].tutorId.toString() +
                                      ".jpg",
                                  fit: BoxFit.cover,
                                  width: rWidth,
                                ),
                              ),
                              Flexible(
                                  flex: 5,
                                  child: Column(
                                    children: [
                                      Container(
                                        constraints:
                                            BoxConstraints.expand(height: 40),
                                        child: Text(
                                          tutorList[index].tutorName.toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        constraints:
                                            BoxConstraints.expand(height: 100),
                                        child: Text(
                                          tutorList[index]
                                              .tutorDescription
                                              .toString(),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        tutorList[index].tutorEmail.toString(),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ))
                            ],
                          )),
                        );
                      }))),
              SizedBox(
                height: 30,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: numofpage,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    if ((curpage - 1) == index) {
                      color = Colors.red;
                    } else {
                      color = Colors.black;
                    }
                    return SizedBox(
                      width: 40,
                      child: TextButton(
                          onPressed: () => {_loadTutors(index + 1)},
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(color: color),
                          )),
                    );
                  },
                ),
              ),
            ]),
    );
  }

  void _loadTutors(int pageno) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(Uri.parse(CONSTANTS.server + "/mytutor/php/loadTutor.php"),
        body: {
          'pageno': pageno.toString(),
        }).then((response) {
      var jsondata = jsonDecode(response.body);

      if (response.statusCode == 200 || jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        numofpage = int.parse(jsondata['numofpage']);

        if (extractdata['tutor'] != null) {
          tutorList = <Tutor>[];
          extractdata['tutor'].forEach((v) {
            tutorList.add(Tutor.fromJson(v));
          });
        } else {
          titlecenter = "No Tutor Available";
          tutorList.clear();
        }
        setState(() {});
      } else {
        //do something
        titlecenter = "No Tutor Available";
        tutorList.clear();
        setState(() {});
      }
    });
  }
}
