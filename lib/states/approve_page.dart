import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:projectsalesmaterial/model/filelist.dart';
import 'package:projectsalesmaterial/model/tag_detal.dart';
import 'package:projectsalesmaterial/states/video_content.dart';
import 'package:projectsalesmaterial/utility/myconstant.dart';
import 'package:url_launcher/url_launcher.dart';

class approve_page extends StatefulWidget {
  const approve_page({super.key});
  @override
  State<approve_page> createState() => _approve_pageState();
}

class _approve_pageState extends State<approve_page> {
  List<FileModel> file_detail_list = [];
  TextEditingController descriptionFileEdit = TextEditingController();

  //upload tag file
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagController = TextEditingController();
  List<String> _selectedTags = [];
  List<Tag_Model> tag_list = []; // ตัวอย่างการประกาศและสร้าง instance ของ List
  final tag_selector = <String>[];
  List<String> chipsList = [];
  TextEditingController addTag = TextEditingController();
  static const IconData add_task_sharp =
      IconData(0xe75a, fontFamily: 'MaterialIcons');

  static const IconData block_sharp =
      IconData(0xe7df, fontFamily: 'MaterialIcons');

  static const IconData check_circle_outline_rounded =
      IconData(0xf634, fontFamily: 'MaterialIcons');

  @override
  void initState() {
    super.initState();
    getfiledetail();
    gettagdetail();
  }

  Future<void> gettagdetail() async {
    //รับค่า ข้อมูลTagทั้งหมด
    tag_list.clear();
    String apipath =
        'https://btmexpertsales.com/filemanagesys/get_detail_tag.php';
    await Dio().get(apipath).then((value) {
      print('XXXxXX$value');
      for (var data in jsonDecode(value.data)) {
        Tag_Model tagdetail = Tag_Model.fromMap(data);
        setState(
          () {
            tag_list.add(tagdetail);
            print('XXXXX$tag_list');
            tag_list.forEach((tag) {
              if (!_selectedTags.contains(tag.name_tag)) {
                _selectedTags.add(tag.name_tag);
              }
            });

            print('XXXXX$_selectedTags');
          },
        );
      }
    });
  }

