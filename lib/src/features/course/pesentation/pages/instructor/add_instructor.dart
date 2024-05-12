import 'package:flutter/material.dart';
import 'package:online_course/core/services/database_helper.dart';
import 'package:online_course/src/theme/app_color.dart';

class AddInstructorPage extends StatefulWidget {
  @override
  _AddInstructorPageState createState() => _AddInstructorPageState();
}

class _AddInstructorPageState extends State<AddInstructorPage> {
  List<int> selectedHours = [];
  List<String> selectedLessons = [];
  Map<String, double> lessonPrices = {};

  TextEditingController lessonController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController homePhoneController = TextEditingController();
  TextEditingController cellPhoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      appBar: AppBar(
        title: Text('Öğretmen Ekle'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Öğretmen:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                _buildInfoField(
                    controller: nameController, label: 'Adı Soyadı'),
                _buildInfoField(
                    controller: homePhoneController, label: 'Ev Telefonu'),
                _buildInfoField(
                    controller: cellPhoneController, label: 'Cep Telefonu'),
                _buildInfoField(controller: addressController, label: 'Adres'),
                _buildInfoField(
                    controller: emailController, label: 'E-posta Adresi'),
                SizedBox(height: 20),
                Text(
                  'Çalışabildiği Saatler:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: [
                    buildHourButton(9),
                    buildHourButton(10),
                    buildHourButton(11),
                    buildHourButton(13),
                    buildHourButton(14),
                    buildHourButton(15),
                    // İstediğiniz saat aralıklarını buraya ekleyin
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Verebildiği Dersler ve Ücretleri:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                _buildLessons(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    onSaveButtonPressed();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                  ),
                  child: Text(
                    'Kaydet',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoField(
      {required TextEditingController controller, required String label}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
      ),
      maxLines: null,
    );
  }

  Widget buildHourButton(int hour) {
    bool isSelected = selectedHours.contains(hour);
    return ElevatedButton(
      onPressed: () {
        setState(() {
          if (isSelected) {
            selectedHours.remove(hour);
          } else {
            selectedHours.add(hour);
          }
        });
      },
      style: ElevatedButton.styleFrom(
        side: BorderSide(
          color: isSelected ? Colors.black : Colors.transparent,
          width: 2.0,
        ),
        backgroundColor: AppColor.primary,
      ),
      child: Text(
        '$hour:00',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildLessons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: lessonController,
                decoration: InputDecoration(
                  labelText: 'Ders Adı',
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: priceController,
                decoration: InputDecoration(
                  labelText: 'Ücret',
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                if (lessonController.text.isNotEmpty &&
                    priceController.text.isNotEmpty) {
                  setState(() {
                    selectedLessons.add(lessonController.text);
                    lessonPrices[lessonController.text] =
                        double.parse(priceController.text);
                    lessonController.clear();
                    priceController.clear();
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
              ),
              child: Text(
                'Ekle',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          itemCount: selectedLessons.length,
          itemBuilder: (context, index) {
            final lesson = selectedLessons[index];
            final price = lessonPrices[lesson]!;
            return ListTile(
              title: Text(lesson),
              subtitle: Text('Ücret: $price'),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    selectedLessons.removeAt(index);
                    lessonPrices.remove(lesson);
                  });
                },
              ),
            );
          },
        ),
      ],
    );
  }

  void onSaveButtonPressed() async {
    Map<String, dynamic> instructorRow = {
      'name': nameController.text,
      'homePhone': homePhoneController.text,
      'cellPhone': cellPhoneController.text,
      'address': addressController.text,
      'email': emailController.text,
    };
    print(instructorRow);

    int instructorId =
        await DatabaseHelper.instance.insertInstructor(instructorRow);

    for (String lessonName in selectedLessons) {
      double price = lessonPrices[lessonName]!;
      Map<String, dynamic> lessonRow = {
        'instructorId': instructorId,
        'name': lessonName,
        'price': price,
      };
      await DatabaseHelper.instance.insertLesson(lessonRow);
    }
    // Öğretmen saatlerini ekleyelim
    await DatabaseHelper.instance.insertHours(instructorId, selectedHours);

    // İşlem tamamlandıktan sonra kullanıcıya bir mesaj göstermek için bir SnackBar gösterelim
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Öğretmen ve dersler başarıyla kaydedildi!')),
    );
    Navigator.pop(context);
  }
}
