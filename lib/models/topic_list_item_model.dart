/*
 * Copyright (c) 2022, Oracle and/or its affiliates.
 * Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/
 */
//Object that encapsulates details for each item in the topic list for the homepage
class TopicListItemModel {
  String? id;
  String? title;
  String? description;
  String? thumbnailId;
  String? thumbnailUrl;

  TopicListItemModel.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson['id'];
    title = parsedJson['name'];
    description = parsedJson['description'];
    thumbnailId = parsedJson['fields']['thumbnail']['id'];
  }
}
