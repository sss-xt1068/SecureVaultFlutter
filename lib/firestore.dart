import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

int globalcount;
class Database extends StatefulWidget {
  int atcount;
  Database({
    @required this.atcount,
  });

  DatabaseState createState() => DatabaseState(atcount:atcount);
}

class DatabaseState extends State<Database> {
int atcount;
  DatabaseState({
    @required this.atcount,
  });
  Widget build(BuildContext context) {
    globalcount=atcount;
    return Scaffold(
      appBar: AppBar(
        title: Text('Unauthorized Attempts '+atcount.toString()),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('datetimelogs').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        return ListView.builder(
          itemExtent: 80,
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index)=>
          _buildListItems(context, snapshot.data.documents[index]),
        );
      },
    );
  }

  Widget _buildListItems(BuildContext context, DocumentSnapshot document)
  {
    return ListTile(
      title: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              document['when'],
              style: TextStyle(fontSize: 16,fontFamily: 'Roboto'),
            ),
          ),
        ],
      ),
    );
  }
}
