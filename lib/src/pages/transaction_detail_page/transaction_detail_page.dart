import 'package:bmg/src/models/transaction_model.dart';
import 'package:flutter/material.dart';

class TransactionDetailPage extends StatefulWidget {
  final Transaction transaction;
  const TransactionDetailPage({super.key, required this.transaction});

  static const routeName = '/transaction_detail_page';

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Détail de la transaction"),
      ),
      body: Center(
        child: Column(
          children: [
            Text("Titre: ${widget.transaction.title}"),
            Text("Description: ${widget.transaction.description}"),
            Text("Montant: ${widget.transaction.amount}"),
            Text("Date de création: ${widget.transaction.creationDate}"),
            Text("Date de complétion: ${widget.transaction.completedDate}"),
            Text("Créateur: ${widget.transaction.creator}"),
            Text("Type: ${widget.transaction.type}"),
          ],
        ),
      ),
    );
  }
}
