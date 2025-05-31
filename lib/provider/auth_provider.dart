import 'package:flutter/material.dart';



import '../model/register_user_model.dart';
import '../services/auth_service.dart';
import '../services/firebase_services.dart';
import '../services/shared_pref.dart';
import '../utils/constant_file.dart';

class AuthProvider extends ChangeNotifier {
  // Loading state
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Text controllers
  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final FirestoreService firestoreService = FirestoreService();

  RegisterUserModel _registerUser = const RegisterUserModel();

  RegisterUserModel get registerUser => _registerUser;

  void _syncControllersToModel() {
    _registerUser = RegisterUserModel(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      mobile: mobileController.text.trim(),
      password: passwordController.text,
    );
  }

  Future<String?> login() async {
    final email = loginEmailController.text.trim();
    final password = loginPasswordController.text;

    if (!loginValidation()) return "Validation failed";
    _setLoading(true);
    try {
      await AuthService().signIn(email, password);
      await SharedPreference().setBooleanPref(SharedPreference.stayLoggedIn, true);
      disposeControllers();
      return null;
    } catch (e) {
      return e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> register() async {
    _syncControllersToModel();
    if (!registerValidation()) return "Validation failed";

    _setLoading(true);
    try {
      await AuthService().signUp(_registerUser.email!, _registerUser.password!);

      await firestoreService.createData(ConstantsFile.firebaseUserCollection, _registerUser.toJson());
      await SharedPreference().setBooleanPref(SharedPreference.stayLoggedIn, true);
      disposeControllers();
      return null;
    } catch (e) {
      return e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    await AuthService().signOut();
  }


  void disposeControllers() {
    nameController.clear();
    emailController.clear();
    mobileController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    loginEmailController.clear();
    loginPasswordController.clear();
  }

  // ✅ VALIDATION FUNCTION
  // Error messages
  final Map<String, String> _errors = {
    ConstantsFile.paramName: '',
    ConstantsFile.paramEmail: '',
    ConstantsFile.paramMobile: '',
    ConstantsFile.paramPassword: '',
    ConstantsFile.paramConfirmPassword: '',
    ConstantsFile.paramLoginEmail: '',
    ConstantsFile.paramLoginPassword: '',
  };

  String getError(String key) => _errors[key] ?? '';

  String get nameError => getError(ConstantsFile.paramName);

  String get emailError => getError(ConstantsFile.paramEmail);

  String get mobileError => getError(ConstantsFile.paramMobile);

  String get passwordError => getError(ConstantsFile.paramPassword);

  String get confirmPasswordError => getError(ConstantsFile.paramConfirmPassword);

  String get loginEmailError => getError(ConstantsFile.paramLoginEmail);

  String get loginPasswordError => getError(ConstantsFile.paramLoginPassword);
  final RegExp _emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
  bool _isEmailValid(String email) => _emailRegex.hasMatch(email);
  bool _isPasswordValid(String password) => password.length >= 6;


  bool registerValidation() {
    _errors[ ConstantsFile.paramName] = '';
    _errors[ ConstantsFile.paramEmail] = '';
    _errors[ ConstantsFile.paramMobile] = '';
    _errors[ ConstantsFile.paramPassword] = '';
    _errors[ ConstantsFile.paramConfirmPassword] = '';

    var name = nameController.text.trim();
    var email = emailController.text.trim();
    var mobile = mobileController.text.trim();
    var password = passwordController.text;
    var confirmPassword = confirmPasswordController.text;

    bool isValid = true;

    if (name.isEmpty) {
      _errors[ConstantsFile.paramName] = "Please enter name";
      isValid = false;
    }
    if (email.isEmpty) {
      _errors[ConstantsFile.paramEmail] = "Please enter email";
      isValid = false;
    } else if (!_isEmailValid(email)) {
      _errors[ConstantsFile.paramEmail] = "Please enter a valid email";
      isValid = false;
    }

    if (mobile.isEmpty) {
      _errors[ConstantsFile.paramMobile] = "Please enter mobile number";
      isValid = false;
    }
     if (password.isEmpty) {
      _errors[ ConstantsFile.paramPassword] = "Please enter password";
      isValid = false;
    } else if (!_isPasswordValid(password)) {
      _errors[ ConstantsFile.paramPassword] = "Password must be at least 6 characters";
      isValid = false;
    }
    if (confirmPassword.isEmpty) {
      _errors[ ConstantsFile.paramConfirmPassword] = "Please enter confirm password";
      isValid = false;
    } else if (password != confirmPassword) {
      _errors[ ConstantsFile.paramConfirmPassword] = "Passwords do not match";
      isValid = false;
    }

    notifyListeners();
    return isValid;
  }

  bool loginValidation() {
    final email = loginEmailController.text.trim();
    final password = loginPasswordController.text;
    _errors[ConstantsFile.paramLoginEmail] = '';
    _errors[ConstantsFile.paramLoginPassword] = '';
    bool isValid = true;



    if (email.isEmpty) {
      _errors[ConstantsFile.paramLoginEmail] = "Please enter email";
      isValid = false;
    } else if (!_isEmailValid(email)) {
      _errors[ConstantsFile.paramLoginEmail] = "Please enter a valid email";
      isValid = false;
    }

    if (password.isEmpty) {
      _errors[ ConstantsFile.paramLoginPassword] = "Please enter password";
      isValid = false;
    } else if (!_isPasswordValid(password)) {
      _errors[ ConstantsFile.paramLoginPassword] = "Password must be at least 6 characters";
      isValid = false;
    }

    notifyListeners();
    return isValid;
  }

  void clearError(String val, String key) {
    if (val.trim().isNotEmpty && (_errors[key]?.isNotEmpty ?? false)) {
      _errors[key] = '';
      notifyListeners();
    }
  }

  void clearLoginEmailError(String val) => clearError(val, ConstantsFile.paramLoginEmail);

  void clearLoginPasswordError(String val) => clearError(val, ConstantsFile.paramLoginPassword);

  void clearNameError(String val) => clearError(val, ConstantsFile.paramName);

  void clearEmailError(String val) => clearError(val, ConstantsFile.paramEmail);

  void clearMobileError(String val) => clearError(val, ConstantsFile.paramMobile);

  void clearPasswordError(String val) => clearError(val, ConstantsFile.paramPassword);

  void clearConfirmPasswordError(String val) => clearError(val, ConstantsFile.paramConfirmPassword);
}
