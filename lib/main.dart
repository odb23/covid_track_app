import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var caseData;
  CovidCaseInfo info;
  String countryName;
  final myController = TextEditingController();
  Object lastError;

  Future _getCaseData() async {
    NetworkHelper networkHelper = NetworkHelper(
        "https://covid-api.mmediagroup.fr/v1/cases?country=$countryName");

    var _future = await networkHelper.getData();
      info = new CovidCaseInfo.fromJson(_future);
    
     print(info.country);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFF3B77BD),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Covid Track",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                      color: Colors.white,
                    ),
                  )),

              Container(
                padding: EdgeInsets.all(15),
                child: TextField(
                  controller: myController,
                  onChanged: (String val) {
                    countryName = val;
                  },
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    icon: Icon(Icons.location_city, color: Colors.white),
                    hintText: "Enter country name",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              FlatButton(
                onPressed: () {
                  setState(() {
                    _getCaseData();
                  });
                },
                child: Text("Get Information",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              Expanded(
                child: Card(
                  margin: EdgeInsets.all(10),
                  color: Colors.white,
                  child: FutureBuilder(
                    future: _getCaseData(),
                  
                    builder: (context, snapshot) {
                      print("in snapshot");
                      Widget result;

                      if (snapshot.connectionState == ConnectionState.done) {
                       if (snapshot.hasError) {
                        print("snapshot error");
                       result = _handleErrorOrNull(); 
                      }else{
                          print("snapshot has data");
                          result = _buildResult();
                       }
                      }else{
                        result = Center(
                          child: CircularProgressIndicator(),
                        );}
                         
                         return result;
                      }                    
                  
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _handleErrorOrNull() {
    if (countryName == null) {
      return Center(
          child: Text("Waiting for input...", style: TextStyle(fontSize: 20)));
    } else {
      return Center(
          child: Text("Something went wrong!", style: TextStyle(fontSize: 20)));
    }
  }

  Widget _buildResult() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            "Country : ${info.country}",
            style: TextStyle(
              fontSize: 25,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            "Continent : ${info.continent}",
            style: TextStyle(
              fontSize: 25,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            "Location : ${info.location}",
            style: TextStyle(
              fontSize: 25,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            "Confirmed : ${info.confirmed}",
            style: TextStyle(
              fontSize: 25,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            "Recovered : ${info.recovered}",
            style: TextStyle(
              fontSize: 25,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            "Deaths : ${info.deaths}",
            style: TextStyle(
              fontSize: 25,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            "Last Updated : ${info.lastUpdated}",
            style: TextStyle(
              fontSize: 25,
            ),
          ),
        ),
      ],
    );
  }
}

class CovidCaseInfo {
  int confirmed;
  int recovered;
  int deaths;
  String country;
  String continent;
  String location;
  String lastUpdated;

  CovidCaseInfo(
      {this.confirmed,
      this.recovered,
      this.deaths,
      this.country,
      this.continent,
      this.location,
      this.lastUpdated});

  factory CovidCaseInfo.fromJson(Map<String, dynamic> data) {
    return CovidCaseInfo(
      confirmed: data['All']['confirmed'],
      recovered: data['All']['recovered'],
      deaths: data['All']['deaths'],
      country: data['All']['country'],
      continent: data['All']['continent'],
      location: data['All']['location'],
      lastUpdated: data['All']['updated'],
    );
  }
}

class NetworkHelper {
  final String _url;

  NetworkHelper(this._url);

  Future getData() async {
    http.Response response = await http.get(this._url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(response.statusCode);
    }
  }
}

// Uri.https('jsonplaceholder.typicode.com', 'albums/1')
/*
 if (snapshot.connectionState == ConnectionState.waiting) {
                        print("In waiting");
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        print("In done");
                        if (!snapshot.hasError) {
                          print("no error found");
                          _buildResult();
                        } else {
                          _handleErrorOrNull();
                        }
                      } 
                         _handleErrorOrNull();
 */