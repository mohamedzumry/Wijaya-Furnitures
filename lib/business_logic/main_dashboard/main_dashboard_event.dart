part of 'main_dashboard_bloc.dart';

@immutable
sealed class MainDashboardEvent {}

class MainDashboardInitialFetchEvent extends MainDashboardEvent {
  final BuildContext context;

  MainDashboardInitialFetchEvent({required this.context});
}

class MainDashboardLogoutEvent extends MainDashboardEvent {}
