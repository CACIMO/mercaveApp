import 'package:flutter/material.dart';
import 'package:mercave/app/shared/components/store/category_grid_list/category_grid_list.widget.ui.dart';

class CategoryGridListWidget extends StatelessWidget {
  final List<dynamic> categories;
  final Function onCategoryTapped;

  CategoryGridListWidget({
    @required this.categories,
    @required this.onCategoryTapped,
  });

  @override
  Widget build(BuildContext context) {
    return CategoryGridListWidgetUI(
      context: context,
      categories: categories,
      onCategoryTapped: onCategoryTapped,
    ).build();
  }
}
