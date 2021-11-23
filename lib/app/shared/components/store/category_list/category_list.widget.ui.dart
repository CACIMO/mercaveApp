import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mercave/app/ui/constants.dart';

class CategoryListWidgetUI {
  final BuildContext context;
  final List<dynamic> categories;
  final Function onCategoryTapped;

  CategoryListWidgetUI({
    @required this.context,
    @required this.categories,
    @required this.onCategoryTapped,
  });

  Widget build() {
    return Container(
      height: MediaQuery.of(context).size.height - 56.0,
      child: _getCategoryList(),
    );
  }

  Widget _getCategoryList() {
    return ListView.separated(
      itemCount: categories.length,
      separatorBuilder: (context, index) => Divider(
        color: kCustomStrongGrayColor,
      ),
      itemBuilder: (BuildContext context, int index) {
        return _getCategoryListItem(category: categories[index]);
      },
    );
  }

  Widget _getCategoryListItem({category}) {
    return new ListTile(
      leading: CachedNetworkImage(
        imageUrl: category['principal_image'],
        placeholder: (context, url) => Image.asset(kCustomPlaceholderImage),
        errorWidget: (context, url, error) => Icon(Icons.error),
        width: 80.0,
      ),
      title: Text(
        category['name'],
        style: TextStyle(
          color: kCustomPrimaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
      subtitle: Text(
        category['count'].toString() + ' Productos',
        style: TextStyle(
          color: kCustomPrimaryColor,
          fontWeight: FontWeight.normal,
          fontSize: 14.0,
        ),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 4.0),
      dense: true,
      onTap: () {
        onCategoryTapped(category);
      },
    );
  }
}
