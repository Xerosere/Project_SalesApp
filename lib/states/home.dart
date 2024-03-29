import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:projectsalesmaterial/states/search_result.dart';
import 'package:projectsalesmaterial/states/upload_main.dart';
import 'package:projectsalesmaterial/states/content.dart';
import 'package:projectsalesmaterial/states/video_content.dart';
import 'package:projectsalesmaterial/utility/myconstant.dart';
import 'package:projectsalesmaterial/model/filelist.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const IconData add_task =
      IconData(0xe05b, fontFamily: 'MaterialIcons');
  static const IconData add_task_sharp =
      IconData(0xe75a, fontFamily: 'MaterialIcons');
  static const IconData add_to_home_screen =
      IconData(0xe05d, fontFamily: 'MaterialIcons');

  int? currentOptionsent;
  List<FileModel> file_detail_list = [];
  TextEditingController descriptionFileEdit = TextEditingController();
  TextEditingController search_data = TextEditingController();

  StreamController<String> searchController =
      StreamController<String>.broadcast();

  @override
  void initState() {
    super.initState();
    getfiledetail();
  }

  Future<void> getfiledetail() async {
    //รับค่าข้อมูลไฟล์ทั้งหมด
    file_detail_list.clear();
    String apipath =
        'https://btmexpertsales.com/filemanagesys/get_allfiledetail.php';
    await Dio().get(apipath).then((value) {
      print('ไฟล์Home' + '$value');
      for (var data in jsonDecode(value.data)) {
        FileModel filedetail = FileModel.fromMap(data);
        setState(
          () {
            file_detail_list.add(filedetail);
            // print(file_detail_list);
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screensize = MediaQuery.of(context).size.width;
    double screensizeHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: const Text(
          'Sales Knowledge Center',
          style: TextStyle(fontSize: 50),
        ),
        backgroundColor: const Color.fromARGB(255, 235, 10, 30),
        foregroundColor: Colors.white,
        actions: [
          Row(children: [
            // Container(      //ฟังก์ชั่น approve file ใช้งานไม่ได้เพราะว่า ถ้ากำหนด status file = Pending ถ้าชื่อไฟล์ซ้ำโปรแกรมจะไม่รันเลขหลังชื่อให้ ทำให้ชื่อไฟล์ซ้ำและไฟล์ที่อัพลงเซิฟเวอร์ไปทำไฟล์เดิม
            //     width: 160,
            //     margin: EdgeInsets.fromLTRB(0, 0, 25, 0),
            //     child: ElevatedButton.icon(
            //         style: ElevatedButton.styleFrom(
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(8),
            //             ),
            //             backgroundColor: Color.fromARGB(255, 1, 22, 106),
            //             foregroundColor: Colors.white),
            //         onPressed: () {
            //           Navigator.pushNamed(context, myconstant.routeApprove);
            //         },
            //         icon: Icon(add_to_home_screen),
            //         label: Text('Pending files'))),
            Container(
              // ปุ่มUploadหน้าHome
              margin: EdgeInsets.fromLTRB(0, 0, 25, 0),
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: Color.fromARGB(255, 0, 0, 0),
                      foregroundColor: Colors.white),
                  onPressed: () {
                    Navigator.pushNamed(context, myconstant.routeUploadHome)
                        .then((result) {
                      currentOption2 = null;
                      currentOption3 = null;
                      currentOption4 = null;
                      file_detail_list.clear();
                      String apipath =
                          'https://btmexpertsales.com/filemanagesys/get_allfiledetail.php';
                      Dio().get(apipath).then((value) {
                        print('ไฟล์Home' + '$value');
                        for (var data in jsonDecode(value.data)) {
                          FileModel filedetail = FileModel.fromMap(data);
                          setState(
                            () {
                              file_detail_list.add(filedetail);
                              // print(file_detail_list);
                            },
                          );
                        }
                      });
                    });
                  },
                  icon: const Icon(CupertinoIcons.arrow_up_doc_fill),
                  label: const Text('Upload')),
            ),
          ])
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          alignment: Alignment.center,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Container(
              width: screensize,
              height: screensizeHeight,
              color: Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  Container(
                    //SearchBar
                    margin: EdgeInsets.all(10),
                    constraints: BoxConstraints(maxWidth: 500, maxHeight: 45),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color.fromARGB(255, 255, 255, 255),
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                    child: TextField(
                      textInputAction: TextInputAction.go,
                      onSubmitted: (value) {
                        setState(() {});
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return Search_result(
                                search_data:
                                    value); // ใส่ค่าที่ป้อนใน TextField ไปยังหน้า Search_result
                          },
                        )).then((result) {
                          // ตัวอย่างการใช้งาน result หลังจากกด Go และเสร็จสิ้นการค้นหา
                        });
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search',
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      ),
                    ),
                  ),
                  Container(
                    //ส่วนที่แสดงปุ่มต่างๆ เมื่อกดแล้วจะไปหน้าแสดงคอนเทนต์และส่งค่าปุ่มที่กดไปด้วยเพื่อนำไปแสดงไฟล์ที่เกี่ยวข้องกับข้อมูลที่ส่งไง
                    width: screensize,
                    child: Container(
                        alignment: Alignment.center,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Container(
                                height: 535,
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: Container(
                                    child: Column(children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      image: DecorationImage(
                                        image: AssetImage(
                                            myconstant.buttonpresentbg),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        minimumSize: Size(500, 250),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        backgroundColor:
                                            Color.fromARGB(0, 0, 0, 0),
                                      ),
                                      onPressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                          builder: (context) {
                                            return const myContentArea(
                                                idref: 'Presentation');
                                          },
                                        )).then((result) {
                                          currentOption2 = null;
                                          currentOption3 = null;
                                          currentOption4 = null;
                                        });
                                      },
                                      child: const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "PRESENTATION",
                                            style: TextStyle(
                                              fontSize: 50,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "ไฟล์นำเสนอที่เกี่ยวข้องกับ โปรไฟล์บริษัทและสินค้า",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  //----------------------------------------------------------------------------------
                                  Stack(
                                    children: [
                                      Container(
                                        width: 495,
                                        height: 243,
                                        margin:
                                            EdgeInsets.fromLTRB(0, 10, 0, 0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                          image: DecorationImage(
                                            image: AssetImage(
                                                myconstant.aliedproduct),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            minimumSize: Size(450, 250),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            backgroundColor:
                                                Color.fromARGB(0, 0, 0, 0),
                                          ),
                                          onPressed: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return const myContentArea(
                                                  idref: 'Allied Product');
                                            })).then((result) {
                                              currentOption2 = null;
                                              currentOption3 = null;
                                              currentOption4 = null;
                                            });
                                          },
                                          child: const Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "ALLIED PRODUCTS",
                                                style: TextStyle(
                                                  fontSize: 50,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                "เอกสารเกี่ยวกับ Solutions ต่างๆของทางบริษัท",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 15,
                                        left: 30,
                                        child: Container(
                                          width: 70,
                                          height: 65,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  myconstant.alliedProductbg),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  //----------------------------------------------------------
                                ])),
                              ),
                              Container(
                                height: 535,
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: Container(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Stack(
                                            children: [
                                              Container(
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                        15, 0, 0, 5),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8)),
                                                  image: DecorationImage(
                                                    image: AssetImage(myconstant
                                                        .artworkbutton),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          foregroundColor:
                                                              Color.fromARGB(
                                                                  255,
                                                                  255,
                                                                  255,
                                                                  255),
                                                          minimumSize:
                                                              Size(450, 250),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          backgroundColor:
                                                              Color.fromARGB(
                                                                  0,
                                                                  255,
                                                                  255,
                                                                  255)),
                                                  onPressed: () {
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                      return const myContentArea(
                                                          idref: 'Artwork');
                                                    })).then((result) {
                                                      currentOption2 = null;
                                                      currentOption3 = null;
                                                      currentOption4 = null;
                                                    });
                                                  },
                                                  child: const Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "ART WORK",
                                                        style: TextStyle(
                                                          fontSize: 50,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        " Graphic Design & Video Animation ",
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 10,
                                                left: 30,
                                                child: Container(
                                                  width: 70,
                                                  height: 70,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                          myconstant.artworkbg),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Stack(
                                            children: [
                                              Container(
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                        15, 0, 0, 5),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8)),
                                                  image: DecorationImage(
                                                    image: AssetImage(myconstant
                                                        .promotionbutton),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    foregroundColor:
                                                        Color.fromARGB(
                                                            255, 255, 255, 255),
                                                    minimumSize: Size(450, 250),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            0, 255, 255, 255),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                      return const myContentArea(
                                                          idref: 'Promotion');
                                                    })).then((result) {
                                                      currentOption2 = null;
                                                      currentOption3 = null;
                                                      currentOption4 = null;
                                                    });
                                                  },
                                                  child: const Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "PROMOTION",
                                                        style: TextStyle(
                                                          fontSize: 50,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        "",
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 10,
                                                left: 30,
                                                child: Container(
                                                  width: 70,
                                                  height: 70,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                          myconstant
                                                              .promotionbg),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(
                                        //ปุ่ม MHE
                                        margin:
                                            EdgeInsets.fromLTRB(20, 10, 0, 0),
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        height: 243,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Color.fromARGB(255, 0, 0, 0),
                                        ),
                                        child: Row(
                                          children: [
                                            Stack(
                                              children: [
                                                Container(
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 0, 5, 0),
                                                  decoration:
                                                      const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(8)),
                                                  ),
                                                  child: SizedBox(
                                                    width: 205,
                                                    height: 230,
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              foregroundColor:
                                                                  const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      0,
                                                                      0,
                                                                      0),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                              backgroundColor:
                                                                  Color
                                                                      .fromARGB(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          255)),
                                                      onPressed: () {
                                                        Navigator.push(context,
                                                            MaterialPageRoute(
                                                          builder: (context) {
                                                            return const myContentArea(
                                                                idref:
                                                                    'Full Line Catalog');
                                                          },
                                                        )).then((result) {
                                                          currentOption2 = null;
                                                          currentOption3 = null;
                                                          currentOption4 = null;
                                                        });
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 130),
                                                            alignment: Alignment
                                                                .center,
                                                            child: const Text(
                                                              "MHE",
                                                              style: TextStyle(
                                                                fontSize: 30,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        235,
                                                                        10,
                                                                        10),
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 0),
                                                            alignment: Alignment
                                                                .center, // นำ Alignment.center ไปใส่ที่นี่
                                                            child: const Text(
                                                              "FULL LINE",
                                                              style: TextStyle(
                                                                fontSize: 30,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 0,
                                                  left: 60,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                        builder: (context) {
                                                          return const myContentArea(
                                                              idref:
                                                                  'Full Line Catalog');
                                                        },
                                                      )).then((result) {
                                                        currentOption2 = null;
                                                        currentOption3 = null;
                                                        currentOption4 = null;
                                                      });
                                                    },
                                                    child: Container(
                                                      width: 120,
                                                      height: 120,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: AssetImage(
                                                              myconstant
                                                                  .catalogbg),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Stack(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      10, 0, 5, 0),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(8)),
                                                  ),
                                                  child: SizedBox(
                                                    width: 205,
                                                    height: 230,
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              foregroundColor:
                                                                  const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      0,
                                                                      0,
                                                                      0),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                              backgroundColor:
                                                                  Color
                                                                      .fromARGB(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          255)),
                                                      onPressed: () {
                                                        Navigator.push(context,
                                                            MaterialPageRoute(
                                                          builder: (context) {
                                                            return const myContentArea(
                                                                idref:
                                                                    'Brochure');
                                                          },
                                                        )).then((result) {
                                                          currentOption2 = null;
                                                          currentOption3 = null;
                                                          currentOption4 = null;
                                                        });
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 130),
                                                            alignment: Alignment
                                                                .center,
                                                            child: const Text(
                                                              "MHE",
                                                              style: TextStyle(
                                                                fontSize: 30,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        235,
                                                                        10,
                                                                        10),
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 0),
                                                            alignment: Alignment
                                                                .center,
                                                            child: const Text(
                                                              "BROCHURE",
                                                              style: TextStyle(
                                                                fontSize: 30,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 0,
                                                  left: 55,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                        builder: (context) {
                                                          return const myContentArea(
                                                              idref:
                                                                  'Brochure');
                                                        },
                                                      )).then((result) {
                                                        currentOption2 = null;
                                                        currentOption3 = null;
                                                        currentOption4 = null;
                                                      });
                                                    },
                                                    child: Container(
                                                      width: 120,
                                                      height: 120,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: AssetImage(
                                                              myconstant
                                                                  .buttonbrochurebg),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Stack(
                                              children: [
                                                Container(
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 0, 5, 0),
                                                  decoration:
                                                      const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(8)),
                                                  ),
                                                  child: SizedBox(
                                                    width: 205,
                                                    height: 230,
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              foregroundColor:
                                                                  const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      0,
                                                                      0,
                                                                      0),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                              backgroundColor:
                                                                  Color
                                                                      .fromARGB(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          255)),
                                                      onPressed: () {
                                                        Navigator.push(context,
                                                            MaterialPageRoute(
                                                          builder: (context) {
                                                            return const myContentArea(
                                                                idref:
                                                                    'Picture AllProduct');
                                                          },
                                                        )).then((result) {
                                                          currentOption2 = null;
                                                          currentOption3 = null;
                                                          currentOption4 = null;
                                                        });
                                                      },
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 75),
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 55),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: const Text(
                                                                "MHE",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 30,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          235,
                                                                          10,
                                                                          10),
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .only(top: 0),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: const Text(
                                                                "PICTURE",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 30,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 0,
                                                  left: 55,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                        builder: (context) {
                                                          return const myContentArea(
                                                              idref:
                                                                  'Picture AllProduct');
                                                        },
                                                      )).then((result) {
                                                        currentOption2 = null;
                                                        currentOption3 = null;
                                                        currentOption4 = null;
                                                      });
                                                    },
                                                    child: Container(
                                                      width: 120,
                                                      height: 120,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: AssetImage(
                                                              myconstant
                                                                  .buttonpicturebg),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Stack(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      10, 0, 5, 0),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(8)),
                                                  ),
                                                  child: SizedBox(
                                                    width: 205,
                                                    height: 230,
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              foregroundColor:
                                                                  const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      0,
                                                                      0,
                                                                      0),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                              backgroundColor:
                                                                  Color
                                                                      .fromARGB(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          255)),
                                                      onPressed: () {
                                                        Navigator.push(context,
                                                            MaterialPageRoute(
                                                          builder: (context) {
                                                            return const myContentArea(
                                                                idref:
                                                                    'Video AllProduct');
                                                          },
                                                        )).then((result) {
                                                          currentOption2 = null;
                                                          currentOption3 = null;
                                                          currentOption4 = null;
                                                        });
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 130),
                                                            alignment: Alignment
                                                                .center,
                                                            child: const Text(
                                                              "MHE",
                                                              style: TextStyle(
                                                                fontSize: 30,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        235,
                                                                        10,
                                                                        10),
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 0),
                                                            alignment: Alignment
                                                                .center,
                                                            child: const Text(
                                                              "VIDEO",
                                                              style: TextStyle(
                                                                fontSize: 30,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 15,
                                                  left: 55,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                        builder: (context) {
                                                          return const myContentArea(
                                                              idref:
                                                                  'Video AllProduct');
                                                        },
                                                      )).then((result) {
                                                        currentOption2 = null;
                                                        currentOption3 = null;
                                                        currentOption4 = null;
                                                      });
                                                    },
                                                    child: Container(
                                                      width: 120,
                                                      height: 120,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: AssetImage(
                                                              myconstant
                                                                  .videobg),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
