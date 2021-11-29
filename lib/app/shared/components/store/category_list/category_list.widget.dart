import 'package:flutter/material.dart';
import 'package:mercave/app/shared/components/store/category_list/category_list.widget.ui.dart';

class CategoryListWidget extends StatelessWidget {
  final List<dynamic> categories;
  final Function onCategoryTapped;

  CategoryListWidget({
    @required this.categories,
    @required this.onCategoryTapped,
  });

  @override
  Widget build(BuildContext context) {
    return CategoryListWidgetUI(
      context: context,
      categories: categories,
      onCategoryTapped: onCategoryTapped,
    ).build();
  }
}
