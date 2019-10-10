import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sauce_app/util/CommonBack.dart';

import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoGallerySinglePage extends StatefulWidget {
  final String photo;

  PhotoGallerySinglePage({this.photo});

  @override
  _PhotoGallerySinglePageState createState() => _PhotoGallerySinglePageState();
}

class _PhotoGallerySinglePageState extends State<PhotoGallerySinglePage> {
  @override
  String photo;

  @override
  void initState() {
    photo = widget.photo;
    super.initState();
  }

  Widget build(BuildContext context) {
    return new GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
          ),
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height,
          ),
          child: new PhotoViewGallery.builder(
            itemCount: 1,
            builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: FileImage(new File(widget.photo)),
              initialScale: PhotoViewComputedScale.contained * 1,
            );
          },)),
    );
  }
}
