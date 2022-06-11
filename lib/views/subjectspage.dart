import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:mytutor/constants.dart';
import 'package:mytutor/models/subject.dart';

class SubjectsPage extends StatefulWidget {
  const SubjectsPage({Key? key}) : super(key: key);

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  late double screenHeight, screenWidth, rWidth;
  String titlecenter = "";
  List<Subject> subjectList = <Subject>[];
  var numofpage, curpage = 1;
  var color;

  @override
  void initState() {
    super.initState();
    _loadSubjects(1);
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
      body: subjectList.isEmpty
          ? const Padding(
              padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
            )
          : Column(children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
              ),
              const Text(
                'Subjects',
                style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
              ),
              Expanded(
                  child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: (1 / 2.3),
                      children: List.generate(subjectList.length, (index) {
                        return InkWell(
                          splashColor: Colors.red,
                          child: Card(
                              child: Column(
                            children: [
                              Flexible(
                                flex: 6,
                                child: CachedNetworkImage(
                                  imageUrl: CONSTANTS.server +
                                      "/mytutor/assets/courses/" +
                                      subjectList[index].subjectId.toString() +
                                      ".jpg",
                                  fit: BoxFit.cover,
                                  width: rWidth,
                                  height: rWidth,
                                ),
                              ),
                              Flexible(
                                  flex: 4,
                                  child: Column(
                                    children: [
                                      Container(
                                        constraints:
                                            const BoxConstraints.expand(
                                                height: 60),
                                        child: Text(
                                          subjectList[index]
                                              .subjectName
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        "RM " +
                                            double.parse(subjectList[index]
                                                    .subjectPrice
                                                    .toString())
                                                .toStringAsFixed(2),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(subjectList[index]
                                              .subjectSessions
                                              .toString() +
                                          " sessions"),
                                      Text(double.parse(subjectList[index]
                                                  .subjectRating
                                                  .toString())
                                              .toStringAsFixed(1) +
                                          " / 5.0"),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Text("Tutorial by "),
                                          CachedNetworkImage(
                                            imageUrl: CONSTANTS.server +
                                                "/mytutor/assets/tutors/" +
                                                subjectList[index]
                                                    .tutorId
                                                    .toString() +
                                                ".jpg",
                                            fit: BoxFit.cover,
                                            width: 30,
                                            height: 30,
                                          ),
                                        ],
                                      )
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
                          onPressed: () => {_loadSubjects(index + 1)},
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

  void _loadSubjects(int pageno) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(Uri.parse(CONSTANTS.server + "/mytutor/php/loadSubjects.php"),
        body: {
          'pageno': pageno.toString(),
        }).then((response) {
      var jsondata = jsonDecode(response.body);

      if (response.statusCode == 200 || jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        numofpage = int.parse(jsondata['numofpage']);

        if (extractdata['subject'] != null) {
          subjectList = <Subject>[];
          extractdata['subject'].forEach((v) {
            subjectList.add(Subject.fromJson(v));
          });
        } else {
          titlecenter = "No Subject Available";
          subjectList.clear();
        }
        setState(() {});
      } else {
        //do something
        titlecenter = "No Subject Available";
        subjectList.clear();
        setState(() {});
      }
    });
  }
}
