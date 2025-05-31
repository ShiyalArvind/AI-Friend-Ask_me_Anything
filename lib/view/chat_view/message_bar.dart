import 'package:flutter/material.dart';

import '../../utils/color_file.dart';
import '../../utils/responsive.dart';
import '../../utils/string_file.dart';

class MessageBar extends StatelessWidget {
  final bool replying;
  final String replyingTo;
  final List<Widget> actions;
  final TextEditingController textController ;
  final Color replyWidgetColor;
  final Color replyIconColor;
  final Color replyCloseColor;
  final Color messageBarColor;
  final String messageBarHintText;
  final TextStyle? messageBarHintStyle;
  final TextStyle textFieldTextStyle;
  final Color sendButtonColor;
  final void Function(String)? onTextChanged;
  final void Function(String)? onSend;
  final void Function()? onTapCloseReply;
  final Widget footerWidget;

  const MessageBar({
    super.key,
    this.replying = false,
    this.replyingTo = "",
    this.actions = const [],
    this.replyWidgetColor = ColorFile.lightBlueColor,
    this.replyIconColor = ColorFile.primaryColor,
    this.replyCloseColor = ColorFile.black12Material,
    this.messageBarColor = ColorFile.lightBlueColor,
    this.sendButtonColor = ColorFile.primaryColor,
    this.messageBarHintText = StringFile.typeYourMessageHere,
    this.messageBarHintStyle,
    this.textFieldTextStyle = const TextStyle(color: ColorFile.blackColor),
    this.onTextChanged,
    this.onSend,
    this.onTapCloseReply,
    this.footerWidget = const SizedBox(), required this.textController,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, res) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              footerWidget,
              replying
                  ? Container(
                    color: replyWidgetColor,
                    padding: EdgeInsets.symmetric(vertical: res.height(8), horizontal: res.width(16)),
                    child: Row(
                      children: [
                        Icon(Icons.reply, color: replyIconColor, size: res.width(24)),
                        Expanded(child: Text('Re : $replyingTo', overflow: TextOverflow.ellipsis)),
                        InkWell(onTap: onTapCloseReply, child: Icon(Icons.close, color: replyCloseColor, size: res.width(24))),
                      ],
                    ),
                  )
                  : Container(),
              replying ? Container(height: res.height(1), color: ColorFile.lightGrayMaterial) : Container(),
              Container(
                color: messageBarColor,
                padding: EdgeInsets.symmetric(vertical: res.height(8), horizontal: res.width(16)),
                child: Row(
                  children: <Widget>[
                    ...actions,
                    Expanded(
                      child: TextField(
                        controller: textController,
                        keyboardType: TextInputType.multiline,
                        textCapitalization: TextCapitalization.sentences,
                        minLines: 1,
                        maxLines: 3,
                        onChanged: onTextChanged,
                        style: textFieldTextStyle,
                        decoration: InputDecoration(
                          hintText: messageBarHintText,
                          hintMaxLines: 1,
                          contentPadding: EdgeInsets.symmetric(horizontal: res.width(8.0), vertical: res.height(10)),
                          hintStyle: messageBarHintStyle ?? TextStyle(fontSize: res.fontSize(16)),
                          fillColor: ColorFile.whiteColor,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(res.radius(30.0)),
                            borderSide: BorderSide(color: ColorFile.whiteColor, width: res.width(0.2)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(res.radius(30.0)),
                            borderSide: BorderSide(color: ColorFile.black26Material, width: res.width(0.2)),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: res.width(16)),
                      child: InkWell(
                        child: Icon(Icons.send, color: sendButtonColor, size: res.width(24)),
                        onTap: () {
                          if (textController.text.trim() != '') {
                            if (onSend != null) {
                              onSend!(textController.text.trim());
                            }
                            textController.text = '';
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
