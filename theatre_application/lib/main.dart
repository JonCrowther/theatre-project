import 'resource.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:theatre_application/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Theatre Application',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Theatre Application Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 300,
              child: ResourceForm(),
            )
          ],
        ),
      ),
    );
  }
}

class ResourceForm extends StatefulWidget {
  const ResourceForm({super.key});

  @override
  State<ResourceForm> createState() => _ResourceForm();
}

class _ResourceForm extends State<ResourceForm> {
  final nameController = TextEditingController();
  final locationController = TextEditingController();
  final availableController = TextEditingController();

  final _resource = Resource();

  @override
  void dispose() {
    nameController.dispose();
    locationController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: "Name of Object",
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the name of the object';
              }
              return null;
            },
          ),
          TextFormField(
            controller: locationController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: "Location",
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a location';
              }
              return null;
            },
          ),
          Row(
            children: <Widget>[
              const Text("Is it available?"),
              const Spacer(),
              Switch(value: _resource.available, 
              onChanged: (value) {
                setState(() {
                  _resource.available = value;
                });
              },
              )
            ],
          ),

          ElevatedButton(
            onPressed: (){
              if (_formKey.currentState!.validate()) {
                _resource.name = nameController.text;
                _resource.location = locationController.text;
                _resource.addResource();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing Data')),
                );
              }
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }
}
