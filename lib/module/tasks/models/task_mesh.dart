import 'package:dart_mappable/dart_mappable.dart';

/*
	ID        uint      `gorm:"primaryKey"`
	CreatedAt time.Time `gorm:"autoCreateTime"`
	UpdatedAt time.Time `gorm:"autoUpdateTime"`

	Filename string `gorm:"not null"`
	Url      string `gorm:"not null"`

	TaskID uint `gorm:"not null"` // Foreign key
*/

part 'task_mesh.mapper.dart';

@MappableClass(caseStyle: CaseStyle.pascalCase)
class TaskMesh with TaskMeshMappable {
  @MappableField(key: "ID")
  final int id;
  final String createdAt;
  final String updatedAt;
  final String filename;
  final String url;
  final int taskID;

  static const empty = TaskMesh(
    id: 1,
    createdAt: '',
    updatedAt: '',
    filename: '',
    url: '',
    taskID: 1,
  );

  const TaskMesh({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.filename,
    required this.url,
    required this.taskID,
  });
}
