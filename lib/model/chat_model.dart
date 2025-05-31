

import '../utils/constant_file.dart';

class ChatModel {
  final String model;
  final List<Messages> messages;

  ChatModel({required this.model, required this.messages});

  // Named constructor using initializer list for final fields
  ChatModel.fromJson(Map<String, dynamic> json)
    : model = json[ConstantsFile.paramModel] ?? '',
      messages =
          (json[ConstantsFile.paramMessages] != null)
              ? List<Messages>.from((json[ConstantsFile.paramMessages] as List<dynamic>).map((v) => Messages.fromJson(v)))
              : [];

  Map<String, dynamic> toJson() {
    return {ConstantsFile.paramModel: model, ConstantsFile.paramMessages: messages.map((v) => v.toJson()).toList()};
  }
}

class Messages {
  final String role;
  final String content;

  Messages({required this.role, required this.content});

  // Named constructor using initializer list for final fields
  Messages.fromJson(Map<String, dynamic> json)
    : role = json[ConstantsFile.paramRole] ?? '',
      content = json[ConstantsFile.paramContent] ?? '';

  Map<String, dynamic> toJson() {
    return {ConstantsFile.paramRole: role, ConstantsFile.paramContent: content};
  }
}
