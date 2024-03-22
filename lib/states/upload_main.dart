import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:projectsalesmaterial/model/fifth_category_model.dart';
import 'package:projectsalesmaterial/model/fourth_category_model.dart';
import 'package:projectsalesmaterial/model/second_category.dart';
import 'package:http/http.dart' as http;
import 'package:projectsalesmaterial/model/main_category.dart';
import 'package:projectsalesmaterial/model/tag_detal.dart';
import 'package:projectsalesmaterial/model/third_cate_model.dart';

import 'package:projectsalesmaterial/model/filelist.dart';
import 'package:projectsalesmaterial/utility/myconstant.dart';

class UploadHome extends StatefulWidget {
  const UploadHome({Key? key}) : super(key: key);

  @override
  State<UploadHome> createState() => _UploadHomeState();
}

File? img_file;
Uint8List webImageArr = Uint8List(8);
TextEditingController descriptionFileInput = TextEditingController();

int countselectfile = 0;

List<Widget> descriptionFile = [];
int countdescription = 0;
List<TextEditingController> descriptionControllers = [];

DateTime now = DateTime.now();
List<String> category = [];
TextEditingController plusCategory = TextEditingController();
String? currentOption;
String? currentOption2;
String? currentOption3;
String? currentOption4;
TextEditingController nameFileUpload = TextEditingController(
  text:
      '${currentOption}_${currentOption2}_${currentOption3}_${currentOption4}',
);
ScrollController _scrollController = ScrollController();

//List Model
List<MainCategoryModel> mainCategory = [];
List<SecondCategory> second_category_list = [];
List<Third_category> third_category_list = [];
List<FourthCategory> fourth_category_list = [];
List<FifthCategory> fifth_category_list = [];
List<FileModel> file_detail_list = [];
List<FileModel> name_file_delete = [];

//Add new category
TextEditingController addnameSecondCategory = TextEditingController();
TextEditingController addThirdCate = TextEditingController();
TextEditingController addfourthCate = TextEditingController();

//Edit name category
TextEditingController editnameSecond = TextEditingController();
TextEditingController editnameThird = TextEditingController();
TextEditingController editnameFourth = TextEditingController();

//upload link youtube
TextEditingController nameYoutube = TextEditingController();
TextEditingController descriptionLinkInput = TextEditingController();
TextEditingController pathVideoInput = TextEditingController();
String? videoId = '';

//upload tag file
final _nameController = TextEditingController();
final _descriptionController = TextEditingController();
final _tagController = TextEditingController();

List<String> _selectedTags = [];
List<Tag_Model> tag_list = []; // ตัวอย่างการประกาศและสร้าง instance ของ List
final tag_selector = <String>[];
List<String> chipsList = [];
TextEditingController addTag = TextEditingController();

class _UploadHomeState extends State<UploadHome> {
  @override
  void initState() {
    super.initState();
    getmaincategory();
    getsubCategory();
    getthirdsubCategory();
    getfourthCategory();
    getfiledetail();
    gettagdetail();
    // getfifthCategory();
    chipsList.clear();
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
    //รับค่า ข้อมูลไฟล์ทั้งหมด
    file_detail_list.clear();
    String apipath =
        'https://btmexpertsales.com/filemanagesys/get_allfiledetail.php';
    await Dio().get(apipath).then((value) {
      // print('ไฟล์Home$value');
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

  Future<Null> getmaincategory() async {
    //รับค่า cate1
    mainCategory.clear();
    String apipath =
        'https://btmexpertsales.com/filemanagesys/get_main_category.php';
    await Dio().get(apipath).then((value) {
      // print(value);
      for (var data in jsonDecode(value.data)) {
        MainCategoryModel mainCategoryList = MainCategoryModel.fromMap(data);
        setState(() {
          mainCategory.add(mainCategoryList);
        });
      }
      ;
    });
  }

  Future<Null> getsubCategory() async {
    //รับค่า cate2
    second_category_list.clear();
    String apipath =
        'https://btmexpertsales.com/filemanagesys/get_all_second_catagory.php';

    await Dio().get(apipath).then((value) {
      // print(value);
      for (var subcate in jsonDecode(value.data)) {
        SecondCategory secondcategorydetail = SecondCategory.fromMap(subcate);
        setState(() {
          second_category_list.add(secondcategorydetail);
          for (var item in second_category_list) {
            if (item.id_category == 'Presentation') {}
          }
        });
      }
    });
  }

  Future<Null> getthirdsubCategory() async {
    //รับค่า cate3
    third_category_list.clear();
    String apipath =
        'https://btmexpertsales.com/filemanagesys/get_all_third_category.php';
    await Dio().get(apipath).then((value) {
      for (var data in jsonDecode(value.data)) {
        Third_category thirdCateDetail = Third_category.fromMap(data);
        setState(() {
          third_category_list.add(thirdCateDetail);
        });
      }
      ;
    });
  }

  Future<Null> getfourthCategory() async {
    //รับค่า cate4
    fourth_category_list.clear();
    String apipath =
        'https://btmexpertsales.com/filemanagesys/get_all_fourth_category.php';
    await Dio().get(apipath).then((value) {
      for (var datafourth in jsonDecode(value.data)) {
        FourthCategory fourthCateDetail = FourthCategory.fromMap(datafourth);
        setState(() {
          fourth_category_list.add(fourthCateDetail);
        });
      }
      ;
    });
  }

  Future<Null> getfifthCategory() async {
    //รับค่า cate5
    String apipath =
        'https://btmexpertsales.com/filemanagesys/get_third_category.php';
    await Dio().get(apipath).then((value) {
      for (var data in jsonDecode(value.data)) {
        Third_category thirdCateDetail = Third_category.fromMap(data);
        setState(() {
          third_category_list.add(thirdCateDetail);
        });
      }
      ;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screensize = MediaQuery.of(context).size.width;
    double screensizeHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 235, 10, 30),
          foregroundColor: Color.fromARGB(255, 255, 255, 255),
          toolbarHeight: 80,
          title: const Text('UPLOAD'),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            selectOptions(), //ส่วนที่เลือก Category1-4
            Container(
              //ส่วนที่เป็นปุ่มเลือกไฟล์,แสดงไฟล์ที่เลือก,อัพโหลดLink
              margin: EdgeInsets.fromLTRB(50, 10, 20, 10),
              width: screensize * 0.3,
              height: screensizeHeight * 0.7,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 235, 239, 240),
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(myconstant.backgroundUpload),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        const Color.fromARGB(255, 255, 255, 255)
                            .withOpacity(0.2),
                        BlendMode.dstATop,
                      )),
                ),
                child: Column(
                  children: [
                    Container(
                      //ส่วนแสดงไฟล์ที่เลือก ไฟล์ที่เลือก,ชื่อไฟล์ที่จะบันทึกลงฐานข้อมูลและServer
                      width: screensize * 0.3,
                      height: 400,
                      child: img_file != null
                          ? Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(10),
                                  child: Text(
                                    img_file != null
                                        ? img_file!.path.split('/').last
                                        : 'No file selected', // เพิ่มข้อความเมื่อ img_file เป็น null
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(10),
                                  height: 50,
                                  width: 600,
                                  child: TextFormField(
                                    maxLength: 230,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[a-zA-Z0-9_]')),
                                    ],
                                    decoration: const InputDecoration(
                                      hintText:
                                          'ชื่อไฟล์นำมาจาก Option ที่เลือก',
                                      counterText: '',
                                    ),
                                    controller: nameFileUpload,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(10),
                                  width: 600,
                                  child: SizedBox(
                                    height: 200,
                                    child: TextFormField(
                                      maxLength: 500,
                                      maxLines: null,
                                      decoration: const InputDecoration(
                                        hintText: 'ระบุรายละเอียด',
                                        counterText: 'maxLength: 500',
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                      controller: descriptionFileInput,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                    ),
                    Row(
                      //ส่วนของปุ่มเลือกไฟลืและปุ่มอัพlink
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              margin: EdgeInsets.all(20),
                              width: 200,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: buttonuploadFile(context), //ปุ่มเลือกไฟล์
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              margin: EdgeInsets.all(20),
                              width: 200,
                              height: 50,
                              child: upLoadLinkYoutube(context), //ปุ่มอัพลิ้งค์
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  ElevatedButton buttonuploadFile(BuildContext context) {
    //ปุ่มเลือกไฟล์
    return ElevatedButton.icon(
      onPressed: () async {
        if (currentOption == null) {
          //ตรวจสอบว่า หมวดหมู่แรกไม่ว่าง ก่อนจะเลือกไฟล์ เพราะว่าต้องใช้ชื่อ หมวดหมู่ในการกำหนดชื่อไฟล์
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('กรุณาเลือกหมวดหมู่'),
            ),
          );
        } else if (currentOption !=
                null && //ตรวจสอบว่า ถ้าหมวดหมู่แรกที่เลือกมีหมวดหมู่ย่อย ต้องเลือกหมวดหมู่ย่อยก่อน
            second_category_list
                .any((item) => item.id_category == currentOption) &&
            currentOption2 == null) {
          print(second_category_list);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('กรุณาเลือกหมวดหมู่ที่สอง'),
            ),
          );
        } else if (currentOption2 !=
                null && //ตรวจสอบว่า ถ้าหมวดหมู่ที่2ที่เลือกมีหมวดหมู่ย่อย ต้องเลือกหมวดหมู่ย่อยก่อน
            third_category_list
                .any((item) => item.IDcategory_second == currentOption2) &&
            currentOption3 == null) {
          print(second_category_list);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('กรุณาเลือกหมวดหมู่ที่สาม'),
            ),
          );
        } else if (currentOption3 !=
                null && //ตรวจสอบว่า ถ้าหมวดหมู่ที่3ที่เลือกมีหมวดหมู่ย่อย ต้องเลือกหมวดหมู่ย่อยก่อน
            fourth_category_list
                .any((item) => item.IDcategory_third == currentOption3) &&
            currentOption4 == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('กรุณาเลือกหมวดหมู่ที่สี่'),
            ),
          );
        } else {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: [
              'jpg',
              'png',
              'pdf',
              'docx',
              'xlsx',
              'zip'
            ], //อัพได้แค่ประเภทไฟล์ที่ระบุ
          );
          if (result != null) {
            setState(() {
              nameFileUpload.clear();
              nameFileUpload.text =
                  '${currentOption}_${currentOption2}_${currentOption3}_${currentOption4}'; //ตั้งชื่อไฟล์ที่จะบันทึกลงฐานข้อมูลและserverเป็นชื่อ Category
              webImageArr = result.files.first.bytes!;
              img_file = File('${result.files.first.name}');
              print(webImageArr);
              print(img_file);
            });
          }
        }
      },
      icon: Icon(Icons.upload_file),
      label: const Text(
        "Select File",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        elevation: 5,
        shadowColor: Color.fromARGB(255, 0, 0, 0),
      ),
    );
  }

