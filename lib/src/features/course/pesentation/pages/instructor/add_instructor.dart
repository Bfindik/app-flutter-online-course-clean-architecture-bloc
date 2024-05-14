import 'package:flutter/material.dart';
import 'package:online_course/core/services/database_helper.dart';
import 'package:online_course/src/theme/app_color.dart';

class AddInstructorPage extends StatefulWidget {
  @override
  _AddInstructorPageState createState() => _AddInstructorPageState();
}

class _AddInstructorPageState extends State<AddInstructorPage> {
  List<int> selectedHours = [];
<<<<<<< HEAD
  List<String> selectedWeekdayLessons = [];
  List<String> selectedWeekendLessons = [];
  Map<String, double> weekdayLessonPrices = {};
  Map<String, double> weekendLessonPrices = {};

  TextEditingController lessonController = TextEditingController();
  TextEditingController weekdayPriceController = TextEditingController();
  TextEditingController weekendPriceController = TextEditingController();
=======
  List<String> selectedLessons = [];
  Map<String, double> lessonPrices = {};

  TextEditingController lessonController = TextEditingController();
  TextEditingController priceController = TextEditingController();
>>>>>>> 4abfa489529a7a26596799ac393c6360ebb09e37
  TextEditingController nameController = TextEditingController();
  TextEditingController homePhoneController = TextEditingController();
  TextEditingController cellPhoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
<<<<<<< HEAD
  Widget _buildLessonInputs({
    required TextEditingController lessonController,
    required TextEditingController priceController,
    required Map<String, double> lessonPrices,
    required List<String> selectedLessons,
    required String title,
    required String priceLabel,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: lessonController,
            decoration: InputDecoration(
              labelText: title,
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            controller: priceController,
            decoration: InputDecoration(
              labelText: priceLabel,
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
    );
  }
=======
>>>>>>> 4abfa489529a7a26596799ac393c6360ebb09e37

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
<<<<<<< HEAD
                  'Verebildiği Hafta İçi Dersler ve Ücretleri:',
=======
                  'Verebildiği Dersler ve Ücretleri:',
>>>>>>> 4abfa489529a7a26596799ac393c6360ebb09e37
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
<<<<<<< HEAD
                _buildLessonInputs(
                  lessonController: lessonController,
                  priceController: weekdayPriceController,
                  lessonPrices: weekdayLessonPrices,
                  selectedLessons: selectedWeekdayLessons,
                  title: 'Ders Adı',
                  priceLabel: 'Ücret',
                ),
                SizedBox(height: 10),
                _buildLessonList(selectedWeekdayLessons, weekdayLessonPrices),
                SizedBox(height: 20),
                Text(
                  'Verebildiği Hafta Sonu Dersler ve Ücretleri:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                _buildLessonInputs(
                  lessonController: lessonController,
                  priceController: weekendPriceController,
                  lessonPrices: weekendLessonPrices,
                  selectedLessons: selectedWeekendLessons,
                  title: 'Ders Adı',
                  priceLabel: 'Ücret',
                ),
                SizedBox(height: 10),
                _buildLessonList(selectedWeekendLessons, weekendLessonPrices),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: onSaveButtonPressed,
=======
                _buildLessons(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    onSaveButtonPressed();
                  },
>>>>>>> 4abfa489529a7a26596799ac393c6360ebb09e37
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

<<<<<<< HEAD
  Widget _buildLessonList(
      List<String> selectedLessons, Map<String, double> lessonPrices) {
    return ListView.builder(
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
=======
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
>>>>>>> 4abfa489529a7a26596799ac393c6360ebb09e37
    );
  }

  void onSaveButtonPressed() async {
<<<<<<< HEAD
    // Hafta içi derslerin özelliklerini ekle
    int instructorId = await saveInstructor();
    await saveLessons(
        selectedWeekdayLessons, weekdayLessonPrices, instructorId, true);
    await saveLessons(
        selectedWeekendLessons, weekendLessonPrices, instructorId, false);
    // Hafta içi ve hafta sonu öğretmenlerin saatlerini eklemek için gerekli işlemleri yap

    // İşlem tamamlandıktan sonra kullanıcıya bir mesaj göstermek için bir SnackBar göster
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Öğretmen ve dersler başarıyla kaydedildi!')),
    );
    Navigator.pop(context);
  }

// Öğretmeni ve dersleri kaydetmek için yardımcı bir fonksiyon
  Future<int> saveInstructor() async {
=======
>>>>>>> 4abfa489529a7a26596799ac393c6360ebb09e37
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
<<<<<<< HEAD
    // Öğretmenin ID'sini döndür
    return instructorId;
  }

  Future<void> saveLessons(
      List<String> lessons,
      Map<String, double> lessonPrices,
      int instructorId,
      bool isWeekday) async {
    for (String lessonName in lessons) {
      double price = lessonPrices[lessonName]!;
      // Dersin hafta içi veya hafta sonu olmasına göre ekleme işlemi yap
      await DatabaseHelper.instance.insertLesson(
        {
          'instructorId': instructorId,
          'name': lessonName,
          'price': price,
        },
        isWeekday, // Hafta içi veya hafta sonu olduğunu belirten parametre
      );
    }
=======

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
>>>>>>> 4abfa489529a7a26596799ac393c6360ebb09e37
  }
}
