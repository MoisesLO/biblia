import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
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
                    return Card(
                      child: ExpansionTile(
                        leading: Icon(Icons.book),
                        title: Text(snapshot.data[i]['title']),
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data[i]['chapters'].length,
                            itemBuilder: (context, h) {
                              return Container(
                                child: ExpansionTile(
                                  leading: Icon(Icons.file_copy),
                                  title: Text('Capitulo ' + (h + 1).toString()),
                                  children: [
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemCount: snapshot
                                          .data[i]['chapters'][h]['verses']
                                          .length,
                                      itemBuilder: (context, j) {
                                        return Container(
                                          padding: EdgeInsets.only(
                                              bottom: 5.0,
                                              top: 5.0,
                                              left: 20.0,
                                              right: 5.0),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: Colors.grey,
                                                      width: 0.2))),
                                          child: Text(
                                            (j + 1).toString() +
                                                '. ' +
                                                snapshot.data[i]['chapters'][h]
                                                    ['verses'][j]['text'],
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        );
                                      },
                                    )
                                  ],
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    );
                  },
                );
              }
            },
          )),
    );
  }
}
