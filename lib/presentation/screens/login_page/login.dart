import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_shop_wijaya/business_logic/login_page/bloc/login_page_bloc.dart';
import 'package:furniture_shop_wijaya/routes/route_constants.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// ignore: prefer_typing_uninitialized_variables

class _LoginPageState extends State<LoginPage> {
  late LoginPageBloc loginPageBloc;

  @override
  void initState() {
    loginPageBloc = BlocProvider.of<LoginPageBloc>(context);
    loginPageBloc.add(LoginPageInitialEvent());
    super.initState();
  }

  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordResetFormKey = GlobalKey<FormState>();

  int _submitForm() {
    if (_formKey.currentState!.validate()) {
      return 1;
    } else {
      return 0;
    }
  }

  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Prevent dialog from being dismissed by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error Message'),
          content: const Text('Your Credentials are Wrong. Try again!!'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                loginPageBloc.add((LoginPageInitialEvent()));
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showForgotPasswordDialog() async {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.grey,
      builder: (BuildContext context) {
        TextEditingController emailController = TextEditingController();
        return AlertDialog(
          title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Text(
              'Forgot Password Form',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          content: Form(
            key: _passwordResetFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_passwordResetFormKey.currentState!.validate()) {
                      final email = emailController.text.trim();
                      loginPageBloc.add(
                        LoginPageForgotPasswordSubmitButtonClickedEvent(
                          emailAddress: email,
                        ),
                      );
                    }
                  },
                  child: const Text('Send Password Reset Email'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginPageBloc, LoginPageState>(
        bloc: loginPageBloc,
        listenWhen: (previous, current) => current is LoginPageActionState,
        buildWhen: (previous, current) => current is! LoginPageActionState,
        listener: (context, state) {
          if (state is LoginPageLoginSucessActionState) {
            context.goNamed(WFRouteConstants.mainDashboard);
          } else if (state is LoginPageLoginFailedActionState) {
            _showConfirmationDialog();
          } else if (state is LoginPageForgotPasswordActionState) {
            _showForgotPasswordDialog();
          } else if (state is LoginPageForgotPasswordEmailSentActionState) {
            context.pop();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Password reset email sent'),
            ));
          } else if (state
              is LoginPageForgotPasswordEmailSendFailedActionState) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Error sending password reset email !!!'),
            ));
          } else if (state is LoginPageRegisterSucessActionState) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Registration Success'),
            ));
          } else if (state is LoginPageRegisterFailedActionState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                state.registrationResult,
                style: const TextStyle(color: Colors.white),
              ),
            ));
          }
        },
        builder: (context, state) {
          if (state is LoginPendingState) {
            return Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                    color: Colors.blue, size: 100));
          } else if (state is LoginPageLoadingSucessState ||
              state is LoginPageRegisterState) {
            final isLoginState =
                state is LoginPageLoadingSucessState ? true : false;
            final title = isLoginState ? 'Login' : 'Register';
            return Center(
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/background.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      height: 500,
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: Container(
                            color: Colors.white.withOpacity(0.5),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 20,
                                right: 20,
                                top: 30,
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      // width: MediaQuery.of(context).size.width *
                                      //     0.70093,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0, top: 0),
                                        child: TextFormField(
                                          controller: emailController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Email is required!!!';
                                            } else {
                                              return null;
                                            }
                                          },
                                          decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'Ex: email@gmail.com',
                                              hintStyle: TextStyle(
                                                  color: Colors.black38,
                                                  fontSize: 12)),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      // width: MediaQuery.of(context).size.width *
                                      //     0.70093,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0, top: 0),
                                        child: TextFormField(
                                          controller: passwordController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Password is required!!!';
                                            } else {
                                              return null;
                                            }
                                          },
                                          obscureText: true,
                                          decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'Enter your password',
                                              hintStyle: TextStyle(
                                                  color: Colors.black38,
                                                  fontSize: 12)),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          minimumSize: Size(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.70093,
                                              60),
                                          backgroundColor:
                                              const Color(0xFF1EA7DD),
                                          foregroundColor: Colors.white),
                                      onPressed: () async {
                                        if (_submitForm() == 1) {
                                          if (isLoginState) {
                                            loginPageBloc.add(
                                              LoginPageLoginButtonClickedEvent(
                                                emailAddress:
                                                    emailController.text,
                                                password:
                                                    passwordController.text,
                                              ),
                                            );
                                          } else {
                                            loginPageBloc.add(
                                              LoginPageRegisterButtonClickedEvent(
                                                emailAddress:
                                                    emailController.text,
                                                password:
                                                    passwordController.text,
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      child: Center(
                                        child: Text(
                                          title,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    const Text(
                                      '- - - Or - - -',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 15),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        minimumSize: Size(
                                            MediaQuery.of(context).size.width *
                                                0.70093,
                                            60),
                                        backgroundColor: Colors.white,
                                      ),
                                      onPressed: () {
                                        loginPageBloc.add(
                                            LoginPageGoogleSignInButtonClickedEvent());
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(left: 10.0),
                                            child: Text(
                                              'Login with Google',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Container(
                                            height: 22,
                                            width: 22,
                                            decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/google_logo.png'),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            isLoginState
                                                ? loginPageBloc.add(
                                                    LoginPageChangeStateToRegisterEvent())
                                                : loginPageBloc.add(
                                                    LoginPageChangeStateToLoginEvent());
                                          },
                                          child: MouseRegion(
                                            cursor: SystemMouseCursors.click,
                                            child: Text(
                                              isLoginState
                                                  ? "Don't have an account? Register"
                                                  : "Already have an account? Login",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 11),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            loginPageBloc.add(
                                                LoginPageForgotPasswordClickedEvent());
                                          },
                                          child: const MouseRegion(
                                            cursor: SystemMouseCursors.click,
                                            child: Text(
                                              'Forgot your password?',
                                              style: TextStyle(
                                                  // color: Color(0xFF1EA7DD),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 11),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
