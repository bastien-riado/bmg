import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class Transaction {
  int id;
  String title;
  String creator;
  String paymentMethod;
  DateTime creationDate;
  DateTime? completedDate;
  double amount;
  String? description;
  TransactionType type;
  TransactionCategory category;
  TransactionStatus status;
  int? eventId;
  String? lastModifiedBy;
  DateTime? lastModifiedDate;

  Transaction({
    required this.id,
    required this.title,
    required this.creator,
    required this.paymentMethod,
    required this.creationDate,
    this.completedDate,
    required this.amount,
    this.description,
    required this.type,
    required this.category,
    required this.status,
    this.eventId,
    this.lastModifiedBy,
    this.lastModifiedDate,
  });

  factory Transaction.fromFirestore(Map<String, dynamic> data, String id) {
    return Transaction(
      id: data['id'] ?? int.parse(id),
      title: data['title'] ?? '',
      creator: data['creator'] ?? '',
      paymentMethod: data['paymentMethod'] ?? '',
      creationDate: data['creationDate'] != null
          ? DateTime.parse(data['creationDate'])
          : DateTime.now(),
      completedDate: data['completedDate'] != null
          ? DateTime.parse(data['completedDate'])
          : null,
      amount: (data['amount'] ?? 0).toDouble(),
      description: data['description'],
      type: data['type'] != null
          ? TransactionType.values.firstWhere(
              (e) => e.toString() == 'TransactionType.${data['type']}',
              orElse: () => TransactionType.income)
          : TransactionType.income,
      category: data['category'] != null
          ? TransactionCategory.values.firstWhere(
              (e) => e.toString() == 'TransactionCategory.${data['category']}',
              orElse: () => TransactionCategory.other)
          : TransactionCategory.other,
      status: data['status'] != null
          ? TransactionStatus.values.firstWhere(
              (e) => e.toString() == 'TransactionStatus.${data['status']}',
              orElse: () => TransactionStatus.pending)
          : TransactionStatus.pending,
      eventId: data['eventId'],
      lastModifiedBy: data['lastModifiedBy'],
      lastModifiedDate: data['lastModifiedDate'] != null
          ? DateTime.parse(data['lastModifiedDate'])
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'creator': creator,
      'paymentMethod': paymentMethod,
      'creationDate': creationDate.toIso8601String(),
      'completedDate': completedDate?.toIso8601String(),
      'amount': amount,
      'description': description,
      'type': type.toString().split('.').last,
      'category': category.toString().split('.').last,
      'status': status.toString().split('.').last,
      'eventId': eventId,
      'lastModifiedBy': lastModifiedBy,
      'lastModifiedDate': lastModifiedDate?.toIso8601String(),
    };
  }

  String get formattedCreationDate {
    return _formatDate(creationDate);
  }

  String get formattedCompletedDate {
    return completedDate != null ? _formatDate(completedDate!) : 'N/A';
  }

  String get formattedLastModifiedDate {
    return lastModifiedDate != null ? _formatDate(lastModifiedDate!) : 'N/A';
  }

  String _formatDate(DateTime date) {
    return DateFormat.yMd().format(date);
  }

  DataGridRow getDataGridRow() {
    return DataGridRow(cells: <DataGridCell>[
      DataGridCell<int>(columnName: 'id', value: id),
      DataGridCell<String>(columnName: 'title', value: title),
      DataGridCell<String>(columnName: 'description', value: description),
      DataGridCell<double>(columnName: 'amount', value: amount),
      DataGridCell<DateTime>(columnName: 'creationDate', value: creationDate),
      DataGridCell<DateTime?>(
          columnName: 'completedDate', value: completedDate),
      DataGridCell<String>(columnName: 'creator', value: creator),
      DataGridCell<TransactionType>(columnName: 'type', value: type),
      DataGridCell<TransactionCategory>(
          columnName: 'category', value: category),
      DataGridCell<String>(columnName: 'paymentMethod', value: paymentMethod),
      DataGridCell<TransactionStatus>(columnName: 'status', value: status),
      DataGridCell<int?>(columnName: 'eventId', value: eventId),
    ]);
  }
}

enum TransactionStatus {
  pending,
  completed,
  cancelled,
}

enum TransactionCategory {
  food,
  subvention,
  event,
  sale,
  rent,
  other,
}

enum TransactionType {
  income,
  expense,
}
