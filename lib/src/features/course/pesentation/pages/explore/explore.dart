import 'package:flutter/material.dart';
import 'package:online_course/core/utils/dummy_data.dart';
import 'package:online_course/src/features/course/pesentation/pages/explore/widgets/category_item.dart';

import 'package:online_course/src/theme/app_color.dart';

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
  List<int> selectedCategories =
      []; // Birden fazla seçilen kategorileri saklayacak liste
  final List _categories = categories;
  @override
  void initState() {
    super.initState();
    selectedCraft = null; // veya başka bir başlangıç değeri olarak belirleyin
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
              'El İşi Seçin:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(bottom: 5, top: 5, left: 15),
              child: Row(
                children: List.generate(
                  _categories.length,
                  (index) => CategoryItem(
                    data: _categories[index],
                    isSelected: selectedCategories.contains(
                        index), // Seçili kategorilerin listesinde mi kontrol edilir
                    onTap: () {
                      setState(() {
                        if (selectedCategories.contains(index)) {
                          selectedCategories.remove(
                              index); // Kategoriyi seçili listesinden kaldır
                        } else {
                          selectedCategories
                              .add(index); // Kategoriyi seçili listesine ekle
                        }
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
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
                    color: AppColor.primary, // Kenarlık rengi
                    width: 2.0, // Kenarlık kalınlığı
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
              ),
              onPressed: () {
                // Perform search based on selected options
                // You can navigate to another page to display search results
              },
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
