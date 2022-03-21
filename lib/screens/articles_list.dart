/*
 * Copyright (c) 2022, Oracle and/or its affiliates.
 * Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/
 */
import 'package:flutter/material.dart';
import 'package:oceflutterblogsample/components/article_list_item.dart';
import 'package:oceflutterblogsample/models/topic_list_item_model.dart';
import 'package:oceflutterblogsample/models/article_list_model.dart';
import 'package:oceflutterblogsample/models/article_list_item_model.dart';
import 'package:oceflutterblogsample/networking/services.dart';
import 'package:oceflutterblogsample/utils/constants.dart';

//This class renders the articles that belong to a topic
class ArticlesList extends StatefulWidget {
  // Constructor that accepts the topicModel
  ArticlesList({required this.topicModel});

  final TopicListItemModel topicModel;

  @override
  _ArticlesListState createState() => _ArticlesListState();
}

class _ArticlesListState extends State<ArticlesList> {
  String? exception;
  List<ArticleListItemModel> articles = [];
  bool dataFetched = false;

  @override
  void initState() {
    super.initState();
    if (mounted) fetchData();
  }

  // Makes API call to fetch all the articles for a topic.
  Future<void> fetchData() async {
    final Services services = Services();
    try {
      ArticleListModel articleListModel =
          await services.fetchArticles(widget.topicModel.id);
      setState(() {
        articles = articleListModel.articlesList;
      });
    } catch (exception) {
      setState(() {
        this.exception = exception.toString();
      });
      print(exception.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topicModel.title!),
        backgroundColor: kActionbarColor,
      ),
      body: SafeArea(
        child: (articles.length == 0)
            ?
            // By default, show a loading spinner.
            Center(child: CircularProgressIndicator())
            : ListView.separated(
                itemCount: articles.length,
                separatorBuilder: (BuildContext context, int index) => Divider(
                  color: Colors.black,
                  height: 1,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return new ArticleListItem(
                      articleListItemModel: articles[index]);
                },
              ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
