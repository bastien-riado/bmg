import 'package:flutter/material.dart';

class AddSalePage extends StatefulWidget {
  const AddSalePage({super.key});

  static const routeName = '/add_sale_page';

  @override
  State<AddSalePage> createState() => _AddSalePageState();
}

class _AddSalePageState extends State<AddSalePage> {
  final _formKey = GlobalKey<FormState>();
  int? _id;
  String? _type;
  double? _price;
  String? _description;

  @override
  Widget build(BuildContext context) {
    final List<String> saleTypes = [
      'Crepes',
      'Boissons',
      'Autres',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter une vente"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Type"),
                value: saleTypes.first,
                items: saleTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  _type = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Prix"),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) =>
                    value!.isEmpty ? 'Le prix est obligatoire' : null,
                onSaved: (value) => _price = double.tryParse(value!),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Description"),
                validator: (value) =>
                    value!.isEmpty ? 'La description est obligatoire' : null,
                onSaved: (value) => _description = value,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Navigator.of(context).pop({
                      'id': _id,
                      'type': _type,
                      'price': _price,
                      'description': _description,
                    });
                  }
                },
                child: const Text("Enregistrer"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
