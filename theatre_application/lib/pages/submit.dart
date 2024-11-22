import '../resource.dart';
import 'package:flutter/material.dart';

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

  final _resource = Resource("","","",false);

  @override
  void dispose() {
    nameController.dispose();
    locationController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.inversePrimary, width: 3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Form(
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
      ),
    );
  }
}
