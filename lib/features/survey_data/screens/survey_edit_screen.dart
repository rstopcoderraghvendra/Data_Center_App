import 'package:flutter/material.dart';
import '../../common/widgets/primary_button.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/local_storage.dart';
import '../../../data/repositories/customer_repository.dart';

class SurveyEditScreen extends StatefulWidget {
  const SurveyEditScreen({super.key});

  @override
  State<SurveyEditScreen> createState() => _SurveyEditScreenState();
}

class _SurveyEditScreenState extends State<SurveyEditScreen> {
  final _repository = CustomerRepository(ApiClient(storage: LocalStorage()));
  final _nameController = TextEditingController();
  final _propertyIdController = TextEditingController();
  bool _loading = true;
  bool _saving = false;
  int? _customerId;

  @override
  void dispose() {
    _nameController.dispose();
    _propertyIdController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_customerId != null) {
      return;
    }
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args['id'] != null) {
      _customerId = int.tryParse(args['id'].toString());
    }
    _load();
  }

  Future<void> _load() async {
    if (_customerId == null) {
      setState(() => _loading = false);
      return;
    }
    try {
      final data = await _repository.fetchCustomer(_customerId!);
      _nameController.text = data['name']?.toString() ?? '';
      _propertyIdController.text =
          data['property_details_property_id']?.toString() ?? '';
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _save() async {
    if (_saving || _customerId == null) {
      return;
    }
    setState(() => _saving = true);
    try {
      await _repository.updateCustomer(_customerId!, {
        'name': _nameController.text.trim(),
        'property_details_property_id': _propertyIdController.text.trim(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Record updated')),
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
      appBar: AppBar(title: const Text('Edit Survey Data')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : Column(
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
