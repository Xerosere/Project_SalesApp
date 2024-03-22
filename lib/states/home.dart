import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
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
  int? currentOptionsent;
  List<FileModel> file_detail_list = [];
  TextEditingController descriptionFileEdit = TextEditingController();
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
          Container(
            // ปุ่มUploadหน้าHome
            margin: EdgeInsets.fromLTRB(0, 0, 25, 0),
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
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
          )
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
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        var matchingFiles = file_detail_list.where((file) =>
                            file.name_file.toLowerCase().contains(value
                                .toLowerCase()) || // ตรวจสอบว่าชื่อไฟล์มี value ที่ค้นหาหรือไม่
                            file.Tag.toLowerCase().contains(value
                                .toLowerCase()) || // ตรวจสอบ Tag มี value ที่ค้นหาหรือไม่
                            file.IDcategory_first.toLowerCase().contains(value
                                .toLowerCase()) || // ตรวจสอบ category 1  มี value ที่ค้นหาหรือไม่
                            file.IDcategory_second! // ตรวจสอบ category 2 มี value ที่ค้นหาหรือไม่
                                .toLowerCase()
                                .contains(value.toLowerCase()) ||
                            file.IDcategory_third! // ตรวจสอบ category 3 มี value ที่ค้นหาหรือไม่
                                .toLowerCase()
                                .contains(value.toLowerCase()) ||
                            file.IDcategory_fourth! // ตรวจสอบ category 4 มี value ที่ค้นหาหรือไม่
                                .toLowerCase()
                                .contains(value.toLowerCase()));
                        if (matchingFiles.isNotEmpty) {
                          //ถ้ามีข้อมูล
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Search Result'),
                                content: SizedBox(
                                  width: double.maxFinite,
                                  height: 300,
                                  child: ListView.builder(
                                    //แสดงไฟล์ที่ค้นเจอ
                                    itemCount: matchingFiles.length,
                                    itemBuilder: (context, index) {
                                      var file = matchingFiles.elementAt(index);
                                      return InkWell(
                                        onTap: () {
                                          showDialog(
                                            //แสดงรายละเอียดไฟล์
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(file.name_file),
                                                  Container(
                                                    height: 30,
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        String url =
                                                            'https://btmexpertsales.com/filemanagesys/download.php?filename=${file.name_file}';
                                                        launch(url);
                                                      },
                                                      child: const Text(
                                                        'Download',
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w900),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              content: SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        if (file.type_file ==
                                                            'youtube_url') {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                            builder: (context) {
                                                              return VideoContent(
                                                                idref:
                                                                    '${file.path_video}',
                                                                title: '',
                                                              );
                                                            },
                                                          ));
                                                        } else if (file
                                                                .type_file ==
                                                            'fileServer_url') {
                                                          String fileUrl =
                                                              'https://btmexpertsales.com/filemanagesys/file/${file.name_file}';
                                                          launch(fileUrl);
                                                        }
                                                      },
                                                      child: Stack(
                                                        children: [
                                                          // Container ที่บรรจุรูปภาพ
                                                          Container(
                                                            width: 700,
                                                            height: 400,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    20),
                                                            child: FadeInImage
                                                                .assetNetwork(
                                                              placeholder:
                                                                  myconstant
                                                                      .loadinggif,
                                                              image: (() {
                                                                if (file
                                                                    .name_file
                                                                    .toLowerCase()
                                                                    .endsWith(
                                                                        '.pdf')) {
                                                                  return myconstant
                                                                      .pdficon;
                                                                } else if (file
                                                                    .name_file
                                                                    .toLowerCase()
                                                                    .endsWith(
                                                                        '.docx')) {
                                                                  return myconstant
                                                                      .docicon;
                                                                } else if (file
                                                                    .name_file
                                                                    .toLowerCase()
                                                                    .endsWith(
                                                                        '.xlsx')) {
                                                                  return myconstant
                                                                      .xlsxicon;
                                                                } else if (file
                                                                    .name_file
                                                                    .toLowerCase()
                                                                    .endsWith(
                                                                        '.zip')) {
                                                                  return myconstant
                                                                      .zipicon;
                                                                } else if (file
                                                                        .type_file ==
                                                                    'youtube_url') {
                                                                  return 'https://btmexpertsales.com/filemanagesys/showimages.php?url=https://img.youtube.com/vi/${file.path_video}/maxresdefault.jpg';
                                                                } else {
                                                                  return 'https://btmexpertsales.com/filemanagesys/showimages.php?url=file/${file.name_file}';
                                                                }
                                                              })(),
                                                              fit: BoxFit
                                                                  .contain,
                                                            ),
                                                          ),
                                                          if (file.type_file ==
                                                              'youtube_url')
                                                            Positioned(
                                                              top: 150,
                                                              left: 300,
                                                              child: Container(
                                                                width: 100,
                                                                height: 100,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              8)),
                                                                  image:
                                                                      DecorationImage(
                                                                    image: AssetImage(
                                                                        myconstant
                                                                            .playicon),
                                                                    fit: BoxFit
                                                                        .scaleDown, // หรือเลือก BoxFit ตามที่เหมาะสม
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    10,
                                                                    0,
                                                                    10,
                                                                    0),
                                                            child: Row(
                                                              children: [
                                                                const Text(
                                                                    'ชื่อไฟล์ : ',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            16)),
                                                                Text(
                                                                    "${file.name_file}"),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    10,
                                                                    0,
                                                                    10,
                                                                    0),
                                                            width: 600,
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                const Text(
                                                                  'รายละเอียด : ',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                ),
                                                                Flexible(
                                                                  child: Text(
                                                                      "${file.description_file}",
                                                                      overflow:
                                                                          TextOverflow
                                                                              .visible),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    10,
                                                                    0,
                                                                    10,
                                                                    0),
                                                            // width: 200,
                                                            child: Row(
                                                              children: [
                                                                const Text(
                                                                    'ผู้อัพโหลด :',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            16)),
                                                                Text(
                                                                    "${file.user_name}"),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    10,
                                                                    0,
                                                                    10,
                                                                    0),
                                                            // width: 200,
                                                            child: Row(
                                                              children: [
                                                                const Text(
                                                                    'เวลาที่อัพโหลด : ',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            16)),
                                                                Text(file
                                                                    .datetime_upload),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    10,
                                                                    0,
                                                                    10,
                                                                    0),
                                                            child: Row(
                                                              children: [
                                                                const Text(
                                                                  'Tag: ',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                                Text(
                                                                    "${file.Tag}"),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: Text('Back')),
                                                TextButton(
                                                  //แก้ไขรายละเอียดไฟล์
                                                  onPressed: () async {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return StatefulBuilder(
                                                          builder: (context,
                                                              setState) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  'Edit File'),
                                                              content:
                                                                  SingleChildScrollView(
                                                                child: Column(
                                                                  children: [
                                                                    TextField(
                                                                      controller:
                                                                          descriptionFileEdit,
                                                                      decoration:
                                                                          const InputDecoration(
                                                                        labelText:
                                                                            'แก้ไขรายละเอียด',
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          context),
                                                                  child: Text(
                                                                      'Cancel'),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () async {
                                                                    String
                                                                        apipath =
                                                                        'https://btmexpertsales.com/filemanagesys/edit_file_detail.php?descriptionFileEdit=${descriptionFileEdit.text}&idFile=${file.number_cate}';

                                                                    await Dio()
                                                                        .get(
                                                                            apipath)
                                                                        .then(
                                                                            (value) {
                                                                      // print(
                                                                      //     value);
                                                                    });
                                                                    Navigator.pop(
                                                                        context);
                                                                    Navigator.pushReplacement(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (BuildContext context) =>
                                                                                super.widget));
                                                                  },
                                                                  child: Text(
                                                                      'Confirm'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Text('Edit'),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                        child: ListTile(
                                          title: Text(file.name_file),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                title: const Text(
                                  'ERROR',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                content: const Text(
                                  'No information found !!!',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 16,
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Confirm',
                                      style: TextStyle(
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      decoration: const InputDecoration(
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
                                                "เอกสารเกี่ยวกับ Solutions ต่างๆของทางบริษัท TMHWST",
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
                                                        "Promotion",
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
