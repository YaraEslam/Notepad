import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:note/models/note.dart';
import 'package:note/utils/database_helper.dart';
import 'package:sqflite/sqlite_api.dart';

import 'AddNote.dart';

class Notes extends StatefulWidget {
  @override
  NotesState createState() => NotesState();
}

class NotesState extends State<Notes> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    updateListView();
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }

    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: getRandomColors(index, noteList),
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListTile(
              title: Text(
                this.noteList[index].title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                ),
              ),
              subtitle: Text(
                this.noteList[index].date,
              ),
              trailing: GestureDetector(
                child: Icon(
                  Icons.delete,
                  color: Colors.grey,
                ),
                onTap: () {
                  delete(context, noteList[index]);
                },
              ),
              onTap: () {
                debugPrint("ListTile Tapped");
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return AddNote(
                      note: this.noteList[index], appBarTitle: "Edit Note");
                }));
              },
            ),
          );
        });
  }

  // Returns the note color
  Color getRandomColors(int index, List<Note> noteList) {
    int num = new Random().nextInt(10);
    if (noteList != null) {
      num = noteList[index].priority;
    }
    switch (num) {
      case 1:
        return Colors.white;
        break;
      case 2:
        return Colors.cyanAccent;
        break;
      case 3:
        return Colors.pink;
        break;
      case 4:
        return Colors.redAccent;
        break;
      case 5:
        return Colors.deepOrangeAccent;
        break;
      case 6:
        return Colors.yellow;
        break;
      case 7:
        return Colors.green;
        break;
      case 8:
        return Colors.limeAccent;
        break;
      case 9:
        return Colors.purpleAccent;
        break;
      case 10:
        return Colors.blueAccent;
        break;

      default:
        return Colors.white;
    }
  }

  void delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      showSnackBar(context, 'Note Deleted Successfully');
      updateListView();
    }
  }

  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Note note, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddNote(note: note, appBarTitle: title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}
