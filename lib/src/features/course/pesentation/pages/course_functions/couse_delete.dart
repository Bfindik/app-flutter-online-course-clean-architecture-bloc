import 'package:flutter/material.dart';
import 'package:online_course/core/services/database_helper.dart';
import 'package:online_course/src/theme/app_color.dart';

class DeleteCoursePage extends StatefulWidget {
  @override
  _DeleteCoursePageState createState() => _DeleteCoursePageState();
}

class _DeleteCoursePageState extends State<DeleteCoursePage> {
  int? selectedCourseId;
  List<Map<String, dynamic>> courses = [];

  @override
  void initState() {
    super.initState();
    loadCourses();
  }

  Future<void> loadCourses() async {
    courses = await DatabaseHelper.instance.getCourses();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      appBar: AppBar(
        title: Text('Kurs Sil'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Silinecek Kurs:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 50),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: Colors.grey), // Border rengi gri olarak ayarlandı
                  borderRadius:
                      BorderRadius.circular(8.0), // Border yuvarlaklığı
                ),
                child: DropdownButton<int>(
                  hint: Text(
                    'Silinecek kursu seçin',
                    style: TextStyle(fontSize: 20),
                  ),
                  value: selectedCourseId,
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedCourseId = newValue;
                    });
                  },
                  items: courses.map<DropdownMenuItem<int>>(
                      (Map<String, dynamic> instructor) {
                    return DropdownMenuItem<int>(
                      value: instructor['id'],
                      child: Text(
                        instructor['name'],
                        style: TextStyle(fontSize: 20), // Metin boyutunu büyüt
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () async {
                if (selectedCourseId != null) {
                  await DatabaseHelper.instance.deleteCourse(selectedCourseId!);
                  // İşlem tamamlandıktan sonra kullanıcıya bir mesaj göstermek için bir SnackBar göster
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Öğretmen başarıyla silindi!')),
                  );
                  // İşlem tamamlandıktan sonra ana sayfaya geri dön
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
              ),
              child: Text(
                'Kursu Sil',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
