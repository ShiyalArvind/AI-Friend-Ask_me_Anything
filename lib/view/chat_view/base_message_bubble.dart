import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../Common/custom_text.dart';
import '../../model/chat_message.dart';
import '../../utils/color_file.dart';
import '../../utils/constant_file.dart';
import '../../utils/responsive.dart';

class BaseMessageBubble extends StatelessWidget {
  const BaseMessageBubble({
    super.key,

    required this.currentElement,
    this.previousElement,
    this.nextElement,
    required this.isLoading,
    required this.messageContent,
    required this.loadingContent,
  });

  final ChatMessage? previousElement;
  final ChatMessage currentElement;
  final ChatMessage? nextElement;
  final bool isLoading;
  final Widget messageContent;
  final Widget loadingContent;

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    bool displayUserName = true;
    bool displayAvatar = true;

    if (currentElement.isSender) {
      displayUserName = false;
    } else if (nextElement == null ||
        DateUtils.dateOnly(currentElement.timestamp) != DateUtils.dateOnly(nextElement!.timestamp)) {
      displayUserName = true;
    } else if (!nextElement!.isSender) {
      displayUserName = false;
    }

    displayAvatar = displayUserName;
    final isLoadingReceiver = !currentElement.isSender && currentElement.text == ConstantsFile.loadingMark;

    return Row(
      mainAxisAlignment: currentElement.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (displayAvatar)
          Padding(
            padding: EdgeInsets.only(top: res.height(12.0), left: res.width(8.0)),
            child: CircleAvatar(
              radius: res.radius(16),
              backgroundColor: ColorFile.primaryColor,
              child: Icon(Icons.person, color: ColorFile.whiteColor, size: res.width(24)),
            ),
          ),
        if (!displayAvatar) SizedBox(width: res.width(40)),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: currentElement.isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (displayUserName)
              Padding(
                padding: EdgeInsets.only(left: res.width(10.0), top: res.height(10)),
                child: CustomText(
                  currentElement.username,
                  fontSize: ConstantsFile.mediumFontSize,
                  color: ColorFile.primaryColor,
                  fontFamily: ConstantsFile.mediumFont,
                ),
              ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.76,
              child: Align(
                alignment: currentElement.isSender ? Alignment.centerRight : Alignment.centerLeft,
                child: Card(
                  elevation: 4.0,
                  shadowColor: ColorFile.black45Material,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: const Radius.circular(18.0),
                      topRight: const Radius.circular(18.0),
                      topLeft: Radius.circular(currentElement.isSender ? 18.0 : 0),
                      bottomRight: Radius.circular(currentElement.isSender ? 0 : 18.0),
                    ),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, isLoadingReceiver ? 20.0 : 24.0),
                        child: isLoadingReceiver ? loadingContent : messageContent,
                      ),
                      if (!isLoadingReceiver)
                        Positioned(
                          bottom: 4,
                          right: 8,
                          child: Text(
                            DateFormat.Hm().format(currentElement.timestamp),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
