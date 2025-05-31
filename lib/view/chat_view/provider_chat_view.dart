
import 'package:flutter/material.dart';
import 'package:friend/provider/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../auth/login_page.dart';
import '../../model/chat_message.dart';
import '../../provider/chat_provider.dart';
import '../../utils/color_file.dart';
import '../../utils/responsive.dart';

import 'chat_time_line.dart';
import 'message_bar.dart';

class GenericChatView extends StatefulWidget {
  const GenericChatView({super.key, required this.fetchMessages, required this.getMessages, required this.footerBuilder});

  final Future<void> Function(BuildContext) fetchMessages;
  final List<ChatMessage> Function(ChatProvider) getMessages;
  final Widget Function(BuildContext, ChatProvider) footerBuilder;

  @override
  State<GenericChatView> createState() => _GenericChatViewState();
}

class _GenericChatViewState extends State<GenericChatView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController textController = TextEditingController();
  final Duration _scrollDelay = const Duration(seconds: 1);

  void _removeInputTextFocus() => FocusScope.of(context).unfocus();

  Future<bool> _onPageTopScrollFunction() async {
    await Future.delayed(_scrollDelay);
    return true;
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(0.0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ensures it runs every time the widget is inserted in the tree
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.fetchMessages(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: ChatTheme.chatBackgroundDecoration,
        child: ResponsiveBuilder(
          builder: (context, res) {
            return Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _removeInputTextFocus,
                    child: Consumer<ChatProvider>(
                      builder: (context, chatProvider, _) {
                        final messages = widget.getMessages(chatProvider);
                        final isFetched = chatProvider.isLoading;
                        if (isFetched) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (messages.isEmpty) {
                          return const Center(child: Text("No messages yet.", style: TextStyle(fontSize: 16)));
                        }

                        return ChatTimeline(
                          messages: messages,
                          localUserTheme: ChatTheme.localUserTheme(context),
                          remoteUserTheme: ChatTheme.remoteUserTheme(context),
                          onPageTopScrollFunction: _onPageTopScrollFunction,
                          scrollController: _scrollController,
                        );
                      },
                    ),
                  ),
                ),
                Consumer<ChatProvider>(
                  builder: (context, chatProvider, _) {
                    return MessageBar(
                      footerWidget: widget.footerBuilder(context, chatProvider),
                      onSend: (text) {
                        if (text.trim().isEmpty) return;
                        final provider = context.read<ChatProvider>();

                        provider.sendMessage(text, isSender: true);

                        Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
                        textController.clear();
                      },
                      actions: [
                        InkWell(child: Icon(Icons.add, color: ColorFile.blackColor, size: res.width(24)), onTap: () {}),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: res.width(8)),
                          child: InkWell(
                            child: Icon(Icons.camera_alt, color: ColorFile.greenColor, size: res.width(24)),
                            onTap: () {},
                          ),
                        ),
                      ],
                      textController: textController,
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ProviderChatView extends StatelessWidget {
  const ProviderChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Chat"),
          centerTitle: true,
          backgroundColor: ColorFile.primaryColor,
          actions: [
            IconButton(
              onPressed: () {
                context.read<AuthProvider>().signOut();

                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
              },
              icon: const Icon(Icons.logout_sharp),
            ),
          ],
        ),
        body: GenericChatView(
          fetchMessages: (ctx) => ctx.read<ChatProvider>().getAllMessages(),
          getMessages: (provider) => provider.getMessages(),
          footerBuilder: (_, __) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}
