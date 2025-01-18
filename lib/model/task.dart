// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:frontend/model/task_file.dart';
import 'package:frontend/model/task_mesh.dart';
import 'package:frontend/model/task_status.dart';

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
  final TaskStatus status;
  final int userID;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final List<TaskFile> images;
  final TaskMesh? mesh;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
    required this.userID,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    this.deletedAt,
    this.images = const [],
    this.mesh,
  });

  Task copyWith({
    int? id,
    String? title,
    String? description,
    bool? completed,
    TaskStatus? status,
    int? userID,
    String? createdAt,
    String? updatedAt,
    String? deletedAt,
    List<TaskFile>? images,
    TaskMesh? mesh,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      status: status ?? this.status,
      userID: userID ?? this.userID,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      images: images ?? this.images,
      mesh: mesh ?? this.mesh,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'completed': completed,
      'status': status,
      'userID': userID,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
      'images': images.map((x) => x.toMap()).toList(),
      'mesh': mesh?.toMap(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['ID'] as int,
      title: map['Title'] as String,
      description: map['Description'] as String,
      completed: map['Completed'] as bool,
      status: TaskStatusX.fromName(map['Status'] as String),
      userID: map['UserID'] as int,
      createdAt: map['CreatedAt'] as String,
      updatedAt: map['UpdatedAt'] as String,
      deletedAt: map['DeletedAt'] != null ? map['DeletedAt'] as String : null,
      images: map['Images'] != null
          ? List<TaskFile>.from(
              (map['Images'] as List<dynamic>).map<TaskFile>(
                (x) => TaskFile.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
      mesh: map['Mesh'] != null
          ? TaskMesh.fromMap(map['Mesh'] as Map<String, dynamic>)
          : null,
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
      status,
      userID,
      createdAt,
      updatedAt,
      deletedAt,
      images,
      mesh,
    ];
  }
}
