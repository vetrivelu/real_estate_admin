import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:real_estate_admin/Modules/Dashboard/agentTable.dart';
import 'package:real_estate_admin/Modules/Dashboard/dashboardController.dart';
import 'package:real_estate_admin/Modules/Dashboard/bar_chart.dart';
import 'package:real_estate_admin/Modules/Dashboard/lead_line_chart.dart';
import 'package:real_estate_admin/Modules/Dashboard/progresscard.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f9f8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "DASHBOARD",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: GetBuilder(
          init: DashboardController(),
          builder: (context) {
            var controller = Get.find<DashboardController>();
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                      flex: 8,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                // Color.fromARGB(255, 231, 225, 251)
                                Expanded(
                                    child: ProgressCard(
                                  valueColor: const Color.fromARGB(255, 174, 143, 253),
                                  backGroundColor: const Color.fromARGB(255, 231, 225, 251),
                                  denominator: controller.totalLeads.toDouble(),
                                  numerator: controller.totalSuccessleads.toDouble(),
                                  neumeratorTitle: 'CONVERTED ',
                                  denominatorTitle: 'TOTAL',
                                  cardTitle: 'LEADS',
                                )),
                                Expanded(
                                    child: ProgressCard(
                                  valueColor: const Color.fromARGB(255, 254, 187, 108),
                                  backGroundColor: const Color.fromARGB(255, 253, 243, 233),
                                  denominator: controller.totalAgents.toDouble(),
                                  numerator: controller.totalActiveAgents.toDouble(),
                                  neumeratorTitle: 'ACTIVE',
                                  denominatorTitle: 'TOTAL',
                                  cardTitle: 'AGENTS',
                                )),
                                Expanded(
                                    child: ProgressCard(
                                  valueColor: const Color.fromARGB(255, 69, 198, 168),
                                  backGroundColor: const Color.fromARGB(255, 232, 250, 234),
                                  denominator: controller.totalProperties.toDouble(),
                                  numerator: controller.totalSuccessleads.toDouble(),
                                  neumeratorTitle: 'SOLD',
                                  denominatorTitle: 'TOTAL',
                                  cardTitle: 'PROPERTIES',
                                )),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                Expanded(
                                  child: LeadChart(
                                    dateWiseLeads: controller.dateWiseLeads,
                                    title: "LEAD PER DAY",
                                    color: Colors.purpleAccent.shade100,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                Expanded(
                                  child: LeadChart(
                                      color: Colors.greenAccent.shade100,
                                      dateWiseLeads: controller.dateWiseSoldLeads,
                                      title: "PROPERTIES SOLD PER DAY"),
                                  // child: LeadLIneChart(dateWiseLeads: controller.dateWiseLeadCount, title: 'PER DAY LEAD'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Expanded(
                            child: AgentDataTable(
                          headColor: Colors.deepPurple.shade100,
                          agents: controller.top5AgentsByLeads,
                          num1: 0,
                        )),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: AgentDataTable(headColor: Colors.pink.shade100, agents: controller.top5AgentsBySuccessfull, num1: 1),
                        )),
                        Expanded(
                          child: AgentDataTable(headColor: Colors.green.shade100, agents: controller.top5AgentsByComission, num1: 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
