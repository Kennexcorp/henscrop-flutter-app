import 'package:flutter/material.dart';
import 'package:henscrop/widgets/right_drawer.dart';

class DocumentPage extends StatefulWidget {
  DocumentPage({Key key}) : super(key: key);

  @override
  _DocumentPageState createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Documents'),),
      body: Center(
        child: Icon(
          Icons.file_copy_sharp,
          size: 120.0,
          color: Colors.blue,
        ),
      ),
      drawer: const RightDrawer(),
    );
  }
}