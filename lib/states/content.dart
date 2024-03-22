import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectsalesmaterial/model/filelist.dart';
import 'package:projectsalesmaterial/model/fourth_category_model.dart';
import 'package:projectsalesmaterial/model/main_category.dart';
import 'package:projectsalesmaterial/model/second_category.dart';
import 'package:projectsalesmaterial/model/third_cate_model.dart';
import 'package:projectsalesmaterial/states/upload_main.dart';
import 'package:projectsalesmaterial/states/video_content.dart';
import 'package:projectsalesmaterial/utility/myconstant.dart';

// import 'dart:html' as html;
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/link.dart';

class myContentArea extends StatefulWidget {
  final String idref;
  const myContentArea({super.key, required this.idref});
  @override
  State<myContentArea> createState() => _myContentAreaState();
}

class _myContentAreaState extends State<myContentArea> {
  List<MainCategoryModel> mainCategory = [];
  List<SecondCategory> second_category_list = [];
  List<Third_category> third_category_list = [];
  List<FileModel> file_detail_list = [];
  List<FourthCategory> fourth_category_list = [];
  TextEditingController descriptionFileEdit = TextEditingController();
  TextEditingController searchdata = TextEditingController();

  // final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  // Future<void>? _launched;
  int countquantity = 0;

  String sent = '';

