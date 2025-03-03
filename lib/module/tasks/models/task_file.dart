import 'package:dart_mappable/dart_mappable.dart';

/*
	ID        uint      `gorm:"primaryKey"`
	Filename  string    `gorm:"not null"`
	Url       string    `gorm:"not null"`
	CreatedAt time.Time `gorm:"autoCreateTime"`
	UpdatedAt time.Time `gorm:"autoUpdateTime"`
	TaskID    uint      `gorm:"not null"` // Foreign key
*/

part 'task_file.mapper.dart';

@MappableClass(caseStyle: CaseStyle.pascalCase)
class TaskFile with TaskFileMappable {
  final int id;
  final String filename;
  final String url;
  final String createdAt;
  final String updatedAt;
  final int taskID;

  static const empty = TaskFile(
    id: 0,
    filename: '',
    url: '',
    createdAt: '',
    updatedAt: '',
    taskID: 0,
  );

  const TaskFile({
    required this.id,
    required this.filename,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
    required this.taskID,
  });
}
