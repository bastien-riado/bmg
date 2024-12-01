import 'package:bmg/src/models/transaction_model.dart';
import 'package:bmg/src/shared/providers/transactions_provider.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class TransactionDataSource extends DataGridSource {
  final BuildContext context;
  final DataGridController dataGridController;
  TransactionDataSource(
    this._transactions,
    this.context,
    this.dataGridController,
  ) {
    dataGridRows = _transactions
        .map<DataGridRow>((dataGridRow) => dataGridRow.getDataGridRow())
        .toList();

    return;
  }

  List<Transaction> _transactions = [];
  late List<DataGridRow> dataGridRows = [];
  dynamic newCellValue;

  TextEditingController editingController = TextEditingController();

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      color: dataGridRows.indexOf(row) % 2 == 0
          ? Colors.white
          : const Color.fromARGB(255, 235, 230, 230).withOpacity(0.3),
      cells: row.getCells().map<Widget>((dataGridCell) {
        String displayValue = dataGridCell.value?.toString() ?? '';

        if (dataGridCell.columnName == 'creationDate' ||
            dataGridCell.columnName == 'completedDate') {
          if (dataGridCell.value is DateTime) {
            displayValue = DateFormat.yMd().format(dataGridCell.value);
          }
        }

        return Container(
          alignment: dataGridCell.columnName == 'id'
              ? Alignment.centerRight
              : Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            displayValue,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
    );
  }

  @override
  bool onCellBeginEdit(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex,
      GridColumn column) {
    Provider.of<TransactionsProvider>(context, listen: false)
        .setIsGridInEdition(true);
    return true;
  }

  @override
  Future<void> onCellSubmit(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column) async {
    final dynamic oldValue = dataGridRow
            .getCells()
            .firstWhereOrNull((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            ?.value ??
        '';

    final int dataRowIndex = dataGridRows.indexOf(dataGridRow);
    final newValue = newCellValue;

    if (newValue == null || oldValue == newValue) {
      Provider.of<TransactionsProvider>(context, listen: false)
          .setIsGridInEdition(false);
      return;
    }

    final currentRow = dataGridRows[dataRowIndex];

    switch (column.columnName) {
      case 'id':
        currentRow.getCells()[rowColumnIndex.columnIndex] =
            DataGridCell<int>(columnName: 'id', value: newValue);
        _transactions[dataRowIndex].id = newValue as int;
        break;
      case 'title':
        currentRow.getCells()[rowColumnIndex.columnIndex] =
            DataGridCell<String>(columnName: 'title', value: newValue);
        _transactions[dataRowIndex].title = newValue as String;
        break;
      case 'description':
        currentRow.getCells()[rowColumnIndex.columnIndex] =
            DataGridCell<String>(columnName: 'description', value: newValue);
        _transactions[dataRowIndex].description = newValue as String;
        break;
      case 'amount':
        currentRow.getCells()[rowColumnIndex.columnIndex] =
            DataGridCell<double>(columnName: 'amount', value: newValue);
        _transactions[dataRowIndex].amount = newValue as double;
        break;
      case 'creationDate':
      case 'completedDate':
        DateTime? parsedDate;
        if (newValue is DateTime) {
          parsedDate = newValue;
        } else if (newValue is String) {
          try {
            parsedDate = DateTime.parse(newValue);
          } catch (e) {
            print('Error parsing date: $e');
            return;
          }
        }
        if (parsedDate != null) {
          currentRow.getCells()[rowColumnIndex.columnIndex] =
              DataGridCell<DateTime>(
                  columnName: column.columnName, value: parsedDate);

          if (column.columnName == 'creationDate') {
            _transactions[dataRowIndex].creationDate = parsedDate;
          } else {
            _transactions[dataRowIndex].completedDate = parsedDate;
          }
        }
        break;
      case 'creator':
        currentRow.getCells()[rowColumnIndex.columnIndex] =
            DataGridCell<String>(columnName: 'creator', value: newValue);
        _transactions[dataRowIndex].creator = newValue as String;
        break;
      case 'type':
        currentRow.getCells()[rowColumnIndex.columnIndex] =
            DataGridCell<TransactionType>(columnName: 'type', value: newValue);
        _transactions[dataRowIndex].type = newValue;
        break;
      case 'category':
        currentRow.getCells()[rowColumnIndex.columnIndex] =
            DataGridCell<TransactionCategory>(
                columnName: 'category', value: newValue);
        _transactions[dataRowIndex].category = newValue;
        break;
      case 'paymentMethod':
        currentRow.getCells()[rowColumnIndex.columnIndex] =
            DataGridCell<String>(columnName: 'paymentMethod', value: newValue);
        _transactions[dataRowIndex].paymentMethod = newValue as String;
        break;
      case 'status':
        currentRow.getCells()[rowColumnIndex.columnIndex] =
            DataGridCell<TransactionStatus>(
                columnName: 'status', value: newValue);
        _transactions[dataRowIndex].status = newValue;
        break;
      case 'eventId':
        currentRow.getCells()[rowColumnIndex.columnIndex] =
            DataGridCell<String>(columnName: 'eventId', value: newValue);
        _transactions[dataRowIndex].eventId = newValue;
        break;
    }

    Provider.of<TransactionsProvider>(context, listen: false)
        .setIsGridInEdition(false);
  }

  RegExp _getRegExp(bool isNumericKeyBoard, String columnName) {
    return isNumericKeyBoard ? RegExp('[0-9]') : RegExp('[a-zA-Z ]');
  }

  @override
  Future<bool> canSubmitCell(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column) async {
    return true;
  }

  @override
  void onCellCancelEdit(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex,
      GridColumn column) {
    dataGridController.endEdit();
    Provider.of<TransactionsProvider>(context, listen: false)
        .setIsGridInEdition(false);
  }

  @override
  Widget? buildEditWidget(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column, CellSubmit submitCell) {
    final String displayText = dataGridRow
            .getCells()
            .firstWhereOrNull((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            ?.value
            ?.toString() ??
        '';
    newCellValue = null;

    final bool isNumericType =
        column.columnName == 'id' || column.columnName == 'amount';
    final bool isDateType = column.columnName == 'creationDate' ||
        column.columnName == 'completedDate';
    final RegExp regExp = _getRegExp(isNumericType, column.columnName);

    if (isDateType) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (BuildContext context) => Dialog(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              getDateRangePicker(submitCell),
            ]),
          ),
        );
        return;
      });
    }

    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: isNumericType ? Alignment.centerRight : Alignment.centerLeft,
      child: TextField(
        autofocus: true,
        onTapOutside: (event) {
          onCellCancelEdit(dataGridRow, rowColumnIndex, column);
        },
        controller: editingController..text = displayText,
        textAlign: isNumericType ? TextAlign.right : TextAlign.left,
        autocorrect: false,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 16.0),
        ),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(regExp)
        ],
        keyboardType: isNumericType ? TextInputType.number : TextInputType.text,
        onChanged: (String value) {
          if (value.isNotEmpty) {
            if (isNumericType) {
              newCellValue = int.parse(value);
            } else {
              newCellValue = value;
            }
          } else {
            newCellValue = null;
          }
        },
        onSubmitted: (String value) {
          submitCell();
        },
      ),
    );
  }

  Widget getDateRangePicker(CellSubmit submitCell) {
    DateTime? selectedDate;

    return SizedBox(
      height: 400,
      child: SfDateRangePicker(
        view: DateRangePickerView.month,
        selectionMode: DateRangePickerSelectionMode.single,
        showActionButtons: true,
        headerHeight: 50,
        showNavigationArrow: true,
        onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
          selectedDate = args.value;
        },
        onSubmit: (Object? value) {
          try {
            if (selectedDate != null) {
              submitCell();
              Navigator.of(context).pop();
            } else if (value is DateTime) {
              newCellValue = value;
              submitCell();
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pop();
            }
          } catch (e) {
            print('Error in date submission: $e');
            Navigator.of(context).pop();
          }
        },
        onCancel: () {
          newCellValue = null;
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
