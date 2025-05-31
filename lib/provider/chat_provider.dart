import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/chat_message.dart';
import '../model/chat_model.dart';
import '../model/chat_response_model.dart';

import '../services/api_base_url.dart';
import '../services/api_service.dart';
import '../services/firebase_services.dart';

import 'dart:async';

import '../services/shared_pref.dart';
import '../utils/constant_file.dart';

class ChatProvider extends ChangeNotifier {
  final List<ChatMessage> _textMessages = [];

  List<ChatMessage> getMessages() => _textMessages;

  bool _isMessageLoading = false;

  bool get isLoading => _isMessageLoading;

  bool _isTextLoading = false;

  bool get isTextLoading => _isTextLoading;

  final FirebaseRealtimeService _realtimeService = FirebaseRealtimeService();
  final FirestoreService _firestoreService = FirestoreService();
  final ApiServices _api = ApiServices(null);


  StreamSubscription? _textSubscription;
  StreamSubscription? _imageSubscription;

  String? _userId;
  String _chatPath = '';

  String currentUser = '';

  double _imageQuality = 40.0;

  double get imageQuality => _imageQuality;
  int imageQuantity = 1;

  void updateImageQuality(double value) {
    _imageQuality = value;
    notifyListeners();
  }

  void incrementImageQty() {
    imageQuantity++;
    notifyListeners();
  }

  void decrementImageQty() {
    if (imageQuantity > 1) {
      imageQuantity--;
      notifyListeners();
    }
  }

  Future<void> getAllMessages() async {
    _isMessageLoading = true;
    await _initUserAndPaths();
    _textSubscription?.cancel();
    _textSubscription = _realtimeService.streamData(_chatPath).listen((event) {
      _textMessages
        ..clear()
        ..addAll(_parseMessages(event.snapshot.value));
      _isMessageLoading = false;
      notifyListeners();
    });
  }

  Future<void> sendMessage(String text, {required bool isSender}) async {
    await _initUserAndPaths();

    final message = ChatMessage(
      text: text,
      isSender: isSender,
      timestamp: DateTime.now(),
      username: FirebaseAuth.instance.currentUser?.displayName ?? '',
      userId: _userId ?? '',
    );

    _textMessages.add(message);
    notifyListeners();
    await _realtimeService.addData(_chatPath, message.toJson());

    if (isSender) {
      _isTextLoading = true;
      _addLoadingMessage(_textMessages);
      notifyListeners();

      try {
        final reqBody =
            ChatModel(
              model: ApiBaseUrls.chatModel,
              messages:
                  _textMessages
                      .where((m) => m.text != ConstantsFile.loadingMark)
                      .map((m) => Messages(role: m.isSender ? 'user' : 'assistant', content: m.text))
                      .toList(),
            ).toJson();

        final response = await _api.postApiData(ApiBaseUrls.singleChat, reqBody);
        final content = ChatResponseModel.fromJson(response).choices.first.message.content;

        _replaceLoadingOrAdd(_textMessages, content);
        await _realtimeService.addData(_chatPath, _textMessages.last.toJson());
      } catch (e) {
        _replaceLoadingOrAdd(_textMessages, "Error: $e");
      } finally {
        _isTextLoading = false;
        notifyListeners();
      }
    }
  }

  // ───────────────────── Common Utilities ───────────────────── //

  Future<void> _initUserAndPaths() async {
    _userId = FirebaseAuth.instance.currentUser?.uid;
    if (_userId != null) {
      final users = await _firestoreService.fetchData('users');
      final user = users.firstWhere((u) => u['userId'] == _userId, orElse: () => {});
      currentUser = user['name'] ?? '';
      SharedPreference().setStringPref(ConstantsFile.sharedPrefName, currentUser);
      _chatPath = "chat_$_userId";

    }
  }

  List<ChatMessage> _parseMessages(dynamic data) {
    if (data is Map) {
      return data.entries.map((e) => ChatMessage.fromJson(Map<String, dynamic>.from(e.value))).toList()
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    }
    return [];
  }

  void _addLoadingMessage(List<ChatMessage> list) {
    list.add(
      ChatMessage(text: ConstantsFile.loadingMark, isSender: false, timestamp: DateTime.now(), username: 'assistant', userId: ''),
    );
  }

  void _replaceLoadingOrAdd(List<ChatMessage> list, String text) {
    final index = list.indexWhere((msg) => msg.text == ConstantsFile.loadingMark && !msg.isSender);
    final msg = ChatMessage(text: text, isSender: false, timestamp: DateTime.now(), username: 'assistant', userId: '');
    if (index != -1) {
      list[index] = msg;
    } else {
      list.add(msg);
    }
  }

  void clearAllMessages() {
    _textMessages.clear();

    notifyListeners();
  }

  @override
  void dispose() {
    _textSubscription?.cancel();
    _imageSubscription?.cancel();
    super.dispose();
  }
}
