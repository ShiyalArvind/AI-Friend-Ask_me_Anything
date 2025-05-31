

import '../utils/constant_file.dart';

class ChatResponseModel {
  final String id;
  final String object;
  final int created;
  final String model;
  final List<dynamic> prompt; // List<dynamic> since prompt in your JSON is an empty list
  final List<Choices> choices;
  final Usage usage;

  ChatResponseModel({
    required this.id,
    required this.object,
    required this.created,
    required this.model,
    required this.prompt,
    required this.choices,
    required this.usage,
  });

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatResponseModel(
      id: json[ ConstantsFile.paramId] ?? '',
      object: json[ConstantsFile.paramObject] ?? '',
      created: json[ConstantsFile.paramCreated] ?? 0,
      model: json[ConstantsFile.paramModel] ?? '',
      prompt: json[ConstantsFile.paramPrompt] != null ? List<dynamic>.from(json[ConstantsFile.paramPrompt]) : [],
      choices:
          json[ConstantsFile.paramChoices] != null
              ? List<Choices>.from((json[ConstantsFile.paramChoices] as List).map((v) => Choices.fromJson(v)))
              : [],
      usage: json[ConstantsFile.paramUsage] != null ? Usage.fromJson(json[ConstantsFile.paramUsage]) : Usage.empty(),
    );
  }

  Map<String, dynamic> toJson() => {
    ConstantsFile.paramId: id,
    ConstantsFile.paramObject: object,
    ConstantsFile.paramCreated: created,
    ConstantsFile.paramModel: model,
    ConstantsFile.paramPrompt: prompt,
    ConstantsFile.paramChoices: choices.map((v) => v.toJson()).toList(),
    ConstantsFile.paramUsage: usage.toJson(),
  };
}

class Choices {
  final String finishReason;
  final dynamic seed;
  final dynamic logProbs;
  final int index;
  final Message message;

  Choices({required this.finishReason, required this.seed, required this.logProbs, required this.index, required this.message});

  factory Choices.fromJson(Map<String, dynamic> json) {
    return Choices(
      finishReason: json[ConstantsFile.paramFinishReason] ?? '',
      seed: json[ConstantsFile.paramSeed] ?? 0,
      logProbs: json[ConstantsFile.paramLogProbs] != null ? List<dynamic>.from(json[ConstantsFile.paramLogProbs]) : [],
      index: json[ConstantsFile.paramIndex] ?? 0,
      message: json[ConstantsFile.paramMessage] != null ? Message.fromJson(json[ConstantsFile.paramMessage]) : Message.empty(),
    );
  }

  Map<String, dynamic> toJson() => {
    ConstantsFile.paramFinishReason: finishReason,
    ConstantsFile.paramSeed: seed,
    ConstantsFile.paramLogProbs: logProbs,
    ConstantsFile.paramIndex: index,
    ConstantsFile.paramMessage: message.toJson(),
  };
}

class Message {
  final String role;
  final String content;
  final List<dynamic> toolCalls;

  Message({required this.role, required this.content, required this.toolCalls});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      role: json[ConstantsFile.paramRole] ?? '',
      content: json[ConstantsFile.paramContent] ?? '',
      toolCalls: json[ConstantsFile.paramToolCalls] != null ? List<dynamic>.from(json[ConstantsFile.paramToolCalls]) : [],
    );
  }

  Map<String, dynamic> toJson() => {
    ConstantsFile.paramRole: role,
    ConstantsFile.paramContent: content,
    ConstantsFile.paramToolCalls: toolCalls,
  };

  // Helper if a message is missing
  factory Message.empty() => Message(role: '', content: '', toolCalls: []);
}

class Usage {
  final int promptTokens;
  final int completionTokens;
  final int totalTokens;

  Usage({required this.promptTokens, required this.completionTokens, required this.totalTokens});

  factory Usage.fromJson(Map<String, dynamic> json) {
    return Usage(
      promptTokens: json[ConstantsFile.paramPromptTokens] ?? 0,
      completionTokens: json[ConstantsFile.paramCompletionTokens] ?? 0,
      totalTokens: json[ConstantsFile.paramTotalTokens] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    ConstantsFile.paramPromptTokens: promptTokens,
    ConstantsFile.paramCompletionTokens: completionTokens,
    ConstantsFile.paramTotalTokens: totalTokens,
  };

  factory Usage.empty() => Usage(promptTokens: 0, completionTokens: 0, totalTokens: 0);
}

