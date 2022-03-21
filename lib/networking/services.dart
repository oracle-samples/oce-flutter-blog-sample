/*
 * Copyright (c) 2022, Oracle and/or its affiliates.
 * Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/
 */
import 'package:oceflutterblogsample/models/article_model.dart';
import 'package:oceflutterblogsample/models/article_list_item_model.dart';
import 'package:oceflutterblogsample/models/topic_list_model.dart';
import 'package:oceflutterblogsample/models/topic_list_item_model.dart';
import 'package:oceflutterblogsample/models/article_list_model.dart';
import 'content.dart';

//Helper class for making all the API calls needed for the app
class Services {

  // Fetch the top level values to be displayed on the home page.
  //
  // @returns TopicListModel
  Future<TopicListModel> fetchHomePage() async {
    final Content content = Content();
    try {
      final dynamic topicListData = await content.queryItems(<String, String>{
        'q': '(type eq "OCEGettingStartedHomePage" AND name eq "HomePage")',
        'fields': 'all',
      });
      return TopicListModel.fromJson(topicListData);
    } catch (exception) {
      rethrow;
    }
  }

  // Fetch details about the specific topic
  //
  // @param {String} topicId - the id of the topic
  // @returns TopicListItemModel
  Future<TopicListItemModel> fetchTopic(topicId) async {
    final Content content = Content();
    try {
      final dynamic data = await content.getItem(<String, String?>{
        'id': topicId,
        'fields': 'all',
        'expand': 'all',
      });
      TopicListItemModel topicListItemModel = TopicListItemModel.fromJson(data);
      topicListItemModel.thumbnailUrl = getMediumRenditionUrl(topicListItemModel.thumbnailId);
      return topicListItemModel;
    } catch (exception) {
      rethrow;
    }
  }

  // Get all the articles for the specified topic.
  //
  // @param {String} topicId - the id of the topic
  // @returns ArticleListModel which contains the list of articles for the topic
  Future<ArticleListModel>fetchArticles(topicId) async{
    final Content content = Content();
    try {
      final dynamic data = await content.queryItems(<String, String>{
        'q': '(type eq "OCEGettingStartedArticle" AND fields.topic eq "$topicId")',
        'fields': 'all',
        'orderBy': 'fields.published_date:desc',
      });
      ArticleListModel articleListModel = ArticleListModel.fromJson(data);
      for (ArticleListItemModel articleListItemModel in articleListModel.articlesList) {
        articleListItemModel.thumbnailUrl = getMediumRenditionUrl(articleListItemModel.thumbnailId);
      }
      return articleListModel;
    } catch (exception) {
      rethrow;
    }
  }

  // Get details of the specified article.
  //
  // @param {String} articleId - The id of the article
  // @returns ArticleModel - the article
  Future<ArticleModel>fetchArticle(articleId) async{
    final Content content = Content();
    try {
      final dynamic data = await content.getItem(<String, String?>{
        'id': articleId,
        'expand': 'all',
      });
      ArticleModel articleModel =  ArticleModel.fromJson(data);
      articleModel.authorImageUrl = getMediumRenditionUrl(articleModel.authorImageId);
      articleModel.imageUrl = getRenditionUrl(articleModel.imageId);
      return articleModel;
    } catch (exception) {
      rethrow;
    }
  }

  // Return the medium rendition URL for the specified item.
  //
  // @param {String} itemId - the Id of the item whose medium rendition URL is required
  // @returns String - the medium rendition URL
  String? getMediumRenditionUrl(itemId) {
    final Content content = Content();
    try {
      return content.getMediumRenditionUrl(<String, String?>{
        'id': itemId,
      });
    } catch (exception) {
      rethrow;
    }
  }

  // Return the rendition URL for the specified item.
  //
  // @param {String} itemId - the Id of the item whose rendition URL is required
  // @returns String - the rendition URL
  String? getRenditionUrl(itemId) {
    final Content content = Content();
    try {
      return content.getRenditionURL(<String, String?>{
        'id': itemId,
      });
    } catch (exception) {
      rethrow;
    }
  }

}
