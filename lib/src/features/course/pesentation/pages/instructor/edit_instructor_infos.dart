import 'package:flutter/material.dart';
import 'package:online_course/core/services/database_helper.dart';
import 'package:online_course/src/theme/app_color.dart';

class EditInstructorPage extends StatefulWidget {
  @override
  _EditInstructorPageState createState() => _EditInstructorPageState();
}

class _EditInstructorPageState extends State<EditInstructorPage> {
  List<Map<String, dynamic>> instructors = [];
  int? selectedInstructorId;
  late List<int> selectedHours;
  late List<String> selectedLessons;
  late Map<String, double> lessonPrices;

  TextEditingController nameController = TextEditingController();
  TextEditingController homePhoneController = TextEditingController();
  TextEditingController cellPhoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController lessonController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedHours = List.generate(
        24, (index) => index); // 0'dan 23'e kadar saatleri ekliyoruz
    selectedLessons = [];
    lessonPrices = {};
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
        title: Text('Öğretmen Bilgilerini Düzenle'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Öğretmen Seçin:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              DropdownButton<int>(
                hint: Text(
                  'Öğretmen adını seçin',
                  style: TextStyle(fontSize: 20),
                ),
                value: selectedInstructorId,
                onChanged: (int? newValue) {
                  setState(() {
                    selectedInstructorId = newValue;
                    // Seçilen öğretmenin bilgilerini yükle
                    loadInstructorInfo(selectedInstructorId!);
                  });
                },
                items: instructors.map<DropdownMenuItem<int>>(
                  (Map<String, dynamic> instructor) {
                    return DropdownMenuItem<int>(
                      value: instructor['id'],
                      child: Text(instructor['name']),
                    );
                  },
                ).toList(),
              ),
              SizedBox(height: 20),
              Text(
                'Öğretmen Bilgileri:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              _buildInfoField(
                controller: nameController,
                label: 'Adı Soyadı',
              ),
              _buildInfoField(
                controller: homePhoneController,
                label: 'Ev Telefonu',
              ),
              _buildInfoField(
                controller: cellPhoneController,
                label: 'Cep Telefonu',
              ),
              _buildInfoField(
                controller: addressController,
                label: 'Adres',
              ),
              _buildInfoField(
                controller: emailController,
                label: 'E-posta Adresi',
              ),
              SizedBox(height: 20),
              Text(
                'Çalışma Saatleri:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              _buildHoursList(),
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
                  updateInstructorInfo(
                      selectedInstructorId!); // Güncelleme işlemi
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary,
                ),
                child: Text(
                  'Güncelle',
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
        backgroundColor: isSelected ? AppColor.primary : Colors.white,
      ),
      child: Text(
        '$hour:00',
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
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

  Future<void> loadInstructorInfo(int instructorId) async {
    Map<String, dynamic>? instructor =
        await DatabaseHelper.instance.getInstructorById(instructorId);
    if (instructor != null) {
      nameController.text = instructor['name'];
      homePhoneController.text = instructor['homePhone'];
      cellPhoneController.text = instructor['cellPhone'];
      addressController.text = instructor['address'];
      emailController.text = instructor['email'];

      List<Map<String, dynamic>> hours =
          await DatabaseHelper.instance.getHoursByInstructorId(instructorId);
      selectedHours = hours.map<int>((hour) => hour['hour']).toList();

      List<Map<String, dynamic>> lessons =
          await DatabaseHelper.instance.getLessonsByInstructorId(instructorId);
      selectedLessons =
          lessons.map<String>((lesson) => lesson['name']).toList();
      lessonPrices = Map.fromIterable(lessons,
          key: (lesson) => lesson['name'], value: (lesson) => lesson['price']);

      setState(() {});
    }
  }

  Widget _buildHoursList() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: List.generate(7, (index) {
        return buildHourButton(
            index + 9); // Saatlerin 9'dan başlaması için index + 9
      }),
    );
  }

  Future<void> updateInstructorInfo(int instructorId) async {
    // Yeni bilgileri al
    Map<String, dynamic> updatedInstructor = {
      'id': selectedInstructorId,
      'name': nameController.text,
      'homePhone': homePhoneController.text,
      'cellPhone': cellPhoneController.text,
      'address': addressController.text,
      'email': emailController.text,
      'hours': selectedHours,
      'lessons': selectedLessons,
      'lessonPrices': lessonPrices,
    };

    // Öğretmen bilgilerini güncelle
    int result =
        await DatabaseHelper.instance.updateInstructor(updatedInstructor);
    if (result != 0) {
      // Güncelleme başarılı
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Öğretmen bilgileri güncellendi'),
        ),
      );
    } else {
      // Güncelleme başarısız
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Öğretmen bilgilerini güncellerken bir hata oluştu'),
        ),
      );
    }
    Navigator.pop(context);
  }
}
