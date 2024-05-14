import 'package:flutter/material.dart';
import 'package:online_course/core/services/database_helper.dart'; // Veritabanı yardımcı sınıfı
import 'package:online_course/src/features/course/pesentation/pages/course_detail/widgets/lesson_item.dart';

class CourseDetailLessonList extends StatelessWidget {
  const CourseDetailLessonList({required this.courseId, super.key});
  final int courseId; // Kursun id'si

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseHelper.instance.getLessonNamesByCourseId(courseId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final lessons = snapshot.data ?? [];
          return ListView.builder(
            itemCount: lessons.length,
            itemBuilder: (context, index) {
              return LessonItem(
                data: lessons[index],
              );
            },
          );
        }
      },
    );
  }
}
