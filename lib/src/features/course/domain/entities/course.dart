import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Course extends Equatable {
  Course(
      {required this.id,
      required this.instructorId,
      required this.name,
      required this.description,
      required this.price,
      required this.image,
      required this.startDate,
      required this.endDate,
      required this.lessonIds,
      required this.craftDays,
      this.isFavorited = false});

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

  @override
  List<Object?> get props => [
        id,
        name,
        price,
        image,
        startDate,
        endDate,
        lessonIds,
        craftDays,
        isFavorited
      ];
}
