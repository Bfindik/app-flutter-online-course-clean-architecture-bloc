import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_course/core/services/database_helper.dart';
import 'package:online_course/core/utils/dummy_data.dart';
import 'package:online_course/src/features/course/pesentation/pages/explore/widgets/category_item.dart';
import 'package:online_course/src/theme/app_color.dart';

class AddCoursePage extends StatefulWidget {
  @override
  _AddCoursePageState createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  String? selectedCraft = '';
  late List _categories = categories;
  List<String> selectedDays = [];
  List<int> selectedCategories = [];
  List<Map<String, dynamic>> instructors = [];
  int? selectedInstructorId;
  double coursePrice = 0.0;
  DateTime? startDate;
  DateTime? endDate;
  Map<String, List<String>> craftDays = {};

  List<String> weekdays = [
    'Pazartesi',
    'Salı',
    'Çarşamba',
    'Perşembe',
    'Cuma',
  ];
  List<String> weekendDays = ['Cumartesi', 'Pazar'];
  final TextEditingController _controller = TextEditingController();
  final TextEditingController imageURLController = TextEditingController();
  final TextEditingController courseNameController =
      TextEditingController(); // Add this line
  final TextEditingController DescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadInstructors();
  }

  @override
  void dispose() {
    _controller.dispose();
    courseNameController.dispose(); // Dispose the controller
    super.dispose();
  }

  Future<void> loadInstructors() async {
    instructors = await DatabaseHelper.instance.getInstructors();
    setState(() {});
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? pickedStartDate = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedStartDate != null && pickedStartDate != startDate) {
      setState(() {
        startDate = pickedStartDate;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? pickedEndDate = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedEndDate != null && pickedEndDate != endDate) {
      setState(() {
        endDate = pickedEndDate;
      });
    }
  }

  void getAndSetLessons(int instructorId) async {
    List<Map<String, dynamic>> lessons =
        await DatabaseHelper.instance.getLessonsByInstructor(instructorId);
    print(lessons);
    setState(() {
      _categories = lessons;
      for (var craft in _categories) {
        // Dersin hafta içi veya hafta sonu olup olmadığını kontrol et
        bool isWeekday = craft['isWeekday'] == 1; // 1 hafta içi, 0 hafta sonu
        // Günleri ayarla
        craftDays[craft['name']] = isWeekday ? [...weekdays] : [...weekendDays];
      }
    });
  }

  void calculateCoursePrice() {
    double totalCoursePrice = 0.0;
    for (int index in selectedCategories) {
      totalCoursePrice += double.parse(_categories[index]['price'].toString());
    }
    setState(() {
      coursePrice = totalCoursePrice;
      print("${coursePrice}");
      _controller.text = totalCoursePrice.toString();
    });
  }

  Future<void> _showCraftDaysDialog(String? craftName) async {
    if (craftName != null && craftDays.containsKey(craftName)) {
      List<String> selectedDaysForCraft = [...craftDays[craftName]!];
      bool isWeekday =
          selectedDaysForCraft.every((day) => weekdays.contains(day));
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Günleri Seçin'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Hangi günlerde bu el işi yapılacak?'),
                  SizedBox(height: 10),
                  ToggleButtons(
                    children: isWeekday
                        ? weekdays
                            .map((day) =>
                                Text(day, style: TextStyle(fontSize: 12)))
                            .toList()
                        : weekendDays
                            .map((day) =>
                                Text(day, style: TextStyle(fontSize: 12)))
                            .toList(),
                    isSelected: isWeekday
                        ? weekdays
                            .map((day) => selectedDaysForCraft.contains(day))
                            .toList()
                        : weekendDays
                            .map((day) => selectedDaysForCraft.contains(day))
                            .toList(),
                    onPressed: (index) {
                      setState(() {
                        final selectedDay =
                            isWeekday ? weekdays[index] : weekendDays[index];
                        if (selectedDaysForCraft.contains(selectedDay)) {
                          selectedDaysForCraft.remove(selectedDay);
                        } else {
                          selectedDaysForCraft.add(selectedDay);
                        }
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              // El işine göre seçilen günleri güncelle
                              craftDays[craftName] = selectedDaysForCraft;
                            });
                            calculateCoursePrice();
                            Navigator.of(context).pop();
                          },
                          child: Text('Tamam'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Belirtilen el işi bulunamadı veya null.'),
          duration: Duration(seconds: 2), // Uyarı süresi, isteğe bağlı
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kurs Ekle'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Öğretmen Seçin:',
                style: TextStyle(fontSize: 18.0),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: DropdownButton<int>(
                  hint: Text(
                    'Öğretmeni seçin',
                    style: TextStyle(fontSize: 16),
                  ),
                  value: selectedInstructorId,
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedInstructorId = newValue;
                      getAndSetLessons(selectedInstructorId!);
                    });
                  },
                  items: instructors.map<DropdownMenuItem<int>>(
                    (Map<String, dynamic> instructor) {
                      return DropdownMenuItem<int>(
                        value: instructor['id'],
                        child: Text(
                          instructor['name'],
                          style: TextStyle(fontSize: 20),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: courseNameController, // Add this TextFormField
                decoration: InputDecoration(
                  labelText: 'Kurs Adı',
                  hintText: 'Kurs adını girin',
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 20.0),
              Text(
                'El İşi Seçin:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(bottom: 5, top: 5, left: 15),
                child: Row(
                  children: List.generate(
                    _categories.length,
                    (index) => ElevatedButton(
                      onPressed: () {
                        if (!selectedCategories.contains(index)) {
                          _showCraftDaysDialog(_categories[index]['name']);
                        }
                        setState(() {
                          if (selectedCategories.contains(index)) {
                            selectedCategories.remove(index);
                          } else {
                            selectedCategories.add(index);
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedCategories.contains(index)
                            ? AppColor.primary
                            : Colors.white,
                      ),
                      child: Text(_categories[index]['name']),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                children: [
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _selectStartDate(context),
                    child: Text(startDate != null
                        ? DateFormat.yMMMd().format(startDate!)
                        : 'Başlangıç Tarihi Seç'),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => _selectEndDate(context),
                    child: Text(endDate != null
                        ? DateFormat.yMMMd().format(endDate!)
                        : 'Bitiş Tarihi Seç'),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Kurs Açıklaması',
                  hintText: 'Kurs hakkında kısa bir açıklama girin',
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: DescriptionController,
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Kurs Fiyatı',
                  hintText: 'TL',
                ),
                controller: _controller,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: imageURLController,
                decoration: InputDecoration(
                  labelText: 'Resim URL',
                  hintText: 'Kurs resminin URL adresini girin',
                ),
                keyboardType: TextInputType.url,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  // Seçilen derslerin kimliklerini ve günlerini birleştir
                  List<String> lessonIds = selectedCategories
                      .map((index) => _categories[index]['id'].toString())
                      .toList();
                  print("seçilen değerler ${lessonIds}");
                  // craftDays haritasını JSON formatına dönüştür
                  String craftDaysJson = json.encode(craftDays);

                  Map<String, dynamic> course = {
                    'instructorId': selectedInstructorId,
                    'name':
                        courseNameController.text, // Use the input course name
                    'description':
                        DescriptionController.text, // Kurs açıklaması
                    'price': coursePrice, // Kurs fiyatı
                    'image': imageURLController.text, // Resim URL'si
                    'startDate': startDate.toString(), // Başlangıç tarihi
                    'endDate': endDate.toString(), // Bitiş tarihi
                    'lessonIds':
                        lessonIds.join(','), // Seçilen derslerin kimlikleri
                    'craftDays': craftDaysJson, // Seçilen ders günleri
                  };
                  print(course);

                  int courseId =
                      await DatabaseHelper.instance.insertCourse(course);
                  if (courseId != -1) {
                    // Başarıyla eklendi
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Kurs başarıyla eklendi.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    Navigator.of(context)
                        .pop(); // Kullanıcıyı ana sayfaya geri yönlendir
                  } else {
                    // Hata oluştu
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Hata'),
                        content: Text('Kurs eklenirken bir hata oluştu.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Tamam'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: Text('Kursu Ekle'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
