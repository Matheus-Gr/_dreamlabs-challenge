import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '_dreamlabs challenge',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: '_dreamlabs challenge'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

//Color Picker
List gradients = [
  [Color(0xFFFF9800), Color(0xFFEE0505)],
  [Color(0xFFFFFB03), Color(0xFFFF8E03)],
  [Color(0xFFCDDC39), Color(0xFF30E522)],
  [Color(0xFF13F1D5), Color(0xFF17AA37)],
  [Color(0xFF36D1DC), Color(0xFF3D6BDC)],
  [Color(0xFFFA02B4), Color(0xFF9F00F5)]
];

class _MyHomePageState extends State<MyHomePage> {
  //Color Picker
  int currentGradient = 0;

  //Read Posts
  Future<List<Card>> _getCards() async {
    var data =
        await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));
    var jsonData = json.decode(data.body);

    List<Card> cards = [];

    for (var item in jsonData) {
      Card card =
          Card(item["id"], item["title"], item["body"], currentGradient);
      cards.add(card);
      if (currentGradient == gradients.length - 1) {
        currentGradient = 0;
      } else {
        currentGradient += 1;
      }
    }

    return cards;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getCards(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                  child: Center(child: Text("Loading, please wait...")));
            } else {
              return ListView.separated(
                  padding: const EdgeInsets.all(15),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int id) {
                    return Container(
                        padding: const EdgeInsets.only(bottom: 25, top: 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: gradients[snapshot.data[id].gradientId]),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(1, 5), // changes position of shadow
                            ),
                          ],
                        ),
                        child: ListTile(
                          trailing: FlutterLogo(),
                          title: Text(
                            snapshot.data[id].title,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            snapshot.data[id].body,
                            style: GoogleFonts.roboto(
                                fontSize: 14, color: Color(0xFF222222)),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) =>
                                        DetailPage(snapshot.data[id])));
                          },
                        ));
                  },
                  separatorBuilder: (BuildContext context, int id) {
                    return SizedBox(
                      height: 15,
                    );
                  });
            }
          },
        ),
      ),
    );
  }
}

class Card {
  final int id;
  final String title;
  final String body;
  final int gradientId;

  Card(this.id, this.title, this.body, this.gradientId);
}

class DetailPage extends StatelessWidget {
  final Card card;

  DetailPage(this.card);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(card.title),
        backgroundColor: gradients[card.gradientId][0],
      ),
      body: new Container(
          padding: EdgeInsets.all(40),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: gradients[card.gradientId]),
          ),
          child: Center(
              child: Text(card.body,
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold, fontSize: 20)))),
    );
  }
}
