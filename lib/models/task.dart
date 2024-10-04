// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class Task extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  DateTime createdAtTime;
  DateTime createdAtDate;
  bool? isCompleted;
  bool? isDeleted;
  bool? isFavorite;

  static const uuid = Uuid();

  Task({
    String? id,
    required this.title,
    required this.subtitle,
    required this.createdAtTime,
    required this.createdAtDate,
    bool? isCompleted,
    bool? isDeleted,
    bool? isFavorite,
  })  : id = id ?? uuid.v4(),
        isCompleted = isCompleted ?? false,
        isDeleted = isDeleted ?? false,
        isFavorite = isFavorite ?? false;

  Task copyWith({
    String? id,
    String? title,
    String? subtitle,
    DateTime? createdAtTime,
    DateTime? createdAtDate,
    bool? isCompleted,
    bool? isDeleted,
    bool? isFavorite,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      createdAtTime: createdAtTime ?? this.createdAtTime,
      createdAtDate: createdAtDate ?? this.createdAtDate,
      isCompleted: isCompleted ?? this.isCompleted,
      isDeleted: isDeleted ?? this.isDeleted,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'createdAtTime': createdAtTime.toIso8601String(),
        'createdAtDate': createdAtDate.toIso8601String(),
        'isCompleted': isCompleted,
        'isDeleted': isDeleted,
        'isFavorite': isFavorite,
      };

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      createdAtTime: DateTime.parse(json['createdAtTime']),
      createdAtDate: DateTime.parse(json['createdAtDate']),
      isCompleted: json['isCompleted'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        title,
        subtitle,
        createdAtDate,
        createdAtTime,
        isCompleted,
        isDeleted,
        isFavorite,
      ];
}
