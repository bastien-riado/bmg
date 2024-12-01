import 'package:bmg/src/models/transaction_model.dart' as bmg;
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionsService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<bmg.Transaction> get transactions {
    return _db.collection('transactions').withConverter<bmg.Transaction>(
          fromFirestore: (snapshot, _) =>
              bmg.Transaction.fromFirestore(snapshot.data() ?? {}, snapshot.id),
          toFirestore: (transaction, _) => transaction.toFirestore(),
        );
  }

  Future<void> addTransaction(bmg.Transaction transaction) async {
    try {
      await transactions.doc(transaction.id.toString()).set(transaction);
    } catch (e) {
      print('Failed to add transaction: $e');
      rethrow;
    }
  }

  Future<void> updateTransaction(bmg.Transaction transaction) async {
    try {
      await transactions.doc(transaction.id.toString()).set(transaction);
    } catch (e) {
      print('Failed to update transaction: $e');
    }
  }

  Future<void> deleteTransaction(bmg.Transaction transaction) async {
    try {
      await transactions.doc(transaction.id.toString()).delete();
    } catch (e) {
      print('Failed to delete transaction: $e');
    }
  }

  Future<List<bmg.Transaction>> getTransactions() async {
    try {
      final snapshot = await transactions.get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Failed to fetch transactions: $e');
      return [];
    }
  }
}
