import 'package:flutter/material.dart';
import 'package:online_course/core/services/database_helper.dart';
import 'package:online_course/src/features/course/domain/entities/course.dart';
import 'package:online_course/src/features/course/pesentation/pages/explore/widgets/category_item.dart';
import 'package:online_course/src/features/course/pesentation/pages/explore/widgets/explore_course_list.dart';
import 'package:online_course/src/theme/app_color.dart';
import 'package:sqflite/sqflite.dart';

class CourseSearchPage extends StatefulWidget {
  const CourseSearchPage({Key? key}) : super(key: key);

  @override
  _CourseSearchPageState createState() => _CourseSearchPageState();
}

class _CourseSearchPageState extends State<CourseSearchPage> {
  String? selectedCraft = '';
  bool isWeekdaySelected = false;
  bool isWeekendSelected = false;
  double budget = 0.0;
  List<int> selectedCategories = [];
  List<Map<String, dynamic>> _lessons =
      []; // Veritabanından alınan derslerin listesi

  @override
  void initState() {
    super.initState();
    selectedCraft = null;
    _loadLessons(); // Dersleri yükle
  }

  // Dersleri yükleme işlevi
  void _loadLessons() async {
    List<Map<String, dynamic>> lessons =
        await DatabaseHelper.instance.getLessons();
    setState(() {
      _lessons = lessons;
    });
  }

  void _performSearch() async {
    final searchedCoursesData =
        await DatabaseHelper.searchCoursesByBudgetAndCategories(
      selectedCategories: selectedCategories,
      budget: budget,
    );
    // Convert the List<Map<String, dynamic>> to List<Course>
    final searchedCourses = searchedCoursesData
        .map((courseData) => Course.fromMap(courseData))
        .toList();

    // Eğer arama sonucu boşsa, ekrana "Hiçbir sonuç bulunamadı" mesajını yazdır
    if (searchedCourses.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Arama Sonuçları'),
            content: Text('Hiçbir sonuç bulunamadı.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Dialog penceresini kapat
                },
                child: Text('Kapat'),
              ),
            ],
          );
        },
      );
    } else {
      // Eğer sonuçlar bulunduysa, arama sonuçlarını göster
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text('Arama Sonuçları'),
            ),
            body: ExploreCourseList(courses: searchedCourses),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      appBar: AppBar(
        title: Text('Kurs Arama'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kurs Günleri:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            CheckboxListTile(
              title: Text('Haftaiçi'),
              value: isWeekdaySelected,
              onChanged: (value) {
                setState(() {
                  isWeekdaySelected = value!;
                });
              },
              activeColor: AppColor.primary,
            ),
            CheckboxListTile(
              title: Text('Haftasonu'),
              value: isWeekendSelected,
              onChanged: (value) {
                setState(() {
                  isWeekendSelected = value!;
                });
              },
              activeColor: AppColor.primary,
            ),
            SizedBox(height: 20),
            Text(
              'El İşi Seçin:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(bottom: 5, top: 5, left: 15),
              child: Row(
                children: List.generate(
                  _lessons.length,
                  (index) {
                    final lesson = _lessons[index];
                    // Haftaiçi veya haftasonu seçeneklerine göre filtreleme yap
                    if ((isWeekdaySelected && lesson['isWeekday'] == 1) ||
                        (isWeekendSelected && lesson['isWeekday'] == 0)) {
                      return CategoryItem(
                        data: lesson,
                        isSelected: selectedCategories.contains(index),
                        onTap: () {
                          setState(() {
                            if (selectedCategories.contains(index)) {
                              selectedCategories.remove(index);
                            } else {
                              selectedCategories.add(index);
                            }
                          });
                        },
                      );
                    } else {
                      return SizedBox.shrink(); // Görünmez bir widget döndür
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Bütçe Girin:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  budget = double.tryParse(value) ?? 0.0;
                });
              },
              decoration: InputDecoration(
                hintText: 'TL',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor.primary,
                    width: 2.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
              ),
              onPressed: _performSearch,
              child: Text(
                'Ara',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
