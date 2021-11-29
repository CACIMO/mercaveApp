import 'package:flutter/material.dart';
import 'package:mercave/app/shared/components/loaders/page_loader/page_loader.widget.ui.dart';

class PageLoaderWidget extends StatelessWidget {
  final bool error;
  final Function onError;

  const PageLoaderWidget({
    this.error,
    this.onError,
  });

  @override
  Widget build(BuildContext context) {
    return PageLoaderWidgetUI(
      context: context,
      error: error,
      onError: onError,
    ).build();
  }
}
