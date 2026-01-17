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
  final _municipalityController = TextEditingController();
  final _integratedPidController = TextEditingController();
  final _integratedOwnerController = TextEditingController();
  final _areaOfAuthorityController = TextEditingController();
  final _colonyController = TextEditingController();
  final _addressController = TextEditingController();
  final _mobileController = TextEditingController();
  final _categoryController = TextEditingController();
  final _totalAreaController = TextEditingController();
  final _unitController = TextEditingController();
  final _authorizationStatusController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _propertyIdController.dispose();
    _municipalityController.dispose();
    _integratedPidController.dispose();
    _integratedOwnerController.dispose();
    _areaOfAuthorityController.dispose();
    _colonyController.dispose();
    _addressController.dispose();
    _mobileController.dispose();
    _categoryController.dispose();
    _totalAreaController.dispose();
    _unitController.dispose();
    _authorizationStatusController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) {
      return;
    }
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name is required')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final payload = <String, dynamic>{
        'name': name,
        'municipality_name': _municipalityController.text.trim(),
        'property_details_property_id': _propertyIdController.text.trim(),
        'integrated_pid_property_id': _integratedPidController.text.trim(),
        'integrated_pid_owner_occupier_name':
            _integratedOwnerController.text.trim(),
        'area_of_authority': _areaOfAuthorityController.text.trim(),
        'colony_name': _colonyController.text.trim(),
        'address_of_property': _addressController.text.trim(),
        'mobile_no': _mobileController.text.trim(),
        'category': _categoryController.text.trim(),
        'total_area': double.tryParse(_totalAreaController.text.trim()),
        'unit': _unitController.text.trim(),
        'authorization_status': _authorizationStatusController.text.trim(),
        'source_type': 'survey',
      };
      payload.removeWhere(
        (key, value) => value == null || value.toString().trim().isEmpty,
      );
      await _repository.createCustomer(payload);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Record created')),
        );
        Navigator.of(context).pop(true);
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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Survey Data'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Basic'),
              Tab(text: 'Details'),
              Tab(text: 'Photos'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTabCard(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Owner Name',
                    prefixIcon: Icon(Icons.person_outline),
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _propertyIdController,
                  decoration: const InputDecoration(
                    labelText: 'Property Id',
                    prefixIcon: Icon(Icons.list_alt_outlined),
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _municipalityController,
                  decoration: const InputDecoration(
                    labelText: 'Municipality Name',
                    prefixIcon: Icon(Icons.location_city_outlined),
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _integratedPidController,
                  decoration: const InputDecoration(
                    labelText: 'Integrated PID Property ID',
                    prefixIcon: Icon(Icons.badge_outlined),
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _integratedOwnerController,
                  decoration: const InputDecoration(
                    labelText: 'Integrated PID Owner/Occupier Name',
                    prefixIcon: Icon(Icons.person_pin_outlined),
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _areaOfAuthorityController,
                  decoration: const InputDecoration(
                    labelText: 'Area of Authority',
                    prefixIcon: Icon(Icons.apartment_outlined),
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _colonyController,
                  decoration: const InputDecoration(
                    labelText: 'Colony Name',
                    prefixIcon: Icon(Icons.home_work_outlined),
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  label: _saving ? 'Saving...' : 'Save & Continue',
                  onPressed: _saving ? () {} : _save,
                ),
              ],
            ),
            _buildTabCard(
              children: [
                TextField(
                  controller: _addressController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Address of Property',
                    prefixIcon: Icon(Icons.home_outlined),
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Mobile No',
                    prefixIcon: Icon(Icons.phone_outlined),
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _categoryController,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    prefixIcon: Icon(Icons.category_outlined),
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _totalAreaController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Total Area',
                    prefixIcon: Icon(Icons.square_foot_outlined),
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _unitController,
                  decoration: const InputDecoration(
                    labelText: 'Unit',
                    prefixIcon: Icon(Icons.straighten_outlined),
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _authorizationStatusController,
                  decoration: const InputDecoration(
                    labelText: 'Authorization Status (approved/unapproved)',
                    prefixIcon: Icon(Icons.verified_outlined),
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  label: _saving ? 'Saving...' : 'Save & Continue',
                  onPressed: _saving ? () {} : _save,
                ),
              ],
            ),
            _buildTabCard(
              children: [
                _buildPhotoTile(
                  title: 'Upload Photo 1',
                  subtitle: 'Front view of property',
                ),
                const SizedBox(height: 12),
                _buildPhotoTile(
                  title: 'Upload Photo 2',
                  subtitle: 'Side view of property',
                ),
                const SizedBox(height: 12),
                _buildPhotoTile(
                  title: 'Upload Photo 3',
                  subtitle: 'Additional view',
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  label: _saving ? 'Saving...' : 'Save',
                  onPressed: _saving ? () {} : _save,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabCard({required List<Widget> children}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: children),
        ),
      ),
    );
  }

  Widget _buildPhotoTile({required String title, required String subtitle}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          const Icon(Icons.photo_camera_outlined),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Upload'),
          ),
        ],
      ),
    );
  }
}
