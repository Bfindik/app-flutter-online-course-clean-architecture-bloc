import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_course/core/services/database_helper.dart';
import 'package:online_course/src/theme/app_color.dart';

class CourseEditPage extends StatefulWidget {
  @override
  _CourseEditPageState createState() => _CourseEditPageState();
}

class _CourseEditPageState extends State<CourseEditPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController imageURLController = TextEditingController();
  bool _isLoading = true;
  List<Map<String, dynamic>> _courses = [];
  Map<String, dynamic>? _selectedCourse;
  List<Map<String, dynamic>> instructors = [];
  int? selectedInstructorId;
  List _categories = [];
  List<String> selectedDays = [];
  List<int> selectedCategories = [];
  Map<String, List<String>> craftDays = {};
  List<String> weekdays = ['Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma'];
  List<String> weekendDays = ['Cumartesi', 'Pazar'];
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    _fetchCourses();
    loadInstructors();
  }

  Future<void> _fetchCourses() async {
    _courses = await DatabaseHelper.instance.getCourses();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> loadInstructors() async {
    instructors = await DatabaseHelper.instance.getInstructors();
    setState(() {});
  }

  Future<void> _fetchCourseDetails() async {
    if (_selectedCourse != null) {
      selectedInstructorId = _selectedCourse!['instructorId'];
      _descriptionController.text = _selectedCourse!['description'];
      _priceController.text = _selectedCourse!['price'].toString();
      imageURLController.text = _selectedCourse!['image'];
      startDate = DateTime.parse(_selectedCourse!['startDate']);
      endDate = DateTime.parse(_selectedCourse!['endDate']);

      // Deserialize lessonIds and craftDays
      selectedCategories = (_selectedCourse!['lessonIds'] as String)
          .split(',')
          .map((id) => int.parse(id))
          .toList();
      craftDays = Map<String, List<String>>.from(
          json.decode(_selectedCourse!['craftDays']));

      await getAndSetLessons(selectedInstructorId!);

      setState(() {});
    }
  }

  Future<void> getAndSetLessons(int instructorId) async {
    List<Map<String, dynamic>> lessons =
        await DatabaseHelper.instance.getLessonsByInstructor(instructorId);
    _categories = lessons;
    for (var craft in _categories) {
      bool isWeekday = craft['isWeekday'] == 1;
      craftDays[craft['name']] = isWeekday ? [...weekdays] : [...weekendDays];
    }
  }

  void calculateCoursePrice() {
    double totalCoursePrice = 0.0;
    for (int index in selectedCategories) {
      totalCoursePrice += double.parse(_categories[index]['price'].toString());
    }
    setState(() {
      _priceController.text = totalCoursePrice.toString();
    });
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
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _updateCourse() async {
    if (_formKey.currentState!.validate()) {
      String lessonIds = selectedCategories.join(',');
      String craftDaysJson = json.encode(craftDays);

      Map<String, dynamic> updatedCourse = {
        'id': _selectedCourse!['id'],
        'instructorId': selectedInstructorId,
        'name': _selectedCourse!['name'],
        'description': _descriptionController.text,
        'price': double.parse(_priceController.text),
        'image': imageURLController.text,
        'startDate': startDate.toString(),
        'endDate': endDate.toString(),
        'lessonIds': lessonIds,
        'craftDays': craftDaysJson,
      };

      int result = await DatabaseHelper.instance.updateCourse(updatedCourse);
      if (result != -1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kurs başarıyla güncellendi.'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pop();
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Hata'),
            content: Text('Kurs güncellenirken bir hata oluştu.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Tamam'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kurs Düzenle'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButton<Map<String, dynamic>>(
                        hint:
                            Text('Kurs Seçin', style: TextStyle(fontSize: 16)),
                        value: _selectedCourse,
                        onChanged: (Map<String, dynamic>? newValue) {
                          setState(() {
                            _selectedCourse = newValue;
                            _fetchCourseDetails();
                          });
                        },
                        items: _courses.map((course) {
                          return DropdownMenuItem<Map<String, dynamic>>(
                            value: course,
                            child: Text(course['name'],
                                style: TextStyle(fontSize: 20)),
                          );
                        }).toList(),
                      ),
                      if (_selectedCourse != null) ...[
                        SizedBox(height: 20.0),
                        Text('Öğretmen Seçin:',
                            style: TextStyle(fontSize: 18.0)),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: DropdownButton<int>(
                            hint: Text('Öğretmeni seçin',
                                style: TextStyle(fontSize: 16)),
                            value: selectedInstructorId,
                            onChanged: (int? newValue) {
                              setState(() {
                                selectedInstructorId = newValue;
                                getAndSetLessons(selectedInstructorId!);
                              });
                            },
                            items: instructors
                                .map<DropdownMenuItem<int>>((instructor) {
                              return DropdownMenuItem<int>(
                                value: instructor['id'],
                                child: Text(instructor['name'],
                                    style: TextStyle(fontSize: 20)),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Text('El İşi Seçin:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(
                              bottom: 5, top: 5, left: 15),
                          child: Row(
                            children: List.generate(
                              _categories.length,
                              (index) => ElevatedButton(
                                onPressed: () {
                                  if (!selectedCategories.contains(index)) {
                                    _showCraftDaysDialog(
                                        _categories[index]['name']);
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
                                  backgroundColor:
                                      selectedCategories.contains(index)
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
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            labelText: 'Kurs Açıklaması',
                            hintText: 'Kurs hakkında kısa bir açıklama girin',
                          ),
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                        ),
                        SizedBox(height: 20.0),
                        Text('Kurs Fiyatı (₺):',
                            style: TextStyle(fontSize: 18.0)),
                        TextFormField(
                          controller: _priceController,
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
                          onPressed: _updateCourse,
                          child: Text('Kursu Güncelle'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
