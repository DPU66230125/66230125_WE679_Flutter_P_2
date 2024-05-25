import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_p_2/api/form.dart';
import 'package:flutter_application_p_2/api/response.dart';
import 'package:flutter_application_p_2/loginPage.dart';
import 'package:flutter_application_p_2/overviewPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? user;
  List<dynamic>? myForms;
  String? errorMessage;

  Future<void> logOut() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
  }

  Future<void> loadData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final String? userRaw = pref.getString("user");

    if (userRaw != null) {
      user = jsonDecode(userRaw);
      final userId = user!['id'];

      setState(() {});

      APIForm.myForms(userId).then((value) {
        if (value.success == true) {
          setState(() {
            myForms = value.data;
          });
        } else {
          setState(() {
            errorMessage = value.data.toString();
          });
        }
      }).catchError((onError) {
        setState(() {
          errorMessage = onError.toString();
        });
      });
    }
  }

  Future<void> createForm() async {
    try {
      APIResponse response = await APIForm.createForm(user?['id']);

      if (response.success == true) {
        final dynamic docId = response.data['id'];
        final reload = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OverviewPage(docId: docId)));
        onGoBack(reload);
      } else {
        errorMessage = response.data.toString();
        setState(() {});
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  FutureOr onGoBack(dynamic value) {
    print('GO-BACK');
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
        title: Text(
          'Home',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  if (user != null)
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: Text("${user!['display_name']}"),
                      subtitle: Text(user!['email']),
                      trailing: IconButton(
                          onPressed: () => {
                                logOut(),
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Login()))
                              },
                          icon: const Icon(Icons.logout)),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            if (myForms == null)
              CircularProgressIndicator(
                semanticsLabel: 'Circular progress indicator',
              ),
            if (errorMessage != null)
              Text(
                errorMessage ?? '-99',
                style: TextStyle(color: Colors.red.shade700),
              ),
            if (myForms != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Your History (${myForms?.length} items)',
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 20)),
                      Divider(),
                    ]),
              ),
            if (myForms != null)
              Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.all(8.00),
                    itemCount: myForms?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: Image(
                            image: AssetImage('assets/images/logo_small.png')),
                        title: Text(myForms?[index]['title']),
                        subtitle: Text(
                            "updated at ${myForms?[index]['updated_date']}"),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () async {
                          final reload = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OverviewPage(
                                      docId: myForms?[index]['id'])));
                          onGoBack(reload);
                        },
                      );
                    }),
              ),
            /*SizedBox(height: 32),
            Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('แผนงานอื่นๆ (2 forms)',
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 20)),
                    Divider()
                  ]),
            ),*/
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        //tooltip: 'Increment',
        label: Text(
          'New VISA',
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ),
        onPressed: createForm,
        icon: Icon(Icons.add,
            color: Theme.of(context).colorScheme.onSecondary, size: 28),
      ),
    );
  }
}
