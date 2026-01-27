import 'package:data_care_app/features/bill_distribution/screens/model/bill_model.dart';
import 'package:flutter/material.dart';

class BillFormScreen extends StatefulWidget {
  final Bill? bill;
  final bool isEditMode;

  const BillFormScreen({
    super.key,
    this.bill,
    this.isEditMode = false,
  });

  @override
  State<BillFormScreen> createState() => _BillFormScreenState();
}

class _BillFormScreenState extends State<BillFormScreen> {
  final _formKey = GlobalKey<FormState>();
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

  // Theme colors
  static const Color primaryColor = Color(0xFF667eea);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF718096);

  @override
  void initState() {
    super.initState();

    // Load existing data if in edit mode
    if (widget.isEditMode && widget.bill != null) {
      // Load from bill model
      _nameController.text = widget.bill!.customerName;
      _propertyIdController.text = widget.bill!.propertyDetails;
      _municipalityController.text = widget.bill!.municipality;
      _integratedPidController.text = widget.bill!.integratedPid;
      _integratedOwnerController.text = widget.bill!.integratedOwner;
      _areaOfAuthorityController.text = widget.bill!.areaOfAuthority;
      _colonyController.text = widget.bill!.colony;
      _addressController.text = widget.bill!.address;
      _mobileController.text = widget.bill!.mobile;
      _categoryController.text = widget.bill!.category;
      _totalAreaController.text = widget.bill!.totalArea;
      _unitController.text = widget.bill!.unit;
      _authorizationStatusController.text = widget.bill!.authorizationStatus;
    }
  }

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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final bill = Bill(
        id: widget.isEditMode ? widget.bill!.id : _generateBillId(),
        title: 'Bill - ${_nameController.text}',
        description: 'Bill for ${_propertyIdController.text}',
        amount: double.tryParse(_totalAreaController.text) ?? 0.0,
        date: DateTime.now(),
        customerName: _nameController.text.trim(),
        propertyDetails: _propertyIdController.text.trim(),
        municipality: _municipalityController.text.trim(),
        integratedPid: _integratedPidController.text.trim(),
        integratedOwner: _integratedOwnerController.text.trim(),
        areaOfAuthority: _areaOfAuthorityController.text.trim(),
        colony: _colonyController.text.trim(),
        address: _addressController.text.trim(),
        mobile: _mobileController.text.trim(),
        category: _categoryController.text.trim(),
        totalArea: _totalAreaController.text.trim(),
        unit: _unitController.text.trim(),
        authorizationStatus: _authorizationStatusController.text.trim(),
      );

      Navigator.of(context).pop(bill);
    }
  }

  String _generateBillId() {
    final now = DateTime.now();
    final timestamp = now.millisecondsSinceEpoch;
    return 'BILL${timestamp.toString().substring(8)}';
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text(
            widget.isEditMode ? 'Edit Bill Distribution' : 'Add New Bill',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
              fontFamily: 'Roboto',
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: primaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              decoration: BoxDecoration(
                color: primaryColor,
                border: Border(
                  bottom: BorderSide(
                      color: primaryColor.withOpacity(0.8), width: 1),
                ),
              ),
              child: TabBar(
                indicatorColor: Colors.white,
                indicatorWeight: 3,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white.withOpacity(0.8),
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  fontFamily: 'Roboto',
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Roboto',
                ),
                tabs: [
                  Tab(
                    icon: Icon(Icons.person_outline, size: 20),
                    text: 'Basic Info',
                  ),
                  Tab(
                    icon: Icon(Icons.details_outlined, size: 20),
                    text: 'Property Details',
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
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildSectionCard(
              title: 'Owner Information',
              icon: Icons.person_outline,
              children: [
                _buildTextField(
                  controller: _nameController,
                  label: 'Owner Name',
                  icon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Owner name is required';
                    }
                    return null;
                  },
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
                  icon: Icons.list_alt_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Property ID is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _municipalityController,
                  label: 'Municipality Name',
                  icon: Icons.location_city_outlined,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _integratedPidController,
                  label: 'Integrated PID Property ID',
                  icon: Icons.qr_code_outlined,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _integratedOwnerController,
                  label: 'Integrated PID Owner/Occupier Name',
                  icon: Icons.badge_outlined,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _areaOfAuthorityController,
                  label: 'Area of Authority',
                  icon: Icons.apartment_outlined,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _colonyController,
                  label: 'Colony Name',
                  icon: Icons.map_outlined,
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSubmitButton(),
          ],
        ),
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
                icon: Icons.category_outlined,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: _buildTextField(
                      controller: _totalAreaController,
                      label: 'Total Area',
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
                      icon: Icons.straighten_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _authorizationStatusController,
                label: 'Authorization Status',
                icon: Icons.verified_outlined,
                hintText: 'approved/unapproved',
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSubmitButton(),
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
            elevation: 2,
            color: primaryColor.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: primaryColor.withOpacity(0.2)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(
                    Icons.photo_library_outlined,
                    size: 40,
                    color: primaryColor,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Property Photos',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Upload clear photos from different angles',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textSecondary,
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
          _buildSubmitButton(),
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
      color: cardColor,
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
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 20, color: primaryColor),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor,
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
    String? Function(String?)? validator,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: 14,
            fontFamily: 'Roboto',
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontSize: 16,
            color: textColor,
            fontFamily: 'Roboto',
          ),
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(icon, size: 20, color: primaryColor),
            filled: true,
            fillColor: backgroundColor,
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
                color: primaryColor,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            labelStyle: const TextStyle(
              color: textSecondary,
              fontSize: 14,
              fontFamily: 'Roboto',
            ),
            hintStyle: const TextStyle(
              color: Color(0xFF999999),
              fontSize: 14,
              fontFamily: 'Roboto',
            ),
          ),
          validator: validator,
        ),
      ],
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
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 20, color: primaryColor),
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
                        color: textColor,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        color: textSecondary,
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
                    icon: Icon(Icons.camera_alt_outlined,
                        size: 18, color: primaryColor),
                    label: const Text(
                      'Take Photo',
                      style: TextStyle(
                        color: primaryColor,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: primaryColor),
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
                      backgroundColor: primaryColor,
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

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _saving ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 2,
        ),
        child: _saving
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Text(
                widget.isEditMode ? 'Update Bill' : 'Create Bill',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  fontFamily: 'Roboto',
                ),
              ),
      ),
    );
  }
}
