/*
 * Copyright (c) 2022, Oracle and/or its affiliates.
 * Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/
 */
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:oceflutterblogsample/utils/constants.dart';

class ItemImage extends StatelessWidget {
  // Constructor that accepts the item id. Default the thumbnail param to true.
  ItemImage({required this.url, this.fit, this.height, this.width});

  final String? url;
  final BoxFit? fit;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      placeholder: (context, url) => Image(
        image: AssetImage(kPlaceholderImage),
        fit: BoxFit.scaleDown,
        height: height,
        width: width,
      ),
      imageUrl: url!,
      height: height,
      width: width,
      fit: fit == null ? BoxFit.cover : fit,
    );
  }
}
