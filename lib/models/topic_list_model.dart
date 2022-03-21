/*
 * Copyright (c) 2022, Oracle and/or its affiliates.
 * Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/
 */
//Object that encapsulates details needed for the homepage. It also encapsulates the topic ids needed
//to render the topics list on the homepage
class TopicListModel {
  String? logoId;
  String? title;
  String? aboutUrl;
  String? contactUrl;
  String? logoUrl; //This field is set externally. It needs an API calls
  var topicIdList = <String>[];

  TopicListModel.fromJson(Map<String, dynamic> parsedJson) {
    logoId = parsedJson['items'][0]['fields']['company_logo']['id'];
    title = parsedJson['items'][0]['fields']['company_name'];
    aboutUrl = parsedJson['items'][0]['fields']['about_url'];
    contactUrl = parsedJson['items'][0]['fields']['contact_url'];
    List<dynamic> topicsData = parsedJson['items'][0]['fields']['topics'];
    for (var topic in topicsData) {
      topicIdList.add(topic['id']);
    }
  }

}