  ElevatedButton upLoadLinkYoutube(BuildContext context) {
    // สร้าง ElevatedButton สำหรับอัพโหลดลิ้งค์ YouTube
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        elevation: 5,
        shadowColor: Color.fromARGB(255, 0, 0, 0),
      ),
      onPressed: () {
        if (currentOption == null) {
          //ตรวจสอบว่า หมวดหมู่แรกไม่ว่าง ก่อนจะเลือกไฟล์ เพราะว่าต้องใช้ชื่อ หมวดหมู่ในการกำหนดชื่อไฟล์
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('กรุณาเลือกหมวดหมู่'),
            ),
          );
        } else if (currentOption !=
                null && //ตรวจสอบว่า ถ้าหมวดหมู่แรกที่เลือกมีหมวดหมู่ย่อย ต้องเลือกหมวดหมู่ย่อยก่อน
            second_category_list
                .any((item) => item.id_category == currentOption) &&
            currentOption2 == null) {
          print(second_category_list);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('กรุณาเลือกหมวดหมู่ที่สอง'),
            ),
          );
        } else if (currentOption2 !=
                null && //ตรวจสอบว่า ถ้าหมวดหมู่ที่2ที่เลือกมีหมวดหมู่ย่อย ต้องเลือกหมวดหมู่ย่อยก่อน
            third_category_list
                .any((item) => item.IDcategory_second == currentOption2) &&
            currentOption3 == null) {
          print(second_category_list);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('กรุณาเลือกหมวดหมู่ที่สาม'),
            ),
          );
        } else if (currentOption3 !=
                null && //ตรวจสอบว่า ถ้าหมวดหมู่ที่3ที่เลือกมีหมวดหมู่ย่อย ต้องเลือกหมวดหมู่ย่อยก่อน
            fourth_category_list
                .any((item) => item.IDcategory_third == currentOption3) &&
            currentOption4 == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('กรุณาเลือกหมวดหมู่ที่สี่'),
            ),
          );
        } else {
          // เมื่อปุ่มถูกกด
          showDialog(
            // ให้ผู้ใช้ป้อนข้อมูล
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Container(
                  width: 700.0,
                  height: 300.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                            hintText: 'Video Name'), //ป้อนชื่อของวิดีโอ
                        controller: nameYoutube,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            hintText: 'Description'), //ป้อนรายละเอียด
                        controller: descriptionLinkInput,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            hintText:
                                'Video URL'), //ป้อนLink จะเป็นFullหรือShort ก็ได้ Full link: https://www.youtube.com/watch?v=ItPC7-SjQfM Short link: https://youtu.be/ItPC7-SjQfM
                        controller: pathVideoInput,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          //ตรวจสอบว่าผู้ใช้ป้อนข้อมูลช่อง Name Video และ Video URL หรือไม่ ถ้าช่องใดช่องหนึ่งไม่มีข้อมูลจะขึ้นแจ้งเตือน
                          if (nameYoutube.text.isEmpty ||
                              pathVideoInput.text.isEmpty) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Please fill in all fields.'),
                              ),
                            );
                            return;
                          }
                          RegExp shortUrlRegExp = RegExp(
                              r'^https:\/\/youtu\.be\/([^\?&]+)'); //ตัด Short link ให้เหลือแค่ID ของวิดีโอ
                          Match? shortUrlMatch =
                              shortUrlRegExp.firstMatch(pathVideoInput.text);

                          RegExp fullUrlRegExp = RegExp(
                              r'^https:\/\/www\.youtube\.com\/watch\?v=([^\?&]+)'); //ตัด Full link ให้เหลือแค่ID ของวิดีโอ

                          Match? fullUrlMatch =
                              fullUrlRegExp.firstMatch(pathVideoInput.text);

                          String videoId; //เก็บค่า Youtube ID

                          if (shortUrlMatch !=
                                  null && //ตรวจสอบว่าความถูกต้องของLink ที่ผู้ใช้กรอก
                              shortUrlMatch.groupCount >= 1) {
                            videoId = shortUrlMatch.group(1)!;
                          } else if (fullUrlMatch != null &&
                              fullUrlMatch.groupCount >= 1) {
                            videoId = fullUrlMatch.group(1)!;
                          } else {
                            //ถ้าlink ไม่ถูกต้องให้แจ้งเตือนInvalid YouTube URL.
                            setState(() {
                              nameYoutube.clear();
                              pathVideoInput.clear();
                              descriptionLinkInput.clear();
                            });
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Invalid YouTube URL.'),
                              ),
                            );
                            return;
                          }
                          // เช็คว่า URL ซ้ำหรือไม่
                          bool isDuplicate = file_detail_list
                              .any((item) => item.path_video == videoId);
                          if (isDuplicate) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Duplicate video path. Please choose another video.'),
                              ),
                            );
                            return;
                          }
                          //ถ้าเงื่อนไขทั้งหมดผ่าน บันทึกข้อมูลลงฐานข้อมูล
                          String apipath =
                              'https://btmexpertsales.com/filemanagesys/insert_detail_filemanage.php?'
                              'nameFile=${nameYoutube.text}&'
                              'descriptionFile=${descriptionLinkInput.text}&'
                              'datetimeUpload=$now&'
                              'IDpath_youtube=$videoId&'
                              'IDcategory_first=$currentOption&'
                              'IDcategory_second=$currentOption2&'
                              'IDcategory_third=$currentOption3&'
                              'IDcategory_fourth=$currentOption4&'
                              'type_of_file=youtube_url&'
                              'tag_file=${currentOption3 != null ? '$currentOption3,' : ''}${chipsList.join(',')}';

                          Dio().get(apipath).then((response) {
                            print(response);
                          }).catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error uploading video.'),
                              ),
                            );
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Video uploaded successfully.'),
                            ),
                          );

                          // Clear input fields and close the dialog
                          setState(() {
                            nameYoutube.clear();
                            pathVideoInput.clear();
                            descriptionLinkInput.clear();
                          });
                          Navigator.pop(context);
                        },
                        child: Text('Confirm'),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
      icon: Icon(Icons.link),
      label: Text(
        'Link',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Container selectOptions() {
    //เลือกหมวดหมู่
    return Container(
      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          const Text(
            'SELECT FOLDER',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 20),
          const Text(
            'เลือกหมวดหมู่',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              // category 1
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),

              padding: EdgeInsets.all(2.5),
              width: 700,
              child: Container(
                width: 600,
                child: DropdownButton<String>(
                    alignment: Alignment.centerLeft,
                    style: TextStyle(
                      fontSize: 20,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                    value: currentOption,
                    onChanged: (String? newValue) {
                      //Setค่า CurrentOption ตามitem ที่เลือก
                      setState(() {
                        CrossAxisAlignment.center;
                        currentOption = newValue!;
                        currentOption2 = null;
                        currentOption3 = null;
                        currentOption4 = null;

                        nameFileUpload.clear();

                        nameFileUpload.text = //Setชื่อไฟล์ ตามitem ที่เลือก
                            '${currentOption}_${currentOption2}_${currentOption3}_${currentOption4}';
                      });
                    },
                    items: mainCategory.map((data) {
                      return DropdownMenuItem<String>(
                        value: data
                            .id_category, //ค่าของ item == id_category table:filemanage_firstcategory
                        child: Text(data.name_first),
                      );
                    }).toList()),
              ),
            ),
          ]),
          Container(
            //category2
            margin: EdgeInsets.all(20),
            alignment: Alignment.center,
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            padding: EdgeInsets.all(2.5),
            width: 700,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 450,
                  child: DropdownButton<String>(
                    alignment: Alignment.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: const Color.fromARGB(255, 0, 0, 0)),
                    value: currentOption2,
                    onChanged: (String? newValue) {
                      setState(() {
                        currentOption2 =
                            newValue!; //Setค่า CurrentOption 2 ตามitem ที่เลือก

                        currentOption3 = null;
                        currentOption4 = null;
                        print(currentOption2);
                        nameFileUpload.clear();

                        nameFileUpload.text = //Setชื่อไฟล์ ตามitem ที่เลือก
                            '${currentOption}_${currentOption2}_${currentOption3}_${currentOption4}';
                      });
                    },
                    items: second_category_list
                        .where((data) =>
                            data.id_category ==
                            currentOption) // แสดงเฉพาะ category2 ที่เป็น caregory2 ย่อยของ category1
                        .map((data) {
                      return DropdownMenuItem<String>(
                        value: data.name_second,
                        child: Container(
                            child: Text(data
                                .name_second)), //ค่าของ item == name_second table:filemanage_secondcategory
                      );
                    }).toList(),
                  ),
                ),

                Container(
                  //EditNameCategory2
                  // width: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      backgroundColor: Color.fromARGB(104, 200, 200, 200),
                    ),
                    onPressed: () {
                      if (currentOption2 == null) {
                        //ต้องเลอก currentOption2 ก่อนถึงจะแก้ไขได้
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('กรุณาเลือกหมวดหมู่ที่จะแก้ไข'),
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return AlertDialog(
                                  title: Text('Edit name "$currentOption2"'),
                                  content: Container(
                                    width: 500,
                                    child: TextFormField(
                                      maxLength: 50,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp(
                                            r'[a-zA-Z0-9_ ]')), //กรอกข้อมูลได้เฉพาะที่ระบุ
                                      ],
                                      decoration: InputDecoration(
                                        hintText:
                                            'Edit Name Category (a-z,A-Z,0-9,_, )',
                                      ),
                                      controller: editnameSecond,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      //ปุ่มยืนยันการแก้ไข
                                      onPressed: () async {
                                        String newSecondName =
                                            editnameSecond.text;
                                        // Check if the input is not empty and consists only of letters and digits
                                        if (newSecondName.isNotEmpty) {
                                          // Check if the new name already exists
                                          bool nameExists =
                                              second_category_list.any((item) =>
                                                  item.id_category ==
                                                      currentOption &&
                                                  item.name_second ==
                                                      newSecondName);
                                          if (nameExists) {
                                            //ถ้าข้อมูลที่ป้อนเข้ามามีค่าซ้ำกับข้อมูลในฐานข้อมูลจะแจ้งเตือนชื่อซ้ำ
                                            Navigator.pop(context);
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  backgroundColor: Colors.white,
                                                  title: const Text(
                                                    'ERROR',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                  content: const Text(
                                                    'Name already exists!!!',
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0),
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
                                            print('Name already exists!');
                                            return;
                                          }
                                          //ถ้าชื่อไม่ซ้ำจะอัพเดทชื่อ category2 ในtabel: filemanage_secondcategory
                                          String apipath = // Edit name cate 2
                                              'https://btmexpertsales.com/filemanagesys/edit_name_2nd_cate.php?edit_name_second=${newSecondName}&&Namecategory_second=${currentOption2}&&Namecategory_first=${currentOption}';

                                          await Dio()
                                              .get(apipath)
                                              .then((value) {
                                            print(value);
                                          });

                                          //ถ้าชื่อไม่ซ้ำจะอัพเดทชื่อ category2 ในข้อมูลไฟล์ทุกข้อมูลที่อยู่ใน category2 อันเดิม
                                          String
                                              apipath2 = // Edit name cate 2 in file
                                              'https://btmexpertsales.com/filemanagesys/edit_name_2nd_file.php?edit_name_second=${newSecondName}&&Namecategory_second=${currentOption2}&&Namecategory_first=${currentOption}';

                                          await Dio()
                                              .get(apipath2)
                                              .then((value) {
                                            print(value);
                                          });

                                          editnameSecond.clear();
                                          setState(() {
                                            currentOption2 = null;
                                          });

                                          Navigator.pop(context);
                                          AlertEditSuccessful(context);

                                          second_category_list.clear();
                                          //รับค่าข้อมูลของcategory2 ทั้งหมด
                                          String apipath3 =
                                              'https://btmexpertsales.com/filemanagesys/get_all_second_catagory.php';

                                          await Dio()
                                              .get(apipath3)
                                              .then((value) {
                                            print(value);
                                            for (var subcate
                                                in jsonDecode(value.data)) {
                                              SecondCategory
                                                  secondcategorydetail =
                                                  SecondCategory.fromMap(
                                                      subcate);
                                              setState(() {
                                                second_category_list
                                                    .add(secondcategorydetail);
                                              });
                                            }
                                          });
                                        } else {
                                          // กรณีที่ข้อมูลว่างเปล่า
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
                                                  'Please enter a name!!!',
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
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
                                      child: Text('Confirm'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      }
                    },
                    child: const Icon(
                      Icons.edit,
                    ),
                  ),
                ),
                Container(
                  //เพิ่ม category 2
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 255, 0, 0),
                      backgroundColor: Color.fromARGB(104, 200, 200, 200),
                      padding: EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      if (currentOption == null) {
                        // ต้องเลือก category 1 ก่อนถึงจะเพิ่ม category 2 ได้
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('กรุณาเลือกหมวดหมู่ที่หนึ่ง'),
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return AlertDialog(
                                  title: Text('Add a new category 2'),
                                  content: Container(
                                    width: 500,
                                    child: TextFormField(
                                      maxLength: 50,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[a-zA-Z0-9_ ]')),
                                      ],
                                      decoration: InputDecoration(
                                        hintText:
                                            'Add a new category (a-z,A-Z,0-9,_, )',
                                      ),
                                      controller: addnameSecondCategory,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        String addNewSecondCategory =
                                            addnameSecondCategory.text;
                                        // Check if the input is not empty and consists only of letters and digits
                                        if (addNewSecondCategory.isNotEmpty) {
                                          // Check if the new name already exists
                                          bool nameExists =
                                              second_category_list.any((item) =>
                                                  item.id_category ==
                                                      currentOption &&
                                                  item.name_second ==
                                                      addNewSecondCategory);
                                          if (nameExists) {
                                            //ถ้าข้อมูลที่ป้อนเข้ามามีค่าซ้ำกับข้อมูลในฐานข้อมูลจะแจ้งเตือนชื่อซ้ำ

                                            Navigator.pop(context);
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  backgroundColor: Colors
                                                      .white, // Set background color
                                                  title: const Text(
                                                    'ERROR',
                                                    style: TextStyle(
                                                      color: Colors
                                                          .red, // Set title text color
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                  content: const Text(
                                                    'Name already exists!!!',
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255,
                                                          0,
                                                          0,
                                                          0), // Set content text color
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
                                                          color: Colors
                                                              .blue, // Set button text color
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                            // Show error message or handle duplicate name
                                            print('Name already exists!');
                                            return; // Stop further execution
                                          }
                                          //ข้อมูลไม่ซ้ำ บันทึก catgory2 อันหใม่ ลงฐานข้อมูล
                                          String apipath =
                                              'https://btmexpertsales.com/filemanagesys/insert_second_category.php?name=${addnameSecondCategory.text}&&id_cate=${currentOption}';

                                          await Dio()
                                              .get(apipath)
                                              .then((value) {
                                            print(value);
                                          });
                                          addnameSecondCategory.clear();
                                          Navigator.pop(context);
                                          AlertAddSuccessful(context);

//รับค่า category 2 เพื่ออัพเดทข้อมูล
                                          second_category_list.clear();
                                          String apipath2 =
                                              'https://btmexpertsales.com/filemanagesys/get_all_second_catagory.php';

                                          await Dio()
                                              .get(apipath2)
                                              .then((value) {
                                            print(value);
                                            for (var subcate
                                                in jsonDecode(value.data)) {
                                              SecondCategory
                                                  secondcategorydetail =
                                                  SecondCategory.fromMap(
                                                      subcate);
                                              setState(() {
                                                second_category_list
                                                    .add(secondcategorydetail);
                                                for (var item
                                                    in second_category_list) {
                                                  if (item.id_category ==
                                                      currentOption) {
                                                    print(item);
                                                  }
                                                }
                                                currentOption2 = null;
                                              });
                                            }
                                          });
                                        } else {
                                          // กรณีที่ข้อมูลว่างเปล่า
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
                                                  'Please enter a name!!!',
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
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
                                      child: Text('Confirm'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      }
                    },
                    child: const Icon(Icons.add),
                  ),
                ),

//Delete category 2

                Container(
                  child: IconButton(
                    onPressed: () {
                      if (currentOption2 == null) {
                        // ต้องเลือก category 1 ก่อนถึงจะเพิ่ม category 2 ได้
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('กรุณาเลือก Category 2 ที่จะลบ'),
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Confirm Deletion'),
                              content: Text('Are you sure you want to delete?'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancel')),
                                TextButton(
                                  onPressed: () {
                                    String
                                        apipath = //ลบsecond_cateที่เลือกออกจากฐานข้อมูล
                                        'https://btmexpertsales.com/filemanagesys/delete_second_cate.php?Namecategory_first=${currentOption}&&Namecategory_second=${currentOption2}';
                                    Dio().get(apipath).then((value) {
                                      print(value);
                                      print('cate1$currentOption');
                                      print('cate2$currentOption2');
                                      print('cate3$currentOption3');
                                    });
                                    second_category_list.clear();
                                    String
                                        apipath2 = //โหลดsecond_cate ใหม่ เพื่อให้ข้อมูลอัพเดท
                                        'https://btmexpertsales.com/filemanagesys/get_all_second_catagory.php';
                                    Dio().get(apipath2).then((value) {
                                      for (var data in jsonDecode(value.data)) {
                                        SecondCategory secondCateDetail =
                                            SecondCategory.fromMap(data);
                                        setState(() {
                                          second_category_list
                                              .add(secondCateDetail);
                                        });
                                      }
                                    });
                                    file_detail_list.clear();
                                    String
                                        apipath3 = //ดึงข้อมูลใน third_cat ที่ลบไป
                                        'https://btmexpertsales.com/filemanagesys/getfilesec_change.php?file_first_cate=${currentOption}&file_second_cate=${currentOption2}';

                                    Dio().get(apipath3).then((value) {
                                      print('Response: $value');
                                      for (var data in jsonDecode(value.data)) {
                                        FileModel filedetail =
                                            FileModel.fromMap(data);
                                        setState(() {
                                          file_detail_list.add(filedetail);
                                        });
                                        // Prepare FormData for POST request
                                        FormData formData2 = FormData.fromMap({
                                          'nameFile': filedetail.name_file,
                                          'descriptionFile':
                                              filedetail.description_file,
                                          'datetimeUpload': filedetail
                                              .datetime_upload
                                              .toString(),
                                          'user_upload':
                                              filedetail.user_name ?? '',
                                          'number_cate': filedetail.number_cate,
                                          'path_video':
                                              filedetail.path_video ?? '',
                                          'IDcategory_first':
                                              filedetail.IDcategory_first,
                                          'IDcategory_second':
                                              filedetail.IDcategory_second,
                                          'IDcategory_third':
                                              filedetail.IDcategory_third,
                                          'IDcategory_fourth':
                                              filedetail.IDcategory_fourth,
                                          'type_file': filedetail.type_file,
                                          'datetime_deleted': now.toString(),
                                        });

                                        String
                                            apipath4 = //ย้ายข้อมูลไฟล์ที่อยู่ใน category 2 ไป table อื่นเพื่อไม่ใช้มีการแสดงไฟล์
                                            'https://btmexpertsales.com/filemanagesys/insert_filedetail_deleted.php';

                                        Dio()
                                            .post(apipath4, data: formData2)
                                            .then((response) {
                                          print(
                                              'Uploaded file: ${filedetail.name_file}');
                                          print(
                                              'Uploaded file3: ${currentOption2}');
                                        }).catchError((error) {
                                          print(
                                              'Error uploading file: ${filedetail.name_file}, Error: $error');
                                          // Handle error if necessary
                                        });
                                      }

                                      String apipath2 =
                                          //ลบข้อมูลที่ category2 = currentOption2ที่เลือก
                                          'https://btmexpertsales.com/filemanagesys/delete_second_detail.php?IDcategory_second=${currentOption2}&IDcategory_first=${currentOption}';
                                      Dio().get(apipath2).then((value) {
                                        print(value);
                                        print('cate1delete$currentOption');
                                        print('cate1delete$currentOption2');
                                        print('cate1delete$currentOption3');
                                      });
                                      setState(() {
                                        currentOption2 = null;
                                      });
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Delete'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    icon: Icon(Icons.delete),
                  ),
                ),
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.all(20),
            //category 3
            alignment: Alignment.center,
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            padding: EdgeInsets.all(2.5),
            width: 700,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 450,
                  child: DropdownButton<String>(
                      alignment: Alignment.center,
                      style: const TextStyle(
                          fontSize: 20, color: Color.fromARGB(255, 0, 0, 0)),
                      value: currentOption3,
                      onChanged: (String? newValue) {
                        setState(() {
                          currentOption3 =
                              newValue!; //Setค่า CurrentOption 2 ตามitem ที่เลือก
                          nameFileUpload.clear();

                          nameFileUpload.text =
                              '${currentOption}_${currentOption2}_${currentOption3}_${currentOption4}'; //Setชื่อไฟล์ ตามitem ที่เลือก
                          print(currentOption3);

                          currentOption4 = null;
                        });
                      },
                      items: third_category_list
                          .where((data) =>
                              data.IDcategory_first == currentOption &&
                              data.IDcategory_second ==
                                  currentOption2) // แสดงเฉพาะ category3 ที่เป็น caregory3 ย่อยของ category2
                          .map((data) {
                        return DropdownMenuItem<String>(
                          value: data.name_third,
                          child: Text(data.name_third),
                        );
                      }).toList()),
                ),
                Container(
                  //EditNameCategory3
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      backgroundColor: Color.fromARGB(104, 200, 200, 200),
                    ),
                    onPressed: () {
                      //ต้องเลอก currentOption3 ก่อนถึงจะแก้ไขได้

                      if (currentOption3 == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('กรุณาเลือกหมวดหมู่ที่จะแก้ไข'),
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return AlertDialog(
                                  title:
                                      Text('Edit Name Third"$currentOption3"'),
                                  content: Container(
                                    width: 500,
                                    child: TextFormField(
                                      maxLength: 50,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[a-zA-Z0-9_ ]')),
                                      ],
                                      decoration: const InputDecoration(
                                        hintText:
                                            'Edit Name Category (a-z,A-Z,0-9,_, )',
                                      ),
                                      controller: editnameThird,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        String newThirdName =
                                            editnameThird.text;
                                        // Check if the input is not empty and consists only of letters and digits
                                        if (newThirdName.isNotEmpty) {
                                          // Check if the new name already exists
                                          bool nameExists =
                                              third_category_list.any((item) =>
                                                  item.IDcategory_first ==
                                                      currentOption &&
                                                  item.IDcategory_second ==
                                                      currentOption2 &&
                                                  item.name_third ==
                                                      newThirdName);
                                          if (nameExists) {
                                            Navigator.pop(context);
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  backgroundColor: Colors.white,
                                                  title: const Text(
                                                    'ERROR',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                  content: const Text(
                                                    'Name already exists!!!',
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0),
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
                                            print('Name already exists!');
                                            return;
                                          }
                                          //ถ้าชื่อไม่ซ้ำจะอัพเดทชื่อ category3 ในtabel: filemanage_thirdcategory
                                          String apipath = // Edit name cate 3
                                              'https://btmexpertsales.com/filemanagesys/edit_name_3rd_cate.php?edit_name_third=${editnameThird.text}&&Namecategory_second=${currentOption2}&&Namecategory_first=${currentOption}&&Namecategory_third=${currentOption3}';

                                          Dio().get(apipath).then((value) {
                                            print(value);
                                          });

                                          //ถ้าชื่อไม่ซ้ำจะอัพเดทชื่อ category3 ในข้อมูลไฟล์ทุกข้อมูลที่อยู่ใน category3 อันเดิม
                                          String
                                              apipath2 = // Edit name cate 3 in File
                                              'https://btmexpertsales.com/filemanagesys/edit_name_3rd_file.php?edit_name_third=${editnameThird.text}&&Namecategory_second=${currentOption2}&&Namecategory_first=${currentOption}&&Namecategory_third=${currentOption3}';

                                          Dio().get(apipath2).then((value) {
                                            print(value);
                                          });

                                          editnameThird.clear();
                                          setState(() {
                                            currentOption3 = null;
                                          });

                                          Navigator.pop(context);
                                          AlertEditSuccessful(context);

                                          third_category_list.clear();
                                          // รับค่า category3 ใหม่เพื่ออัพเดทข้อมูล
                                          String apipath3 =
                                              'https://btmexpertsales.com/filemanagesys/get_all_third_category.php';

                                          await Dio()
                                              .get(apipath3)
                                              .then((value) {
                                            print(value);
                                            for (var data
                                                in jsonDecode(value.data)) {
                                              Third_category thirdCateDetail =
                                                  Third_category.fromMap(data);
                                              setState(() {
                                                third_category_list
                                                    .add(thirdCateDetail);
                                                for (var item
                                                    in third_category_list) {
                                                  if (item.IDcategory_first ==
                                                      currentOption) {
                                                    print(item);
                                                  }
                                                }
                                              });
                                            }
                                          });
                                        } else {
                                          // กรณีที่ข้อมูลว่างเปล่า
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
                                                  'Please enter a name!!!',
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
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
                                      child: Text('Confirm'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      }
                    },
                    child: const Icon(
                      Icons.edit,
                    ),
                  ),
                ),
                Container(
                  //เพิ่ม category3
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 255, 0, 0),
                      backgroundColor: Color.fromARGB(104, 200, 200, 200),
                      padding: EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      // ต้องเลือกcategory2ก่อน
                      if (currentOption2 == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('กรุณาเลือกหมวดหมู่ที่สอง'),
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return AlertDialog(
                                  title: Text('Third'),
                                  content: Container(
                                    width: 500,
                                    child: TextFormField(
                                      maxLength: 50,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[a-zA-Z0-9_ ]')),
                                      ],
                                      decoration: const InputDecoration(
                                        hintText:
                                            'Add a new category (a-z,A-Z,0-9,_, )',
                                      ),
                                      controller: addThirdCate,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        String addNewThirdCategory =
                                            addThirdCate.text;
                                        // Check if the input is not empty and consists only of letters and digits
                                        if (addNewThirdCategory.isNotEmpty) {
                                          // Check if the new name already exists
                                          bool nameExists =
                                              third_category_list.any((item) =>
                                                  item.IDcategory_first ==
                                                      currentOption &&
                                                  item.IDcategory_second ==
                                                      currentOption2 &&
                                                  item.name_third ==
                                                      addNewThirdCategory);
                                          if (nameExists) {
                                            Navigator.pop(context);
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  backgroundColor: Colors
                                                      .white, // Set background color
                                                  title: const Text(
                                                    'ERROR',
                                                    style: TextStyle(
                                                      color: Colors
                                                          .red, // Set title text color
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                  content: const Text(
                                                    'Name already exists!!!',
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0),
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
                                            // Show error message or handle duplicate name
                                            print('Name already exists!');
                                            return; // Stop further execution
                                          }

                                          //  บันทึกข้อมูล category3 อันใหม่ ลงฐานข้อมูล
                                          String apipath =
                                              'https://btmexpertsales.com/filemanagesys/insert_third_category.php?name_third=${addThirdCate.text}&&IDcategory_first=${currentOption}&&IDcategory_second=${currentOption2}';

                                          Dio().get(apipath).then((value) {
                                            print(value);
                                          });
                                          addThirdCate.clear();
                                          Navigator.pop(context);
                                          AlertAddSuccessful(context);

                                          third_category_list.clear();
                                          // รับค่าข้อมูลของcategory3 เพื่ออัพเดทข้อมูล
                                          String apipath2 =
                                              'https://btmexpertsales.com/filemanagesys/get_all_third_category.php';
                                          Dio().get(apipath2).then((value) {
                                            print(value);
                                            for (var data
                                                in jsonDecode(value.data)) {
                                              Third_category thirdCateDetail =
                                                  Third_category.fromMap(data);
                                              setState(() {
                                                third_category_list
                                                    .add(thirdCateDetail);
                                                print('$thirdCateDetail');
                                                currentOption3 = null;
                                              });
                                            }
                                            ;
                                          });
                                        } else {
                                          // กรณีที่ข้อมูลว่างเปล่า
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
                                                  'Please enter a name!!!',
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
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
                                      child: Text('Confirm'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      }
                    },
                    child: const Icon(Icons.add),
                  ),
                ),

                //Delete category 3
                Container(
                  child: IconButton(
                    onPressed: () {
                      if (currentOption3 == null) {
                        // ต้องเลือก category 1 ก่อนถึงจะเพิ่ม category 3 ได้
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('กรุณาเลือก Category 3 ที่จะลบ'),
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Confirm Deletion'),
                              content: Text('Are you sure you want to delete?'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancel')),
                                TextButton(
                                  onPressed: () {
                                    String
                                        apipath = //ลบthird_cateที่เลือกออกจากฐานข้อมูล
                                        'https://btmexpertsales.com/filemanagesys/delete_third_cate.php?Namecategory_first=${currentOption}&&Namecategory_second=${currentOption2}&&Namecategory_third=${currentOption3}';
                                    Dio().get(apipath).then((value) {
                                      print(value);
                                      print('cate1$currentOption');
                                      print('cate2$currentOption2');
                                      print('cate3$currentOption3');
                                    });
                                    third_category_list.clear();
                                    String
                                        apipath2 = //โหลดthird_cat ใหม่ เพื่อให้ข้อมูลอัพเดท
                                        'https://btmexpertsales.com/filemanagesys/get_all_third_category.php';
                                    Dio().get(apipath2).then((value) {
                                      for (var data in jsonDecode(value.data)) {
                                        Third_category thirdCateDetail =
                                            Third_category.fromMap(data);
                                        setState(() {
                                          third_category_list
                                              .add(thirdCateDetail);
                                        });
                                      }
                                    });
                                    file_detail_list.clear();
                                    String
                                        apipath3 = //ดึงข้อมูลไฟล์ใน third_cat ที่ลบไป
                                        'https://btmexpertsales.com/filemanagesys/getfile3rd_change.php?file_first_cate=${currentOption}&file_second_cate=${currentOption2}&file_third_cate=${currentOption3}';

                                    Dio().get(apipath3).then((value) {
                                      print('Response: $value');
                                      for (var data in jsonDecode(value.data)) {
                                        FileModel filedetail =
                                            FileModel.fromMap(data);
                                        setState(() {
                                          file_detail_list.add(filedetail);
                                        });

                                        // Prepare FormData for POST request
                                        FormData formData2 = FormData.fromMap({
                                          'nameFile': filedetail.name_file,
                                          'descriptionFile':
                                              filedetail.description_file,
                                          'datetimeUpload': filedetail
                                              .datetime_upload
                                              .toString(),
                                          'user_upload':
                                              filedetail.user_name ?? '',
                                          'number_cate': filedetail.number_cate,
                                          'path_video':
                                              filedetail.path_video ?? '',
                                          'IDcategory_first':
                                              filedetail.IDcategory_first,
                                          'IDcategory_second':
                                              filedetail.IDcategory_second,
                                          'IDcategory_third':
                                              filedetail.IDcategory_third,
                                          'IDcategory_fourth':
                                              filedetail.IDcategory_fourth,
                                          'type_file': filedetail.type_file,
                                          'datetime_deleted': now.toString(),
                                        });

                                        String
                                            apipath4 = //ย้ายข้อมูลไฟล์ใน third_cat ที่ลบไปบันทึกที่ filemanage_deleted_files
                                            'https://btmexpertsales.com/filemanagesys/insert_filedetail_deleted.php';

                                        // Send POST request
                                        Dio()
                                            .post(apipath4, data: formData2)
                                            .then((response) {
                                          print(
                                              'Uploaded file: ${filedetail.name_file}');
                                          print(
                                              'Uploaded file3: ${currentOption3}');
                                          // Handle response if necessary
                                        }).catchError((error) {
                                          print(
                                              'Error uploading file: ${filedetail.name_file}, Error: $error');
                                          // Handle error if necessary
                                        });
                                      }

                                      String apipath2 =
                                          'https://btmexpertsales.com/filemanagesys/delete_third_detail.php?IDcategory_second=${currentOption2}&IDcategory_first=${currentOption}&IDcategory_third=${currentOption3}';
                                      Dio().get(apipath2).then((value) {
                                        print(value);
                                        print('cate1delete$currentOption');
                                        print('cate1delete$currentOption2');
                                        print('cate1delete$currentOption3');
                                      });
                                      setState(() {
                                        currentOption3 = null;
                                      });
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Delete'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    icon: Icon(Icons.delete),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            //Options4
            alignment: Alignment.center,
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            padding: EdgeInsets.all(2.5),
            width: 700,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: 450,
                    child: DropdownButton<String>(
                        alignment: Alignment.center,
                        style: const TextStyle(
                            fontSize: 20, color: Color.fromARGB(255, 0, 0, 0)),
                        value: currentOption4,
                        onChanged: (String? newValue) {
                          setState(() {
                            currentOption4 = newValue!;

                            nameFileUpload.clear();

                            nameFileUpload.text =
                                '${currentOption}_${currentOption2}_${currentOption3}_${currentOption4}';
                            print(currentOption4);
                            // ดึงข้อมูลไฟล์
                          });
                        },
                        items: fourth_category_list
                            .where((data) =>
                                data.IDcategory_first == currentOption &&
                                data.IDcategory_second == currentOption2 &&
                                data.IDcategory_third ==
                                    currentOption3) // กรองข้อมูลเฉพาะที่มี id_category เท่ากับ currentOption
                            .map((data) {
                          return DropdownMenuItem<String>(
                            value: data.name_fourth,
                            child: Text(data.name_fourth),
                          );
                        }).toList())),
                Container(
                  //EditNameCategory4
                  // width: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      backgroundColor: Color.fromARGB(104, 200, 200, 200),
                    ),
                    onPressed: () {
                      if (currentOption4 == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('กรุณาเลือกหมวดหมู่ที่จะแก้ไข'),
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return AlertDialog(
                                  title: Text('Fourth Third'),
                                  content: Container(
                                    width: 500,
                                    child: TextFormField(
                                      maxLength: 50,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[a-zA-Z0-9_ ]')),
                                      ],
                                      decoration: const InputDecoration(
                                        hintText:
                                            'Edit Name Category (a-z,A-Z,0-9,_,  )',
                                      ),
                                      controller: editnameFourth,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        String newFourthName =
                                            editnameFourth.text;
                                        // Check if the input is not empty and consists only of letters and digits
                                        if (newFourthName.isNotEmpty) {
                                          // Check if the new name already exists
                                          bool nameExists =
                                              fourth_category_list.any((item) =>
                                                  item.IDcategory_first ==
                                                      currentOption &&
                                                  item.IDcategory_second ==
                                                      currentOption2 &&
                                                  item.IDcategory_third ==
                                                      currentOption3 &&
                                                  item.name_fourth ==
                                                      newFourthName);

                                          if (nameExists) {
                                            //ถ้ามีชื่อซ้ำแจ้งเตือน
                                            Navigator.pop(context);
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  backgroundColor: Colors.white,
                                                  title: const Text(
                                                    'ERROR',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                  content: const Text(
                                                    'Name already exists!!!',
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0),
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
                                            return;
                                          }

                                          String apipath = // Edit name cate 4
                                              'https://btmexpertsales.com/filemanagesys/edit_name_4th_cate.php?edit_name_fourth=${editnameFourth.text}&&Namecategory_second=${currentOption2}&&Namecategory_first=${currentOption}&&Namecategory_third=${currentOption3}&&Namecategory_fourth=${currentOption4}';
                                          await Dio()
                                              .get(apipath)
                                              .then((value) {
                                            print(value);
                                          });

                                          String
                                              apipath2 = // Edit name cate 4 in file
                                              'https://btmexpertsales.com/filemanagesys/edit_name_4th_file.php?edit_name_fourth=${editnameFourth.text}&&Namecategory_second=${currentOption2}&&Namecategory_first=${currentOption}&&Namecategory_third=${currentOption3}&&Namecategory_fourth=${currentOption4}';
                                          await Dio()
                                              .get(apipath2)
                                              .then((value) {
                                            print(value);
                                          });

                                          fourth_category_list.clear();
                                          String
                                              apipath3 = //โหลดfourth_cat ใหม่ เพื่อให้ข้อมูลอัพเดท
                                              'https://btmexpertsales.com/filemanagesys/get_all_fourth_category.php';
                                          Dio().get(apipath3).then((value) {
                                            print(value);
                                            print(currentOption);
                                            print(currentOption2);
                                            print(currentOption3);
                                            print(
                                                'sssssssssdqsqd1s$currentOption4');
                                            for (var data
                                                in jsonDecode(value.data)) {
                                              FourthCategory fourthCateDetail =
                                                  FourthCategory.fromMap(data);
                                              setState(() {
                                                fourth_category_list
                                                    .add(fourthCateDetail);
                                                currentOption4 = null;
                                              });
                                            }
                                          });

                                          Navigator.pop(context);
                                          AlertEditSuccessful(context);

// อัพเดท dropdown หลังจากอัพเดทข้อมูลใน fourth_category_list
                                          setState(() {
                                            print(
                                                'XXXXXXXXXXXXXXXXXXXXXXXXXXX');
                                            print(currentOption);
                                            print(currentOption4);
                                            print(currentOption3);
                                            print(currentOption4);
                                          });
                                          // Update UI after editing
                                        } else {
                                          // กรณีที่ข้อมูลว่างเปล่า
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
                                                  'Please enter a name!!!',
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
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
                                      child: Text('Confirm'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      }
                    },
                    child: const Icon(
                      Icons.edit,
                    ),
                  ),
                ),
                Container(
                  //เพิ่ม category 4
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 255, 0, 0),
                      backgroundColor: Color.fromARGB(104, 200, 200, 200),
                      padding: EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      if (currentOption3 == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('กรุณาเลือกหมวดหมู่ที่สาม'),
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return AlertDialog(
                                  title: Text('ADD Fouth'),
                                  content: Container(
                                    width: 500,
                                    child: TextFormField(
                                      maxLength: 50,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[a-zA-Z0-9_ ]')),
                                      ],
                                      decoration: InputDecoration(
                                        hintText:
                                            'Add a new category (a-z,A-Z,0-9,_, )',
                                      ),
                                      controller: addfourthCate,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        String addNewFouthCategory =
                                            addfourthCate.text;
                                        // Check if the input is not empty and consists only of letters and digits
                                        if (addNewFouthCategory.isNotEmpty) {
                                          // Check if the new name already exists
                                          bool nameExists =
                                              fourth_category_list.any((item) =>
                                                  item.IDcategory_first ==
                                                      currentOption &&
                                                  item.IDcategory_second ==
                                                      currentOption2 &&
                                                  item.IDcategory_third ==
                                                      currentOption3 &&
                                                  item.name_fourth ==
                                                      addNewFouthCategory);
                                          if (nameExists) {
                                            Navigator.pop(context);
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  backgroundColor: Colors
                                                      .white, // Set background color
                                                  title: const Text(
                                                    'ERROR',
                                                    style: TextStyle(
                                                      color: Colors
                                                          .red, // Set title text color
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                  content: const Text(
                                                    'Name already exists!!!',
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255,
                                                          0,
                                                          0,
                                                          0), // Set content text color
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
                                                          color: Colors
                                                              .blue, // Set button text color
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                            // Show error message or handle duplicate name
                                            print('Name already exists!');
                                            return; // Stop further execution
                                          }

                                          String apipath =
                                              'https://btmexpertsales.com/filemanagesys/insert_fourth_category.php?name_fourth=${addfourthCate.text}&&IDcategory_first=${currentOption}&&IDcategory_second=${currentOption2}&&IDcategory_third=${currentOption3}';
                                          await Dio()
                                              .get(apipath)
                                              .then((value) {
                                            print(value);
                                          });
                                          addfourthCate.clear();
                                          Navigator.pop(context);
                                          AlertAddSuccessful(context);

                                          fourth_category_list.clear();
                                          String apipath2 =
                                              'https://btmexpertsales.com/filemanagesys/get_all_fourth_category.php';
                                          await Dio()
                                              .get(apipath2)
                                              .then((value) {
                                            print(value);
                                            for (var data
                                                in jsonDecode(value.data)) {
                                              FourthCategory fourthCateDetail =
                                                  FourthCategory.fromMap(data);
                                              setState(() {
                                                fourth_category_list
                                                    .add(fourthCateDetail);
                                                currentOption4 = null;
                                              });
                                            }
                                            ;
                                          });
                                        } else {
                                          // กรณีที่ข้อมูลว่างเปล่า
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
                                                  'Please enter a name!!!',
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
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
                                      child: Text('Confirm'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      }
                    },
                    child: const Icon(Icons.add),
                  ),
                ),

                //Delete category 4
                Container(
                  child: IconButton(
                    onPressed: () {
                      if (currentOption4 == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('กรุณาเลือก Category 4 ที่จะลบ'),
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Confirm Deletion'),
                              content: Text('Are you sure you want to delete?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    String
                                        apipath = //ลบfourth_cateออกจากฐานข้อมูล
                                        'https://btmexpertsales.com/filemanagesys/delete_fourth_cate.php?Namecategory_second=${currentOption2}&&Namecategory_first=${currentOption}&&Namecategory_third=${currentOption3}&&Namecategory_fourth=${currentOption4}';
                                    Dio().get(apipath).then((value) {
                                      print(value);
                                      print(currentOption);
                                      print(currentOption2);
                                      print(currentOption3);
                                      print(currentOption4);
                                    });
                                    fourth_category_list.clear();
                                    String
                                        apipath2 = //โหลดfourth_cat ใหม่ เพื่อให้ข้อมูลอัพเดท
                                        'https://btmexpertsales.com/filemanagesys/get_all_fourth_category.php';
                                    Dio().get(apipath2).then((value) {
                                      print(value);
                                      print(currentOption);
                                      print(currentOption2);
                                      print(currentOption3);
                                      print('sssssssssdqsqd1s$currentOption4');
                                      for (var data in jsonDecode(value.data)) {
                                        FourthCategory fourthCateDetail =
                                            FourthCategory.fromMap(data);
                                        setState(() {
                                          fourth_category_list
                                              .add(fourthCateDetail);
                                          currentOption4 = null;
                                        });
                                      }
                                    });

                                    file_detail_list.clear();
                                    String
                                        apipath3 = //ดึงข้อมูลใน fourth_cat ที่ลบไป
                                        'https://btmexpertsales.com/filemanagesys/getfile4th_change.php?file_first_cate=${currentOption}&file_second_cate=${currentOption2}&file_third_cate=${currentOption3}&file_fourth_cate=${currentOption4}';

                                    Dio().get(apipath3).then((value) {
                                      print('Response: $value');

                                      for (var data in jsonDecode(value.data)) {
                                        FileModel filedetail =
                                            FileModel.fromMap(data);
                                        setState(() {
                                          file_detail_list.add(filedetail);
                                        });

                                        // Prepare FormData for POST request
                                        FormData formData2 = FormData.fromMap({
                                          'nameFile': filedetail.name_file,
                                          'descriptionFile':
                                              filedetail.description_file,
                                          'datetimeUpload': filedetail
                                              .datetime_upload
                                              .toString(),
                                          'user_upload':
                                              filedetail.user_name ?? '',
                                          'number_cate': filedetail.number_cate,
                                          'path_video':
                                              filedetail.path_video ?? '',
                                          'IDcategory_first':
                                              filedetail.IDcategory_first,
                                          'IDcategory_second':
                                              filedetail.IDcategory_second,
                                          'IDcategory_third':
                                              filedetail.IDcategory_third,
                                          'IDcategory_fourth':
                                              filedetail.IDcategory_fourth,
                                          'type_file': filedetail.type_file,
                                          'datetime_deleted': now.toString(),
                                        });

                                        String
                                            apipath4 = //ย้ายข้อมูลในfourth_cat ไปอีกฐานข้อมูล
                                            'https://btmexpertsales.com/filemanagesys/insert_filedetail_deleted.php';

                                        // Send POST request
                                        Dio()
                                            .post(apipath4, data: formData2)
                                            .then((response) {
                                          print(
                                              'Uploaded file: ${filedetail.name_file}');
                                          print(
                                              'Uploaded file3: ${currentOption3}');
                                          // Handle response if necessary
                                        }).catchError((error) {
                                          print(
                                              'Error uploading file: ${filedetail.name_file}, Error: $error');
                                          // Handle error if necessary
                                        });
                                      }

                                      String apipath2 =
                                          'https://btmexpertsales.com/filemanagesys/delete_fourth_detail.php?IDcategory_second=${currentOption2}&IDcategory_first=${currentOption}&IDcategory_third=${currentOption3}&IDcategory_fourth=${currentOption4}';
                                      Dio().get(apipath2).then((value) {
                                        print(value);
                                        print('cate1delete$currentOption');
                                        print('cate1delete$currentOption2');
                                        print('cate1delete$currentOption3');
                                        print('cate1delete$currentOption4');
                                      });
                                      setState(() {});
                                    });

                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Delete'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    icon: Icon(Icons.delete),
                  ),
                ),
              ],
            ),
          ),

// เพิ่มระยะห่างระหว่างปุ่มและ TextFormField
          Container(
              width: 700, // ทำให้ TextFormField มีความกว้างเต็มพื้นที่
              child: Column(
                children: [
                  TextFormField(
                    controller: _tagController,
                    onChanged: (value) {
                      setState(() {
                        _selectedTags.clear();
                        _selectedTags.addAll(tag_list
                            .where((element) => element.name_tag
                                .toUpperCase()
                                .contains(value.toUpperCase()))
                            .map((tag) => tag.name_tag)
                            .toList());
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Search Tags",
                      hintText: "Search tags",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          showDialog(
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
                                      var apipath =
                                          'https://www.btmexpertsales.com/filemanagesys/insert_tag_detail.php?name_tag=${addTag.text}';
                                      Dio().get(apipath).then((response) {
                                        print('Response: $response');

                                        setState(() {
                                          tag_list.clear();
                                          String apipath =
                                              'https://btmexpertsales.com/filemanagesys/get_detail_tag.php';
                                          Dio().get(apipath).then((value) {
                                            for (var data
                                                in jsonDecode(value.data)) {
                                              Tag_Model tagdetail =
                                                  Tag_Model.fromMap(data);
                                              setState(
                                                () {
                                                  tag_list.add(tagdetail);
                                                  tag_list.forEach((tag) {
                                                    if (!_selectedTags.contains(
                                                        tag.name_tag)) {
                                                      _selectedTags
                                                          .add(tag.name_tag);
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
                      visible: _selectedTags.isEmpty,
                      child: Text(
                        "ไม่มี Tag ที่ต้องการ (สามารถเพิ่ม Tag โดยคลิกที่เครื่องหมาย + ที่ช่อง Search Tag)",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      height: 50,
                      width: 700,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _selectedTags.length,
                        physics:
                            AlwaysScrollableScrollPhysics(), // เพิ่ม physics เพื่อให้เลื่อนด้วยคลิกเมาส์
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                print('object');
                                // ทำอะไรสักอย่างเมื่อกด Chip
                              },
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    String chipName =
                                        _selectedTags.elementAt(index);
                                    if (!chipsList.contains(chipName)) {
                                      chipsList.add(
                                          chipName); // เพิ่มชื่อ Chip เข้า List ถ้ายังไม่มีใน List
                                      // ปริ้นข้อมูลใน chipsList หลังจากเพิ่ม Chips เข้าไป
                                    } else {
                                      print(
                                          'Chip $chipName already exists in the list.'); // ปริ้นข้อความแจ้งเตือนถ้าชื่อ Chip มีอยู่แล้วใน List
                                    }
                                  });
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
                                chipsList.removeAt(
                                    index); // ลบ Chip ที่ถูกกดออกจาก List
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
          buttonConfirm(),
        ],
      ),
    );
  }

  Future<dynamic> AlertAddSuccessful(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
            onWillPop: () async =>
                false, // ป้องกันการปิด AlertDialog ด้วยการกด back button บนอุปกรณ์
            child: AlertDialog(
              backgroundColor: Colors.white,
              title: const Text(
                'Successful',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              content: const Text(
                'เพิ่มหมวดหมู่เสร็จสิ้น',
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 16,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) => UploadHome()));
                  },
                  child: const Text(
                    'Confirm',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }

  Future<dynamic> AlertEditSuccessful(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async =>
              false, // ป้องกันการปิด AlertDialog ด้วยการกด back button บนอุปกรณ์
          child: AlertDialog(
            backgroundColor: Colors.white,
            title: const Text(
              'Successful',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            content: const Text(
              'แก้ไขหมวดหมู่เสร็จสิ้น',
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 16,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => UploadHome()));
                },
                child: const Text(
                  'Confirm',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<DropdownMenuItem<String>> getDropdownItems() {
    return mainCategory.map((data) {
      return DropdownMenuItem<String>(
        value: data.id_category,
        child: Text(data.name_first),
      );
    }).toList();
  }

  List<DropdownMenuItem<String>> getDropdownItems2() {
    return second_category_list.map((data) {
      return DropdownMenuItem<String>(
        value: data.number_cate,
        child: Text(data.name_second),
      );
    }).toList();
  }

  List<DropdownMenuItem<String>> getDropdownItems3() {
    return third_category_list.map((data) {
      return DropdownMenuItem<String>(
        value: data.number_cate,
        child: Text(data.name_third),
      );
    }).toList();
  }

  List<DropdownMenuItem<String>> getDropdownItems4() {
    return fourth_category_list.map((data) {
      return DropdownMenuItem<String>(
        value: data.number_cate,
        child: Text(data.name_fourth),
      );
    }).toList();
  }

  ElevatedButton buttonConfirm() {
    return ElevatedButton.icon(
      onPressed: () async {
        if (currentOption == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please select a category'),
            ),
          );
          return; // ออกจากการทำงานของปุ่มหลังจากแสดง SnackBar
        } else if (currentOption !=
                null && //ตรวจสอบว่า ถ้าหมวดหมู่แรกที่เลือกมี หมวดหมู่ย่อยต้องเลือกหมวดหมู่ย่อยก่อน
            second_category_list
                .any((item) => item.id_category == currentOption) &&
            currentOption2 == null) {
          print(second_category_list);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('กรุณาเลือกหมวดหมู่ที่สอง'),
            ),
          );
        } else if (currentOption2 !=
                null && //ตรวจสอบว่า ถ้าหมวดหมู่ที่2ที่เลือกมี หมวดหมู่ย่อยต้องเลือกหมวดหมู่ย่อยก่อน
            third_category_list
                .any((item) => item.IDcategory_second == currentOption2) &&
            currentOption3 == null) {
          print(second_category_list);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('กรุณาเลือกหมวดหมู่ที่สาม'),
            ),
          );
        } else if (currentOption3 !=
                null && //ตรวจสอบว่า ถ้าหมวดหมู่ที่3ที่เลือกมี หมวดหมู่ย่อยต้องเลือกหมวดหมู่ย่อยก่อน
            fourth_category_list
                .any((item) => item.IDcategory_third == currentOption3) &&
            currentOption4 == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('กรุณาเลือกหมวดหมู่ที่สี่'),
            ),
          );
        } else if (img_file != null) {
          print('หลุดการตรวจสอบ');
          String filetype =
              img_file!.path.split('.')[img_file!.path.split('.').length - 1];
          String filenameWithExtension = '${nameFileUpload.text}.$filetype';
          if (filenameWithExtension.isNotEmpty) {
            bool nameExists = file_detail_list.any((item) =>
                item.name_file ==
                filenameWithExtension); // ตรวจสอบว่าชื่อไฟล์ซ้ำหรือไม่

            if (nameExists) {
              // หากชื่อไฟล์ซ้ำ แก้ไขชื่อไฟล์ใหม่

              int count = 1;
              String newFilename = filenameWithExtension;
              while (nameExists) {
                newFilename = '${nameFileUpload.text}($count).$filetype';
                nameExists = file_detail_list
                    .any((item) => item.name_file == newFilename);
                count++;
              }
              filenameWithExtension = newFilename;
            }
          } else {
            // กรณีที่ชื่อไฟล์ว่างเปล่า
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
                    'Please enter a name!!',
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
            return;
          }

          if (nameFileUpload.text.isEmpty) {
            //ถ้าชื่อไฟล์ว่างเปล่า
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
                    'Please enter a name file!!!',
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
            return;
          }

          // อัปโหลดไฟล์ไปยังเซิร์ฟเวอร์

          print('55555555$filenameWithExtension');
          var apipath =
              'https://www.btmexpertsales.com/filemanagesys/upload_file_filemanage.php';

          var request = http.MultipartRequest('POST', Uri.parse(apipath));
          Uint8List data = webImageArr;
          List<int> list = data.cast();

          request.files.add(
            http.MultipartFile.fromBytes('file', list,
                filename: filenameWithExtension),
          );

          var response = await request.send();
          await response.stream.bytesToString().asStream().listen(
            (event) async {
              var parsedJson = json.decode(event);
              print(parsedJson);

              if (currentOption2 == null) {
                currentOption2 = null;
              }

              if (currentOption3 == null) {
                currentOption3 = null;
              }

              if (currentOption4 == null) {
                currentOption4 = null;
              }

              videoId == null;
              //อัพโหลดdetailFile

              if ((currentOption ==
                          'Full Line Catalog' || //ถ้าจะอัพไฟล์ไปที่โฟล์เดอร์ MHE จะบันทึกCurrentOption3 ลงไปในTagด้วย (CurrentOption3 ของMHE คือ Model MHE)
                      currentOption == 'Brochure' ||
                      currentOption == 'Picture AllProduct' ||
                      currentOption == 'Video AllProduct') &&
                  currentOption3 != null) {
                String apipath =
                    'https://btmexpertsales.com/filemanagesys/insert_detail_filemanage.php?'
                    'nameFile=${filenameWithExtension}&'
                    'descriptionFile=${descriptionFileInput.text}&'
                    'datetimeUpload=$now&'
                    'IDcategory_first=$currentOption&'
                    'IDcategory_second=$currentOption2&'
                    'IDcategory_third=$currentOption3&'
                    'IDcategory_fourth=$currentOption4&'
                    'IDpath_youtube=null&'
                    'type_of_file=fileServer_url&'
                    'tag_file=$currentOption3,${chipsList.join(',')}';

                Dio().get(apipath).then((value) {
                  print(value);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Data Uploaded Successfully'),
                  ),
                );
              } else {
                String apipath =
                    'https://btmexpertsales.com/filemanagesys/insert_detail_filemanage.php?'
                    'nameFile=${filenameWithExtension}&'
                    'descriptionFile=${descriptionFileInput.text}&'
                    'datetimeUpload=$now&'
                    'IDcategory_first=$currentOption&'
                    'IDcategory_second=$currentOption2&'
                    'IDcategory_third=$currentOption3&'
                    'IDcategory_fourth=$currentOption4&'
                    'IDpath_youtube=null&'
                    'type_of_file=fileServer_url&'
                    'tag_file=${chipsList.join(',')}'; // รวมรายการชิปด้วยเครื่องหมายจุลภาค

                Dio().get(apipath).then((value) {
                  print(value);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Data Uploaded Successfully'),
                  ),
                );
              }
              print(webImageArr);

              nameFileUpload.clear();
              descriptionFileInput.clear();
              file_detail_list.clear();
              webImageArr.clear();

              print(webImageArr);
              print('dwqdwqdqdq$img_file');
              // setState(() {
              //   img_file = null;
              // });
              String apipath2 =
                  'https://btmexpertsales.com/filemanagesys/get_allfiledetail.php';
              await Dio().get(apipath2).then((value) {
                for (var data in jsonDecode(value.data)) {
                  FileModel filedetail = FileModel.fromMap(data);
                  setState(() {
                    file_detail_list.add(filedetail);
                  });
                }
              });
            },
          );
        } else {
          print('Please select a file');
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
                  'Please select a file!!!',
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
      icon: Icon(Icons.upload),
      label: Text('UPLOAD'),
      style: ElevatedButton.styleFrom(
        // ปรับขนาดของปุ่ม
        minimumSize: Size(150, 50), // กำหนดขนาดขั้นต่ำของปุ่ม
        padding: EdgeInsets.symmetric(
            horizontal: 20, vertical: 10), // กำหนดการเรียงรายละเอียดของปุ่ม
        textStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // กำหนดรูปร่างของปุ่ม
          side: BorderSide.none, // ลบขอบออก
        ), // กำหนดขนาดตัวอักษรของปุ่ม
        backgroundColor: Color.fromARGB(200, 235, 10, 10),
        foregroundColor: Colors.white,
      ),
    );
  }
}
