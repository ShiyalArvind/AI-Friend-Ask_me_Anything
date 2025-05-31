
import 'package:flutter/material.dart';


import '../../model/chat_message.dart';
import '../../utils/color_file.dart';
import '../../utils/responsive.dart';
import '../loader/bouncing_pulse_loading.dart';

import 'base_message_bubble.dart';

class MessageBox extends StatelessWidget {
  const MessageBox({
    super.key,

    required this.previousElement,
    required this.currentElement,
    required this.nextElement,
    required this.isLoading,
  });

  final ChatMessage? previousElement;
  final ChatMessage currentElement;
  final ChatMessage? nextElement;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, res) {
        return BaseMessageBubble(
          currentElement: currentElement,
          previousElement: previousElement,
          nextElement: nextElement,
          isLoading: isLoading,
          messageContent:  Text(currentElement.text) ,
          loadingContent: BouncingPulseLoading(color: ColorFile.primaryColor, size: 20),
        );
      },
    );
  }
}
