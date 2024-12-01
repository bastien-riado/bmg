import 'package:bmg/src/models/transaction_model.dart';
import 'package:flutter/material.dart';

class TransactionProvider extends ChangeNotifier {
  final Transaction _transaction = Transaction(
    id: 0,
    title: '',
    creator: '',
    paymentMethod: '',
    creationDate: DateTime.now(),
    amount: 0,
    type: TransactionType.income,
    category: TransactionCategory.other,
    status: TransactionStatus.pending,
  );

  Transaction get transaction => _transaction;

  void setTitle(String title) {
    _transaction.title = title;
    notifyListeners();
  }

  void setCreator(String creator) {
    _transaction.creator = creator;
    notifyListeners();
  }

  void setPaymentMethod(String paymentMethod) {
    _transaction.paymentMethod = paymentMethod;
    notifyListeners();
  }

  void setCreationDate(DateTime creationDate) {
    _transaction.creationDate = creationDate;
    notifyListeners();
  }

  void setCompletedDate(DateTime? completedDate) {
    _transaction.completedDate = completedDate;
    notifyListeners();
  }

  void setAmount(double amount) {
    _transaction.amount = amount;
    notifyListeners();
  }

  void setDescription(String? description) {
    _transaction.description = description;
    notifyListeners();
  }

  void setType(TransactionType type) {
    _transaction.type = type;
    notifyListeners();
  }

  void setCategory(TransactionCategory category) {
    _transaction.category = category;
    notifyListeners();
  }

  void setStatus(TransactionStatus status) {
    _transaction.status = status;
    notifyListeners();
  }

  void setEventId(int? eventId) {
    _transaction.eventId = eventId;
    notifyListeners();
  }

  void setLastModifiedBy(String? lastModifiedBy) {
    _transaction.lastModifiedBy = lastModifiedBy;
    notifyListeners();
  }

  void setLastModifiedDate(DateTime? lastModifiedDate) {
    _transaction.lastModifiedDate = lastModifiedDate;
    notifyListeners();
  }
}
