import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../services/auth_service.dart';
import '../models/child.dart';
import '../l10n/app_localizations.dart';

class AddChildScreen extends StatefulWidget {
  const AddChildScreen({super.key});

  @override
  State<AddChildScreen> createState() => _AddChildScreenState();
}

class _AddChildScreenState extends State<AddChildScreen> {
  final _nameController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final loc = AppLocalizations.of(context)!;

    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      helpText: loc.selectDate,
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<void> _saveChild() async {
    final loc = AppLocalizations.of(context)!;

    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.nameRequired)),
      );
      return;
    }

    if (_selectedDate == null) return;

    final child = Child(
      name: _nameController.text.trim(),
      birthDate: _selectedDate!,
    );

    final parent = await AuthService.instance.getCurrentParent();
    if (parent == null) return;

    final parentId = parent['id'] as int;

    await DatabaseHelper.instance.insertChild(child, parentId);

    if (!mounted) return;

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.addChildTitle),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveChild,
        icon: const Icon(Icons.check_rounded),
        label: Text(loc.save),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            Center(
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.child_care_rounded,
                  size: 42,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: loc.childName,
                prefixIcon: const Icon(Icons.person_outline),
                filled: true,
                fillColor: theme.colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),

            const SizedBox(height: 24),

            InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: _pickDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: loc.birthDate,
                  prefixIcon: const Icon(Icons.calendar_today_outlined),
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Text(
                  _selectedDate == null
                      ? loc.selectDate
                      : '${_selectedDate!.day}.${_selectedDate!.month}.${_selectedDate!.year}',
                  style: TextStyle(
                    color: _selectedDate == null
                        ? theme.colorScheme.onSurface.withOpacity(0.6)
                        : theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
