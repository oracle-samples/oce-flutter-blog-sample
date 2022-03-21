/*
 * Copyright (c) 2022, Oracle and/or its affiliates.
 * Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/
 */
import 'article_list_item_model.dart';

//Object that encapsulates the articles list for a topic
class ArticleListModel {

  List<ArticleListItemModel> articlesList = <ArticleListItemModel>[];

  ArticleListModel.fromJson(Map<String, dynamic> parsedJson) {
    List<dynamic> articlesData = parsedJson['items'];
    for (var articleData in articlesData) {
      articlesList.add(ArticleListItemModel.fromJson(articleData));
    }
  }

}
