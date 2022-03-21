/*
 * Copyright (c) 2022, Oracle and/or its affiliates.
 * Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/
 */
//Object that encapsulates details for each item in the article list for a topic
class ArticleListItemModel {
  String? id;
  String? title;
  String? description;
  late DateTime publishedDate;
  String? thumbnailId;
  String? thumbnailUrl;

  ArticleListItemModel.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson['id'];
    title = parsedJson['name'];
    description = parsedJson['description'];
    thumbnailId = parsedJson['fields']['image']['id'];
    String datetime = parsedJson['fields']['published_date']['value'];
    publishedDate =  DateTime.parse(datetime);
  }
}