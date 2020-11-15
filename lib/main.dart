import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Variable datos
var data;

// Futura funcion que cargara el string cuando este listo
Future loadJson() async {
  String data = await rootBundle.loadString('assets/json/biblia.json');
  return json.decode(data);
}

void main() {
  runApp(MainPage());
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Load Json Biblia
  @override
  void initState() {
    loadJson().then((value) {
      setState(() {
        data = value;
        // print(data[0]['description']);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biblia ES',
      home: Scaffold(
          appBar: AppBar(
            title: Text('Biblia'),
          ),
          body: FutureBuilder(
            future: loadJson(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Text('Cargando ..!');
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: 66,
                  itemBuilder: (context, i) {
                    return ExpansionTile(
                      title: Text(snapshot.data[i]['title']),
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data[i]['chapters'].length,
                          itemBuilder: (context, h) {
                            return ExpansionTile(
                              title: Text('Capitulo ' + (h + 1).toString()),
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data[i]['chapters'][h]['verses'].length,
                                  itemBuilder: (context, j) {
                                    return ListTile(
                                      title:
                                          Text((j+1).toString() + '. ' + snapshot.data[i]['chapters'][h]['verses'][j]['text']),
                                    );
                                  },
                                )
                              ],
                            );
                          },
                        )
                      ],
                    );
                  },
                );
              }
            },
          )),
    );
  }
}
