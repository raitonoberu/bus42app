import 'package:flutter/material.dart';

import 'widgets.dart';

class Selector extends StatefulWidget {
  final String title;
  final Future<List> itemsGetter;
  final Function titleFormatter;

  Selector(this.title, this.itemsGetter, this.titleFormatter);

  @override
  _SelectorState createState() => _SelectorState();
}

class _SelectorState extends State<Selector> {
  List items = [];
  bool isLoaded = false;

  @override
  Widget build(BuildContext context) {
    if (!isLoaded) {
      return Scaffold(
          appBar: appBar(widget.title),
          body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: appBar(widget.title),
      body: ListView.separated(
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          String title = widget.titleFormatter(items[index]);
          return ListTile(
            title: Text(title),
            onTap: () {
              Navigator.pop(context, items[index]);
            },
          );
        },
        itemCount: items.length,
        separatorBuilder: (context, index) {
          return Divider(
            height: 0,
          );
        },
      ),
    );
  }

  Future initialize() async {
    items = await widget.itemsGetter;
    isLoaded = true;
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }
}
