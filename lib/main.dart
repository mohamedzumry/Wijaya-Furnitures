import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:furniture_shop_wijaya/business_logic/customer_page/customer_page_bloc.dart';
import 'package:furniture_shop_wijaya/business_logic/main_dashboard/main_dashboard_bloc.dart';
import 'package:furniture_shop_wijaya/business_logic/receipts_page/receipts_page_bloc.dart';
import 'package:furniture_shop_wijaya/business_logic/sales_page/sales_page_bloc.dart';
import 'package:furniture_shop_wijaya/routes/app_route_config.dart';
import 'package:url_strategy/url_strategy.dart';
import 'business_logic/login_page/bloc/login_page_bloc.dart';
import 'business_logic/search/bloc/search_bloc_bloc.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_shop_wijaya/business_logic/category_page/bloc/category_page_bloc.dart';
import 'package:furniture_shop_wijaya/business_logic/supplier_page/bloc/supplier_page_bloc.dart';
import 'business_logic/item_page/bloc/item_page_bloc_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Handle errors...
  registerErrorHandlers();
  // turn off the # in the URLs on the web
  setPathUrlStrategy();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SupplierPageBloc(),
        ),
        BlocProvider(
          create: (context) => CategoryPageBloc(),
        ),
        BlocProvider(
          create: (context) => ItemPageBlocBloc(),
        ),
        BlocProvider(
          create: (context) => SearchBlocBloc(),
        ),
        BlocProvider(
          create: (context) => LoginPageBloc(),
        ),
        BlocProvider(
          create: (context) => MainDashboardBloc(),
        ),
        BlocProvider(
          create: (context) => ReceiptsPageBloc(),
        ),
        BlocProvider(
          create: (context) => CustomerPageBloc(),
        ),
        BlocProvider(
          create: (context) => SalesPageBloc(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: WFRouter().router,
      title: 'Wijaya Furniture Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      // home: const LoginPage(),
    );
  }
}

void registerErrorHandlers() {
  // * Show some error UI if any uncaught exception happens
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint(details.toString());
  };
  // * Handle errors from the underlying platform/OS
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    debugPrint(error.toString());
    return true;
  };
  // * Show some error UI when any widget in the app fails to build
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('An error occurred'),
      ),
      body: Center(child: Text(details.toString())),
    );
  };
}
