/*
 * Copyright (c) 2022, Oracle and/or its affiliates.
 * Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/
 */
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:oceflutterblogsample/components/item_image.dart';
import 'package:oceflutterblogsample/models/topic_list_item_model.dart';
import 'package:oceflutterblogsample/screens/articles_list.dart';
import 'package:oceflutterblogsample/utils/constants.dart';

// This class renders each topic item in the topics screen
class TopicListItem extends StatelessWidget {
  TopicListItem({required this.topicModel});

  final TopicListItemModel topicModel;

  @override
  Widget build(BuildContext context) {
    //if (!dataFetched) return CircularProgressIndicator();
    return GestureDetector(
      onTap: () {
        Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => ArticlesList(
              topicModel: topicModel,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: kTileBorderColor)),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ItemImage(
                  url: topicModel.thumbnailUrl,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    topicModel.description!,
                    style: TextStyle(fontSize: 18.0),
                    maxLines: 3,
                  ),
                ),
              ],
            ),
            Container(
              color: Color.fromRGBO(188, 8, 7, 0.75),
              child: Text(topicModel.title!,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.white)),
              padding: new EdgeInsets.fromLTRB(40.0, 16.0, 40.0, 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
