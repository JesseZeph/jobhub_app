import 'dart:convert';
import 'package:http/http.dart' as https;
import 'package:jobhubv2_0/models/request/agents/agents.dart';
import 'package:jobhubv2_0/models/response/applied/applied.dart';

import 'package:jobhubv2_0/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppliedHelper {
  static var client = https.Client();

  static Future<bool> applyJobs(String model) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      return false;
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };
    var url = Uri.https(Config.apiUrl, Config.appliedUrl);
    var response = await client.post(url, headers: requestHeaders, body: model);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<List<Applied>> getApplied() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token is required');
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };
    var url = Uri.https(Config.apiUrl, Config.appliedUrl);
    var response = await client.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      var applied = appliedFromJson(response.body);
      return applied;
    } else {
      throw Exception('Failed to get applied jobs');
    }
  }
}