  Future<void> getfiledetail() async {
    //รับค่าข้อมูลไฟล์ทั้งหมดที่รออนุมัติ
    file_detail_list.clear();
    String apipath =
        'https://btmexpertsales.com/filemanagesys/get_file_pendding.php';
    await Dio().get(apipath).then((value) {
      print('ไฟล์Home' + '$value');
      for (var data in jsonDecode(value.data)) {
        FileModel filedetail = FileModel.fromMap(data);
        setState(
          () {
            file_detail_list.add(filedetail);
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
        title: Text('Approve File'),
      ),
      body: Container(
          //content  แสดงไฟล์ที่รออนุมัติ
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
                for (var data in file_detail_list)
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
                                            //ปุ่มดาวน์โหลด
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
                                                          fit: BoxFit.scaleDown,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            //รายละเอียดต่างๆของไฟล์
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
                                      //ปุ่มต่างๆในหน้ารายละเอียดไฟล์
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                //ปุ่มอนุมัติให้ไฟล์แสดงที่หน้าแอพได้
                                                margin: EdgeInsets.all(5),
                                                height: 50,
                                                child: ElevatedButton.icon(
                                                  style: ButtonStyle(
                                                    shape: MaterialStateProperty
                                                        .all<OutlinedBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    ),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(
                                                      const Color.fromARGB(
                                                          255, 40, 238, 83),
                                                    ),
                                                    foregroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(
                                                      Color.fromARGB(
                                                          255, 0, 0, 0),
                                                    ),
                                                    elevation:
                                                        MaterialStateProperty
                                                            .all<double>(8),
                                                    shadowColor:
                                                        MaterialStateProperty
                                                            .all<Color>(
                                                      Colors.grey
                                                          .withOpacity(0.5),
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    showDialog(
                                                      //แจ้งเตือนให้กดยืนยันอีก1รอบ
                                                      context: context2,
                                                      builder: (context) {
                                                        return WillPopScope(
                                                          onWillPop:
                                                              () async => //ฟังก์ชั่นแจ้งเตือนเมื่อ EDIT category สำเร็จ
                                                                  false, // ป้องกันการปิด AlertDialog ด้วยการกด back button บนอุปกรณ์
                                                          child: AlertDialog(
                                                            backgroundColor:
                                                                Colors.white,
                                                            title: const Text(
                                                              'APPROVE CONFIRM',
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                            content: const Text(
                                                              'ยืนยันการอนุมัติไฟล์นี้ใช่หรือไม่',
                                                              style: TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        0,
                                                                        0,
                                                                        0),
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                //ปุ่มยืนยันการอนุมัติให้ไฟล์แสดงที่หน้าแอพได้
                                                                onPressed:
                                                                    () async {
                                                                  String
                                                                      apipath =
                                                                      'https://btmexpertsales.com/filemanagesys/approve_file.php?id_file=${data.number_cate}';

                                                                  await http
                                                                      .get(Uri.parse(
                                                                          apipath))
                                                                      .then(
                                                                          (response) {
                                                                    if (response
                                                                            .statusCode ==
                                                                        200) {
                                                                      print(
                                                                          'API request successful');
                                                                    } else {
                                                                      print(
                                                                          'Error: ${response.statusCode}');
                                                                    }
                                                                  }).catchError(
                                                                          (error) {
                                                                    print(
                                                                        'Error: $error');
                                                                  });

                                                                  file_detail_list
                                                                      .clear();
                                                                  String
                                                                      apipath2 =
                                                                      'https://btmexpertsales.com/filemanagesys/get_file_pendding.php';
                                                                  await Dio()
                                                                      .get(
                                                                          apipath2)
                                                                      .then(
                                                                          (value) {
                                                                    print('sdqwdwq' +
                                                                        '$value');
                                                                    for (var data
                                                                        in jsonDecode(
                                                                            value.data)) {
                                                                      FileModel
                                                                          filedetail =
                                                                          FileModel.fromMap(
                                                                              data);
                                                                      setState(
                                                                        () {
                                                                          file_detail_list
                                                                              .add(filedetail);
                                                                        },
                                                                      );
                                                                    }
                                                                  });

                                                                  Navigator.pop(
                                                                      context);
                                                                  Navigator.pop(
                                                                      context2);

                                                                  ScaffoldMessenger.of(
                                                                          //แจ้งเตือนการอนุมัติ
                                                                          context)
                                                                      .showSnackBar(
                                                                    SnackBar(
                                                                      content: Text(
                                                                          'อนุมัติการแสดงไฟล์สำเร็จ'),
                                                                    ),
                                                                  );
                                                                },
                                                                child:
                                                                    const Text(
                                                                  'Confirm',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .blue,
                                                                  ),
                                                                ),
                                                              ),
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                    'cancel',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .red,
                                                                    ),
                                                                  ))
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                  icon: const Icon(Icons
                                                      .check_circle_outline_rounded),
                                                  label: const Text(
                                                    'APPROVE',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                //ปุ่มReject
                                                margin: EdgeInsets.all(5),
                                                height: 50,
                                                child: ElevatedButton.icon(
                                                    style: ButtonStyle(
                                                      shape: MaterialStateProperty
                                                          .all<OutlinedBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                      ),
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(
                                                        const Color.fromARGB(
                                                            255, 235, 10, 10),
                                                      ),
                                                      foregroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(
                                                        Color.fromARGB(
                                                            255, 0, 0, 0),
                                                      ),
                                                      elevation:
                                                          MaterialStateProperty
                                                              .all<double>(8),
                                                      shadowColor:
                                                          MaterialStateProperty
                                                              .all<Color>(
                                                        Colors.grey
                                                            .withOpacity(0.5),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      showDialog(
                                                        //แจ้งเตือนว่าจะReject หรือไม่
                                                        context: context2,
                                                        builder: (context) {
                                                          return WillPopScope(
                                                            onWillPop:
                                                                () async => //ฟังก์ชั่นแจ้งเตือนเมื่อ EDIT category สำเร็จ
                                                                    false, // ป้องกันการปิด AlertDialog ด้วยการกด back button บนอุปกรณ์
                                                            child: AlertDialog(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              title: const Text(
                                                                'REJECT CONFIRM',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 18,
                                                                ),
                                                              ),
                                                              content:
                                                                  const Text(
                                                                'ยืนยันการปฏิเสธไฟล์นี้ใช่หรือไม่',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  //ปุ่มยืนยันการ Reject
                                                                  onPressed:
                                                                      () async {
                                                                    String
                                                                        apipath = //ลบไฟล์ออกจากsql
                                                                        'https://btmexpertsales.com/filemanagesys/delete_pendding_file.php?id_file=${data.number_cate}';

                                                                    await http
                                                                        .get(Uri.parse(
                                                                            apipath))
                                                                        .then(
                                                                            (response) {
                                                                      if (response
                                                                              .statusCode ==
                                                                          200) {
                                                                        print(
                                                                            'API request successful');
                                                                      } else {
                                                                        print(
                                                                            'Error: ${response.statusCode}');
                                                                      }
                                                                    }).catchError(
                                                                            (error) {
                                                                      print(
                                                                          'Error: $error');
                                                                    });

                                                                    file_detail_list
                                                                        .clear();
                                                                    String
                                                                        apipath2 =
                                                                        'https://btmexpertsales.com/filemanagesys/get_file_pendding.php';
                                                                    await Dio()
                                                                        .get(
                                                                            apipath2)
                                                                        .then(
                                                                            (value) {
                                                                      print('sdqwdwq' +
                                                                          '$value');
                                                                      for (var data
                                                                          in jsonDecode(
                                                                              value.data)) {
                                                                        FileModel
                                                                            filedetail =
                                                                            FileModel.fromMap(data);
                                                                        setState(
                                                                          () {
                                                                            file_detail_list.add(filedetail);
                                                                          },
                                                                        );
                                                                      }
                                                                    });

                                                                    Navigator.pop(
                                                                        context);
                                                                    Navigator.pop(
                                                                        context2);

                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                      SnackBar(
                                                                        content:
                                                                            Text('การปฏิเสธไฟล์สำเร็จ'),
                                                                      ),
                                                                    );
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    'Confirm',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .blue,
                                                                    ),
                                                                  ),
                                                                ),
                                                                TextButton(
                                                                    //ยกเลิก
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child:
                                                                        const Text(
                                                                      'cancel',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .red,
                                                                      ),
                                                                    ))
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    icon: const Icon(Icons
                                                        .check_circle_outline_rounded),
                                                    label: const Text(
                                                      'REJECT',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w900),
                                                    )),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              TextButton(
                                                  //ปุ่มปิดหน้าต่างแสดงรายละเอียดต่างๆของไฟล์
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: Text('Back')),
                                              Container(
                                                // ปุ่มแก้ไขไฟล์
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
                                                                    child:
                                                                        Column(
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
                                                                        Container(
                                                                            //แก้ไขtag ของไฟล์โดยการจะแทนค่าที่tagเดิมทั้งหมด
                                                                            width:
                                                                                700,
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                TextFormField(
                                                                                  controller: _tagController,
                                                                                  onChanged: (value) {
                                                                                    setState(() {
                                                                                      _selectedTags.clear();
                                                                                      _selectedTags.addAll(tag_list.where((element) => element.name_tag.toUpperCase().contains(value.toUpperCase())).map((tag) => tag.name_tag).toList());
                                                                                    });
                                                                                  },
                                                                                  decoration: InputDecoration(
                                                                                    labelText: "Search Tags",
                                                                                    hintText: "Search tags",
                                                                                    suffixIcon: IconButton(
                                                                                      icon: Icon(Icons.add),
                                                                                      onPressed: () {
                                                                                        showDialog(
                                                                                          //ปุ่ม + ด้านหลังกล่องSearch tags
                                                                                          context: context,
                                                                                          builder: (BuildContext context) {
                                                                                            return AlertDialog(
                                                                                              title: Text("Add Tag"),
                                                                                              content: TextField(
                                                                                                controller: addTag,
                                                                                                decoration: InputDecoration(
                                                                                                  hintText: "Enter tag name",
                                                                                                ),
                                                                                              ),
                                                                                              actions: [
                                                                                                TextButton(
                                                                                                  onPressed: () {
                                                                                                    Navigator.of(context).pop();
                                                                                                  },
                                                                                                  child: Text("Cancel"),
                                                                                                ),
                                                                                                ElevatedButton(
                                                                                                  onPressed: () {
                                                                                                    var apipath = //เพิ่มtagในฐานข้อมูล
                                                                                                        'https://www.btmexpertsales.com/filemanagesys/insert_tag_detail.php?name_tag=${addTag.text}';
                                                                                                    Dio().get(apipath).then((response) {
                                                                                                      print('Response: $response');

                                                                                                      setState(() {
                                                                                                        tag_list.clear();
                                                                                                        String apipath = //โหลดข้อมูล tag และ แสดง
                                                                                                            'https://btmexpertsales.com/filemanagesys/get_detail_tag.php';
                                                                                                        Dio().get(apipath).then((value) {
                                                                                                          for (var data in jsonDecode(value.data)) {
                                                                                                            Tag_Model tagdetail = Tag_Model.fromMap(data);
                                                                                                            setState(
                                                                                                              () {
                                                                                                                tag_list.add(tagdetail);
                                                                                                                tag_list.forEach((tag) {
                                                                                                                  if (!_selectedTags.contains(tag.name_tag)) {
                                                                                                                    _selectedTags.add(tag.name_tag);
                                                                                                                  }
                                                                                                                });

                                                                                                                print('ssssss$_selectedTags');
                                                                                                              },
                                                                                                            );
                                                                                                          }
                                                                                                        });
                                                                                                      });

                                                                                                      if (response.statusCode == 200) {
                                                                                                        print('Data inserted successfully');
                                                                                                      } else {
                                                                                                        print('Failed to insert data');
                                                                                                      }
                                                                                                    }).catchError((error) {
                                                                                                      print('Error: $error');
                                                                                                    });
                                                                                                    Navigator.of(context).pop();
                                                                                                  },
                                                                                                  child: Text("Confirm"),
                                                                                                ),
                                                                                              ],
                                                                                            );
                                                                                          },
                                                                                        );
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                                                                  child: Visibility(
                                                                                    visible: _selectedTags.isEmpty, //ถ้าข้อมูลที่ป้อนและข้อมูลTag ในฐานข้อมูลไม่ตรงกัน
                                                                                    child: Text(
                                                                                      "ไม่มี Tag ที่ต้องการ (สามารถเพิ่ม Tag โดยคลิกที่เครื่องหมาย + ที่ช่อง Search Tag)",
                                                                                      style: TextStyle(color: Colors.red),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                SingleChildScrollView(
                                                                                  child: Container(
                                                                                    //ถ้าข้อมูลที่ป้อนและข้อมูลTag ในฐานข้อมูลตรงกัน
                                                                                    height: 50,
                                                                                    width: 700,
                                                                                    child: ListView.builder(
                                                                                      scrollDirection: Axis.horizontal,
                                                                                      itemCount: _selectedTags.length,
                                                                                      physics: AlwaysScrollableScrollPhysics(), // เพิ่ม physics เพื่อให้เลื่อนด้วยคลิกเมาส์
                                                                                      itemBuilder: (context, index) {
                                                                                        return Padding(
                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                          child: GestureDetector(
                                                                                            onTap: () {
                                                                                              print('object');
                                                                                            },
                                                                                            child: ElevatedButton(
                                                                                              onPressed: () {
                                                                                                setState(() {
                                                                                                  String chipName = _selectedTags.elementAt(index);
                                                                                                  if (!chipsList.contains(chipName)) {
                                                                                                    chipsList.add(chipName); // เพิ่มชื่อ Chip เข้า List ถ้ายังไม่มีใน List
                                                                                                    // ปริ้นข้อมูลใน chipsList หลังจากเพิ่ม Chips เข้าไป
                                                                                                  } else {
                                                                                                    print('Chip $chipName already exists in the list.'); // ปริ้นข้อความแจ้งเตือนถ้าชื่อ Chip มีอยู่แล้วใน List
                                                                                                  }
                                                                                                });

                                                                                                print(chipsList);
                                                                                              },
                                                                                              child: Text(_selectedTags.elementAt(index)),
                                                                                              style: ElevatedButton.styleFrom(),
                                                                                            ),
                                                                                          ),
                                                                                        );
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  height: 50,
                                                                                  child: ListView.builder(
                                                                                    scrollDirection: Axis.horizontal,
                                                                                    itemCount: chipsList.length,
                                                                                    itemBuilder: (context, index) {
                                                                                      return Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: Chip(
                                                                                          label: Text(chipsList[index]),
                                                                                          deleteIcon: Icon(Icons.close),
                                                                                          onDeleted: () {
                                                                                            setState(() {
                                                                                              chipsList.removeAt(index); // เมื่อกด x หลัง item ลบ Chip ที่ถูกกดออกจาก List
                                                                                              print(chipsList);
                                                                                            });
                                                                                          },
                                                                                        ),
                                                                                      );
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            )),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  actions: [
                                                                    TextButton(
                                                                      onPressed:
                                                                          () =>
                                                                              Navigator.pop(context),
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
                                                                            .get(apipath)
                                                                            .then((value) {
                                                                          print(
                                                                              value);
                                                                        });
                                                                        String
                                                                            apipath2 =
                                                                            'https://btmexpertsales.com/filemanagesys/Edit_file_tag.php?new_tag=${chipsList.join(',')}&idFile=${data.number_cate}';

                                                                        await Dio()
                                                                            .get(apipath2)
                                                                            .then((value) {});

                                                                        Navigator.pop(
                                                                            context);
                                                                        Navigator
                                                                            .pushReplacement(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (BuildContext context) => approve_page()),
                                                                        );
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
                              height: 108,
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
