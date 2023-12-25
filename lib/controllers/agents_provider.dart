import 'package:flutter/material.dart';
import 'package:jobhubv2_0/models/request/agents/agents.dart';
import 'package:jobhubv2_0/models/response/agent/getAgent.dart';
import 'package:jobhubv2_0/models/response/jobs/jobs_response.dart';
import 'package:jobhubv2_0/services/helpers/agencies_helper.dart';

class AgentNotifier extends ChangeNotifier {
  late List<Agents> allAgents;
  late Future<List<JobsResponse>> agentJobs;
  late Map<String, dynamic> chat;

  Agents? agent;

  Future<List<Agents>> getAgents() {
    var agents = AgencyHelper.getAgents();
    return agents;
  }

  Future<GetAgent> getAgentInfo(String uid) {
    var getAgent = AgencyHelper.getAgentInfo(uid);
    return getAgent;
  }

  Future<List<JobsResponse>> getAgentJobs(String uid) {
    agentJobs = AgencyHelper.getAgentJobs(uid);
    return agentJobs;
  }
}
