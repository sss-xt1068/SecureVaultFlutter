import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

int globalcount;

class Database extends StatefulWidget {
  int atcount;
  Database({
    @required this.atcount,
  });

  DatabaseState createState() => DatabaseState(atcount: atcount);
}

class DatabaseState extends State<Database> {
  int atcount;
  DatabaseState({
    @required this.atcount,
  });
  Widget build(BuildContext context) {
    globalcount = atcount;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Unauthorized Attempts ',
          style: TextStyle(fontFamily: 'Montserrat'),
        ),
      ),
      body: myBody(context),
      bottomSheet: Container(height:13,width: double.infinity,alignment: Alignment.center,
        child: Text('Unathorized attempts stored in /SecureVault',style: TextStyle(fontSize: 12),)),
    );
  }

  Widget myBody(BuildContext context) {
    return Container(
      //color: Colors.greenAccent,
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('datetimelogs').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());
        return ListView.separated(
          //reverse: true,
          //itemExtent: 80,
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) =>
              _buildListItems(context, snapshot.data.documents[index]),
          separatorBuilder: (BuildContext context, int index) => const Divider(
            color: Colors.red,
            thickness: 2,
          ),
        );
      },
    );
  }

  Widget _buildListItems(BuildContext context, DocumentSnapshot document) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              document['when'],
              style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
