import 'package:flutter/material.dart';
import 'package:stay_safe/ui/screens/advices_page.dart';
import 'package:stay_safe/ui/screens/nearby_interface.dart';

class MyBottomNavigationBar extends StatefulWidget {
  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
 int _currentIndex=0;
 final List<Widget> _children = [
   NearbyInterface(),
   AdvicesPage(),


 ];
 
 void onTappedBar(int index){
   setState((){
     _currentIndex = index;

   });
 }
 
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StaySafe',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
    
 home: Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
      onTap: onTappedBar,
      currentIndex: _currentIndex,
        items:[
          BottomNavigationBarItem(
        icon:new Icon(Icons.home,),
        
        title: new Text("Home")
        ,
        
        ),
          BottomNavigationBarItem(
        icon:new Icon(Icons.help_outline,),
        title: new Text("About COVID-19")
      
        
      ),
      
        ],
            ),

 ),   
    );
         
  }
}