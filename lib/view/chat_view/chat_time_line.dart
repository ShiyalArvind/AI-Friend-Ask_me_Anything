import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Common/message_group_listing.dart';

import '../../model/chat_message.dart';
import '../../provider/chat_provider.dart';

import 'message_box.dart';
import 'date_chip.dart';

class ChatTimeline extends StatefulWidget {
  const ChatTimeline({
    super.key,

    required this.messages,
    required this.localUserTheme,
    required this.remoteUserTheme,
    this.onPageTopScrollFunction,
    required this.scrollController, // New parameter
  });

  final List<ChatMessage> messages;
  final Future<bool> Function()? onPageTopScrollFunction;
  final ThemeData localUserTheme;
  final ThemeData remoteUserTheme;
  final ScrollController scrollController; // New parameter

  @override
  State<ChatTimeline> createState() => _ChatTimelineState();
}

class _ChatTimelineState extends State<ChatTimeline> {
  bool keepFetchingData = true;
  Completer<bool>? _scrollCompleter;

  @override
  void initState() {
    widget.scrollController.addListener(onUserScrolls);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      chatProvider.addListener(() {
        Future.delayed(Duration(milliseconds: 100), _scrollToBottom);
      });
    });
  }

  Future<void> onUserScrolls() async {
    if (!keepFetchingData || widget.onPageTopScrollFunction == null || !(_scrollCompleter?.isCompleted ?? true)) return;

    double screenSize = MediaQuery.of(context).size.height;
    double scrollLimit = widget.scrollController.position.maxScrollExtent;
    double missingScroll = scrollLimit - screenSize;
    double scrollLimitActivation = scrollLimit - missingScroll * 0.05;

    if (widget.scrollController.position.pixels < scrollLimitActivation) return;

    _scrollCompleter = Completer();
    keepFetchingData = await widget.onPageTopScrollFunction!();
    _scrollCompleter!.complete(keepFetchingData);
  }

  @override
  void dispose() {
    // Remove the listener to prevent memory leaks
    widget.scrollController.removeListener(onUserScrolls);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    int? lastUserMsgIndex;
    if (chatProvider.isTextLoading && widget.messages.isNotEmpty) {
      for (int i = widget.messages.length - 1; i >= 0; i--) {
        if (widget.messages[i].isSender) {
          lastUserMsgIndex = i;
          break;
        }
      }
    }
    return Scrollbar(
      controller: widget.scrollController,
      thumbVisibility: true,
      radius: const Radius.circular(15),
      child: MessageGroupListing<ChatMessage, DateTime>(
        controller: widget.scrollController,
        elements: widget.messages,
        order: GroupedListOrder.DESC,
        sort: true,
        reverse: true,
        floatingHeader: true,
        useStickyGroupSeparators: false,
        padding: const EdgeInsets.all(10),
        groupBy: (ChatMessage element) => DateTime(element.timestamp.year, element.timestamp.month, element.timestamp.day),
        groupHeaderBuilder: (element) => DateChip(date: element.timestamp),
        interdependentItemBuilder: (context, ChatMessage? previousElement, ChatMessage currentElement, ChatMessage? nextElement) {
          int idx = widget.messages.indexOf(currentElement);
          bool showLoader = chatProvider.isTextLoading && lastUserMsgIndex == idx && !currentElement.isSender;
          return Theme(
            data: currentElement.isSender ? widget.localUserTheme : widget.remoteUserTheme,

            child: MessageBox(
              previousElement: previousElement,
              currentElement: currentElement,
              nextElement: nextElement,
              isLoading: showLoader,
            ),
          );
        },
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.scrollController.hasClients) {
        widget.scrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }
}
