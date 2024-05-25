import 'dart:async';
import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_p_2/api/form.dart';
import 'package:flutter_application_p_2/api/response.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateEditPage extends StatefulWidget {
  final bool isNew;
  final dynamic docId;

  const CreateEditPage({super.key, required this.isNew, required this.docId});

  @override
  State<CreateEditPage> createState() => _CreateEditPageState();
}

class _CreateEditPageState extends State<CreateEditPage> {
  final titleController = TextEditingController();

  final List<String> prefixItems = [
    'Mr.',
    'Mrs.',
    'Miss',
  ];
  String? selectedPrefix;

  final fnameController = TextEditingController();
  final mnameController = TextEditingController();
  final lnameController = TextEditingController();
  final nationalityController = TextEditingController();
  final placeOfBirthController = TextEditingController();
  final maritalStatusController = TextEditingController();

  //date
  DateTime dateOfBirth = DateTime.now();

  final passportNoController = TextEditingController();
  final placeOfIssueController = TextEditingController();

  //date
  DateTime dateOfIssue = DateTime.now();

  //date
  DateTime dateOfExpiry = DateTime.now();

  final occupationController = TextEditingController();
  final addrDomController = TextEditingController();
  final addrDomTelController = TextEditingController();
  final addrPermController = TextEditingController();
  final addrPermTelController = TextEditingController();
  final addrPermEmailController = TextEditingController();
  final addrDesController = TextEditingController();

  //date
  DateTime dateOfArrival = DateTime.now();

  final travelByController = TextEditingController();
  final durationOfStayController = TextEditingController();
  final guarantorDesNameController = TextEditingController();
  final guarantorDesTelController = TextEditingController();
  final guarantorDomNameController = TextEditingController();
  final guarantorDomTelController = TextEditingController();

  dynamic id;
  Map<String, dynamic>? user;
  Map<String, dynamic>? form;
  String? errorMessage;

  Future<void> loadData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final String? userRaw = pref.getString("user");

