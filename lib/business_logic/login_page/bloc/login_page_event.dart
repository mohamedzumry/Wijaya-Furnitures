part of 'login_page_bloc.dart';

@immutable
sealed class LoginPageEvent {}

class LoginPageInitialEvent extends LoginPageEvent {}

class LoginPageLoginButtonClickedEvent extends LoginPageEvent {
  final String emailAddress;
  final String password;

  LoginPageLoginButtonClickedEvent(
      {required this.emailAddress, required this.password});
}

class LoginPageGoogleSignInButtonClickedEvent extends LoginPageEvent {}

class LoginPageForgotPasswordClickedEvent extends LoginPageEvent {}

class LoginPageForgotPasswordSubmitButtonClickedEvent extends LoginPageEvent {
  final String emailAddress;

  LoginPageForgotPasswordSubmitButtonClickedEvent({required this.emailAddress});
}

class LoginPageChangeStateToRegisterEvent extends LoginPageEvent {}

class LoginPageChangeStateToLoginEvent extends LoginPageEvent {}

class LoginPageRegisterButtonClickedEvent extends LoginPageEvent {
  final String emailAddress;
  final String password;

  LoginPageRegisterButtonClickedEvent({
    required this.emailAddress,
    required this.password,
  });
}
