import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyApp> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagController = TextEditingController();
  final _tags = <String>[
    'YOU CAN',
    'ชื่อ',
    'ใส่ชื่อ',
    'คําอธิบาย',
    'เพิ่มค่าอธิบายโดยละเอียด',
    'ลิงก์',
    'เพิ่มลิงก์',
    'บอร์ด',
    'เลือกบอร์ด',
    'หัวข้อที่ติดแท็ก',
    'ไม่ต้องกังวล',
    'คนอื่นจะไม่เห็นแท็กของคุณ',
    'ตัวเลือกเพิ่',
    'แท็กที่ตรงกัน',
    'ภาพพื้นหลัง iphone',
    'เคส iphone',
    'ไอคอน ios',
    'เคส iphone 6'
  ];
  final _selectedTags = <String>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter File Upload"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Name",
                hintText: "Enter file name",
              ),
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: "Description",
                hintText: "Enter file description",
              ),
            ),
            TextFormField(
              controller: _tagController,
              decoration: InputDecoration(
                labelText: "Tags",
                hintText: "Enter tags",
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _tagController.clear();
                    _selectedTags.clear();
                  },
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _selectedTags.clear();
                  _selectedTags.addAll(_tags
                      .where((tag) =>
                          tag.toLowerCase().contains(value.toLowerCase()))
                      .toList());
                });
              },
            ),
            Container(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _selectedTags.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Chip(
                      label: Text(_selectedTags.elementAt(index)),
                      deleteIcon: Icon(Icons.close),
                      onDeleted: () {
                        setState(() {
                          _selectedTags.remove(_selectedTags.elementAt(index));
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text;
                final description = _descriptionController.text;
                final tags = _selectedTags.join(', ');
                final file = '';
                if (name.isNotEmpty && description.isNotEmpty && _selectedTags.isNotEmpty) {
                  // Perform file upload here
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please fill in all fields'),
                    ),
                  );
                }
              },
              child: Text("Upload File"),
            ),
          ],
        ),
      ),
    );
  }
}
