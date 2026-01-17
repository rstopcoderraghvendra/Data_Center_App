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
  bool _loading = true;
  bool _saving = false;
  int? _customerId;

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
      _municipalityController.text =
          data['municipality_name']?.toString() ?? '';
      _integratedPidController.text =
          data['integrated_pid_property_id']?.toString() ?? '';
      _integratedOwnerController.text =
          data['integrated_pid_owner_occupier_name']?.toString() ?? '';
      _areaOfAuthorityController.text =
          data['area_of_authority']?.toString() ?? '';
      _colonyController.text = data['colony_name']?.toString() ?? '';
      _addressController.text = data['address_of_property']?.toString() ?? '';
      _mobileController.text = data['mobile_no']?.toString() ?? '';
      _categoryController.text = data['category']?.toString() ?? '';
      _totalAreaController.text = data['total_area']?.toString() ?? '';
      _unitController.text = data['unit']?.toString() ?? '';
      _authorizationStatusController.text =
          data['authorization_status']?.toString() ?? '';
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
        'municipality_name': _municipalityController.text.trim(),
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
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Record updated')),
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
          title: const Text('Edit Survey Data'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Basic'),
              Tab(text: 'Details'),
              Tab(text: 'Photos'),
            ],
          ),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
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
                          labelText:
                              'Authorization Status (approved/unapproved)',
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
