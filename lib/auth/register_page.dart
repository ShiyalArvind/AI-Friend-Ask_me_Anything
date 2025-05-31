
import 'package:flutter/material.dart';
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
import 'login_page.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ResponsiveBuilder(
        builder: (context, res) {
          return BackGround(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: res.width(20)),
              child: Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CustomText(
                            StringFile.register.toUpperCase(),
                            fontSize: ConstantsFile.titleFontSize,
                            color: ColorFile.primaryColor,
                            fontFamily: ConstantsFile.boldFont,
                          ),
                        ),
                        SizedBox(height: res.height(10)),

                       CustomTextField(
                            StringFile.name,
                            authProvider.nameController,
                            title: StringFile.name,
                            externalErrorText: authProvider.nameError,
                            onChange: authProvider.clearNameError),

                        SizedBox(height: res.height(10)),

                       CustomTextField(
                            StringFile.mobileNumber,
                            authProvider.mobileController,
                            title: StringFile.mobileNumber,
                            externalErrorText: authProvider.mobileError,
                            onChange:authProvider.clearMobileError
                          ),

                        SizedBox(height: res.height(10)),

                      CustomTextField(
                            StringFile.email,
                            authProvider.emailController,
                            title: StringFile.email,
                            externalErrorText: authProvider.emailError,
                            onChange: authProvider.clearEmailError
                          ),

                        SizedBox(height: res.height(10)),
                   CustomTextField(
                            StringFile.password,
                            authProvider.passwordController,
                            title: StringFile.password,
                            obscureText: true,
                            externalErrorText: authProvider.passwordError,
                            onChange: authProvider.clearPasswordError
                          ),

                        SizedBox(height: res.height(10)),
                    CustomTextField(
                            StringFile.confirmPassword,
                            authProvider.confirmPasswordController,
                            title: StringFile.confirmPassword,
                            obscureText: true,
                            externalErrorText: authProvider.confirmPasswordError,
                            onChange:authProvider.clearConfirmPasswordError
                          ),


                        SizedBox(height: res.height(50)),
                        CustomButton(
                          text: StringFile.register,
                          onPressed: authProvider.isLoading ? () {} : () => _signUp(context, authProvider),
                          style: ButtonStyleType.gradient,
                          gradient: ColorFile.vibrantOrangeGradient,
                          isLoading: authProvider.isLoading,
                        ),

                        SizedBox(height: res.height(20)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              StringFile.alreadyHaveAccount,
                              fontSize: ConstantsFile.regularFontSize,
                              color: ColorFile.blackColor,
                              fontFamily: ConstantsFile.regularFont,
                            ),
                            SizedBox(width: res.width(10)),
                            GestureDetector(
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage())),
                              child: CustomText(
                                StringFile.signIn,
                                fontSize: ConstantsFile.regularFontSize,
                                color: ColorFile.primaryColor,
                                fontFamily: ConstantsFile.boldFont,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _signUp(BuildContext context, AuthProvider authProvider) async {
    final errorMessage = await authProvider.register();

    if (errorMessage == null) {
      if (!context.mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProviderChatView()));

    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }
}
