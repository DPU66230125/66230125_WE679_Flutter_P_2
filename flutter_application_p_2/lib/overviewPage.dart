import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_p_2/api/form.dart';
import 'package:flutter_application_p_2/api/response.dart';
import 'package:flutter_application_p_2/createEditPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

class OverviewPage extends StatefulWidget {
  final dynamic docId;

  const OverviewPage({super.key, required this.docId});

  @override
  State<OverviewPage> createState() => _OveriewPageState();
}

class _OveriewPageState extends State<OverviewPage> {
  dynamic id;
  Map<String, dynamic>? user;
  Map<String, dynamic>? form;
  String? errorMessage;

  Future<void> loadData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final String? userRaw = pref.getString("user");

    if (userRaw != null) {
      user = jsonDecode(userRaw);
      id = widget.docId;

      try {
        APIResponse response = await APIForm.formDetail(id);
        if (response.success == true) {
          form = response.data;
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

  Future<void> _launchUrl() async {
    final Uri _url = Uri.parse('http://54.175.155.216/api/p-2/visa-form-1-result.pdf');

    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
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
          title: Text('${form?['title'] ?? 'Overview'}'),
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
        body: Builder(builder: (context) {
          if (form != null) {
            return Expanded(
                child: SfPdfViewer.network(
                    'http://54.175.155.216/api/p-2/visa-form-1-result.pdf'));
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
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Padding(
            padding: const EdgeInsets.fromLTRB(32, 12, 16, 12),
            child: Row(children: [
              FloatingActionButton.extended(
                backgroundColor: Theme.of(context).colorScheme.error,
                //tooltip: 'Increment',
                label: Text(
                  'Delete',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary),
                ),
                onPressed: () async {
                  BuildContext contextP = context;
                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: const Text('Warning!!!'),
                            content: const Text(
                                'Do you wish to delete this item permanently?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  APIForm.deleteForm(id).then((value) {
                                    Navigator.pop(context);
                                    Navigator.pop(contextP, true);
                                  });
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          ));
                },
                icon: Icon(Icons.delete_forever,
                    color: Theme.of(context).colorScheme.onSecondary, size: 28),
              ),
              Spacer(),
              FloatingActionButton.extended(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                //tooltip: 'Increment',
                label: Text(
                  'Download',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary),
                ),
                onPressed: _launchUrl,
                icon: Icon(Icons.cloud_download,
                    color: Theme.of(context).colorScheme.onSecondary, size: 28),
              ),
              const SizedBox(width: 8),
              FloatingActionButton.extended(
                backgroundColor: Theme.of(context).colorScheme.primary,
                //tooltip: 'Increment',
                label: Text(
                  'Edit',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
                onPressed: () async {
                  //await updatePlanProdLine();
                  final reload = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CreateEditPage(isNew: false, docId: id)));
                  onGoBack(reload);
                },
                icon: Icon(Icons.edit,
                    color: Theme.of(context).colorScheme.onPrimary, size: 28),
              ),
            ])));
  }
}
