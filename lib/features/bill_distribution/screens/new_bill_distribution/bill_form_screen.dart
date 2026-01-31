import 'package:data_care_app/features/bill_distribution/screens/model/bill_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

class _BillFormScreenState extends State<BillFormScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;
  int _currentStep = 0;

  // Controllers
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

  // Premium Color Theme
  static const Color primaryColor = Color(0xFFFF6B35);
  static const Color propertyInfoColor = Color(0xFF6366F1);
  static const Color locationColor = Color(0xFF14B8A6);
  static const Color specificationsColor = Color(0xFFEF4444);
  static const Color photosColor = Color(0xFF10B981);
  static const Color textFieldIconColor = Color(0xFF8B5CF6);
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color cardColor = Colors.white;
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color tabSelectedColor = Color(0xFF6366F1);
  static const Color tabUnselectedColor = Color(0xFF94A3B8);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentStep = _tabController.index;
      });
    });

    if (widget.isEditMode && widget.bill != null) {
      _loadBillData();
    }
  }

  void _loadBillData() {
    _nameController.text = widget.bill!.customerName;
    _propertyIdController.text = widget.bill!.propertyDetails;
    _municipalityController.text = widget.bill!.municipality;
    _integratedPidController.text = widget.bill!.integratedPid;
    _integratedOwnerController.text = widget.bill!.integratedOwner;
    _areaOfAuthorityController.text = widget.bill!.areaOfAuthority.toString();
    _colonyController.text = widget.bill!.colony;
    _addressController.text = widget.bill!.address;
    _mobileController.text = widget.bill!.mobile;
    _categoryController.text = widget.bill!.category.toString();
    _totalAreaController.text = widget.bill!.totalArea.toString();
    _unitController.text = widget.bill!.unit.toString();
    _authorizationStatusController.text =
        widget.bill!.authorizationStatus.toString();
  }

  @override
  void dispose() {
    _tabController.dispose();
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

  void _nextStep() {
    if (_currentStep < 2) {
      _tabController.animateTo(_currentStep + 1);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _tabController.animateTo(_currentStep - 1);
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        if (_nameController.text.isEmpty ||
            _propertyIdController.text.isEmpty ||
            _mobileController.text.isEmpty ||
            _mobileController.text.length < 10) {
          return false;
        }
        return true;
      case 1:
        if (_addressController.text.isEmpty ||
            _municipalityController.text.isEmpty ||
            _colonyController.text.isEmpty) {
          return false;
        }
        return true;
      case 2:
        if (_categoryController.text.isEmpty ||
            _totalAreaController.text.isEmpty ||
            _unitController.text.isEmpty) {
          return false;
        }
        return true;
      default:
        return false;
    }
  }

  void _submitForm() async {
    if (!_validateCurrentStep()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill all required fields in Step ${_currentStep + 1}',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: specificationsColor,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(12),
        ),
      );
      return;
    }

    if (_currentStep < 2) {
      _nextStep();
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() => _saving = true);

      await Future.delayed(const Duration(milliseconds: 800));

      final bill = Bill(
        name: _nameController.text.trim(),
        propertyDetailsPropertyId: _propertyIdController.text.trim(),
        municipalityName: _municipalityController.text.trim(),
        integratedPidPropertyId: _integratedPidController.text.trim(),
        integratedPidOwnerOccupierName: _integratedOwnerController.text.trim(),
        areaOfAuthority: _areaOfAuthorityController.text.trim(),
        colonyName: _colonyController.text.trim(),
        addressOfProperty: _addressController.text.trim(),
        mobileNo: _mobileController.text.trim(),
        category: _categoryController.text.trim(),
        totalArea: _totalAreaController.text.trim(),
        unit: _unitController.text.trim(),
        authorizationStatus: _authorizationStatusController.text.trim(),
        id: _generateBillId(),
        sourceType: '',
        createdBy: 1,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      setState(() => _saving = false);
      Navigator.of(context).pop(bill);
    }
  }

  int _generateBillId() {
    final now = DateTime.now();
    final timestamp = now.millisecondsSinceEpoch;
    return int.parse('BILL${timestamp.toString().substring(8)}');
    // return 'BILL${timestamp.toString().substring(8)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 64,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, backgroundColor],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.isEditMode ? 'Edit Bill' : 'New Bill Entry',
              style: GoogleFonts.poppins(
                color: textPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 18,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              'Step ${_currentStep + 1} of 3',
              style: GoogleFonts.inter(
                color: textSecondary,
                fontWeight: FontWeight.w500,
                fontSize: 11,
              ),
            ),
          ],
        ),
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
            color: textPrimary,
            padding: EdgeInsets.zero,
            constraints: BoxConstraints.tight(const Size(36, 36)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.info_outline_rounded, size: 18),
              color: textPrimary,
              padding: EdgeInsets.zero,
              constraints: BoxConstraints.tight(const Size(36, 36)),
              onPressed: () {},
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStepIndicator(),
              const SizedBox(height: 10),
              _buildClickableTabBar(),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStep1(),
                _buildStep2(),
                _buildStep3(),
              ],
            ),
          ),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Row(
          children: List.generate(3, (index) {
            final isActive = index <= _currentStep;
            final isCompleted = index < _currentStep;
            final stepColors = [
              primaryColor,
              locationColor,
              specificationsColor
            ];

            return Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 3,
                      decoration: BoxDecoration(
                        gradient: isActive
                            ? LinearGradient(
                                colors: [
                                  stepColors[index],
                                  stepColors[index].withOpacity(0.6),
                                ],
                              )
                            : null,
                        color: isActive ? null : borderColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  if (index < 2) const SizedBox(width: 3),
                ],
              ),
            );
          }),
        ));
  }

  Widget _buildClickableTabBar() {
    final stepIcons = [
      Icons.person_rounded,
      Icons.location_on_rounded,
      Icons.description_rounded,
    ];
    final stepColors = [primaryColor, locationColor, specificationsColor];
    final stepTitles = ['Basic Info', 'Location', 'image'];

    return GestureDetector(
      onTap: () {
        // Tab bar is ALWAYS clickable - go to next step regardless of form fill
        _nextStep();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: List.generate(3, (index) {
            final isActive = index == _currentStep;
            final isCompleted = index < _currentStep;

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  // Individual tab click - ALWAYS allowed
                  _tabController.animateTo(index);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                  decoration: BoxDecoration(
                    gradient: isActive
                        ? LinearGradient(
                            colors: [
                              stepColors[index],
                              stepColors[index].withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: isActive ? null : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: stepColors[index].withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: isActive
                              ? Colors.white.withOpacity(0.25)
                              : (isCompleted
                                  ? stepColors[index].withOpacity(0.15)
                                  : Colors.transparent),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isActive
                                ? Colors.white
                                : (isCompleted
                                    ? stepColors[index]
                                    : tabUnselectedColor),
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: isCompleted
                              ? Icon(
                                  Icons.check_rounded,
                                  color: stepColors[index],
                                  size: 16,
                                )
                              : Icon(
                                  stepIcons[index],
                                  color: isActive
                                      ? Colors.white
                                      : tabUnselectedColor,
                                  size: 14,
                                ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        stepTitles[index],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: isActive
                              ? Colors.white
                              : (isCompleted
                                  ? stepColors[index]
                                  : tabUnselectedColor),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Form(
          key: _formKey,
          child: Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(18),
              border:
                  Border.all(color: primaryColor.withOpacity(0.1), width: 1),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 8),
                _buildCompactTextField(
                  controller: _nameController,
                  label: 'Owner Name',
                  icon: Icons.person_outline_rounded,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 8),
                _buildCompactTextField(
                  controller: _propertyIdController,
                  label: 'Property ID',
                  icon: Icons.tag_rounded,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 8),
                _buildCompactTextField(
                  controller: _municipalityController,
                  label: 'Municipality',
                  icon: Icons.location_city_rounded,
                ),
                const SizedBox(height: 8),
                _buildCompactTextField(
                  controller: _mobileController,
                  label: 'Mobile Number',
                  icon: Icons.phone_android_rounded,
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
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: locationColor.withOpacity(0.1), width: 1),
            boxShadow: [
              BoxShadow(
                color: locationColor.withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              _buildCompactTextField(
                controller: _addressController,
                label: 'Address',
                icon: Icons.home_rounded,
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Address is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              _buildCompactTextField(
                controller: _colonyController,
                label: 'Colony',
                icon: Icons.landscape_rounded,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Colony is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              _buildCompactTextField(
                controller: _integratedPidController,
                label: 'Integrated PID',
                icon: Icons.qr_code_2_rounded,
              ),
              const SizedBox(height: 8),
              _buildCompactTextField(
                controller: _integratedOwnerController,
                label: 'Integrated Owner',
                icon: Icons.badge_rounded,
              ),
              const SizedBox(height: 8),
              _buildCompactTextField(
                controller: _areaOfAuthorityController,
                label: 'Area of Authority',
                icon: Icons.maps_home_work_rounded,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep3() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(18),
                border:
                    Border.all(color: photosColor.withOpacity(0.1), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: photosColor.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        _buildPhotoButton('Front View', Icons.home_rounded),
                        const SizedBox(height: 8),
                        _buildPhotoButton(
                            'Side View', Icons.photo_camera_rounded),
                        const SizedBox(height: 8),
                        _buildPhotoButton(
                            'Additional', Icons.add_a_photo_rounded),
                        const SizedBox(height: 8),
                        _buildPhotoButton('Location', Icons.map_rounded),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Save/Submit button for all steps
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _currentStep == 0
                        ? [primaryColor, primaryColor.withOpacity(0.8)]
                        : _currentStep == 1
                            ? [locationColor, locationColor.withOpacity(0.8)]
                            : [photosColor, photosColor.withOpacity(0.8)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: (_currentStep == 0
                              ? primaryColor
                              : _currentStep == 1
                                  ? locationColor
                                  : photosColor)
                          .withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _saving ? null : _submitForm,
                    borderRadius: BorderRadius.circular(14),
                    child: _saving
                        ? const Center(
                            child: SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _currentStep < 2
                                    ? Icons.save_rounded
                                    : Icons.check_circle_rounded,
                                size: 20,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _currentStep < 2
                                    ? 'Save & Continue'
                                    : 'Create Bill',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
            if (_currentStep > 0) const SizedBox(width: 10),
            // Previous button only for steps 1 and 2
            if (_currentStep > 0)
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _currentStep == 1 ? primaryColor : locationColor,
                    width: 1.5,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _previousStep,
                    borderRadius: BorderRadius.circular(14),
                    child: Center(
                      child: Icon(
                        Icons.arrow_back_rounded,
                        size: 20,
                        color: _currentStep == 1 ? primaryColor : locationColor,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        height: maxLines > 1 ? null : 46,
        child: TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: textPrimary,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: GoogleFonts.inter(
              fontSize: 12,
              color: textSecondary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
            prefixIcon: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.all(7),
              child: Icon(icon, size: 18, color: textPrimary),
            ),
            filled: true,
            fillColor: backgroundColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: textPrimary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: specificationsColor, width: 1.2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: specificationsColor, width: 2),
            ),
            errorStyle: GoogleFonts.inter(
              fontSize: 10,
              height: 0.7,
              fontWeight: FontWeight.w600,
            ),
          ),
          validator: validator,
        ),
      ),
    );
  }

  Widget _buildPhotoButton(String title, IconData icon) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                backgroundColor,
                backgroundColor.withOpacity(0.5),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 1.2),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [photosColor, photosColor.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: photosColor.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Icon(icon, size: 18, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: photosColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(Icons.camera_alt_rounded,
                    size: 16, color: photosColor),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: photosColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(Icons.upload_rounded, size: 16, color: photosColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
