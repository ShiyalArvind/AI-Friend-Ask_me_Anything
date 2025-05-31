

import '../utils/constant_file.dart';

class ChatMessage implements Comparable {
  final String text;
  final bool isSender;
  final DateTime timestamp;
  final String username;
  final String userId;


  ChatMessage({
    required this.text,
    required this.isSender,
    required this.timestamp,
    required this.username,
    required this.userId,

  });

  @override
  int compareTo(other) {
    return timestamp.compareTo(other.timestamp);
  }

  Map<String, dynamic> toJson() {
    return {
      ConstantsFile.paramText: text,
      ConstantsFile.paramIsSender: isSender,
      ConstantsFile.paramTimestamp: timestamp.toIso8601String(),
      ConstantsFile.paramUsername: username,
      ConstantsFile.paramUserId: userId,

    };
  }

  /// Deserialize from Firebase data
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      text: json[ConstantsFile.paramText] ?? '',
      isSender: json[ConstantsFile.paramIsSender] ?? false,
      timestamp: DateTime.parse(json[ConstantsFile.paramTimestamp]),
      username: json[ConstantsFile.paramUsername] ?? '',
      userId: json[ConstantsFile.paramUserId] ?? '',

    );
  }
}


