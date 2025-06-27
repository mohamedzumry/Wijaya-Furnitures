// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_shop_wijaya/business_logic/login_page/bloc/login_page_bloc.dart';
import 'package:furniture_shop_wijaya/business_logic/main_dashboard/main_dashboard_bloc.dart';
import 'package:furniture_shop_wijaya/presentation/screens/customers_page/customers_page.dart';
import 'package:furniture_shop_wijaya/presentation/screens/items_page/items_page.dart';
import 'package:furniture_shop_wijaya/presentation/screens/receipts_page/receipts_page.dart';
import 'package:furniture_shop_wijaya/presentation/screens/sales_page/sales_page.dart';
import 'package:furniture_shop_wijaya/presentation/screens/supplier_page/supplier_page.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../routes/route_constants.dart';
import '../category_page/category_page.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();
  late List<SideMenuItem> items;
  bool isSignedIn = false;
  SideMenuDisplayMode sideMenuDisplayMode = SideMenuDisplayMode.open;
  late Icon sideMenuDisplayModeIcon = const Icon(Icons.arrow_back_ios_new);

  late MainDashboardBloc mainDashboardBloc;
  late LoginPageBloc loginPageBloc;

  @override
  void initState() {
    mainDashboardBloc = BlocProvider.of<MainDashboardBloc>(context);
    mainDashboardBloc.add(MainDashboardInitialFetchEvent(context: context));
    loginPageBloc = BlocProvider.of<LoginPageBloc>(context);
    sideMenu.addListener((index) {
      pageController.jumpToPage(index);
    });
    super.initState();
  }

  // void initSideMenuItems(){
  //   List<SideMenuItem> items = [
  //   SideMenuItem(
  //     title: 'Suppliers',
  //     onTap: (index, _) => sideMenu.changePage(0),
  //     icon: const Icon(Icons.person_add),
  //   ),
  //   SideMenuItem(
  //     title: 'Category',
  //     onTap: (index, _) => sideMenu.changePage(1),
  //     icon: const Icon(Icons.category),
  //   ),
  //   SideMenuItem(
  //     title: 'Items',
  //     onTap: (index, _) => sideMenu.changePage(2),
  //     icon: const Icon(Icons.inventory),
  //   ),
  //   SideMenuItem(
  //     title: 'Sales',
  //     onTap: (index, _) => sideMenu.changePage(3),
  //     icon: const Icon(Icons.shopping_bag),
  //   ),
  //   SideMenuItem(
  //     title: 'Invoices',
  //     onTap: (index, _) => sideMenu.changePage(4),
  //     icon: const Icon(Icons.receipt),
  //   ),
  //   SideMenuItem(
  //     title: 'Customers',
  //     onTap: (index, _) => sideMenu.changePage(5),
  //     icon: const Icon(Icons.settings),
  //   ),
  // ];
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: BlocConsumer<MainDashboardBloc, MainDashboardState>(
        bloc: mainDashboardBloc,
        listenWhen: (previous, current) => current is MainDashboardActionState,
        buildWhen: (previous, current) => current is! MainDashboardActionState,
        listener: (context, state) {
          if (state is MainDashboardLogoutSuccessState) {
            GoRouter.of(context).goNamed(WFRouteConstants.loginPage);
          }
        },
        builder: (context, state) {
          switch (state.runtimeType) {
            case const (MainDashboardLoadingState):
              return Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                    color: Colors.red, size: 50),
              );
            case const (MainDashboardInitialFetchSuccessState):
              final MainDashboardInitialFetchSuccessState successState =
                  state as MainDashboardInitialFetchSuccessState;
              return Center(
                child: Row(
                  children: [
                    SideMenu(
                      controller: sideMenu,
                      title: const Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 80),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image(
                                image: AssetImage('assets/images/wf-logo2.png'),
                                width: 60,
                                height: 60,
                              ),
                              SizedBox(height: 10),
                              Text('Wijaya Furniture',
                                  style: TextStyle(
                                      color: Color(0xFF1EA7DD),
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
                              Text('Since 1971',
                                  style: TextStyle(
                                      color: Color(0xFF1EA7DD),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal)),
                            ]),
                      ),
                      footer: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 10, left: 10, right: 10),
                        child: SizedBox(
                          width: double.maxFinite,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              mainDashboardBloc.add(MainDashboardLogoutEvent());
                            },
                            label: const Text("Logout"),
                            icon: const Icon(Icons.logout),
                            // icon: sideMenuDisplayModeIcon,
                          ),
                        ),
                      ),
                      items: [
                        SideMenuItem(
                          title: 'Suppliers',
                          onTap: (index, _) => sideMenu.changePage(0),
                          icon: const Icon(Icons.person_add),
                        ),
                        SideMenuItem(
                          title: 'Category',
                          onTap: (index, _) => sideMenu.changePage(1),
                          icon: const Icon(Icons.category),
                        ),
                        SideMenuItem(
                          title: 'Items',
                          onTap: (index, _) => sideMenu.changePage(2),
                          icon: const Icon(Icons.inventory),
                        ),
                        SideMenuItem(
                          title: 'Sales',
                          onTap: (index, _) => sideMenu.changePage(3),
                          icon: const Icon(Icons.shopping_bag),
                        ),
                        SideMenuItem(
                          title: 'Invoices',
                          onTap: (index, _) => sideMenu.changePage(4),
                          icon: const Icon(Icons.receipt),
                        ),
                        SideMenuItem(
                          title: 'Customers',
                          onTap: (index, _) => sideMenu.changePage(5),
                          icon: const Icon(Icons.settings),
                        ),
                      ],
                      style: SideMenuStyle(
                        displayMode: sideMenuDisplayMode,
                        openSideMenuWidth:
                            MediaQuery.of(context).size.width * 0.17,
                        // openSideMenuWidth: 300,
                        compactSideMenuWidth: 50,
                        hoverColor: Colors.amber,
                        selectedColor: const Color(0xFF1EA7DD),
                        selectedIconColor: Colors.white,
                        unselectedIconColor:
                            const Color.fromRGBO(151, 151, 151, 1),
                        backgroundColor: Colors.white,
                        selectedTitleTextStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        unselectedTitleTextStyle: const TextStyle(
                            color: Color.fromRGBO(151, 151, 151, 1),
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                        iconSize: 24,
                      ),
                    ),
                    Expanded(
                      child: PageView(
                        controller: pageController,
                        children: [
                          const Center(
                            child: SupplierPage(),
                          ),
                          const Center(
                            child: CategoryPage(),
                          ),
                          // const Center(
                          //   child: ItemsPage(),
                          // ),
                          Center(
                            child: ItemsPage(
                              itemListStream: successState.itemList,
                              categoryListStream: successState.categoryList,
                              supplierListStream: successState.supplierList,
                            ),
                          ),
                          Center(
                            child: SalesPage(
                              itemListStream: successState.itemList,
                              customerListStream: successState.customersList,
                            ),
                          ),
                          const Center(
                            child: ReceiptsPage(),
                          ),
                          Center(
                            child: CustomersPage(
                              customersStream: successState.customersList,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            default:
              return const Center(
                child: Text("Sorry, some error occurred!!!"),
              );
          }
        },
      ),
    );
    // }
  }
}
