import 'package:dart_mappable/dart_mappable.dart';

part 'chat_message.mapper.dart';

@MappableClass(caseStyle: CaseStyle.pascalCase)
class ChatMessage with ChatMessageMappable {
  @MappableField(key: "ID")
  final int id;
  final String message;
  final String sender;

  bool get isAI => !isUser;
  bool get isUser => sender == "USER";

  const ChatMessage({
    required this.id,
    required this.message,
    required this.sender,
  });
}
