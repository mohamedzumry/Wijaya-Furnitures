import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:furniture_shop_wijaya/data/models/user/registration_result.dart';
import 'package:furniture_shop_wijaya/data/repository/auth_repository/auth_repository.dart';

part 'login_page_event.dart';
part 'login_page_state.dart';

class LoginPageBloc extends Bloc<LoginPageEvent, LoginPageState> {
  bool isLogged = false;
  AuthRepository authRepository = AuthRepository();

  LoginPageBloc() : super(LoginPageInitial()) {
    on<LoginPageInitialEvent>(loginPageInitialEvent);
    on<LoginPageLoginButtonClickedEvent>(loginPageLoginButtonClickedEvent);
    on<LoginPageGoogleSignInButtonClickedEvent>(
        loginPageGoogleSignInButtonClickedEvent);
    on<LoginPageForgotPasswordClickedEvent>(
        loginPageForgotPasswordClickedEvent);
    on<LoginPageForgotPasswordSubmitButtonClickedEvent>(
        loginPageForgotPasswordSubmitButtonClickedEvent);
    on<LoginPageChangeStateToRegisterEvent>(
        loginPageChangeStateToRegisterEvent);
    on<LoginPageChangeStateToLoginEvent>(loginPageChangeStateToLoginEvent);
    on<LoginPageRegisterButtonClickedEvent>(
        loginPageRegisterButtonClickedEvent);
  }

  FutureOr<void> loginPageInitialEvent(
      LoginPageInitialEvent event, Emitter<LoginPageState> emit) {
    if (FirebaseAuth.instance.currentUser != null) {
      emit(LoginPageLoginSucessActionState());
    } else {
      emit(LoginPageLoadingSucessState());
    }
  }

  FutureOr<void> loginPageLoginButtonClickedEvent(
      LoginPageLoginButtonClickedEvent event,
      Emitter<LoginPageState> emit) async {
    emit(LoginPendingState());
    if (isLogged == false) {
      bool val = await authRepository.authenticateUsers(
          event.emailAddress, event.password);

      if (val == true) {
        isLogged == true;
        emit(LoginPageLoginSucessActionState());
      } else {
        emit(LoginPageLoginFailedActionState());
      }
    } else {
      emit(LoginPageLoginSucessActionState());
    }
  }

  Future<FutureOr<void>> loginPageGoogleSignInButtonClickedEvent(
      LoginPageGoogleSignInButtonClickedEvent event,
      Emitter<LoginPageState> emit) async {
    final res = await authRepository.handleGoogleSignIn();

    if (res.user!.email != null) {
      emit(LoginPageLoginSucessActionState());
    } else {
      emit(LoginPageLoginFailedActionState());
    }
  }

  FutureOr<void> loginPageForgotPasswordClickedEvent(
      LoginPageForgotPasswordClickedEvent event, Emitter<LoginPageState> emit) {
    emit(LoginPageForgotPasswordActionState());
  }

  Future<FutureOr<void>> loginPageForgotPasswordSubmitButtonClickedEvent(
      LoginPageForgotPasswordSubmitButtonClickedEvent event,
      Emitter<LoginPageState> emit) async {
    final result =
        await authRepository.sendPasswordResetEmail(event.emailAddress);
    if (result.status == RegistrationStatus.success) {
      emit(LoginPageForgotPasswordEmailSentActionState());
    } else {
      emit(LoginPageForgotPasswordEmailSendFailedActionState());
    }
  }

  FutureOr<void> loginPageChangeStateToRegisterEvent(
      LoginPageChangeStateToRegisterEvent event, Emitter<LoginPageState> emit) {
    emit(LoginPageRegisterState());
  }

  FutureOr<void> loginPageChangeStateToLoginEvent(
      LoginPageChangeStateToLoginEvent event, Emitter<LoginPageState> emit) {
    emit(LoginPageLoadingSucessState());
  }

  Future<FutureOr<void>> loginPageRegisterButtonClickedEvent(
      LoginPageRegisterButtonClickedEvent event,
      Emitter<LoginPageState> emit) async {
    final RegistrationResult result =
        await authRepository.registerUser(event.emailAddress, event.password);
    if (result.status == RegistrationStatus.success) {
      emit(LoginPageRegisterSucessActionState());
      emit(LoginPageLoginSucessActionState());
    } else {
      emit(LoginPageRegisterFailedActionState(
        registrationResult: result.errorMessage!,
      ));
    }
  }
}
