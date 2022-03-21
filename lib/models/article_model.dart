/*
 * Copyright (c) 2022, Oracle and/or its affiliates.
 * Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/
 */
//Object that encapsulates details for an article
class ArticleModel {
  String? id;
  String? title;
  String? description;
  String? authorName;
  String? authorImageId;
  late DateTime publishedDate;
  String? imageId;
  String? imageCaption;
  String? content;
  String? authorImageUrl; //this field is set externally
  String? imageUrl; //this field is set externally

  ArticleModel.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson['id'];
    title = parsedJson['name'];
    authorName = parsedJson['fields']['author']['name'];
    authorImageId = parsedJson['fields']['author']['fields']['avatar']['id'];
    String datetime = parsedJson['fields']['published_date']['value'];
    publishedDate = DateTime.parse(datetime);
    description = parsedJson['description'];
    imageId = parsedJson['fields']['image']['id'];
    imageCaption = parsedJson['fields']['image_caption'];
    content = parsedJson['fields']['article_content'];
  }
}
