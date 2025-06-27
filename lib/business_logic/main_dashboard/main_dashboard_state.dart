part of 'main_dashboard_bloc.dart';

@immutable
sealed class MainDashboardState {}

final class MainDashboardActionState extends MainDashboardState {}

final class MainDashboardInitial extends MainDashboardState {}

final class MainDashboardLoadingState extends MainDashboardState {}

final class MainDashboardInitialFetchErrorState extends MainDashboardState {}

final class MainDashboardInitialFetchSuccessState extends MainDashboardState {
  final Stream<List<Item>> itemList;
  final Stream<List<CategoryType>> categoryList;
  final Stream<List<Supplier>> supplierList;
  final Stream<List<CustomerType>> customersList;

  MainDashboardInitialFetchSuccessState({
    required this.itemList,
    required this.categoryList,
    required this.supplierList,
    required this.customersList,
  });
}

final class MainDashboardLogoutSuccessState extends MainDashboardActionState {}
