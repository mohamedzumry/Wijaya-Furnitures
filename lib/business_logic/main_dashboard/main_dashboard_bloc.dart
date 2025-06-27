import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:furniture_shop_wijaya/data/models/category/category.dart';
import 'package:furniture_shop_wijaya/data/models/customer/customer.dart';
import 'package:furniture_shop_wijaya/data/models/supplier/supplier.dart';
import 'package:furniture_shop_wijaya/data/repository/main_dashboard/main_dashboard_repository.dart';

import '../../data/models/item/item.dart';
part 'main_dashboard_event.dart';
part 'main_dashboard_state.dart';

class MainDashboardBloc extends Bloc<MainDashboardEvent, MainDashboardState> {
  final MainDashboardRepository mainDashboardRepository =
      MainDashboardRepository();

  MainDashboardBloc() : super(MainDashboardInitial()) {
    on<MainDashboardInitialFetchEvent>(mainDashboardInitialFetchEvent);
    on<MainDashboardLogoutEvent>(mainDashboardLogoutEvent);
  }

  Future<FutureOr<void>> mainDashboardLogoutEvent(
      MainDashboardLogoutEvent event, Emitter<MainDashboardState> emit) async {
    await FirebaseAuth.instance.signOut();
    emit(MainDashboardLogoutSuccessState());
  }

  FutureOr<void> mainDashboardInitialFetchEvent(
      MainDashboardInitialFetchEvent event, Emitter<MainDashboardState> emit) {
    emit(MainDashboardLoadingState());
    emit(
      MainDashboardInitialFetchSuccessState(
        itemList: mainDashboardRepository.getAllItemsStream(),
        supplierList: mainDashboardRepository.getAllSuppliersStream(),
        categoryList: mainDashboardRepository.getAllCategoriesStream(),
        customersList: mainDashboardRepository.getAllCustomersStream(),
      ),
    );
  }
}