    if (userRaw != null) {
      user = jsonDecode(userRaw);
      final userId = user!['id'];
      id = widget.docId;

      try {
        APIResponse response = await APIForm.formDetail(id);
        if (response.success == true) {
          form = response.data;
          /*
          {
              "success": true,
              "data": {
                  "id": "1",
                  "author_id": "1",
                  "created_date": "2024-05-21 13:09:42",
                  "updated_date": "2024-05-22 07:51:16",
                  "title": "แบบคำขอ VISA พ.ค.",
                  "prefix": "Mr.",
                  "fname": "SAMPAN",
                  "mname": "",
                  "lname": "SISULID",
                  "nationality": "Lao",
                  "place_of_birth": "Vientiane",
                  "marital_status": "Single",
                  "date_of_birth": null,
                  "passport_no": "AB4376996",
                  "place_of_issue": "BANGKOK",
                  "date_of_issue": "2019-11-08",
                  "date_of_expiry": "2024-11-07",
                  "occupation": "",
                  "addr_dom": "",
                  "addr_dom_tel": "",
                  "addr_perm": "",
                  "addr_perm_tel": "",
                  "addr_perm_email": "",
                  "addr_des": "",
                  "date_of_arrival": null,
                  "travel_by": "commercial plane",
                  "duration_of_stay": "30",
                  "guarantor_des_name": "",
                  "guarantor_des_tel": "",
                  "guarantor_dom_name": "",
                  "guarantor_dom_tel": ""
              }
          }
          */
          titleController.text = form?['title'] ?? 'Untitled';

          if (prefixItems.contains(form?['prefix'])) {
            selectedPrefix = form?['prefix'];
          } else {
            selectedPrefix = prefixItems[0];
          }
          fnameController.text = form?['fname'] ?? 'Unnamed';
          mnameController.text = form?['mname'] ?? '';
          lnameController.text = form?['lname'] ?? '';

          nationalityController.text = form?['nationality'] ?? '';
          maritalStatusController.text = form?['marital_status'] ?? '';

          dateOfBirth = DateFormat('yyyy-MM-dd')
              .parse(form?['date_of_birth'] ?? DateTime.now());
          placeOfBirthController.text = form?['place_of_birth'];

          passportNoController.text = form?['passport_no'] ?? '';
          placeOfIssueController.text = form?['place_of_issue'] ?? '';
          dateOfIssue = DateFormat('yyyy-MM-dd')
              .parse(form?['date_of_issue'] ?? DateTime.now());
          dateOfExpiry = DateFormat('yyyy-MM-dd')
              .parse(form?['date_of_expiry'] ?? DateTime.now());

          occupationController.text = form?['occupation'] ?? '';
          addrDomController.text = form?['addr_dom'] ?? '';
          addrDomTelController.text = form?['addr_dom_tel'] ?? '';
          addrPermController.text = form?['addr_perm'] ?? '';
          addrPermTelController.text = form?['addr_perm_tel'] ?? '';
          addrPermEmailController.text = form?['addr_perm_email'] ?? '';

          addrDesController.text = form?['addr_des'] ?? '';

          dateOfArrival = DateFormat('yyyy-MM-dd')
              .parse(form?['date_of_arrival'] ?? DateTime.now());

          travelByController.text = form?['travel_by'] ?? '';
          durationOfStayController.text = form?['durationn_of_stay'] ?? '';
          guarantorDesNameController.text = form?['guarantor_des_name'] ?? '';
          guarantorDesTelController.text = form?['guarantor_des_tel'] ?? '';
          guarantorDomNameController.text = form?['guarantor_dom_name'] ?? '';
          guarantorDomTelController.text = form?['guarantor_dom_tel'] ?? '';
        } else {
          errorMessage = response.data.toString();
        }

        setState(() {});
      } catch (e) {
        setState(() {
          errorMessage = e.toString();
        });
      }
    }
  }

  Future<void> updateForm() async {
    try {
      //reassign all value
      form?['title'] = titleController.text;

      form?['prefix'] = selectedPrefix;

      form?['fname'] = fnameController.text;
      form?['mname'] = mnameController.text;
      form?['lname'] = lnameController.text;

      form?['nationality'] = nationalityController.text;
      form?['marital_status'] = maritalStatusController.text;

      form?['date_of_birth'] = DateFormat('yyyy-MM-dd').format(dateOfBirth);

      form?['place_of_birth'] = placeOfBirthController.text;

      form?['passport_no'] = passportNoController.text;
      form?['place_of_issue'] = placeOfIssueController.text;

      form?['date_of_issue'] = DateFormat('yyyy-MM-dd').format(dateOfIssue);
      form?['date_of_expiry'] = DateFormat('yyyy-MM-dd').format(dateOfExpiry);

      form?['occupation'] = occupationController.text;
      form?['addr_dom'] = addrDomController.text;
      form?['addr_dom_tel'] = addrDomTelController.text;
      form?['addr_perm'] = addrPermController.text;
      form?['addr_perm_tel'] = addrPermTelController.text;
      form?['addr_perm_email'] = addrPermEmailController.text;

      form?['addr_des'] = addrDesController.text;

      form?['date_of_arrival'] = DateFormat('yyyy-MM-dd').format(dateOfArrival);

      form?['travel_by'] = travelByController.text;
      form?['durationn_of_stay'] = durationOfStayController.text;
      form?['guarantor_des_name'] = guarantorDesNameController.text;
      form?['guarantor_des_tel'] = guarantorDesTelController.text;
      form?['guarantor_dom_name'] = guarantorDomNameController.text;
      form?['guarantor_dom_tel'] = guarantorDomTelController.text;

      APIResponse response = await APIForm.editForm(form);

      if (response.success == true) {
        Navigator.pop(context, true);
      } else {
        errorMessage = response.data.toString();
        setState(() {});
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
    ////code
    ///Navigator.pop(context, true);
  }

  FutureOr onGoBack(dynamic value) {
    loadData();
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text('${form?['title'] ?? 'Edit VISA Application'}'),
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Builder(builder: (context) {
        if (form != null) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Title',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const Divider(),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.text_fields),
                            border: InputBorder.none,
                            hintText: "Title"),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text('Personal Info',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: DropdownButtonFormField2<String>(
                          isExpanded: true,
                          value: selectedPrefix,
                          decoration: InputDecoration(
                            // Add Horizontal padding using menuItemStyleData.padding so it matches
                            // the menu padding when button's width is not specified.
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            // Add more decoration..
                          ),
                          hint: const Text(
                            'choose title',
                            style: TextStyle(fontSize: 14),
                          ),
                          items: prefixItems
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          validator: (value) {
                            if (value == null) {
                              return 'choose title.';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            //Do something when selected item is changed.
                          },
                          onSaved: (value) {
                            selectedPrefix = value.toString();
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.only(right: 8),
                          ),
                          iconStyleData: const IconStyleData(
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black45,
                            ),
                            iconSize: 24,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        flex: 7,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextField(
                              controller: fnameController,
                              decoration: const InputDecoration(
                                  suffixIcon: Icon(Icons.text_format),
                                  border: InputBorder.none,
                                  hintText: "First Name"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextField(
                              controller: mnameController,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Middle Name"),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextField(
                              controller: lnameController,
                              decoration: const InputDecoration(
                                  suffixIcon: Icon(Icons.family_restroom),
                                  border: InputBorder.none,
                                  hintText: "Family Name"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextField(
                              controller: maritalStatusController,
                              decoration: const InputDecoration(
                                  suffixIcon: Icon(Icons.circle_outlined),
                                  border: InputBorder.none,
                                  hintText: "Marital Status"),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextField(
                              controller: nationalityController,
                              decoration: const InputDecoration(
                                  suffixIcon: Icon(Icons.flag),
                                  border: InputBorder.none,
                                  hintText: "Nationality"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextField(
                              controller: placeOfBirthController,
                              decoration: const InputDecoration(
                                  suffixIcon:
                                      Icon(Icons.local_hospital_outlined),
                                  border: InputBorder.none,
                                  hintText: "Place of Birth"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0.0),
                            child: ListTile(
                              leading: const Icon(Icons.baby_changing_station),
                              title: Text(
                                  DateFormat('yyyy-MM-dd').format(dateOfBirth)),
                              subtitle: const Text('Date of Birth'),
                              onTap: () {
                                showMaterialDatePicker(
                                    context: context,
                                    title: 'Pick your birth date',
                                    selectedDate: dateOfBirth,
                                    onChanged: (value) =>
                                        setState(() => dateOfBirth = value),
                                    firstDate: DateTime(1900, 1, 1),
                                    lastDate: DateTime(2100, 1, 1));
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text('Passport Info',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextField(
                              controller: passportNoController,
                              decoration: const InputDecoration(
                                  suffixIcon: Icon(Icons.numbers),
                                  border: InputBorder.none,
                                  hintText: "Passport No."),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextField(
                              controller: placeOfIssueController,
                              decoration: const InputDecoration(
                                  suffixIcon: Icon(Icons.local_police),
                                  border: InputBorder.none,
                                  hintText: "Place of Issue"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0.0),
                            child: ListTile(
                              leading: const Icon(Icons.checklist_rtl),
                              title: Text(
                                  DateFormat('yyyy-MM-dd').format(dateOfIssue)),
                              subtitle: const Text('Date of Issue'),
                              onTap: () {
                                showMaterialDatePicker(
                                    context: context,
                                    title: 'Pick date of issue',
                                    selectedDate: dateOfIssue,
                                    onChanged: (value) =>
                                        setState(() => dateOfIssue = value),
                                    firstDate: DateTime(1900, 1, 1),
                                    lastDate: DateTime(2100, 1, 1));
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0.0),
                            child: ListTile(
                              leading: const Icon(Icons.timelapse),
                              title: Text(DateFormat('yyyy-MM-dd')
                                  .format(dateOfExpiry)),
                              subtitle: const Text('Date of Expiry'),
                              onTap: () {
                                showMaterialDatePicker(
                                    context: context,
                                    title: 'Pick date of expiry',
                                    selectedDate: dateOfExpiry,
                                    onChanged: (value) =>
                                        setState(() => dateOfExpiry = value),
                                    firstDate: DateTime(1900, 1, 1),
                                    lastDate: DateTime(2100, 1, 1));
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text('Residence Info',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextField(
                              controller: occupationController,
                              decoration: const InputDecoration(
                                  suffixIcon: Icon(Icons.cases),
                                  border: InputBorder.none,
                                  hintText: "Your current occupation"),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextField(
                              controller: addrDomController,
                              decoration: const InputDecoration(
                                  suffixIcon: Icon(Icons.home_filled),
                                  border: InputBorder.none,
                                  hintText: "Address in Lao PDR"),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextField(
                              controller: addrDomTelController,
                              decoration: const InputDecoration(
                                  suffixIcon: Icon(Icons.phone),
                                  border: InputBorder.none,
                                  hintText: "Tel."),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextField(
                              controller: addrPermController,
                              decoration: const InputDecoration(
                                  suffixIcon: Icon(Icons.flag),
                                  border: InputBorder.none,
                                  hintText: "Address in Country of Resident"),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextField(
                              controller: addrPermTelController,
                              decoration: const InputDecoration(
                                  suffixIcon: Icon(Icons.phone),
                                  border: InputBorder.none,
                                  hintText: "Tel."),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextField(
                              controller: addrPermEmailController,
                              decoration: const InputDecoration(
                                  suffixIcon: Icon(Icons.email),
                                  border: InputBorder.none,
                                  hintText: "Email"),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text('Travel Info',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextField(
                              controller: addrDesController,
                              decoration: const InputDecoration(
                                  suffixIcon: Icon(Icons.location_on),
                                  border: InputBorder.none,
                                  hintText: "Proposed Address in Thailand"),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: ListTile(
                            leading: const Icon(Icons.card_travel),
                            title: Text(
                                DateFormat('yyyy-MM-dd').format(dateOfArrival)),
                            subtitle: const Text('Date of Arrival'),
                            onTap: () {
                              showMaterialDatePicker(
                                  context: context,
                                  title: 'Pick date of arrival',
                                  selectedDate: dateOfArrival,
                                  onChanged: (value) =>
                                      setState(() => dateOfArrival = value),
                                  firstDate: DateTime(1900, 1, 1),
                                  lastDate: DateTime(2100, 1, 1));
                            },
                          ),
                        ),
                      )),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextField(
                              controller: durationOfStayController,
                              decoration: const InputDecoration(
                                  suffixIcon: Icon(Icons.sunny),
                                  border: InputBorder.none,
                                  hintText: "Duration of Stay"),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextField(
                              controller: travelByController,
                              decoration: const InputDecoration(
                                  suffixIcon: Icon(Icons.airplanemode_active),
                                  border: InputBorder.none,
                                  hintText: "Travel By"),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text('Name & Contact of Guarantor in Thailand',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextField(
                              controller: guarantorDesNameController,
                              decoration: const InputDecoration(
                                  suffixIcon: Icon(Icons.person),
                                  border: InputBorder.none,
                                  hintText: "Name"),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextField(
                              controller: guarantorDesTelController,
                              decoration: const InputDecoration(
                                  suffixIcon: Icon(Icons.phone),
                                  border: InputBorder.none,
                                  hintText: "Tel"),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text('Name & Contact of Guarantor in Lao PDR',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextField(
                              controller: guarantorDomNameController,
                              decoration: const InputDecoration(
                                  suffixIcon: Icon(Icons.person),
                                  border: InputBorder.none,
                                  hintText: "Name"),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextField(
                              controller: guarantorDomTelController,
                              decoration: const InputDecoration(
                                  suffixIcon: Icon(Icons.phone),
                                  border: InputBorder.none,
                                  hintText: "Tel"),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  if (errorMessage != null)
                    Text(
                      errorMessage ?? '-99',
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                ],
              ),
            ),
          );
        } else {
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  semanticsLabel: 'Circular progress indicator',
                ),
              ))
            ],
          );
        }
      }),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        //tooltip: 'Increment',
        label: Text(
          'Save Change',
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ),
        onPressed: updateForm,
        icon: Icon(Icons.save,
            color: Theme.of(context).colorScheme.onSecondary, size: 28),
      ),
    );
  }
}
