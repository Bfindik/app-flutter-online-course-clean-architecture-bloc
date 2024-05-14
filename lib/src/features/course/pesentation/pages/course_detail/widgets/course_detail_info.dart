import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:online_course/core/services/database_helper.dart';
import 'package:online_course/src/features/course/domain/entities/course.dart';
import 'package:online_course/src/features/course/pesentation/bloc/favorite_course/favorite_course_bloc.dart';
import 'package:online_course/src/theme/app_color.dart';
import 'package:online_course/src/widgets/favorite_box_v2.dart';
import 'package:readmore/readmore.dart';

class CourseDetailInfo extends StatelessWidget {
  const CourseDetailInfo({required this.course, super.key});

  final Course course;

  @override
  Widget build(BuildContext context) {
    DateTime startDate = DateTime.parse(course.startDate);
    DateTime endData = DateTime.parse(course.endDate);
    Future<String?> instructorName =
        DatabaseHelper.instance.getInstructorNameById(course.instructorId);
    DatabaseHelper.instance.printAllLessons();

    // startDate'ı biçimlendir
    String formattedDate = DateFormat('dd.MM.yyyy').format(startDate);
    String formattedDateEnd = DateFormat('dd.MM.yyyy').format(endData);
    print(course.craftDays.join(', '));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                course.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
            BlocBuilder<FavoriteCourseBloc, FavoriteCourseState>(
              builder: (context, state) {
                return FavoriteBoxV2(
                  isFavorited: course.isFavorited,
                  onTap: () {
                    BlocProvider.of<FavoriteCourseBloc>(context)
                        .add(ToggleFavoriteCourse(course));
                  },
                );
              },
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            _buildCourseAttribute(Icons.play_circle_outlined,
                AppColor.labelColor, formattedDate + "-" + formattedDateEnd),
            const SizedBox(
              width: 15,
            ),
            _buildInstructorNameAttribute(
                Icons.star, AppColor.yellow, instructorName),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        _buildCourseDaysAttribute(
            Icons.schedule_rounded, AppColor.labelColor, course.craftDays),
        const SizedBox(
          width: 15,
        ),
        const Text(
          "Kurs Hakkında",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 5,
        ),
        ReadMoreText(
          course.description,
          style: const TextStyle(color: AppColor.labelColor, height: 1.5),
          trimLines: 2,
          trimMode: TrimMode.Line,
          trimCollapsedText: 'daha fazla göster',
          trimExpandedText: 'daha az göster',
          moreStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColor.red,
          ),
        ),
      ],
    );
  }

  Widget _buildCourseAttribute(IconData icon, Color color, String info) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: color,
        ),
        const SizedBox(
          width: 3,
        ),
        Text(
          info,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: AppColor.labelColor, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildCourseDaysAttribute(
      IconData icon, Color color, List<String> craftDays) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: color,
        ),
        const SizedBox(
          width: 3,
        ),
        Expanded(
          child: Wrap(
            spacing: 8.0,
            children: craftDays.map((day) {
              return Text(
                day,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildInstructorNameAttribute(
      IconData icon, Color color, Future<String?> instructorNameFuture) {
    return FutureBuilder<String?>(
      future: instructorNameFuture,
      builder: (context, snapshot) {
        final String? instructorName = snapshot.data;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: color,
              ),
              const SizedBox(
                width: 3,
              ),
              Text(
                instructorName ??
                    '', // Eğitmen adını gösterir, null ise boş bir dize gösterir
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(color: AppColor.labelColor, fontSize: 14),
              ),
            ],
          );
        }
      },
    );
  }
}
