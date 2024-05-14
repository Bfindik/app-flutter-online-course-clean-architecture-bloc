import 'package:flutter/material.dart';
import 'package:online_course/core/services/database_helper.dart';
import 'package:online_course/src/theme/app_color.dart';

class DeleteInstructorPage extends StatefulWidget {
  @override
  _DeleteInstructorPageState createState() => _DeleteInstructorPageState();
}

class _DeleteInstructorPageState extends State<DeleteInstructorPage> {
  List<Map<String, dynamic>> instructors = [];
  int? selectedInstructorId;

  @override
  void initState() {
    super.initState();
    loadInstructors();
  }

  Future<void> loadInstructors() async {
    instructors = await DatabaseHelper.instance.getInstructors();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      appBar: AppBar(
        title: Text('Öğretmen Sil'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Silinecek Öğretmen:',
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
                    'Silinecek öğretmeni seçin',
                    style: TextStyle(fontSize: 20),
                  ),
                  value: selectedInstructorId,
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedInstructorId = newValue;
                    });
                  },
                  items: instructors.map<DropdownMenuItem<int>>(
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
                if (selectedInstructorId != null) {
                  await DatabaseHelper.instance
                      .deleteInstructor(selectedInstructorId!);
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
                'Öğretmeni Sil',
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
