import 'package:bmg/src/pages/add_sale_page/add_sale_page.dart';
import 'package:bmg/src/pages/home_page/admin_wheel_view.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const routeName = '/home_page';

  get addSale => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const AdminWheelView(),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                "Content goes here",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddSalePage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
