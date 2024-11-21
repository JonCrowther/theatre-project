import '../resource.dart';
import 'package:flutter/material.dart';


class FormWidget extends StatefulWidget {
 const FormWidget({super.key, required this.resource});

  final Resource resource;

  @override
  State<StatefulWidget> createState() => _FormWidget();
}

class _FormWidget extends State<FormWidget> {
  TextEditingController? nameController;
  TextEditingController? locationController;

  @override
  void initState() {
    nameController = TextEditingController.fromValue(TextEditingValue(text: widget.resource.name));
    locationController = TextEditingController.fromValue(TextEditingValue(text: widget.resource.location));
    super.initState();
  }

  @override
  void dispose() {
    nameController!.dispose();
    locationController!.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
              Switch(
                value: widget.resource.available, 
                onChanged: (value) {
                  setState(() {
                    widget.resource.available = value;
                  });
                },
              )
            ],
          ),
          const Padding(padding: EdgeInsets.only(top: 5)),
          Row(
            children: [
              TextButton(
                onPressed: (){
                  if (_formKey.currentState!.validate()) {
                    widget.resource.name = nameController!.text;
                    widget.resource.location = locationController!.text;
                    widget.resource.addResource();
                    Navigator.pop(context, "Submit");
                  }
                },
                child: const Text("Submit"),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.pop(context, "Cancel"),
                child: const Text("Cancel"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}