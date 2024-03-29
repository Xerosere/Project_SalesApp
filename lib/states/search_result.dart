import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectsalesmaterial/model/filelist.dart';
import 'package:projectsalesmaterial/states/upload_main.dart';
import 'package:projectsalesmaterial/states/video_content.dart';
import 'package:projectsalesmaterial/utility/myconstant.dart';
import 'package:url_launcher/url_launcher.dart';

class Search_result extends StatefulWidget {
  final String search_data;

  const Search_result({super.key, required this.search_data});

  @override
  State<Search_result> createState() => _Search_resultState();
}

class _Search_resultState extends State<Search_result> {
  late String received_search;
  List<FileModel> file_detail_list = [];

  List<FileModel> file_search = [];
  TextEditingController descriptionFileEdit = TextEditingController();

  @override
  void initState() {
    super.initState();
    received_search = widget.search_data;

    getfiledetail();
    file_search = file_detail_list;
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
        title: Text('ผลลัพธ์การค้นหา: $received_search'),
      ),
      body: Container(
          //content
          child: Column(children: [
        Container(
          padding: const EdgeInsets.fromLTRB(80, 20, 80, 20),
          margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          width: screensize,
          height: screensizeHeight * 0.9,
          child: ListView(shrinkWrap: true, children: [
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 5,
              children: [
                for (var data in file_detail_list.where((file) =>
                    file.name_file.toLowerCase() ==
                        received_search
                            .toLowerCase() || // ตรวจสอบว่าชื่อไฟล์มี value ที่ค้นหาหรือไม่
                    file.Tag.toLowerCase().contains(received_search
                        .toLowerCase()) || // ตรวจสอบ Tag มี value ที่ค้นหาหรือไม่
                    file.IDcategory_first.toLowerCase().contains(received_search
                        .toLowerCase()) || // ตรวจสอบ IDcategory_first มี value ที่ค้นหาหรือไม่
                    file.IDcategory_second!
                        .toLowerCase() // ตรวจสอบ category2 มี value ที่ค้นหาหรือไม่
                        .contains(received_search.toLowerCase()) ||
                    file.IDcategory_third!
                        .toLowerCase() // ตรวจสอบ category3 มี value ที่ค้นหาหรือไม่
                        .contains(received_search.toLowerCase()) ||
                    file.IDcategory_fourth!
                        .toLowerCase() // ตรวจสอบ category4 มี value ที่ค้นหาหรือไม่
                        .contains(received_search.toLowerCase()) ||
                    file.description_file!
                        .toLowerCase() // ตรวจสอบ รายละเอียด มี value ที่ค้นหาหรือไม่
                        .contains(received_search.toLowerCase())))
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Container(
                      color: Color.fromARGB(0, 230, 84, 84),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          foregroundColor: Color.fromARGB(255, 0, 0, 0),
                          backgroundColor: Color.fromARGB(255, 255, 255, 255),
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context2) => AlertDialog(
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(data.name_file),
                                        Container(
                                          height: 30,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              String url =
                                                  'https://btmexpertsales.com/filemanagesys/download.php?filename=${data.name_file}';
                                              launch(url);
                                            },
                                            child: const Text(
                                              'Download',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    content: SingleChildScrollView(
                                      //POPUP เปิดไฟล์
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              print('7777777');
                                              if (data.type_file ==
                                                  'youtube_url') {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                  builder: (context) {
                                                    return VideoContent(
                                                      idref:
                                                          '${data.path_video}',
                                                      title:
                                                          '${data.name_file}',
                                                      id_firstcate:
                                                          '${data.IDcategory_first}',
                                                    );
                                                  },
                                                ));
                                              } else if (data.type_file ==
                                                  'fileServer_url') {
                                                String fileUrl =
                                                    'https://btmexpertsales.com/filemanagesys/file/${data.name_file}';
                                                launch(fileUrl);
                                                print(
                                                    '5555555555555 ${data.name_file}');
                                              }
                                            },
                                            child: Stack(
                                              children: [
                                                // Container ที่บรรจุรูปภาพ
                                                Container(
                                                  width: 700,
                                                  height: 400,
                                                  padding: EdgeInsets.all(20),
                                                  child:
                                                      FadeInImage.assetNetwork(
                                                    placeholder:
                                                        myconstant.loadinggif,
                                                    image: (() {
                                                      if (data.name_file
                                                          .toLowerCase()
                                                          .endsWith('.pdf')) {
                                                        return myconstant
                                                            .pdficon;
                                                      } else if (data.name_file
                                                          .toLowerCase()
                                                          .endsWith('.docx')) {
                                                        return myconstant
                                                            .docicon;
                                                      } else if (data.name_file
                                                          .toLowerCase()
                                                          .endsWith('.xlsx')) {
                                                        return myconstant
                                                            .xlsxicon;
                                                      } else if (data.name_file
                                                          .toLowerCase()
                                                          .endsWith('.zip')) {
                                                        return myconstant
                                                            .zipicon;
                                                      } else if (data
                                                              .type_file ==
                                                          'youtube_url') {
                                                        print(
                                                            'API_path_video_Search');
                                                        return 'https://btmexpertsales.com/filemanagesys/showimages.php?url=https://img.youtube.com/vi/${data.path_video}/maxresdefault.jpg';
                                                      } else {
                                                        print(
                                                            'data_file_pic_Search');

                                                        return 'https://btmexpertsales.com/filemanagesys/showimages.php?url=file/${data.name_file}';
                                                      }
                                                    })(),
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                                if (data.type_file ==
                                                    'youtube_url')
                                                  Positioned(
                                                    top: 150,
                                                    left: 300,
                                                    child: Container(
                                                      width: 100,
                                                      height: 100,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    8)),
                                                        image: DecorationImage(
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
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 0, 10, 0),
                                                  child: Row(
                                                    children: [
                                                      const Text('ชื่อไฟล์ : ',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16)),
                                                      Text("${data.name_file}"),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 0, 10, 0),
                                                  width: 600,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'รายละเอียด : ',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                            "${data.description_file}",
                                                            overflow:
                                                                TextOverflow
                                                                    .visible),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 0, 10, 0),
                                                  // width: 200,
                                                  child: Row(
                                                    children: [
                                                      const Text('ผู้อัพโหลด :',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16)),
                                                      Text("${data.user_name}"),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 0, 10, 0),
                                                  // width: 200,
                                                  child: Row(
                                                    children: [
                                                      const Text(
                                                          'เวลาที่อัพโหลด : ',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16)),
                                                      Text(
                                                          data.datetime_upload),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 0, 10, 0),
                                                  width: 120,
                                                  child: Row(
                                                    children: [
                                                      const Text(
                                                        'File ID : ',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16),
                                                      ),
                                                      Text(
                                                          "${data.number_cate}"),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 0, 10, 0),
                                                  child: Row(
                                                    children: [
                                                      const Text(
                                                        'Tags : ',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16),
                                                      ),
                                                      Text("${data.Tag}"),
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
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text('Back')),
                                          Container(
                                            child: Row(
                                              children: [
                                                TextButton(
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
                                                                          descriptionFileEdit, // ใช้ TextEditingController ที่กำหนดไว้ก่อนหน้านี้
                                                                      decoration:
                                                                          const InputDecoration(
                                                                        labelText:
                                                                            'แก้ไขรายละเอียด', // ให้เป็น label ของ TextField
                                                                      ),
                                                                    ),
                                                                    // สามารถเพิ่ม TextField หรือ Widgets อื่นๆ เพิ่มเติมที่นี่
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
                                                                    print(
                                                                        '${descriptionFileEdit.text}');
                                                                    String
                                                                        apipath =
                                                                        'https://btmexpertsales.com/filemanagesys/edit_file_detail.php?descriptionFileEdit=${descriptionFileEdit.text}&idFile=${data.number_cate}';

                                                                    await Dio()
                                                                        .get(
                                                                            apipath)
                                                                        .then(
                                                                            (value) {
                                                                      print(
                                                                          value);
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
                                          ),
                                        ],
                                      ),
                                    ],
                                  ));
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 270,
                              height: 120,
                              child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                  child: FadeInImage.assetNetwork(
                                      placeholder: myconstant.loadinggif,
                                      image: (() {
                                        if (data.name_file
                                            .toLowerCase()
                                            .endsWith('.pdf')) {
                                          return myconstant.pdficon;
                                        } else if (data.name_file
                                            .toLowerCase()
                                            .endsWith('.docx')) {
                                          return myconstant.docicon;
                                        } else if (data.name_file
                                            .toLowerCase()
                                            .endsWith('.xlsx')) {
                                          return myconstant.xlsxicon;
                                        } else if (data.name_file
                                            .toLowerCase()
                                            .endsWith('.zip')) {
                                          return myconstant.zipicon;
                                        } else if (data.type_file ==
                                            'youtube_url') {
                                          print('API3_path_video');
                                          return 'https://btmexpertsales.com/filemanagesys/showimages.php?url=https://img.youtube.com/vi/${data.path_video}/maxresdefault.jpg';
                                        } else {
                                          print('data3_path_video');
                                          return 'https://btmexpertsales.com/filemanagesys/showimages.php?url=file/${data.name_file}';
                                        }
                                      })(),
                                      fit: BoxFit.contain)),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              width: 300,
                              height: 120,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.name_file,
                                    style: const TextStyle(fontSize: 12),
                                    overflow: TextOverflow
                                        .ellipsis, // แสดงข้อความที่เกินให้ตัดแล้วแสดง ...
                                    maxLines:
                                        2, // จำกัดให้แสดงข้อความในบรรทัดเดียวเท่านั้น
                                  ),
                                  Text(
                                    'รายละเอียด : '
                                    "${data.description_file}",
                                    overflow: TextOverflow
                                        .ellipsis, // แสดงข้อความที่เกินให้ตัดแล้วแสดง ...
                                    maxLines:
                                        2, // จำกัดให้แสดงข้อความได้สูงสุด 3 บรรทัด
                                  ),
                                  Text(
                                    'เวลาอัพโหลด : ${data.datetime_upload}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ]),
        )
      ])),
    );
  }
}
