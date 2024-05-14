// ignore_for_file: must_be_immutable

import 'package:online_course/src/features/course/domain/entities/course.dart';

class CourseModel extends Course {
  CourseModel({
    required super.id,
    required super.instructorId,
    required super.name,
    required super.description,
    required super.price,
    required super.image,
    required super.startDate,
    required super.endDate,
    required super.lessonIds,
    required super.craftDays,
  });

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      id: map['id'] as int, // İd alanını bir tamsayıya dönüştür
      instructorId: map['instructorId']
          as int, // instructorId alanını bir tamsayıya dönüştür
      name: map['name'] as String,
      description: map['description'] as String,
      price: map['price'] as double, // price alanını bir double'a dönüştür
      image: map['image'] as String,
      startDate: map['startDate'] as String,
      endDate: map['endDate'] as String,
      lessonIds: _parseList<String>(
          map['lessonIds']), // lessonIds alanını bir int listesine dönüştür
      craftDays: _parseList<String>(
          map['craftDays']), // craftDays alanını bir String listesine dönüştür
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'instructorId': instructorId,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'startDate': startDate,
      'endDate': endDate,
      'lessonIds':
          lessonIds.join(','), // Convert list to comma-separated string
      'craftDays':
          craftDays.join(','), // Convert list to comma-separated string
    };
  }

  factory CourseModel.empty() => CourseModel(
      id: 0,
      name: "_empty.name",
      price: 0,
      image: "_empty.image",
      startDate: "_empty.duration",
      endDate: "_empty.session",
      instructorId: 0,
      description: "_empty.description",
      craftDays: ["pazartesi", "salı"],
      lessonIds: ["0", "1"]);

  static List<T> _parseList<T>(String input) {
    if (input == null || input.isEmpty) {
      return [];
    }
    return input.split(',').map((e) => e as T).toList();
  }
}
