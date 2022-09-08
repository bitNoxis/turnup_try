import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTest extends StatefulWidget {

  const DateTest({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OurDateTest();
}

class _OurDateTest extends State<DateTest> {

  DateTime? start;
  DateTime? end;

  @override
  void initState() {
    super.initState();
    start = null;
    end = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Date Test'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(start != null ? DateFormat.yMd().format(start!) : 'Nothing yet'),
            ElevatedButton(onPressed: () {
              setState(() {
                start = DateTime.now();
                debugPrint(start!.toUtc().toString());
              });
            }, child: const Text('Start Date'))
          ],
        ),
      ),
    );
  }
}
