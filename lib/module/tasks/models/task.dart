import 'package:dart_mappable/dart_mappable.dart';
import 'package:frontend/helpers/globals.dart';
import 'package:frontend/module/chatbox/models/chat_message.dart';
import 'package:frontend/module/tasks/models/task_file.dart';
import 'package:frontend/module/tasks/models/task_mesh.dart';
import 'package:frontend/module/tasks/models/task_status.dart';

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

part 'task.mapper.dart';

@MappableClass(caseStyle: CaseStyle.pascalCase)
class Task with TaskMappable {
  @MappableField(key: "ID")
  final int id;
  final String title;
  final String description;
  final bool completed;
  final TaskStatus status;
  final int userID;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final List<TaskFile>? images;
  final TaskMesh? mesh;
  final Map<String, dynamic> metadata;
  final List<ChatMessage>? chatMessages;

  String get fTitle =>
      metadata.containsKey("ai-title") ? metadata["ai-title"] : title;

  String get fDescription => metadata.containsKey("ai-description")
      ? metadata["ai-description"]
      : description;

  List<Uri> get imageUrls {
    if (images == null || images!.isEmpty) {
      return [];
    }
    return images!
        .map((e) => Uri.parse(Globals.baseUrl)
            .resolveUri(Uri.parse(e.url.replaceAll("task-", ""))))
        .toList();
  }

  static const empty = Task(
    id: 1,
    title: 'Task',
    description: 'Description',
    completed: false,
    userID: 1,
    createdAt: '',
    updatedAt: '',
    status: TaskStatus.INITIAL,
  );

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
    this.images,
    this.mesh,
    this.metadata = const {},
    this.chatMessages,
  });
}
