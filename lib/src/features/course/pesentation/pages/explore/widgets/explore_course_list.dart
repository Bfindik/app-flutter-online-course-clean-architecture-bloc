import 'package:flutter/material.dart';
import 'package:online_course/core/utils/app_navigate.dart';
import 'package:online_course/src/features/course/domain/entities/course.dart';
import 'package:online_course/src/features/course/pesentation/pages/course_detail/course_detail.dart';
import 'package:online_course/src/features/course/pesentation/pages/explore/widgets/course_item.dart';

class ExploreCourseList extends StatefulWidget {
  const ExploreCourseList({Key? key, required this.courses}) : super(key: key);
  final List<Course> courses;

  @override
  State<ExploreCourseList> createState() => _ExploreCourseListState();
}

class _ExploreCourseListState extends State<ExploreCourseList> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(bottom: 5, top: 5, left: 15),
      child: Row(
        children: [
          _buildItemList(widget.courses),
        ],
      ),
    );
  }

  Widget _buildItemList(List<Course> courses) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: courses.length,
      itemBuilder: (context, index) {
        return CourseItem(
          onTap: () {
            AppNavigator.to(
              context,
              CourseDetailPage(
                course: courses[index],
                isHero: true,
              ),
            );
          },
          course: courses[index],
          width: MediaQuery.of(context).size.width,
        );
      },
    );
  }
}
