import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Course extends Equatable {
  Course({
    required this.id,
    required this.instructorId,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.startDate,
    required this.endDate,
    required this.lessonIds,
    required this.craftDays,
    this.isFavorited = false,
  });

  int id;
  int instructorId;
  String name;
  String description;
  double price;
  String image;
  String startDate;
  String endDate;
  List<String> lessonIds;
  List<String> craftDays;
  bool isFavorited;

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'],
      instructorId: map['instructorId'],
      name: map['name'],
      description: map['description'],
      price: map['price'],
      image: map['image'],
      startDate: map['startDate'],
      endDate: map['endDate'],
      lessonIds: List<String>.from(map['lessonIds']),
      craftDays: List<String>.from(map['craftDays']),
      isFavorited: map['isFavorited'] ?? false,
    );
  }

  @override
  List<Object?> get props => [
        id,
        instructorId,
        name,
        description,
        price,
        image,
        startDate,
        endDate,
        lessonIds,
        craftDays,
        isFavorited,
      ];
}
