import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stay_safe/models/who_advice.dart';
import 'package:stay_safe/models/who_topic.dart';
import 'package:stay_safe/topic.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdvicesPage extends StatefulWidget {
  AdvicesPage({Key key}) : super(key: key);

  @override
  _AdvicesPage createState() => _AdvicesPage();
}

class _AdvicesPage extends State<AdvicesPage> {
  Future<WHOAdvice> _adviceFuture;
  final _auth = FirebaseAuth.instance;
  Firestore _firestore = Firestore.instance; 
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    _fetchData();
    super.initState();
  }
 Future<String> getEmail() async {
  String _email = (await FirebaseAuth.instance.currentUser()).email;
  DocumentSnapshot snapshot = await _firestore.collection('users')
    .document(_email)
    .get();
 // print("data: ${snapshot.data}"); // might be useful to check
  return snapshot.data['email']; // or another key, depending on how it's saved
}


 Future<String> getFullName() async {
  String _email= (await FirebaseAuth.instance.currentUser()).email;
  DocumentSnapshot snapshot = await _firestore.collection('users')
  .document(_email)
  .get();
  print("data: ${snapshot.data}"); // might be useful to check
  return snapshot.data['firstName']; // or another key, depending on how it's saved
}


 Future<String> getPhoneNumber() async {
  String _email = (await FirebaseAuth.instance.currentUser()).email;
  DocumentSnapshot snapshot = await _firestore.collection('users')
   .document(_email)
   .get();
  print("data: ${snapshot.data}"); // might be useful to check
  return snapshot.data['phoneNb']; // or another key, depending on how it's saved
}

 Future<String> getInfection() async {
  String _email = (await FirebaseAuth.instance.currentUser()).email;
  DocumentSnapshot snapshot = await _firestore.collection('users')
   .document(_email)
   .get();
  print("data: ${snapshot.data}"); // might be useful to check
  return snapshot.data['infected']; // or another key, depending on how it's saved
}
  _fetchData() {
    _adviceFuture = _loadJSONFile();
  }

  Future<WHOAdvice> _loadJSONFile() async {
    final jsonString = await DefaultAssetBundle.of(context)
        .loadString("assets/who_corona_advice.json");
    final json = await jsonDecode(jsonString);
    final advices = WHOAdvice.fromJson(json);
    return advices;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        key:_scaffoldKey,


        appBar: AppBar(
          elevation: 0.5,
          leading: new IconButton(
              icon: new Icon(Icons.menu),
              color: Colors.red[800],
              onPressed: () => _scaffoldKey.currentState.openDrawer()
          ),
          centerTitle: true,
          title: Text(
            'StaySafe',
            style: TextStyle(
              color: Colors.red[800],
              fontWeight: FontWeight.bold,
              fontSize: 28.0,
            ),
          ),


          backgroundColor: Colors.white, ),
    body:
     FutureBuilder(
      future: _adviceFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: EdgeInsets.only(top: 16, bottom: 16),
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.error != null) {
          return Center(
            child: Text('An error has occured'),
          );
        } else {
          final WHOAdvice advice = snapshot.data;
          var children = List<Widget>();

          advice.topics.forEach((element) {
            children.add(TopicCardWidget(
              topic: element,
            ));
          });

          children.add(SectionCardWidget(
            title: advice.title,
            description: advice.subtitle,
          ));

          advice.basics.forEach((element) {
            children.add(SectionCardWidget(
              title: element.title,
              description: element.subtitle,
            ));
          });

          return Center(
              child: Container(
                  constraints: BoxConstraints(maxWidth: 768),
                  child: ListView(
                      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                      children: children)));
        }
      },
     ),
  drawer:  Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
             child: Column(children:
             <Widget>[
             Text("StaySafe Profile",textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red,fontSize: 21)),
              Expanded(child:
            FutureBuilder<String>(
    future: getEmail(),
    builder: (context, snapshot) {
      if(!snapshot.hasData) {
        return CircularProgressIndicator(); // or null, or any other widgets
      }
      return Text( "Email: " + snapshot.data);
    },
  ),
              ),
                         Expanded(child:
            FutureBuilder<String>(
    future: getFullName(),
    builder: (context, snapshot) {
      if(!snapshot.hasData) {
        return CircularProgressIndicator(); // or null, or any other widget
      }
      return Text( "Full Name: " + snapshot.data);
    },
  ),
              ),
              
                         Expanded(child:
            FutureBuilder<String>(
    future: getPhoneNumber(),
    builder: (context, snapshot) {
      if(!snapshot.hasData) {
        return Text( "Phone Number: Not Available"); // or null, or any other widget
      }
      return Text( "Phone Number: " + snapshot.data);
    },
  ),
              ),
                  Expanded(child:
            FutureBuilder<String>(
    future: getInfection(),
    builder: (context, snapshot) {
      if(!snapshot.hasData) {
        return CircularProgressIndicator(); // or null, or any other widget
      }
      return Text( "Status: " + snapshot.data);
    },
  ),
              ),
              ],
             ),
            ),
            ListTile(
              title: Text('Log Out', textAlign: TextAlign.center,),
              onTap: () {
                _logOut();
                _scaffoldKey.currentState.openEndDrawer();
              },
            ),
     
       ],
        ),
        ),
           );
  }
void _logOut() async {
    _auth.signOut();
  }}

class TopicCardWidget extends StatelessWidget {
  final WHOTopic topic;

  TopicCardWidget({this.topic});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 16),
        child: Card(
            child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TopicDetailWidget(
                        topic: topic,
                      )),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                trailing: Icon(Icons.arrow_forward),
                title: Text(topic.title),
              ),
            ],
          ),
        )));
  }
}

class SectionCardWidget extends StatelessWidget {
  final String title;
  final String description;

  SectionCardWidget({this.title, this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 16),
        child: Card(
            child: Padding(
          padding: EdgeInsets.only(top: 16, bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(title),
                subtitle: Padding(
                    padding: EdgeInsets.only(top: 8), child: Text(description)),
              ),
            ],
          ),
        )));
  }
}