import 'dart:convert';
import 'package:http/http.dart' as https;
import 'package:jobhubv2_0/models/request/agents/agents.dart';
import 'package:jobhubv2_0/models/request/bookmarks/bookmarks_model.dart';
import 'package:jobhubv2_0/models/response/agent/getAgent.dart';
import 'package:jobhubv2_0/models/response/bookmarks/all_bookmarks.dart';
import 'package:jobhubv2_0/models/response/bookmarks/bookmark.dart';
import 'package:jobhubv2_0/models/response/jobs/jobs_response.dart';
import 'package:jobhubv2_0/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgencyHelper {
  static var client = https.Client();

  static Future<List<Agents>> getAgents() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Failed to get  token');
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };
    var url = Uri.https(Config.apiUrl, Config.getAgentsUrl);
    var response = await client.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      var agents = agentsFromJson(response.body);
      return agents;
    } else {
      throw Exception('Failed to get bookmark');
    }
  }

  static Future<GetAgent> getAgentInfo(String uid) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Failed to get  token');
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };

    var url = Uri.https(Config.apiUrl, '${Config.getAgentsUrl}/$uid');
    var response = await client.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      var agent = getAgentFromJson(response.body);
      return agent;
    } else {
      throw Exception('Failed to get bookmark');
    }
  }

  static Future<List<JobsResponse>> getAgentJobs(String uid) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.https(Config.apiUrl, "${Config.jobs}/agent/$uid");
    var response = await client.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      var agents = jobsResponseFromJson(response.body);
      return agents;
    } else {
      throw Exception('Failed to get bookmark');
    }
  }

  static Future<BookMark?> getBookMark(String jobId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        return null;
      }

      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token'
      };

      var url = Uri.https(Config.apiUrl, "${Config.singleBookmarkUrl}$jobId");

      var response = await client.get(url, headers: requestHeaders);

      if (response.statusCode == 200) {
        var bookmark = bookMarkFromJson(response.body);
        return bookmark;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
