import 'package:flutter/material.dart';
import 'package:real_estate_admin/Model/Agent.dart';
import 'package:real_estate_admin/Model/Lead.dart';
import 'package:real_estate_admin/Model/Property.dart';
import 'package:real_estate_admin/Model/Staff.dart';
import 'package:real_estate_admin/Modules/Agent/agent_controller.dart';
import 'package:real_estate_admin/Modules/Project/leads/lead_form_state.dart';
import 'package:real_estate_admin/Modules/Staff/staff_controller.dart';
import 'package:real_estate_admin/widgets/formfield.dart';
import 'package:real_estate_admin/widgets/future_dialog.dart';

class LeadForm extends StatefulWidget {
  const LeadForm({Key? key, this.lead, required this.property}) : super(key: key);

  final Lead? lead;
  final Property property;

  @override
  State<LeadForm> createState() => _LeadFormState();
}

class _LeadFormState extends State<LeadForm> {
  @override
  void initState() {
    if (widget.lead != null) {
      controller = LeadFormController.fromLead(widget.lead!);
    }
    super.initState();
  }

  late LeadFormController controller = LeadFormController(widget.property.reference);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LEAD"),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          const SizedBox(
            height: 60,
          ),
          Row(
            children: [
              Expanded(child: TileFormField(controller: controller.name, title: 'NAME')),
              Expanded(child: TileFormField(controller: controller.phoneNumber, title: 'PHONE'))
            ],
          ),
          Row(
            children: [
              Expanded(child: TileFormField(controller: controller.address, title: 'ADDRESS')),
              Expanded(child: TileFormField(controller: controller.email, title: 'EMAIL'))
            ],
          ),
          Row(
            children: [
              Expanded(child: TileFormField(controller: controller.governmentId, title: 'GOVT.ID')),
              Expanded(
                  child: ListTile(
                title: const Text("ENQUIRY DATE"),
                subtitle: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextFormField(
                    controller: TextEditingController(text: controller.enquiryDate.toString().substring(0, 10)),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: controller.enquiryDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          ).then((value) {
                            setState(() {
                              controller.enquiryDate = value ?? controller.enquiryDate;
                            });
                          });
                        },
                        child: const Icon(Icons.calendar_month),
                      ),
                    ),
                  ),
                ),
              ))
            ],
          ),
          Row(
            children: [
              Expanded(
                child: LayoutBuilder(builder: (context, constraints) {
                  return ListTile(
                    title: const Text("AGENT"),
                    subtitle: Autocomplete<Agent>(
                      displayStringForOption: (agent) => agent.firstName,
                      optionsViewBuilder: (context, onSelected, options) {
                        print(constraints.maxWidth);
                        return Align(
                          alignment: Alignment.topLeft,
                          child: SizedBox(
                            width: constraints.maxWidth,
                            height: MediaQuery.of(context).size.height / 3,
                            child: Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              child: ListView.builder(
                                  itemCount: options.length,
                                  itemBuilder: (context, index) {
                                    var agent = options.elementAt(index);
                                    return ListTile(
                                      title: Text("${agent.firstName} ${agent.lastName}"),
                                      subtitle: Text("PAN : ${agent.panCardNumber?.toUpperCase()}, \nMOBILE : ${agent.phoneNumber}"),
                                      onTap: () {
                                        onSelected(agent);
                                      },
                                    );
                                  }),
                            ),
                          ),
                        );
                      },
                      optionsBuilder: (vaue) {
                        return AgentController.loadAgents(vaue.text);
                      },
                      onSelected: (agent) {
                        controller.agent = agent;
                        controller.agentRef = AgentController.agentRef.doc(agent.docId);
                      },
                    ),
                  );
                }),
              ),
              Expanded(
                child: LayoutBuilder(builder: (context, constraints) {
                  return ListTile(
                    title: const Text("STAFF"),
                    subtitle: Autocomplete<Staff>(
                      initialValue: TextEditingValue(text: controller.staff?.firstName ?? ''),
                      displayStringForOption: (staff) => staff.firstName,
                      optionsBuilder: (vaue) {
                        return StaffController.loadStaffs(vaue.text);
                      },
                      optionsViewBuilder: (context, onSelected, options) {
                        print(constraints.maxWidth);
                        return Align(
                          alignment: Alignment.topLeft,
                          child: SizedBox(
                            width: constraints.maxWidth,
                            height: MediaQuery.of(context).size.height / 3,
                            child: Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              child: ListView.builder(
                                  itemCount: options.length,
                                  itemBuilder: (context, index) {
                                    var agent = options.elementAt(index);
                                    return ListTile(
                                      title: Text("${agent.firstName} ${agent.lastName}"),
                                      subtitle: Text("PAN : ${agent.panCardNumber?.toUpperCase()}, \nMOBILE : ${agent.phoneNumber}"),
                                      onTap: () {
                                        onSelected(agent);
                                      },
                                    );
                                  }),
                            ),
                          ),
                        );
                      },
                      onSelected: (staff) {
                        controller.staff = staff;
                        controller.staffRef = staff.reference;
                      },
                    ),
                  );
                }),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.maxFinite,
              height: 60,
              child: ElevatedButton(
                  onPressed: () {
                    var future = widget.property.addLead(controller.lead);
                    showFutureDialog(context, future: future);
                  },
                  child: const Text("SUBMIT")),
            ),
          )
        ],
      )),
    );
  }
}
