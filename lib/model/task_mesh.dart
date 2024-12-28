// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

/*
	ID        uint      `gorm:"primaryKey"`
	CreatedAt time.Time `gorm:"autoCreateTime"`
	UpdatedAt time.Time `gorm:"autoUpdateTime"`

	Filename string `gorm:"not null"`
	Url      string `gorm:"not null"`

	TaskID uint `gorm:"not null"` // Foreign key
*/

class TaskMesh extends Equatable {
  final int id;
  final String createdAt;
  final String updatedAt;
  final String filename;
  final String url;
  final int taskID;

  const TaskMesh({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.filename,
    required this.url,
    required this.taskID,
  });

  TaskMesh copyWith({
    int? id,
    String? createdAt,
    String? updatedAt,
    String? filename,
    String? url,
    int? taskID,
  }) {
    return TaskMesh(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      filename: filename ?? this.filename,
      url: url ?? this.url,
      taskID: taskID ?? this.taskID,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'filename': filename,
      'url': url,
      'taskID': taskID,
    };
  }

  factory TaskMesh.fromMap(Map<String, dynamic> map) {
    return TaskMesh(
      id: map['ID'] as int,
      createdAt: map['CreatedAt'] as String,
      updatedAt: map['UpdatedAt'] as String,
      filename: map['Filename'] as String,
      url: map['Url'] as String,
      taskID: map['TaskID'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskMesh.fromJson(String source) =>
      TaskMesh.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      createdAt,
      updatedAt,
      filename,
      url,
      taskID,
    ];
  }
}
