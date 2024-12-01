import 'package:bmg/src/models/transaction_model.dart';
import 'package:bmg/src/services/transactions_service.dart';
import 'package:flutter/material.dart';

class AddSalePage extends StatefulWidget {
  const AddSalePage({super.key});

  static const routeName = '/add_sale_page';

  @override
  State<AddSalePage> createState() => _AddSalePageState();
}

class _AddSalePageState extends State<AddSalePage> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  String? description;
  late double amount;
  late TransactionCategory category;
  late TransactionType type;
  late String paymentMethod;
  late TransactionStatus status;
  int? eventId;

  @override
  void initState() {
    super.initState();
    category = TransactionCategory.other;
    type = TransactionType.income;
    paymentMethod = 'espèces';
    status = TransactionStatus.pending;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter une transaction"),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Intitulé"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'L\'intitulé est obligatoire';
                      }
                      return null;
                    },
                    onSaved: (value) => title = value!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Montant"),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Le montant est obligatoire';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Veuillez entrer un montant valide';
                      }
                      return null;
                    },
                    onSaved: (value) => amount = double.tryParse(value!)!,
                  ),
                  DropdownButtonFormField<TransactionCategory>(
                    decoration: const InputDecoration(labelText: "Catégorie"),
                    value: category,
                    items: TransactionCategory.values.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      category = value!;
                    },
                  ),
                  DropdownButtonFormField<TransactionType>(
                    decoration: const InputDecoration(labelText: "Type"),
                    value: type,
                    items: TransactionType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      type = value!;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    decoration:
                        const InputDecoration(labelText: "Méthode de paiement"),
                    value: paymentMethod,
                    items: [
                      'espèces',
                      'sumup',
                      'lyf',
                      'virement bancaire',
                      'chèque'
                    ].map((paymentMethod) {
                      return DropdownMenuItem(
                        value: paymentMethod,
                        child: Text(paymentMethod),
                      );
                    }).toList(),
                    onChanged: (value) {
                      paymentMethod = value!;
                    },
                  ),
                  DropdownButtonFormField<TransactionStatus>(
                    decoration: const InputDecoration(labelText: "Statut"),
                    value: status,
                    items: TransactionStatus.values.map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      status = value!;
                    },
                  ),
                  TextFormField(
                      decoration:
                          const InputDecoration(labelText: "Description"),
                      onSaved: (value) {
                        description = value ?? '';
                      }),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: "ID de l'événement"),
                    keyboardType: const TextInputType.numberWithOptions(),
                    onSaved: (value) {
                      if (value == null || value.isEmpty) {
                        eventId = null;
                      } else {
                        eventId = int.tryParse(value);
                        if (eventId == null) {
                          throw Exception('Invalid event ID format');
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        try {
                          final newTransaction = Transaction(
                            id: DateTime.now().millisecondsSinceEpoch,
                            title: title,
                            creator: 'admin',
                            paymentMethod: paymentMethod,
                            creationDate: DateTime.now(),
                            completedDate: status == TransactionStatus.completed
                                ? DateTime.now()
                                : null,
                            amount: amount,
                            description: description,
                            type: type,
                            category: category,
                            status: status,
                            eventId: eventId,
                            lastModifiedBy: 'admin',
                            lastModifiedDate: DateTime.now(),
                          );

                          await TransactionsService()
                              .addTransaction(newTransaction);
                          Navigator.of(context).pop(true);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Transaction ajoutée avec succès')),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Erreur: $e')),
                          );
                        }
                      }
                    },
                    child: const Text("Enregistrer"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
