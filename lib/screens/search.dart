import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:note/models/note.dart';
import 'package:note/screens/Notes.dart';
import 'package:note/utils/database_helper.dart';
import 'package:sqflite/sqlite_api.dart';

import 'AddNote.dart';

class Search extends StatefulWidget {
  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<Search> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteListSearch = List<Note>();

  NotesState notes = NotesState();

  @override
  void initState() {
    setState(() {
      updateListView();
      noteListSearch = notes.noteList;

      if (notes.noteList == null) {
        notes.noteList = List<Note>();
        noteListSearch = List<Note>();
        updateListView();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: noteListSearch.length + 1,
        itemBuilder: (BuildContext context, int index) {
          return index == 0 ? _searchbar() : _ListItems(index - 1);
        });
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          notes.noteList = noteList;
          this.noteListSearch = notes.noteList;
          //this.count = noteListSearch.length;
        });
      });
    });
  }

  _searchbar() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search...",
        ),
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            noteListSearch = notes.noteList.where((note) {
              var noteTitle = note.title.toLowerCase();
              return noteTitle.contains(text);
            }).toList();
          });
        },
      ),
    );
  }

  _ListItems(index) {
    return Card(
      color: notes.getRandomColors(index, noteListSearch),
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        title: Text(
          noteListSearch[index].title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 15.0,
          ),
        ),
        subtitle: Text(
          noteListSearch[index].date,
        ),
        trailing: GestureDetector(
          child: Icon(
            Icons.delete,
            color: Colors.grey,
          ),
          onTap: () {
            notes.delete(context, noteListSearch[index]);
          },
        ),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return AddNote(
                note: noteListSearch[index], appBarTitle: "Edit Note");
          }));
        },
      ),
    );
  }
}
