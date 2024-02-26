import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_calendar_1_17_4/widgets/calendar_date_picker_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // _selectedDate = DateTime(
    //   DateTime.now().year,
    //   DateTime.now().month,
    //   DateTime.now().day,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: FlatButton(
          onPressed: () async {
            final result = await showDatePickerBottomSheet(context);
            log('$result');
          },
          child: Text('Show Calendar'),
        ),
      ),
    );
  }
}