  @override
  void initState() {
    super.initState();
    sent = widget.idref;
    getmaincategory();
    getfiledetail();
    getseccategory();
    getthirdsubCategory();
    getfourthCategory();
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  Future<Null> getmaincategory() async {
    mainCategory.clear();
    String apipath =
        'https://btmexpertsales.com/filemanagesys/get_main_cate_content.php?Getidcate=$sent';
    await Dio().get(apipath).then((value) {
      print('7890' + '$value');
      for (var data in jsonDecode(value.data)) {
        MainCategoryModel mainCategoryList = MainCategoryModel.fromMap(data);
        setState(() {
          mainCategory.add(mainCategoryList);
        });
      }
    });
  }

  Future<Null> getseccategory() async {
    second_category_list.clear();
    String apipath =
        'https://btmexpertsales.com/filemanagesys/get_sec_cate_content.php?Getidcate=$sent';
    await Dio().get(apipath).then((value) {
      print('secondDropdown' + '$value');
      for (var data in jsonDecode(value.data)) {
        SecondCategory secondCategoryList = SecondCategory.fromMap(data);
        setState(() {
          second_category_list.add(secondCategoryList);
          // print(secondCategoryList);
          print(sent);
        });
      }
    });
  }

  Future<Null> getthirdsubCategory() async {
    third_category_list.clear();
    String apipath =
        'https://btmexpertsales.com/filemanagesys/get_all_third_category.php';
    await Dio().get(apipath).then((value) {
      print(value);
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
    fourth_category_list.clear();
    String apipath =
        'https://btmexpertsales.com/filemanagesys/get_all_fourth_category.php';
    await Dio().get(apipath).then((value) {
      for (var data in jsonDecode(value.data)) {
        FourthCategory fourthCateDetail = FourthCategory.fromMap(data);
        setState(() {
          fourth_category_list.add(fourthCateDetail);
        });
      }
    });
  }

  Future<void> getfiledetail() async {
    String apipath =
        // 'https://btmexpertsales.com/filemanagesys/get_allfiledetail.php';

        'https://btmexpertsales.com/filemanagesys/get_filedetail.php?sent_id_first=$sent';
    Dio().get(apipath).then((value) {
      print('ชื่อ id FIRST$sent');
      print('ไฟล์Home$value');
      for (var data in jsonDecode(value.data)) {
        FileModel filedetail = FileModel.fromMap(data);
        setState(
          () {
            file_detail_list.add(filedetail);
            print('sqqe12' + '$file_detail_list');
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
          backgroundColor: Color.fromARGB(255, 235, 10, 30),
          foregroundColor: Color.fromARGB(255, 255, 255, 255),
          toolbarHeight: 80,
          title: Container(
            child: Row(
              children: [
                Row(
                  children: mainCategory.map((data) {
                    return Text(
                      data.name_first,
                    );
                  }).toList(),
                ),
                // Container(
                //     margin: const EdgeInsets.all(50),
                //     child: TextFormField(
                //       // decoration: InputDecoration(hintText: 'แก้ไขรายละเอียด'),
                //       controller: searchdata,
                //     ))
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ElevatedButton(
                //     onPressed: () {
                //       Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             builder: (context) => PdfScreen(
                //                 pdfUrl:
                //                     'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf'),
                //           ));
                //     },
                //     child: Text('data')),
                Container(
                  //Search
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  constraints: BoxConstraints(maxWidth: 500, maxHeight: 45),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromARGB(255, 255, 255, 255),
                    border: Border.all(
                      color: Colors.black, // สีขอบ
                      width: 2, // ความหนาของขอบ
                    ),
                  ),
                  child: TextField(
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) {
                      print("search");
                      var matchingFiles = file_detail_list.where((file) =>
                          file.name_file.toLowerCase().contains(value
                              .toLowerCase()) || // ตรวจสอบว่าชื่อไฟล์มี value ที่ค้นหาหรือไม่
                          file.Tag.toLowerCase().contains(value
                              .toLowerCase()) || // ตรวจสอบ Tag มี value ที่ค้นหาหรือไม่
                          file.IDcategory_first.toLowerCase().contains(value
                              .toLowerCase()) || // ตรวจสอบ IDcategory_first มี value ที่ค้นหาหรือไม่
                          file.IDcategory_second!
                              .toLowerCase()
                              .contains(value.toLowerCase()) ||
                          file.IDcategory_third!
                              .toLowerCase()
                              .contains(value.toLowerCase()) ||
                          file.IDcategory_fourth!
                              .toLowerCase()
                              .contains(value.toLowerCase()));
                      if (matchingFiles.isNotEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Search Result'),
                              content: SizedBox(
                                width: double.maxFinite,
                                height: 300,
                                child: ListView.builder(
                                  itemCount: matchingFiles.length,
                                  itemBuilder: (context, index) {
                                    var file = matchingFiles.elementAt(index);
                                    return InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Row(
                                              children: [
                                                Text(file.name_file),
                                                Container(
                                                  height: 20,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      String url =
                                                          'https://btmexpertsales.com/filemanagesys/download.php?filename=${file.name_file}';
                                                      launch(url);
                                                    },
                                                    child: const Text(
                                                      'Download',
                                                      style: TextStyle(
                                                          fontSize: 12),
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
                                                      if (file.type_file ==
                                                          'youtube_url') {
                                                        Navigator.push(context,
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
                                                        print(
                                                            '5555555555555 ${file.name_file}');
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
                                                              if (file.name_file
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
                                                                print(
                                                                    'API_path_video_Search');
                                                                return 'https://btmexpertsales.com/filemanagesys/showimages.php?url=https://img.youtube.com/vi/${file.path_video}/maxresdefault.jpg';
                                                              } else {
                                                                print(
                                                                    'data_file_pic_Search');

                                                                return 'https://btmexpertsales.com/filemanagesys/showimages.php?url=file/${file.name_file}';
                                                              }
                                                            })(),
                                                            fit: BoxFit.contain,
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
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
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
                                                                  10, 0, 10, 0),
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
                                                                  10, 0, 10, 0),
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
                                                                  fontSize: 16,
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
                                                                  10, 0, 10, 0),
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
                                                                  10, 0, 10, 0),
                                                          width: 120,
                                                          child: Row(
                                                            children: [
                                                              const Text(
                                                                'File ID : ',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                              Text(
                                                                  "${file.number_cate}"),
                                                            ],
                                                          ),
                                                        ),
                                                        // Container(
                                                        //   margin:
                                                        //       EdgeInsets.fromLTRB(
                                                        //           10, 0, 10, 0),
                                                        //   width: 120,
                                                        //   child: Text(
                                                        //       "${data.category}"),
                                                        // ),
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
                                                  child: Text('Cancel')),
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
                                                                      'https://btmexpertsales.com/filemanagesys/edit_file_detail.php?descriptionFileEdit=${descriptionFileEdit.text}&idFile=${file.number_cate}';

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
                              backgroundColor:
                                  Colors.white, // Set background color
                              title: const Text(
                                'ERROR',
                                style: TextStyle(
                                  color: Colors.red, // Set title text color
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              content: const Text(
                                'No information found !!!',
                                style: TextStyle(
                                  color: Color.fromARGB(
                                      255, 0, 0, 0), // Set content text color
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
                                      color:
                                          Colors.blue, // Set button text color
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
                  margin: EdgeInsets.all(20),
                  alignment: Alignment.topCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        // category2 option

                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        padding: EdgeInsets.all(2.5),
                        width: 400,
                        height: 30,
                        child: Container(
                          width: 400,
                          child: DropdownButton<String>(
                              style: TextStyle(fontSize: 15),
                              value: currentOption2,
                              onChanged: (String? newValue) {
                                currentOption3 = null;
                                currentOption4 = null;

                                setState(() {
                                  currentOption2 = newValue!;
                                  print('$currentOption2');
                                  currentOption4 = null;
                                  file_detail_list.clear();
                                  String apipath =
                                      'https://btmexpertsales.com/filemanagesys/getfilesec_change.php?file_first_cate=$sent&&file_second_cate=$currentOption2';
                                  Dio().get(apipath).then((value) {
                                    print('XAXAXA' '$value');
                                    print(sent);
                                    List<dynamic> dataList =
                                        jsonDecode(value.data);
                                    for (var data in dataList) {
                                      FileModel filedetail =
                                          FileModel.fromMap(data);
                                      setState(() {
                                        file_detail_list.add(filedetail);
                                      });
                                    }
                                  });

                                  // String apipath =
                                  //     'https://btmexpertsales.com/filemanagesys/get_third_cate_content.php?Getidcate=$sent&&Getidsec=$currentOption2';
                                  // Dio().get(apipath).then((value) {
                                  //   print('thirdDropdown' + '$value');
                                  //   for (var data in jsonDecode(value.data)) {
                                  //     Third_category third_category =
                                  //         Third_category.fromMap(data);
                                  //     setState(() {
                                  //       third_category_list
                                  //           .add(third_category);
                                  //       print(third_category);
                                  //       print('category33'
                                  //           '$third_category_list');
                                  //     });
                                  //   }
                                  // });
                                });
                              },
                              items: second_category_list.map((data) {
                                return DropdownMenuItem<String>(
                                  value: data.name_second,
                                  child: Text(data.name_second),
                                );
                              }).toList()),
                        ),
                      ),
                      Container(
                        // category3 option
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        padding: EdgeInsets.all(2.5),
                        width: 400,
                        height: 30,
                        child: Container(
                            width: 400,
                            child: DropdownButton<String>(
                                value: currentOption3,
                                onChanged: (String? newValue) {
                                  currentOption4 = null;
                                  setState(() {
                                    currentOption3 = newValue!;
                                    file_detail_list.clear();
                                    String apipath =
                                        'https://btmexpertsales.com/filemanagesys/getfile3rd_change.php?file_first_cate=$sent&&file_second_cate=$currentOption2&&file_third_cate=$currentOption3';
                                    Dio().get(apipath).then((value) {
                                      print('AAAA' '$value');
                                      print(sent);

                                      jsonDecode(value.data).forEach((data) {
                                        FileModel filedetail =
                                            FileModel.fromMap(data);
                                        setState(() {
                                          file_detail_list.add(filedetail);
                                        });
                                      });
                                    });
                                  });
                                },
                                items: third_category_list
                                    .where((data) =>
                                        data.IDcategory_first == sent &&
                                        data.IDcategory_second ==
                                            currentOption2) // กรองข้อมูลเฉพาะที่มี id_category เท่ากับ currentOption
                                    .map((data) {
                                  return DropdownMenuItem<String>(
                                    value: data.name_third,
                                    child: Text(data.name_third),
                                  );
                                }).toList())),
                      ),
                      Container(
                        // category4 option
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        padding: EdgeInsets.all(2.5),
                        width: 400,
                        height: 30,
                        child: Container(
                          width: 400,
                          child: DropdownButton<String>(
                              style: TextStyle(fontSize: 20),
                              value: currentOption4,
                              onChanged: (String? newValue) {
                                setState(() {
                                  currentOption4 = newValue!;
                                  print("OP4" + '$currentOption4');
                                  file_detail_list.clear();
                                  String apipath =
                                      'https://btmexpertsales.com/filemanagesys/getfile4th_change.php?file_first_cate=$sent&&file_second_cate=$currentOption2&&file_third_cate=$currentOption3&&file_fourth_cate=$currentOption4';
                                  Dio().get(apipath).then((value) {
                                    print('AAAA' '$value');
                                    print(sent);

                                    jsonDecode(value.data).forEach((data) {
                                      FileModel filedetail =
                                          FileModel.fromMap(data);
                                      setState(() {
                                        file_detail_list.add(filedetail);
                                      });
                                    });
                                  });
                                });
                              },
                              items: fourth_category_list
                                  .where((data) =>
                                      data.IDcategory_first == sent &&
                                      data.IDcategory_second ==
                                          currentOption2 &&
                                      data.IDcategory_third ==
                                          currentOption3) // กรองข้อมูลเฉพาะที่มี id_category เท่ากับ currentOption
                                  .map((data) {
                                return DropdownMenuItem<String>(
                                  value: data.name_fourth,
                                  child: Text(data.name_fourth),
                                );
                              }).toList()),
                        ),
                      ),
                    ],
                  ),
                ),

                SingleChildScrollView(
                    child: Container(
                        //content
                        child: Column(children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(80, 20, 80, 20),
                    margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    width: screensize,
                    height: screensizeHeight,
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
                                    foregroundColor:
                                        Color.fromARGB(255, 0, 0, 0),
                                    backgroundColor:
                                        Color.fromARGB(255, 255, 255, 255),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Container(
                                          width: screensize,
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Container(
                                                  child: const Text(
                                                    'ชื่อไฟล์        : ',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                                Tooltip(
                                                  message: "${data.name_file}",
                                                  child: ConstrainedBox(
                                                    constraints:
                                                        const BoxConstraints(
                                                            maxWidth:
                                                                250 // หรือค่าที่คุณต้องการ
                                                            ),
                                                    child: Flexible(
                                                      child: Text(
                                                        "${data.name_file}",
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 20,
                                                  constraints: BoxConstraints(
                                                      maxWidth: 200),
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      String url =
                                                          'https://btmexpertsales.com/filemanagesys/download.php?filename=${data.name_file}';
                                                      launch(url);
                                                    },
                                                    child: const Text(
                                                      'Download',
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        content: Container(
                                          width: screensize * 0.5,
                                          child: SingleChildScrollView(
                                            //POPUP เปิดไฟล์
                                            child: Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    if (data.type_file ==
                                                        'youtube_url') {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                        builder: (context) {
                                                          return VideoContent(
                                                            idref:
                                                                '${data.path_video}',
                                                            title: '',
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
                                                        padding:
                                                            EdgeInsets.all(20),
                                                        child: FadeInImage
                                                            .assetNetwork(
                                                          placeholder:
                                                              myconstant
                                                                  .loadinggif,
                                                          image: (() {
                                                            if (data.name_file
                                                                .toLowerCase()
                                                                .endsWith(
                                                                    '.pdf')) {
                                                              return myconstant
                                                                  .pdficon;
                                                            } else if (data
                                                                .name_file
                                                                .toLowerCase()
                                                                .endsWith(
                                                                    '.docx')) {
                                                              return myconstant
                                                                  .docicon;
                                                            } else if (data
                                                                .name_file
                                                                .toLowerCase()
                                                                .endsWith(
                                                                    '.xlsx')) {
                                                              return myconstant
                                                                  .xlsxicon;
                                                            } else if (data
                                                                .name_file
                                                                .toLowerCase()
                                                                .endsWith(
                                                                    '.zip')) {
                                                              return myconstant
                                                                  .zipicon;
                                                            } else if (data
                                                                    .type_file ==
                                                                'youtube_url') {
                                                              print(
                                                                  'API2_path_video');
                                                              return 'https://btmexpertsales.com/filemanagesys/showimages.php?url=https://img.youtube.com/vi/${data.path_video}/maxresdefault.jpg';
                                                            } else {
                                                              print(
                                                                  'data2_path_video');
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
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(Radius
                                                                          .circular(
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
                                                        margin: const EdgeInsets
                                                            .fromLTRB(
                                                            10, 0, 10, 0),
                                                        width: screensize,
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Text(
                                                              'ชื่อไฟล์        : ',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                            ),
                                                            Flexible(
                                                              child: Text(
                                                                  "${data.name_file}",
                                                                  overflow:
                                                                      TextOverflow
                                                                          .visible),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .fromLTRB(
                                                            10, 0, 10, 0),
                                                        width: screensize,
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Text(
                                                              'รายละเอียด : ',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
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
                                                        margin: const EdgeInsets
                                                            .fromLTRB(
                                                            10, 0, 10, 0),
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
                                                                "${data.user_name}"),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .fromLTRB(
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
                                                                    fontSize:
                                                                        16)),
                                                            Text(data
                                                                .datetime_upload),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .fromLTRB(
                                                            10, 0, 10, 0),
                                                        width: 120,
                                                        child: Row(
                                                          children: [
                                                            const Text(
                                                              'File ID : ',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 16),
                                                            ),
                                                            Text(
                                                                "${data.number_cate}"),
                                                          ],
                                                        ),
                                                      ),
                                                      // Container(
                                                      //   margin:
                                                      //       EdgeInsets.fromLTRB(
                                                      //           10, 0, 10, 0),
                                                      //   width: 120,
                                                      //   child: Text(
                                                      //       "${data.category}"),
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text('Cancel')),
                                          TextButton(
                                            onPressed: () async {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return StatefulBuilder(
                                                    builder:
                                                        (context, setState) {
                                                      return AlertDialog(
                                                        title:
                                                            Text('Edit File'),
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
                                                            child:
                                                                Text('Cancel'),
                                                          ),
                                                          TextButton(
                                                            onPressed:
                                                                () async {
                                                              print(
                                                                  '${descriptionFileEdit.text}');
                                                              String apipath =
                                                                  'https://btmexpertsales.com/filemanagesys/edit_file_detail.php?descriptionFileEdit=${descriptionFileEdit.text}&idFile=${data.number_cate}';

                                                              await Dio()
                                                                  .get(apipath)
                                                                  .then(
                                                                      (value) {
                                                                print(value);
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                              Navigator.pushReplacement(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (BuildContext
                                                                              context) =>
                                                                          super
                                                                              .widget));
                                                            },
                                                            child:
                                                                Text('Confirm'),
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
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 270,
                                        height: 120,
                                        child: Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 5, 0, 10),
                                            child: FadeInImage.assetNetwork(
                                                placeholder:
                                                    myconstant.loadinggif,
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
                                        padding:
                                            EdgeInsets.fromLTRB(0, 10, 0, 0),
                                        width: 300,
                                        height: 108,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data.name_file,
                                              style:
                                                  const TextStyle(fontSize: 12),
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
                ]))),
              ],
            ),
          ),
        ));
  }
}