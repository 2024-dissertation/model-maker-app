// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:frontend/model/task_file.dart';

/*
	ID          uint `gorm:"primaryKey"`
	CreatedAt   time.Time
	UpdatedAt   time.Time  `gorm:"autoCreateTime"`
	DeletedAt   *time.Time `gorm:"autoUpdateTime"`
	Title       string
	Description string
	Completed   bool
	UserID      uint
	Images      []Image `gorm:"foreignKey:TaskID"`
*/

class Task extends Equatable {
  final int id;
  final String title;
  final String description;
  final bool completed;
  final int userID;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final List<TaskFile> images;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
    required this.userID,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.images = const [],
  });

  Task copyWith({
    int? id,
    String? title,
    String? description,
    bool? completed,
    int? userID,
    String? createdAt,
    String? updatedAt,
    String? deletedAt,
    List<TaskFile>? images,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      userID: userID ?? this.userID,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      images: images ?? this.images,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'completed': completed,
      'userID': userID,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
      'images': images.map((x) => x.toMap()).toList(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['ID'] as int,
      title: map['Title'] as String,
      description: map['Description'] as String,
      completed: map['Completed'] as bool,
      userID: map['UserID'] as int,
      createdAt: map['CreatedAt'] as String,
      updatedAt: map['UpdatedAt'] as String,
      deletedAt: map['DeletedAt'] != null ? map['DeletedAt'] as String : null,
      images: List<TaskFile>.from(
        (map['Images'] as List<dynamic>).map<TaskFile>(
          (x) => TaskFile.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) =>
      Task.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      title,
      description,
      completed,
      userID,
      createdAt,
      updatedAt,
      deletedAt,
      images,
    ];
  }
}
