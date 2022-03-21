/*
 * Copyright (c) 2022, Oracle and/or its affiliates.
 * Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/
 */
import 'package:flutter/material.dart';
import 'package:oceflutterblogsample/models/topic_list_model.dart';
import 'package:oceflutterblogsample/models/topic_list_item_model.dart';
import 'package:oceflutterblogsample/networking/services.dart';
import 'package:oceflutterblogsample/utils/util.dart';
import 'package:oceflutterblogsample/utils/constants.dart';
import 'package:oceflutterblogsample/utils/strings.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/topic_list_item.dart';

enum MenuOption { ABOUT, CONTACT_US }

//This class renders the initial topics screen.
class TopicsList extends StatefulWidget {
  @override
  _TopicsListState createState() => _TopicsListState();
}

class _TopicsListState extends State<TopicsList> {
  String? exception;
  TopicListModel? topicListModel;
  List<TopicListItemModel> topics = [];
  bool dataFetched = false;

  @override
  void initState() {
    super.initState();
    if (mounted) fetchData();
  }

  // Makes API call to fetch the home page details. For each topic in the list that comes back, fetch the
  // topic. Render as soon as each one is fetched.
  Future<void> fetchData() async {
    final Services services = Services();
    try {
      topicListModel = await services.fetchHomePage();
      setState(() {
        topicListModel = topicListModel;
      });
      //for each topicid , fetch the topic
      for (var topicId in topicListModel!.topicIdList) {
        TopicListItemModel topic = await services.fetchTopic(topicId);
        setState(() {
          topics.add(topic);
          if (topics.length == topicListModel!.topicIdList.length) {
            dataFetched = true;
          }
        });
      }
    } catch (e) {
      setState(() {
        exception = e.toString();
      });
      print(exception.toString());
    }
  }

  //Handler for the actionbar overflow menu click
  _select(menuOption) async {
    if (topicListModel == null) return;
    String? url;
    if (menuOption == MenuOption.ABOUT) {
      url = topicListModel!.aboutUrl;
    } else if (menuOption == MenuOption.CONTACT_US) {
      url = topicListModel!.contactUrl;
    }
    if (await canLaunch(url!)) launch(url);
  }

  @override
  Widget build(BuildContext context) {
    int numOfColumns = getNumColumns(context);
    double aspectRatio = numOfColumns == 1 ? 1 : 0.95;
    return Scaffold(
      appBar: AppBar(
        title: Text(topicListModel != null ? topicListModel!.title! : ""),
        actions: <Widget>[
          // overflow menu
          PopupMenuButton<MenuOption>(
            onSelected: _select,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuOption>>[
              const PopupMenuItem<MenuOption>(
                value: MenuOption.ABOUT,
                child: Text(kActionbarMoreAbout),
              ),
              const PopupMenuItem<MenuOption>(
                value: MenuOption.CONTACT_US,
                child: Text(kActionbarMoreContactus),
              ),
            ],
          ),
        ],
        backgroundColor: kActionbarColor,
      ),
      body: SafeArea(
        child: (exception != null)
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    exception!,
                    style: TextStyle(
                      fontSize: 20,
                      color: kActionbarColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : (topics.length == 0)
                ?
                // By default, show a loading spinner.
                Center(child: CircularProgressIndicator())
                : GridView.builder(
                    shrinkWrap: true,
                    itemCount: topics.length,
                    padding: const EdgeInsets.all(kGridSpacing),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: kGridSpacing,
                        crossAxisSpacing: kGridSpacing,
                        childAspectRatio: aspectRatio,
                        crossAxisCount: numOfColumns),
                    itemBuilder: (BuildContext context, int index) {
                      return new TopicListItem(topicModel: topics[index]);
                    },
                  ),
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
