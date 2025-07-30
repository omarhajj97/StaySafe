import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';

import 'package:stay_safe/ui/widgets/contact_card.dart';
import 'package:stay_safe/constants.dart';
import 'package:location/location.dart';

class NearbyInterface extends StatefulWidget {
  static const String id = 'nearby_interface';

  @override
  _NearbyInterfaceState createState() => _NearbyInterfaceState();
}


class _NearbyInterfaceState extends State<NearbyInterface> {
  Location location = Location();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Firestore _firestore = Firestore.instance;
  final Strategy strategy = Strategy.P2P_STAR;
  FirebaseUser loggedInUser;
  String testText = '';
  final _auth = FirebaseAuth.instance;
  List<dynamic> contactTraces = [];
  List<dynamic> contactTimes = [];
  List<dynamic> contactLocations = [];
   List<dynamic> infection = [];

 void addContactsToList() async {
    await getCurrentUser();
    _firestore
        .collection('users')
        .document(loggedInUser.email)
        .collection('met_with')
        .snapshots()
        .listen((snapshot) {
 
   for (var doc in snapshot.documents) {
        String currEmail = doc.data['email'];
        DateTime currTime = doc.data.containsKey('contact time')
            ? (doc.data['contact time'] as Timestamp).toDate()
            : null;
        String currLocation = doc.data.containsKey('contact location')
            ? doc.data['contact location']
            : null;
        String _infection = doc.data['infected'];
        if (!contactTraces.contains(currEmail)) {
          contactTraces.add(currEmail);
          contactTimes.add(currTime);
          contactLocations.add(currLocation);
          infection.add(_infection);
        }
      }
      setState(() {});
      print(loggedInUser.email);
    });
  }

  void deleteOldContacts(int threshold) async {
    await getCurrentUser();
    DateTime timeNow = DateTime.now(); //get today's time

    _firestore
        .collection('users')
        .document(loggedInUser.email)
        .collection('met_with')
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.documents) {
         if (doc.data.containsKey('contact time')) {
          DateTime contactTime = (doc.data['contact time'] as Timestamp).toDate(); // get last contact time
          // if time since contact is greater than threshold than remove the contact
          if (timeNow.difference(contactTime).inDays > threshold) {
            doc.reference.delete();
          }
        }
      }
      setState(() {});
    });
  }
  void discovery() async {
    try {
      bool a = await Nearby().startDiscovery(loggedInUser.email, strategy,
          onEndpointFound: (id, name, serviceId) async {
        print('I saw id:$id with name:$name'); // the name here is an email

        var docRef =
            _firestore.collection('users').document(loggedInUser.email);

        //  When I discover someone I will see their email
        docRef.collection('met_with').document(name).setData({
          'email': await getUsernameOfEmail(email: name),
          'contact time': DateTime.now() as Timestamp,
          'contact location': location.getLocation(),
        });
      }, onEndpointLost: (id) {
        print(id);
      });
      print('DISCOVERING: ${a.toString()}');                                                      
    } catch (e) {
      print(e);
    }
  }

  void getPermissions() {
    Nearby().askLocationAndExternalStoragePermission();
  }

  Future<String> getUsernameOfEmail({String email}) async {
    String res = '';
    await _firestore.collection('users').document(email).get().then((doc) {
      if (doc.exists) {
        res = doc.data['firstName'];
      } else {
        // doc.data() will be undefined in this case
        print("No such document!");
      }
    });
    return res;
  }

  Future<void> getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

 
 
 @override
  void initState() {
    super.initState();
    deleteOldContacts(14);
    addContactsToList();
    getPermissions();
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
      Column(

        children: <Widget>[ 
      
          Expanded(

            child: Padding(
              padding: EdgeInsets.only(
                left: 25.0,
                right: 25.0,
                bottom: 10.0,
                top: 30.0,
              ),
              child: Container(
                height: 100.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.red[500],
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 4.0,
                      spreadRadius: 0.0,
                      offset:
                          Offset(2.0, 2.0), // shadow direction: bottom right
                    )
                  ],
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: //Image(
                       // image: AssetImage('assets/images/corona.png'),
                     // ),
                   Icon( Icons.contacts,size: 50 , color: Colors.white,)),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Your Contact Traces',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 21.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 30.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              elevation: 5.0,
              color: Colors.red[400],
              onPressed: () async {
                try {
                  bool a = await Nearby().startAdvertising(
                    loggedInUser.email,
                    strategy,
                    onConnectionInitiated: null,
                    onConnectionResult: (id, status) {
                      print(status);
                    },
                    onDisconnected: (id) {
                      print('Disconnected $id');
                    },
                  );

                  print('ADVERTISING ${a.toString()}');
                } catch (e) {
                  print(e);
                }

                discovery();
              },
              child: Text(
                'Start Tracing',
                style: kButtonTextStyle,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return ContactCard(
                    imagePath: 'assets/images/profile1.jpg',
                    email: contactTraces[index],
                    infection: infection[index],
                    contactEmail: contactTraces[index],
                    contactTime: contactTimes[index],
                    contactLocation: contactLocations[index],
                  );
                },
                itemCount: contactTraces.length,
              ),
            ),
          ),
          ],
      ),
      drawer: Drawer(
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
  }
}

// TODO: Integrate nearby_api and Nearby_interface.
// TODO: Take mobile number instead of email
