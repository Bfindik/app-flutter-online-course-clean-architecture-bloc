import 'package:get_it/get_it.dart';
import 'package:online_course/core/utils/typedef.dart';
import 'package:online_course/src/features/course/data/models/course_model.dart';
import 'package:online_course/src/features/course/domain/entities/course.dart';

final GetIt sl = GetIt.instance;

abstract class CourseRepository {
  const CourseRepository();

  ResultFuture<List<Course>> getCourses();
  ResultFuture<List<Course>> getFeaturedCourses();
}
