import 'package:online_course/core/errors/exception.dart';
import 'package:online_course/core/services/database_helper.dart';
import 'package:online_course/src/features/course/data/models/course_model.dart';

abstract class CourseRemoteDataSource {
  Future<List<CourseModel>> getCourses();
  Future<List<CourseModel>> getFeaturedCourses();
}

class CourseRemoteDataSourceImpl implements CourseRemoteDataSource {
  CourseRemoteDataSourceImpl();

  @override
  Future<List<CourseModel>> getCourses() async {
    //==== Todo: implement the call to real api =====
    try {
      // Use database helper to get courses
      List<Map<String, dynamic>> coursesMapList =
          await DatabaseHelper.instance.getCourses();

      // Convert Map list to CourseModel list
      return coursesMapList.map((e) => CourseModel.fromMap(e)).toList();

      // final result = await http.get(Uri.parse(NetworkUrls.getCourses));
      // if (result.statusCode == 200) {
      //   return CourseMapper.jsonToCourseModelList(result.body);
      // }
      // return [];
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<CourseModel>> getFeaturedCourses() async {
    //==== Todo: implement the call to real api =====
    try {
      // Use database helper to get courses
      List<Map<String, dynamic>> coursesMapList =
          await DatabaseHelper.instance.getCourses();

      // Convert Map list to CourseModel list
      return coursesMapList.map((e) => CourseModel.fromMap(e)).toList();
    } catch (e) {
      print('Hata: $e');
      throw ServerException();
    }
  }
}
