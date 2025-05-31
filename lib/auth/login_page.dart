
import 'package:flutter/material.dart';
import 'package:friend/auth/register_page.dart';
import 'package:provider/provider.dart';


import '../Common/custom_button.dart';
import '../Common/custom_text.dart';
import '../Common/custom_textfield.dart';
import '../provider/auth_provider.dart';
import '../utils/color_file.dart';
import '../utils/constant_file.dart';
import '../utils/responsive.dart';

import '../utils/string_file.dart';
import '../view/chat_view/provider_chat_view.dart';

import 'auth_background.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, res) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: BackGround(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: res.width(20)),
              child: Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: CustomText(
                          StringFile.login.toUpperCase(),
                          fontSize: ConstantsFile.titleFontSize,
                          color: ColorFile.blackColor,
                          fontFamily: ConstantsFile.boldFont,
                        ),
                      ),

                      SizedBox(height: res.height(20)),
                      CustomTextField(
                        StringFile.email,
                        authProvider.loginEmailController,
                        title: StringFile.email,
                        externalErrorText: authProvider.loginEmailError,
                        onChange: authProvider.clearLoginEmailError,
                      ),

                      SizedBox(height: res.height(20)),
                      CustomTextField(
                        StringFile.password,
                        authProvider.loginPasswordController,
                        title: StringFile.password,
                        obscureText: true,
                        externalErrorText: authProvider.loginPasswordError,
                        onChange: authProvider.clearLoginPasswordError,
                      ),

                      SizedBox(height: res.height(20)),
                      Container(
                        alignment: Alignment.centerRight,
                        child: CustomText(
                          StringFile.forgetPassword,
                          fontSize: ConstantsFile.regularFontSize,
                          color: ColorFile.primaryColor,
                          fontFamily: ConstantsFile.boldFont,
                        ),
                      ),
                      SizedBox(height: res.height(50)),
                      CustomButton(
                        text: StringFile.login,
                        onPressed: authProvider.isLoading ? () {} : () => _login(context, authProvider),
                        style: ButtonStyleType.gradient,
                        gradient: ColorFile.vibrantOrangeGradient,
                        textColor: ColorFile.whiteColor,
                        isLoading: authProvider.isLoading,
                      ),

                      SizedBox(height: res.height(20)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            StringFile.doNotHaveAccount,
                            fontSize: ConstantsFile.regularFontSize,
                            color: ColorFile.blackColor,
                            fontFamily: ConstantsFile.regularFont,
                          ),
                          SizedBox(width: res.width(10)),
                          GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterPage())),
                            child: CustomText(
                              StringFile.signUp,
                              fontSize: ConstantsFile.regularFontSize,
                              color: ColorFile.primaryColor,
                              fontFamily: ConstantsFile.boldFont,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _login(BuildContext context, AuthProvider loginProvider) async {
    final errorMessage = await loginProvider.login();
    if (errorMessage == null) {
      if (!context.mounted) return;
      // Navigate to home or dashboard

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProviderChatView()));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login successful")));

    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
    // loginProvider.disposeControllers();
  }
}
