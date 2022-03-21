/*
 * Copyright (c) 2022, Oracle and/or its affiliates.
 * Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/
 */
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:oceflutterblogsample/config/oce.dart';
import 'package:oceflutterblogsample/utils/strings.dart';

import '../models/app_exceptions.dart';

class Content {

  // Initialize constructor with config data
  Content() {
    data = config;
  }

  late dynamic data;

  // Utility method to build up the URL for published content.
  //
  // Eg.returns : https://host:port/content/published/api/v1.1/
  // @returns published content server URL
  String _getPublishedContentServerURL() {
    final String? serverUrl = data['serverUrl'] as String?;
    final String? apiVersion = data['apiVersion'] as String?;
    return '$serverUrl/content/published/api/$apiVersion/';
  }

  // Adds the channel token to the URL
  //
  // @param {*} currUrl  the current URL to add the channel token to
  // @returns the URL with the channel token added
  String _addChannelToURL(String currUrl) {
    final String? channelToken = data['channelToken'] as String?;
    return '$currUrl?channelToken=$channelToken';
  }

  //Make an http get call and return the response if successful
  //
  //@param url the http get url
  //@returns the json decoded response body
  //@throws FetchDataException, BadRequestException, UnauthorizedException
  Future<dynamic> _get(String url) async {
    dynamic responseJson;
    try {
      final Response response = await get(Uri.parse(url));
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(kConnectionError);
    }
    return responseJson;
  }

  //Return the json decoded response body if response status is successful
  //
  //@throws FetchDataException, BadRequestException, UnauthorizedException if response status is not 200
  dynamic _returnResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        final Map<String, dynamic>? responseJson =
            json.decode(response.body.toString()) as Map<String, dynamic>?;
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorizedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException('StatusCode : ${response.statusCode}');
    }
  }

  // Get a list of items based on SCIM search criteria.<br/>
  //
  // All arguments are passed through to the Content Delivery REST API call.
  // @param {object} args - A json object containing the "queryItems" parameters.
  // @param {string} [args.q=''] - An SCIM query string to restrict results.
  // @param {string} [args.fields=''] - A list of fields to include for each item returned.
  // @param {number} [args.offset] - Return results starting at this number in the results.
  // @param {number} [args.limit] - Limit the number of items returned.
  // @param {array|string} [args.orderBy=[]] - The order by which results should be returned.
  // @param {function} [args.beforeSend=undefined] - A callback passing in the xhr (browser) or options (node) object before making the REST call.
  // @returns {Future<dynamic>} A future dynamic object that can be used to retrieve the data after the call has completed.
  // @example
  // get all items and order by type and name
  // var data = await sdk.queryItems({
  //     'q': '(type eq "' + contentType + '")',
  //     'fields': 'ALL'
  // });
  // print(data);
  Future<dynamic> queryItems(Map<String, String> args) async {
    String url = _getPublishedContentServerURL() + 'items';
    // add the channel token to the URL
    url = _addChannelToURL(url);
    // add query params to the url
    args.forEach((String key, String value) {
      url = '$url&$key=$value';
    });
    return await _get(url);
  }

  //Get the id from the json arguments
  //
  //@param args the json object passed to the function
  //@returns the id
  String _getIdFromArgs(Map<String, String?> args) {
    String? id = args['id'];
    if (id == null) {
      id = args['ID'];
    }
    if (id == null) {
      id = args['itemGUID'];
    }
    return id!;
  }


   // Get a single item given its ID. <br/>
   // @param {object} args - A json object containing the "getItem" parameters.
   // @param {string} args.id - The ID of the content item to return.
   // @returns {Future<dynamic>} A future dynamic object that can be used to retrieve the data after the call has completed.
   // @example
   // var data = sdk.getItem({
   //     'id': contentId
   // });
   // print(data);
  Future<dynamic> getItem(Map<String, String?> args) async {
    String guid = _getIdFromArgs(args);
    String url = _getPublishedContentServerURL() + 'items';
    url = '$url/$guid';
    // add the channel token to the URL
    url = _addChannelToURL(url);
    // add query params to the url
    args.forEach((String key, String? value) {
      url = '$url&$key=$value';
    });
    return await _get(url);
  }

  // Create the medium rendition URL to render an image asset into the page.
  //
  // @returns {string} A fully qualified URL to the medium rendition of the published image asset.
  // @param {object} args - A JavaScript object containing the "getMediumRenditionUrl" parameters.
  // @example
  // get the medium rendition URL for this client
  // console.log(contentClient.getMediumRenditionUrl({
  //     'id': digitalAssetId
  // }));
  //https://host:port/content/published/api/v1.1/assets/{digitalAssetId}/Medium?format=jpg&type=responsiveimage&channelToken={channelToken}"
  String? getMediumRenditionUrl(Map<String, String?> args) {
    final String? itemId = args['id'];
    if (itemId == null) return null;
    String url = _getPublishedContentServerURL();
    url = '${url}assets/$itemId/Medium';
    // add the channel token to the URL
    url = _addChannelToURL(url);
    url = '$url&format=jpg&&type=responsiveimage';
    return url;
  }

  // Create the native URL to render an image asset into the page.
  //
  // @returns {string} A fully qualified URL to the published image asset.
  // @param {object} args - A JavaScript object containing the "getRenditionURL" parameters.
  // @example
  // get the rendition URL for this client
  // console.log(contentClient.getRenditionURL({
  //     'id': digitalAssetId
  // }));
  // @example returns https://host:port/content/published/api/v1.1/assets/{digitalAssetId}/native?channelToken={channelToken}"
  String? getRenditionURL(Map<String, String?> args) {
    final String? itemId = args['id'];
    if (itemId == null) return null;
    String url = _getPublishedContentServerURL();
    url = '${url}assets/$itemId/native';
    // add the channel token to the URL
    url = _addChannelToURL(url);
    return url;
  }
}
