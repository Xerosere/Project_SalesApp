import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectsalesmaterial/model/filelist.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:projectsalesmaterial/utility/myconstant.dart';

class VideoContent extends StatefulWidget {
  final String idref;
  final String title;

  const VideoContent({Key? key, required this.idref, required this.title})
      : super(key: key);

  @override
  State<VideoContent> createState() => _VideoContentState();
}

class _VideoContentState extends State<VideoContent> {
  late YoutubePlayerController _controller;
  List<FileModel> file_detail_list = [];
  List<FileModel> video_detail_list = [];
  String id_video = '';
  String name_file = '';
  List<FileModel> filteredFiles = [];

  TextEditingController descriptionFileEdit = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.idref,
    );
    id_video = widget.idref;
    getfiledetail();
    getvideodetail();
    print('XAZ  ${id_video}');
    print('XAZ${widget.title}');
    // Set filteredFiles to file_detail_list initially
    filteredFiles = file_detail_list;
  }

  Future<void> getfiledetail() async {
    file_detail_list.clear();
    String apipath =
        'https://btmexpertsales.com/filemanagesys/get_allfiledetail.php';
    await Dio().get(apipath).then((value) {
      for (var data in jsonDecode(value.data)) {
        FileModel filedetail = FileModel.fromMap(data);
        setState(() {
          file_detail_list.add(filedetail);
          print('56789$filedetail');
        });
      }
    });
  }

  Future<void> getvideodetail() async {
    video_detail_list.clear();
    String apipath =
        'https://btmexpertsales.com/filemanagesys/get_detail_video.php?pathvideo=$id_video';
    await Dio().get(apipath).then((value) {
      if (value.data != null) {
        for (var data in jsonDecode(value.data)) {
          FileModel videodetail = FileModel.fromMap(data);
          setState(() {
            video_detail_list.add(videodetail);
            print('กกก$video_detail_list');
            print('กกกXX)$videodetail');
          });
        }
      } else {
        print('การตอบกลับ API เป็น null หรือว่างเปล่า');
      }
    }).catchError((error) {
      print('เกิดข้อผิดพลาดในการเรียกข้อมูล: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    double screensize = MediaQuery.of(context).size.width;
    double screensizeHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          title: Text(id_video),
        ),
        body: SingleChildScrollView(
          child: Row(
            children: [
              Container(
                height: screensizeHeight * 0.85,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 800,
                        height: 400,
                        // แสดงวิดีโอ
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: YoutubePlayerIFrame(
                          controller: _controller,
                          aspectRatio: 16 / 9,
                        ),
                      ),
                      SizedBox(height: 20),
                      for (var data in video_detail_list)
                        // แสดงรายละเอียดวิดีโอ
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              //ชื่อ
                              margin: EdgeInsets.fromLTRB(20, 10, 10, 10),
                              child: Text(
                                '${data.name_file}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              // รายละเอียด
                              margin: EdgeInsets.fromLTRB(20, 10, 10, 10),
                              width: 800,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'รายละเอียด :',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Text(
                                    '${data.description_file}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              // ผู้อัพโหลด
                              margin: EdgeInsets.fromLTRB(20, 10, 10, 10),
                              child: Row(
                                children: [
                                  const Text(
                                    'ผู้อัพโหลด : ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  Text(
                                    '${data.user_name}',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              // tag
                              margin: EdgeInsets.fromLTRB(20, 10, 10, 10),
                              child: Row(
                                children: [
                                  const Text(
                                    'Tags : ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  Text(
                                    '${data.Tag}',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              Container(
                  // ไฟล์ที่เกี่ยวข้อง
                  height: screensizeHeight * 0.9,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SingleChildScrollView(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: const EdgeInsets.fromLTRB(30, 10, 10, 10),
                          child: const Text(
                            'ไฟล์ที่เกี่ยวข้อง :',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                      Container(
                        width: screensize * 0.45,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                // ปุ่มfilter file ถ้ากดBrochure จะแสดงเฉพาะไฟล์ที่ IDcategory_first(category1) == Brochure
                                margin: EdgeInsets.fromLTRB(30, 5, 5, 5),
                                width: 130,
                                height: 40,
                                child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        filteredFiles = file_detail_list
                                            .where((file) =>
                                                file.IDcategory_first ==
                                                'Brochure')
                                            .toList();
                                      });
                                    },
                                    child: Text('Brochure'),
                                    style: ElevatedButton.styleFrom(
                                      textStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: BorderSide.none,
                                      ),
                                      backgroundColor:
                                          Color.fromARGB(200, 235, 10, 10),
                                      foregroundColor: Colors.white,
                                    ))),
                            Container(
                              margin: EdgeInsets.all(5),
                              width: 130,
                              height: 40,
                              child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      filteredFiles = file_detail_list
                                          .where((file) =>
                                              file.IDcategory_first ==
                                              'Full Line Catalog')
                                          .toList();
                                    });
                                  },
                                  child: Text('Full Line'),
                                  style: ElevatedButton.styleFrom(
                                    textStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide.none,
                                    ),
                                    backgroundColor:
                                        Color.fromARGB(200, 235, 10, 10),
                                    foregroundColor: Colors.white,
                                  )),
                            ),
                            Container(
                              width: 130,
                              height: 40,
                              child: ElevatedButton(
                                  onPressed: () {
                                    // Add your filter functionality here
                                    setState(() {
                                      filteredFiles = file_detail_list
                                          .where((file) =>
                                              file.IDcategory_first ==
                                              'Picture AllProduct')
                                          .toList();
                                    });
                                  },
                                  child: Text('Picture'),
                                  style: ElevatedButton.styleFrom(
                                    textStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide.none,
                                    ),
                                    backgroundColor:
                                        Color.fromARGB(200, 235, 10, 10),
                                    foregroundColor: Colors.white,
                                  )),
                            ),
                            Container(
                              margin: EdgeInsets.all(5),
                              width: 130,
                              height: 40,
                              child: ElevatedButton(
                                  onPressed: () {
                                    // Add your filter functionality here
                                    setState(() {
                                      filteredFiles = file_detail_list
                                          .where((file) =>
                                              file.IDcategory_first ==
                                              'Video AllProduct')
                                          .toList();
                                    });
                                  },
                                  child: Text('Video'),
                                  style: ElevatedButton.styleFrom(
                                    textStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide.none,
                                    ),
                                    backgroundColor:
                                        Color.fromARGB(200, 235, 10, 10),
                                    foregroundColor: Colors.white,
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        // แสดงไฟล์ที่เกี่ยวข้อง
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var data
                              in filteredFiles) //แสดงไฟล์ทั้งหมดที่อยู่ใน filteredFiles
                            if (data.Tag != '' &&
                                data.Tag != null &&
                                video_detail_list.any(
                                    (video) => video.Tag.contains(data.Tag)) &&
                                id_video != data.path_video)
                              Padding(
                                padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                                child: Container(
                                  color: Color.fromARGB(0, 230, 84, 84),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      foregroundColor:
                                          Color.fromARGB(255, 0, 0, 0),
                                      backgroundColor:
                                          Color.fromARGB(255, 255, 255, 255),
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        //POPUPแสดงรายละเอียดไฟล์ที่คลิก

                                        useSafeArea: true,
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Container(
                                            width: screensize * 0.5,
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
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  ),
                                                  Tooltip(
                                                    message:
                                                        "${data.name_file}",
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
                                                    //ปุ่มดาวน์โหลด คลิกเพื่อดาวน์โหลดไฟล์ที่อยู่ในServer ถ้าคลิกที่เป็นVideo youtube จะแสดง
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
                                                // มีปัญหาตรงที่ถ้าคลิกDialogที่ซ้อนอยู่ด้านบน YoutubePlayerIFrame แล้วตรงที่คลิกอยู่ในกรอบของ YoutubePlayerIFrame มันจะไปคลิกที่ YoutubePlayerIFrame ไม่ไดคลิก Dialog
                                                //่เป็นทุกอันใน Column นี้
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      if (data.type_file ==
                                                          'youtube_url') {
                                                        print(
                                                            '888888 ${data.name_file}');
                                                        Navigator
                                                            .pushReplacement(
                                                                //เปิดหน้าแสดงVideo ที่จะแสดงข้อมูลวิดีโอที่เปิดอยู่ใน POPUP
                                                                context,
                                                                MaterialPageRoute(
                                                          builder: (context) {
                                                            return VideoContent(
                                                              idref:
                                                                  '${data.path_video}',
                                                              title: '',
                                                            );
                                                          },
                                                        ));
                                                        print(
                                                            '666666666 ${data.name_file}');

                                                        print(
                                                            '666666666 ${data.path_video}');
                                                      } else if (data
                                                              .type_file ==
                                                          'fileServer_url') {
                                                        //เปิดไฟล์ ที่เลือกในเว็ป เบราว์เซอร์ ถ้าเป็นไฟล์อื่นๆบอกจาก รูปภาพและPDF จะเป็นการดาวน์โหลด
                                                        String fileUrl =
                                                            'https://btmexpertsales.com/filemanagesys/file/${data.name_file}';
                                                        launch(fileUrl);
                                                      }
                                                    },
                                                    child: Stack(
                                                      children: [
                                                        // Container ที่บรรจุรูปภาพ รูปภาพที่แสดงจะเปลี่ยนไปตามนามสกุลไฟล์
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
                                                                return 'https://btmexpertsales.com/filemanagesys/showimages.php?url=https://img.youtube.com/vi/${data.path_video}/maxresdefault.jpg';
                                                              } else {
                                                                return 'https://btmexpertsales.com/filemanagesys/showimages.php?url=file/${data.name_file}';
                                                              }
                                                            })(),
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
                                                        if (data.type_file ==
                                                            'youtube_url') //ถ้าเป็นไฟล์วิดีโอตรงแสดงรุปภาพจะมี icon play อยู่ด้วย
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
                                                                      .scaleDown,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets
                                                        .fromLTRB(20, 5, 10, 5),
                                                    //รายละเอียดTextต่างๆของไฟล์ที่อยู่ใน POPUP
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
                                                          width: screensize,
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const Text(
                                                                'ชื่อไฟล์        : ',
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
                                                                    "${data.name_file}",
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
                                                          width: screensize,
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
                                                                  "${data.user_name}"),
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
                                                              Text(data
                                                                  .datetime_upload),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  10, 0, 10, 0),
                                                          child: Row(
                                                            children: [
                                                              const Text(
                                                                'Tags : ',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                              Text(
                                                                  "${data.Tag}"),
                                                            ],
                                                          ),
                                                        ),
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
                                                child: Text('Back')),
                                            TextButton(
                                              //ปุ่ม Edit ข้อมูลไฟล์ สามารถแก้ไขได้แค่Description file
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
                                                              child: Text(
                                                                  'Cancel'),
                                                            ),
                                                            TextButton(
                                                              onPressed:
                                                                  () async {
                                                                print(
                                                                    '${descriptionFileEdit.text}');
                                                                String
                                                                    apipath = //อัพเดทdescription_file ใน table filemanage_filedetail ตาม descriptionFileEdit
                                                                    'https://btmexpertsales.com/filemanagesys/edit_file_detail.php?descriptionFileEdit=${descriptionFileEdit.text}&idFile=${data.number_cate}';

                                                                await Dio()
                                                                    .get(
                                                                        apipath)
                                                                    .then(
                                                                        (value) {
                                                                  print(value);
                                                                });
                                                                Navigator.pop(
                                                                    context);
                                                                Navigator.pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (BuildContext context) =>
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
                                    child: Row(
                                      //รูปภาพและรายละเอียดของ ไฟล์ที่เกี่ยวข้อง
                                      children: [
                                        Container(
                                          margin: EdgeInsets.all(5),
                                          width: 270,
                                          height: 150,
                                          child: Container(
                                              height: 150,
                                              padding:
                                                  const EdgeInsets.fromLTRB(
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
                                                      return myconstant
                                                          .xlsxicon;
                                                    } else if (data.name_file
                                                        .toLowerCase()
                                                        .endsWith('.zip')) {
                                                      return myconstant.zipicon;
                                                    } else if (data.type_file ==
                                                        'youtube_url') {
                                                      return 'https://btmexpertsales.com/filemanagesys/showimages.php?url=https://img.youtube.com/vi/${data.path_video}/maxresdefault.jpg';
                                                    } else {
                                                      return 'https://btmexpertsales.com/filemanagesys/showimages.php?url=file/${data.name_file}';
                                                    }
                                                  })(),
                                                  fit: BoxFit.contain)),
                                        ),
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          width: 300,
                                          height: 150,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                data.name_file,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                              Text(
                                                'รายละเอียด : ${data.description_file}',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                              Text(
                                                'เวลาอัพโหลด : ${data.datetime_upload}',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                              Text(
                                                'Tags : ${data.Tag}',
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
                    ],
                  ))),
            ],
          ),
        ));
  }
}
