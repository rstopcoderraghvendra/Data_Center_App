import 'package:data_care_app/features/model/survey_model/survey_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SurveyFormScreen extends StatefulWidget {
  final Survey? survey;
  final bool isEditMode;

  const SurveyFormScreen({
    super.key,
    this.survey,
    this.isEditMode = false,
  });

  @override
  State<SurveyFormScreen> createState() => _SurveyFormScreenState();
}

class _SurveyFormScreenState extends State<SurveyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _propertyIdController;
  late TextEditingController _municipalityController;
  late TextEditingController _integratedPidController;
  late TextEditingController _integratedOwnerController;
  late TextEditingController _areaOfAuthorityController;
  late TextEditingController _colonyController;
  late TextEditingController _addressController;
  late TextEditingController _mobileController;
  late TextEditingController _categoryController;
  late TextEditingController _totalAreaController;
  late TextEditingController _unitController;
  late TextEditingController _authorizationStatusController;
  late TextEditingController _idController;

  // Custom decent blue colors
  static const Color primaryBlue = Color(0xFF1976D2);
  static const Color accentBlue = Color(0xFF2196F3);
  static const Color lightBlue = Color(0xFFBBDEFB);
  static const Color darkBlue = Color(0xFF0D47A1);

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(
      text: widget.isEditMode ? widget.survey!.id : _generateSurveyId(),
    );
    _nameController = TextEditingController(text: widget.survey?.name ?? '');
    _propertyIdController =
        TextEditingController(text: widget.survey?.propertyId ?? '');
    _municipalityController =
        TextEditingController(text: widget.survey?.municipality ?? '');
    _integratedPidController =
        TextEditingController(text: widget.survey?.integratedPid ?? '');
    _integratedOwnerController =
        TextEditingController(text: widget.survey?.integratedOwner ?? '');
    _areaOfAuthorityController =
        TextEditingController(text: widget.survey?.areaOfAuthority ?? '');
    _colonyController =
        TextEditingController(text: widget.survey?.colony ?? '');
    _addressController =
        TextEditingController(text: widget.survey?.address ?? '');
    _mobileController =
        TextEditingController(text: widget.survey?.mobile ?? '');
    _categoryController =
        TextEditingController(text: widget.survey?.category ?? '');
    _totalAreaController =
        TextEditingController(text: widget.survey?.totalArea ?? '');
    _unitController = TextEditingController(text: widget.survey?.unit ?? '');
    _authorizationStatusController =
        TextEditingController(text: widget.survey?.authorizationStatus ?? '');
  }

  @override
  void dispose() {
    _idController.dispose();
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

  String _generateSurveyId() {
    final now = DateTime.now();
    final timestamp = now.millisecondsSinceEpoch;
    return 'SRV${timestamp.toString().substring(8)}';
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final survey = Survey(
        id: _idController.text.trim(),
        name: _nameController.text.trim(),
        propertyId: _propertyIdController.text.trim(),
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

      Navigator.of(context).pop(survey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          title: Text(
            widget.isEditMode ? 'Edit Survey Data' : 'Add New Survey',
            style: const TextStyle(
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
                    text: 'Property Details',
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildBasicTab(),
            _buildPropertyTab(),
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
          // Survey ID
          Card(
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
                  const Row(
                    children: [
                      Icon(Icons.numbers_outlined,
                          color: primaryBlue, size: 20),
                      SizedBox(width: 12),
                      Text(
                        'Survey Information',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _idController,
                    label: 'Survey ID',
                    icon: Icons.numbers_outlined,
                    enabled: !widget.isEditMode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Survey ID is required';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Owner Information
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

          // Contact Information
          _buildSectionCard(
            title: 'Contact Information',
            icon: Icons.contact_phone_outlined,
            children: [
              _buildTextField(
                controller: _mobileController,
                label: 'Mobile Number',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mobile number is required';
                  }
                  if (value.length < 10) {
                    return 'Enter valid mobile number';
                  }
                  return null;
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Save Button
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildPropertyTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Property Details
          _buildSectionCard(
            title: 'Property Details',
            icon: Icons.home_outlined,
            children: [
              _buildTextField(
                controller: _propertyIdController,
                label: 'Property ID',
                icon: Icons.numbers_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Property ID is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _municipalityController,
                label: 'Municipality Name',
                icon: Icons.location_city_outlined,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _integratedPidController,
                label: 'Integrated PID Property ID',
                icon: Icons.qr_code_outlined,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _integratedOwnerController,
                label: 'Integrated PID Owner/Occupier Name',
                icon: Icons.badge_outlined,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _areaOfAuthorityController,
                label: 'Area of Authority',
                icon: Icons.apartment_outlined,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _colonyController,
                label: 'Colony Name',
                icon: Icons.map_outlined,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Location Details
          _buildSectionCard(
            title: 'Location Details',
            icon: Icons.location_on_outlined,
            children: [
              _buildTextField(
                controller: _addressController,
                label: 'Address of Property',
                icon: Icons.home_outlined,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Address is required';
                  }
                  return null;
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Property Specifications
          _buildSectionCard(
            title: 'Property Specifications',
            icon: Icons.category_outlined,
            children: [
              _buildTextField(
                controller: _categoryController,
                label: 'Category',
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
              const SizedBox(height: 12),
              _buildTextField(
                controller: _authorizationStatusController,
                label: 'Authorization Status',
                icon: Icons.verified_outlined,
                hintText: 'approved/unapproved',
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Save Button
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
    String? Function(String?)? validator,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? hintText,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      enabled: enabled,
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
        fillColor: enabled ? const Color(0xFFF8F9FA) : Colors.grey[100],
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
      validator: validator,
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 2,
        ),
        child: Text(
          widget.isEditMode ? 'Update Survey' : 'Create Survey',
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
