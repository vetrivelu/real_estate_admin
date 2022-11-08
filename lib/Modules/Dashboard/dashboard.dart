import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:real_estate_admin/Modules/Dashboard/dashboardController.dart';
import 'package:real_estate_admin/Modules/Dashboard/line_cahrt.dart';
import 'package:real_estate_admin/Modules/Dashboard/progresscard.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            return Row(
              children: [
                Expanded(
                    flex: 8,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Row(
                              children: [
                                Expanded(
                                    child: ProgressCard(
                                  denominator: controller.totalLeads.toDouble(),
                                  numerator: controller.totalSuccessleads.toDouble(),
                                  neumeratorTitle: 'Converted',
                                  denominatorTitle: 'Total Leads',
                                  cardTitle: 'LEADS',
                                )),
                                const Expanded(
                                    child: ProgressCard(
                                  denominator: 30,
                                  numerator: 12,
                                  neumeratorTitle: 'ACTIVE',
                                  denominatorTitle: 'TOTAL AGENTS',
                                  cardTitle: 'AGENTS',
                                )),
                                const Expanded(
                                    child: ProgressCard(
                                  denominator: 9,
                                  numerator: 7,
                                  neumeratorTitle: 'SOLD',
                                  denominatorTitle: 'TOTAl PROPERTIES',
                                  cardTitle: 'LEADS',
                                )),
                                const Expanded(
                                    child: ProgressCard(
                                  denominator: 5,
                                  numerator: 1,
                                  neumeratorTitle: 'Converted',
                                  denominatorTitle: 'Total Leads',
                                  cardTitle: 'LEADS',
                                )),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: LeadChart(dateWiseLeads: controller.dateWiseLeads),
                                      )),
                                    )),
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: LeadChart(dateWiseLeads: controller.dateWiseLeads),
                                      )),
                                    )),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: LeadChart(dateWiseLeads: controller.dateWiseLeads),
                                      )),
                                    )),
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: LeadChart(dateWiseLeads: controller.dateWiseLeads),
                                      )),
                                    )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
                Expanded(
                  flex: 3,
                  child: Container(color: Colors.black),
                ),
              ],
            );
          }),
    );
  }
}
