import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mercave/app/ui/constants.dart';
import 'package:photo_view/photo_view.dart';

class ProductZoomPage extends StatefulWidget {
  final dynamic productParam;

  ProductZoomPage({this.productParam});

  @override
  _ProductZoomPageState createState() => _ProductZoomPageState();
}

class _ProductZoomPageState extends State<ProductZoomPage> {
  PhotoViewController controller;
  double scaleCopy = 1;

  @override
  void initState() {
    super.initState();
    controller = PhotoViewController()..outputStateStream.listen(listener);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void listener(PhotoViewControllerValue value) {
    setState(() {
      scaleCopy = value.scale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: kCustomSecondaryColor),
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: _getAppBarWidget(),
        body: PhotoView(
          backgroundDecoration: BoxDecoration(
            color: kCustomWhiteColor,
          ),
          initialScale: 0.5,
          minScale: 0.5,
          maxScale: 5.0,
          imageProvider: NetworkImage(widget.productParam['principal_image']),
          controller: controller,
        ),
        /*bottomNavigationBar: Stack(
          children: [
            new Container(
              height: 60.0,
              color: kCustomWhiteColor,
            ),
            Positioned(
              left: 0.0,
              right: 0.0,
              top: 0.0,
              bottom: 0.0,
              child: Slider(
                activeColor: kCustomPrimaryColor,
                inactiveColor: kCustomGrayColor,
                min: 0.1,
                max: 10.0,
                onChanged: (newRating) {
                  setState(() {
                    scaleCopy = newRating;
                  });
                },
                value: scaleCopy,
              ),
            ),
          ],
        ),*/
      ),
    );
  }

  Widget _getAppBarWidget() {
    return AppBar(
      title: Text(''),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
