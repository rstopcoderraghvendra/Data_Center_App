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

  // Custom decent blue colors - Same as Edit Screen
  static const Color primaryBlue = Color(0xFF1976D2); // Material Blue 700
  static const Color accentBlue = Color(0xFF2196F3); // Material Blue 500
  static const Color lightBlue = Color(0xFFBBDEFB); // Material Blue 100
  static const Color darkBlue = Color(0xFF0D47A1); // Material Blue 900

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
      // await _repository.createCustomer(payload);
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
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          title: const Text(
            'Add Survey Data',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
              fontFamily: 'Roboto',
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: primaryBlue,
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              decoration: BoxDecoration(
                color: primaryBlue,
                border: Border(
                  bottom: BorderSide(color: darkBlue, width: 1),
                ),
              ),
              child: TabBar(
                indicatorColor: Colors.white,
                indicatorWeight: 3,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white.withOpacity(0.8),
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  fontFamily: 'Roboto',
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Roboto',
                ),
                tabs: const [
                  Tab(
                    icon: Icon(Icons.person_outline, size: 20),
                    text: 'Basic Info',
                  ),
                  Tab(
                    icon: Icon(Icons.details_outlined, size: 20),
                    text: 'Details',
                  ),
                  Tab(
                    icon: Icon(Icons.photo_library_outlined, size: 20),
                    text: 'Photos',
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildBasicTab(),
            _buildDetailsTab(),
            _buildPhotosTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildSectionCard(
            title: 'Owner Information',
            icon: Icons.person_outline,
            children: [
              _buildTextField(
                controller: _nameController,
                label: 'Owner Name',
                hintText: 'Enter owner full name',
                icon: Icons.person_outline,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            title: 'Property Details',
            icon: Icons.home_outlined,
            children: [
              _buildTextField(
                controller: _propertyIdController,
                label: 'Property ID',
                hintText: 'Enter property identification number',
                icon: Icons.numbers_outlined,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _municipalityController,
                label: 'Municipality Name',
                hintText: 'Enter municipality name',
                icon: Icons.location_city_outlined,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _integratedPidController,
                label: 'Integrated PID Property ID',
                hintText: 'Enter integrated property ID',
                icon: Icons.qr_code_outlined,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _integratedOwnerController,
                label: 'Integrated PID Owner/Occupier Name',
                hintText: 'Enter owner/occupier name',
                icon: Icons.badge_outlined,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _areaOfAuthorityController,
                label: 'Area of Authority',
                hintText: 'Enter area of authority',
                icon: Icons.apartment_outlined,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _colonyController,
                label: 'Colony Name',
                hintText: 'Enter colony name',
                icon: Icons.map_outlined,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _saving
              ? Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    color: primaryBlue,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  ),
                )
              : PrimaryButton(
                  label: 'Save & Continue',
                  onPressed: () => _save(),
                ),
        ],
      ),
    );
  }

  Widget _buildDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildSectionCard(
            title: 'Location Details',
            icon: Icons.location_on_outlined,
            children: [
              _buildTextField(
                controller: _addressController,
                label: 'Address of Property',
                hintText: 'Enter complete property address',
                icon: Icons.home_outlined,
                maxLines: 3,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            title: 'Contact Information',
            icon: Icons.contact_phone_outlined,
            children: [
              _buildTextField(
                controller: _mobileController,
                label: 'Mobile Number',
                hintText: 'Enter 10-digit mobile number',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            title: 'Property Specifications',
            icon: Icons.category_outlined,
            children: [
              _buildTextField(
                controller: _categoryController,
                label: 'Category',
                hintText: 'Enter property category',
                icon: Icons.category_outlined,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: _buildTextField(
                      controller: _totalAreaController,
                      label: 'Total Area',
                      hintText: 'e.g., 1500',
                      icon: Icons.square_foot_outlined,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: _buildTextField(
                      controller: _unitController,
                      label: 'Unit',
                      hintText: 'e.g., sq ft',
                      icon: Icons.straighten_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _authorizationStatusController,
                label: 'Authorization Status',
                hintText: 'approved/unapproved',
                icon: Icons.verified_outlined,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _saving
              ? Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    color: primaryBlue,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  ),
                )
              : PrimaryButton(
                  label: 'Save & Continue',
                  onPressed: () => _save(),
                ),
        ],
      ),
    );
  }

  Widget _buildPhotosTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Card(
            elevation: 0,
            color: lightBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: primaryBlue.withOpacity(0.2)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Icon(
                    Icons.photo_library_outlined,
                    size: 40,
                    color: primaryBlue,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Property Photos',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: primaryBlue,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Upload clear photos from different angles',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildPhotoUploadCard(
            title: 'Front View',
            description: 'Clear photo showing the front of the property',
            icon: Icons.home_outlined,
          ),
          const SizedBox(height: 16),
          _buildPhotoUploadCard(
            title: 'Side View',
            description: 'Photo showing the side/angle view',
            icon: Icons.aspect_ratio_outlined,
          ),
          const SizedBox(height: 16),
          _buildPhotoUploadCard(
            title: 'Additional View',
            description: 'Any additional important view',
            icon: Icons.add_photo_alternate_outlined,
          ),
          const SizedBox(height: 16),
          _buildPhotoUploadCard(
            title: 'Location View',
            description: 'Photo showing property in surrounding area',
            icon: Icons.location_on_outlined,
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _saving
                    ? Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: primaryBlue,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : PrimaryButton(
                        label: 'Save All Changes',
                        onPressed: () => _save(),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: lightBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 20, color: primaryBlue),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                    fontFamily: 'Roboto',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hintText,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(
        fontSize: 16,
        color: Color(0xFF333333),
        fontFamily: 'Roboto',
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icon, size: 20, color: primaryBlue),
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: primaryBlue,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        labelStyle: const TextStyle(
          color: Color(0xFF666666),
          fontSize: 14,
          fontFamily: 'Roboto',
        ),
        hintStyle: const TextStyle(
          color: Color(0xFF999999),
          fontSize: 14,
          fontFamily: 'Roboto',
        ),
      ),
    );
  }

  Widget _buildPhotoUploadCard({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 20, color: primaryBlue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                        fontFamily: 'Roboto',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 13,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.camera_alt_outlined,
                        size: 18, color: primaryBlue),
                    label: const Text(
                      'Take Photo',
                      style: TextStyle(
                        color: primaryBlue,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: primaryBlue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.upload_outlined,
                        size: 18, color: Colors.white),
                    label: const Text(
                      'Upload',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
