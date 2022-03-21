/*
 * Copyright (c) 2022, Oracle and/or its affiliates.
 * Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/
 */
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oceflutterblogsample/components/item_image.dart';
import 'package:oceflutterblogsample/components/screen_layout.dart';
import 'package:oceflutterblogsample/models/article_list_item_model.dart';
import 'package:oceflutterblogsample/models/article_model.dart';
import 'package:oceflutterblogsample/networking/services.dart';
import 'package:oceflutterblogsample/utils/constants.dart';
import 'package:flutter_html/flutter_html.dart';

//This class renders a single article.
class Article extends StatefulWidget {
  Article({required this.articleListItemModel});

  final ArticleListItemModel articleListItemModel;

  @override
  _ArticleState createState() => _ArticleState();
}

class _ArticleState extends State<Article> {
  String? exception;
  ArticleModel? articleModel;
  bool dataFetched = false;

  @override
  void initState() {
    super.initState();
    if (mounted) fetchData();
  }

  // Makes API call to fetch all the images needed in this app. Once the results are
  // obtained, it launches the home page screen
  Future<void> fetchData() async {
    final Services services = Services();
    try {
      ArticleModel articleModel =
          await services.fetchArticle(widget.articleListItemModel.id);
      setState(() {
        this.articleModel = articleModel;
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
        title: Text(widget.articleListItemModel.title!),
        backgroundColor: kActionbarColor,
      ),
      body: SafeArea(
        child: (articleModel == null)
            ?
            // By default, show a loading spinner.
            Center(child: CircularProgressIndicator())
            : ScreenLayout(
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Image(
                            image: NetworkImage(articleModel!.authorImageUrl!),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  articleModel!.title!,
                                  style: TextStyle(
                                      fontSize: 24.0,
                                      color: kActionbarColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                    DateFormat.yMMMMd('en_US')
                                        .format(articleModel!.publishedDate),
                                    style: TextStyle(fontSize: 18.0)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      ItemImage(
                        url: articleModel!.imageUrl,
                        fit: BoxFit.scaleDown,
                      ),
                      Text(articleModel!.imageCaption!,
                          style: TextStyle(fontSize: 18.0)),
                      SizedBox(
                        height: 20.0,
                      ),
                      Html(
                        data: articleModel!.content,
                        style: {
                          "body": Style(
                            fontSize: FontSize(20.0),
                          ),
                        },
                        //defaultTextStyle: TextStyle(fontSize: 20.0),
                      ),
                    ],
                  ),
                ),
              ),
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
