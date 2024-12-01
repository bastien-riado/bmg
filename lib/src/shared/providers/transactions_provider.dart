import 'package:bmg/src/models/transaction_model.dart';
import 'package:flutter/material.dart';

class TransactionsProvider extends ChangeNotifier {
  final List<Transaction> _transactions = [];
  List<Transaction> get transactions => _transactions;
  bool isGridInEdition = false;

  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }

  void removeTransaction(Transaction transaction) {
    _transactions.remove(transaction);
    notifyListeners();
  }

  void updateTransaction(Transaction transaction) {
    final index = _transactions.indexWhere((t) => t.id == transaction.id);
    _transactions[index] = transaction;
    notifyListeners();
  }

  void setIsGridInEdition(bool value) {
    isGridInEdition = value;
    notifyListeners();
  }
}
