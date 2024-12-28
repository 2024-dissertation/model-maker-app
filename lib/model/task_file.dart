// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

/*
	ID        uint      `gorm:"primaryKey"`
	Filename  string    `gorm:"not null"`
	Url       string    `gorm:"not null"`
	CreatedAt time.Time `gorm:"autoCreateTime"`
	UpdatedAt time.Time `gorm:"autoUpdateTime"`
	TaskID    uint      `gorm:"not null"` // Foreign key
*/

class TaskFile extends Equatable {
  final int id;
  final String filename;
  final String url;
  final String createdAt;
  final String updatedAt;
  final int taskID;

  const TaskFile({
    required this.id,
    required this.filename,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
    required this.taskID,
  });

  TaskFile copyWith({
    int? id,
    String? filename,
    String? url,
    String? createdAt,
    String? updatedAt,
    int? taskID,
  }) {
    return TaskFile(
      id: id ?? this.id,
      filename: filename ?? this.filename,
      url: url ?? this.url,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      taskID: taskID ?? this.taskID,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'filename': filename,
      'url': url,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'taskID': taskID,
    };
  }

  factory TaskFile.fromMap(Map<String, dynamic> map) {
    return TaskFile(
      id: map['ID'] as int,
      filename: map['Filename'] as String,
      url: map['Url'] as String,
      createdAt: map['CreatedAt'] as String,
      updatedAt: map['UpdatedAt'] as String,
      taskID: map['TaskID'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskFile.fromJson(String source) =>
      TaskFile.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      filename,
      url,
      createdAt,
      updatedAt,
      taskID,
    ];
  }
}
