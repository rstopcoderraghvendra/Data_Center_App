import 'package:flutter/material.dart';
import '../../common/widgets/primary_button.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/local_storage.dart';
import '../../../data/repositories/customer_repository.dart';

class SurveyAddScreen extends StatefulWidget {
  const SurveyAddScreen({super.key});

  @override
  State<SurveyAddScreen> createState() => _SurveyAddScreenState();
}

class _SurveyAddScreenState extends State<SurveyAddScreen> {
  final _repository = CustomerRepository(ApiClient(storage: LocalStorage()));
  final _nameController = TextEditingController();
  final _propertyIdController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _propertyIdController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) {
      return;
    }
    setState(() => _saving = true);
    try {
      await _repository.createCustomer({
        'name': _nameController.text.trim(),
        'property_details_property_id': _propertyIdController.text.trim(),
        'source_type': 'survey',
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Record created')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Survey Data')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Owner Name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _propertyIdController,
                  decoration: const InputDecoration(
                    labelText: 'Property Id',
                    prefixIcon: Icon(Icons.list_alt_outlined),
                  ),
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  label: _saving ? 'Saving...' : 'Save',
                  onPressed: _saving ? () {} : _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
