/*
 * Copyright (c) 2022, Oracle and/or its affiliates.
 * Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/
 */
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oceflutterblogsample/components/item_image.dart';
import 'package:oceflutterblogsample/models/article_list_item_model.dart';
import 'package:oceflutterblogsample/screens/article.dart';
import 'package:oceflutterblogsample/utils/constants.dart';

// This class renders the article items for a single topic
class ArticleListItem extends StatelessWidget {
  // Constructor that accepts the articleListItemModel
  ArticleListItem({required this.articleListItemModel});

  final ArticleListItemModel articleListItemModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => Article(
              articleListItemModel: articleListItemModel,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ItemImage(
                  url: articleListItemModel.thumbnailUrl,
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                ),
                SizedBox(width: kDefaultPadding,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        articleListItemModel.title!,
                        style: TextStyle(
                            fontSize: 20.0,
                            color: kActionbarColor,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        DateFormat.yMMMMd('en_US')
                            .format(articleListItemModel.publishedDate),
                        style: TextStyle(fontSize: 18.0),
                      ),
                      SizedBox(height: kDefaultPadding,),
                      Text(
                        articleListItemModel.description!,
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
