import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_shop_wijaya/business_logic/category_page/bloc/category_page_bloc.dart';
import 'package:furniture_shop_wijaya/data/models/category/category.dart';

// ignore: must_be_immutable
class CategoryPageTile extends StatelessWidget {
  final CategoryType categoryType;
  late CategoryPageBloc categoryPageBloc;
  CategoryPageTile({super.key, required this.categoryType});

  @override
  Widget build(BuildContext context) {
    categoryPageBloc = BlocProvider.of<CategoryPageBloc>(context);
    return GestureDetector(
      onTap: () {
        categoryPageBloc
            .add(CategoryPageTileClickedEvent(categoryType: categoryType));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            width: 500,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/menu.png'))),
                      ),
                      const SizedBox(width: 15),
                      SizedBox(
                        width: 150,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Category Name',
                                style: TextStyle(
                                    color: Color.fromRGBO(151, 151, 151, 1),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold)),
                            Text(categoryType.categoryName,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                          ],
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
    );
  }
}
