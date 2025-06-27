part of 'login_page_bloc.dart';

@immutable
sealed class LoginPageState {}

class LoginPageActionState extends LoginPageState {}

final class LoginPageInitial extends LoginPageState {}

class LoginPageLoadingSucessState extends LoginPageState {}

class LoginPendingState extends LoginPageState {}

class LoginPageLoginSucessActionState extends LoginPageActionState {}

class LoginPageLoginFailedActionState extends LoginPageActionState {}

class LoginPageForgotPasswordActionState extends LoginPageActionState {}

class LoginPageForgotPasswordEmailSentActionState
    extends LoginPageActionState {}

class LoginPageForgotPasswordEmailSendFailedActionState
    extends LoginPageActionState {}

class LoginPageRegisterState extends LoginPageState {}

class LoginPageRegisterSucessActionState extends LoginPageActionState {}

class LoginPageRegisterFailedActionState extends LoginPageActionState {
  final String registrationResult;

  LoginPageRegisterFailedActionState({required this.registrationResult});
}
