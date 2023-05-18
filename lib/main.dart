import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main()  {
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController endpointController = TextEditingController();
  String serverResponse = '';

  Future<void> sendData() async {
    final name = nameController.text;
    final endpoint = endpointController.text;

    if (name.isEmpty || endpoint.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please provide both endpoint URL and your name'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    final response = await http.post(
      Uri.parse('http://$endpoint/api/hello'),
      //Uri.parse('https://64537f59c18adbbdfe9ee461.mockapi.io/flutter'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode == 200) {
      setState(() {
        serverResponse = response.body;
      });
    } else {
      setState(() {
        serverResponse = 'Error occurred during request';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Hello App'),
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: endpointController,
                decoration: const InputDecoration(labelText: 'API Endpoint'),
              ),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Your Name'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: sendData,
                child: const Text('Submit'),
              ),
              const SizedBox(height: 20),
              const Text('Server Response:'),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(serverResponse),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
