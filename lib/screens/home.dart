import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:note/models/note.dart';
import 'package:note/screens/AddNote.dart';
import 'package:note/screens/Notes.dart';
import 'package:note/screens/search.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  NotesState notes = NotesState();
  int _page;

  @override
  void initState() {
    super.initState();
    _page = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text(
          "Note",
          style: TextStyle(
              color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: new Icon(Icons.add),
              iconSize: 25.0,
              color: Colors.white,
              onPressed: () {
//                notes.navigateToDetail(Note('', '', 2), "Add Note");
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return AddNote(
                      note: Note('', '', 2), appBarTitle: "Add Note");
                }));
              },
            ),
          )
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Colors.cyan, //black,
        buttonBackgroundColor: Colors.cyan, //grey[400],
        height: 50,
        animationDuration: Duration(milliseconds: 200),
        animationCurve: Curves.bounceInOut,
        index: 1,
        items: <Widget>[
          Icon(
            Icons.search,
            size: 30.0,
            color: Colors.white,
          ),
          Icon(
            Icons.home,
            size: 30.0,
            color: Colors.white,
          ),
        ],
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
      body: _pageBody(),
    );
  }

  _pageBody() {
    switch (_page) {
      case 0:
        return Search();
      case 1:
        return Notes();
    }
  }
}
