import 'package:bmg/src/models/admin_model.dart';
import 'package:bmg/src/shared/utils/config_utils.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminWheelView extends StatefulWidget {
  const AdminWheelView({super.key});

  @override
  State<AdminWheelView> createState() => _AdminWheelViewState();
}

class _AdminWheelViewState extends State<AdminWheelView> {
  List<AdminModel> _admins = [];
  AdminModel? _selectedAdmin;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAdmins();
  }

  Future<void> _loadAdmins() async {
    try {
      final admins = ConfigUtils.admins;

      // Load the saved admin from SharedPreferences.
      final savedAdminName = await _getSavedAdminName();
      AdminModel? defaultAdmin;

      if (savedAdminName != null) {
        // Find the matching admin from the saved name.
        defaultAdmin = admins.firstWhere(
          (admin) => admin.name == savedAdminName,
          orElse: () => admins.first,
        );
      } else if (admins.isNotEmpty) {
        defaultAdmin = admins.first;
      }

      setState(() {
        _admins = admins;
        _selectedAdmin = defaultAdmin;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _errorMessage = 'Failed to load admins: $error';
        _isLoading = false;
      });
    }
  }

  Future<void> _saveSelectedAdmin(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedAdmin', name);
  }

  Future<String?> _getSavedAdminName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('selectedAdmin');
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Text(_errorMessage!),
      );
    }

    if (_admins.isEmpty) {
      return const Center(
        child: Text('No admins found'),
      );
    }

    return DropdownButtonHideUnderline(
      child: DropdownButton2<AdminModel>(
        isExpanded: true,
        items: _admins
            .map((AdminModel admin) => DropdownMenuItem(
                  value: admin,
                  child: Center(
                    child: Text(
                      admin.name,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ))
            .toList(),
        value: _selectedAdmin,
        onChanged: (AdminModel? value) async {
          if (value != null) {
            setState(() {
              _selectedAdmin = value;
            });

            // Save the selected admin to SharedPreferences.
            await _saveSelectedAdmin(value.name);
          }
        },
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.symmetric(horizontal: 16),
          height: 40,
          width: 140,
        ),
        customButton: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 40,
          width: 140,
          child: Text(
            _selectedAdmin?.name ?? '',
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
        ),
      ),
    );
  }
}
