import 'resource.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:theatre_application/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


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
   var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const SubmitResourcePage();
      case 1:
        page = const ResourceListPage();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title),
          ),
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.add_circle_outline), 
                      label: Text("Add Resource"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.search), 
                      label: Text("Find Resource")
                    ),
                  ], 
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

class SubmitResourcePage extends StatelessWidget {
  const SubmitResourcePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 300,
            child: ResourceForm(),
          )
        ],
      )
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

class ResourceListPage extends StatefulWidget {
  const ResourceListPage({super.key});

  @override
  State<ResourceListPage> createState() => _ResourceListPageState();
}

class _ResourceListPageState extends State<ResourceListPage> {
  final CollectionReference _resourceDB = FirebaseFirestore.instance.collection('resources');

  late final resources = _resourceDB.get();
  late final documents = resources.then((value) {
    var d = value.docs;
    // Start with items sorted by resource_name
    d.sort((a,b) => a.get("resource_name").toString().compareTo(b.get("resource_name").toString()));
    return d;
  });
  bool sort = false;
  int sortColumnIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: documents,
        builder: (context, snapshot){
          if (snapshot.hasData) {
            var data = snapshot.data;
            onSortColumn(int columnIndex, bool ascending) {
              String column;
              switch(columnIndex) {
                case 0:
                  column = "resource_name";
                case 1:
                  column = "location";
                default:
                  return;
              }
              if (!ascending) {
                data!.sort((a,b) => a.get(column).toString().compareTo(b.get(column).toString()));
              } else {
                data!.sort((a,b) => b.get(column).toString().compareTo(a.get(column).toString()));
              }
            }

            return DataTable(
              sortAscending: sort,
              sortColumnIndex: sortColumnIndex,
              columns: <DataColumn>[
                DataColumn(
                  label: const Text("Name"),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      if (sortColumnIndex != columnIndex) {
                        sort = true;
                      } else {
                        sort = !sort;
                      }
                      sortColumnIndex = columnIndex;
                    });
                    onSortColumn(columnIndex, ascending);
                  },
                ),
                DataColumn(
                  label: const Text("Location"),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      if (sortColumnIndex != columnIndex) {
                        sort = true;
                      } else {
                        sort = !sort;
                      }
                      sortColumnIndex = columnIndex;
                    });
                    onSortColumn(columnIndex, ascending);
                  },
                  ),
                const DataColumn(label: Text("Available")),
              ], 
              rows: List<DataRow>.generate(
                (){return data!.length;}(),
                (int index) {
                  var document = data![index];
                  return DataRow(
                    cells: <DataCell>[
                      DataCell(Text(document.get("resource_name"))),
                      DataCell(Text(document.get("location"))),
                      DataCell(Text(document.get("available").toString())),
                    ]
                  );
                }
              )
            );
          }
          if (snapshot.hasError) return const Text("error");
          return const CircularProgressIndicator();
        },
      )
    );
  }
}