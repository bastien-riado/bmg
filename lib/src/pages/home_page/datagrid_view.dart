import 'package:bmg/src/models/transaction_model.dart';
import 'package:bmg/src/pages/home_page/datagrid/transaction_datasource.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class TransactionGrid extends StatefulWidget {
  final List<Transaction> transactions;
  final BuildContext context;

  const TransactionGrid({
    super.key,
    required this.transactions,
    required this.context,
  });

  @override
  State<TransactionGrid> createState() => _TransactionGridState();
}

class _TransactionGridState extends State<TransactionGrid> {
  late DataGridController _dataGridController;
  late TransactionDataSource _transactionDataSource;

  @override
  void initState() {
    super.initState();
    _dataGridController = DataGridController();
    _transactionDataSource = TransactionDataSource(
      widget.transactions,
      context,
      _dataGridController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SfDataGridTheme(
      data: const SfDataGridThemeData(
        gridLineColor: Color.fromARGB(255, 20, 18, 31),
        selectionColor: Colors.lightBlueAccent,
        headerColor: Color.fromARGB(255, 194, 220, 250),
      ),
      child: SfDataGrid(
        controller: _dataGridController,
        source: _transactionDataSource,
        allowEditing: true,
        allowPullToRefresh: true,
        columnWidthMode: ColumnWidthMode.auto,
        selectionMode: SelectionMode.single,
        navigationMode: GridNavigationMode.cell,
        editingGestureType: EditingGestureType.doubleTap,
        gridLinesVisibility: GridLinesVisibility.both,
        headerGridLinesVisibility: GridLinesVisibility.both,
        columns: [
          GridColumn(
            columnName: 'id',
            visible: false,
            label: _buildHeaderCell('ID', Alignment.center),
          ),
          GridColumn(
            columnName: 'title',
            label: _buildHeaderCell('Title', Alignment.center),
          ),
          GridColumn(
            columnName: 'description',
            label: _buildHeaderCell('Description', Alignment.center),
          ),
          GridColumn(
            columnName: 'amount',
            label: _buildHeaderCell('Amount', Alignment.center),
          ),
          GridColumn(
            columnName: 'creationDate',
            label: _buildHeaderCell('Creation Date', Alignment.center),
          ),
          GridColumn(
            columnName: 'completedDate',
            label: _buildHeaderCell('Completed Date', Alignment.center),
          ),
          GridColumn(
            columnName: 'creator',
            label: _buildHeaderCell('Creator', Alignment.center),
          ),
          GridColumn(
            columnName: 'type',
            label: _buildHeaderCell('Type', Alignment.center),
          ),
          GridColumn(
            columnName: 'category',
            label: _buildHeaderCell('Category', Alignment.center),
          ),
          GridColumn(
            columnName: 'paymentMethod',
            label: _buildHeaderCell('Payment Method', Alignment.center),
          ),
          GridColumn(
            columnName: 'status',
            label: _buildHeaderCell('Status', Alignment.center),
          ),
          GridColumn(
            columnName: 'eventId',
            label: _buildHeaderCell('Event ID', Alignment.center),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, Alignment alignment) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      alignment: alignment,
      child: Text(
        text,
      ),
    );
  }
}
