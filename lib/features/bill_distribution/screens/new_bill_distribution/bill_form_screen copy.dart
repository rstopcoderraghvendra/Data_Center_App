import 'package:data_care_app/core/network/api_client.dart';
import 'package:data_care_app/core/storage/local_storage.dart';
import 'package:data_care_app/data/repositories/customer_repository.dart';
import 'package:data_care_app/features/bill_distribution/screens/model/bill_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class BillFormScreen extends StatefulWidget {
  final Bill? bill;
  final bool isEditMode;
  final int? projectId;
  final VoidCallback? onSaveSuccess;

  const BillFormScreen({
    super.key,
    this.bill,
    this.isEditMode = false,
    this.projectId,
    this.onSaveSuccess,
  });

  @override
  State<BillFormScreen> createState() => _BillFormScreenState();
}

class _BillFormScreenState extends State<BillFormScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;
  int _currentStep = 0;
  late final CustomerRepository _repository;

  // Image picker
  final ImagePicker _imagePicker = ImagePicker();

  // Store image files for new uploads
  File? _frontViewFile;
  File? _sideViewFile;
  File? _additionalFile;
  File? _locationFile;

  // Controllers for Step 1 (Basic Info)
  final _municipalityNameController = TextEditingController();
  final _propertyIdController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _mobileController = TextEditingController();

  // Controllers for Step 2 (Property Details) - ✅ REQUIRED VALIDATION HATA DIYA
  final _step2PropertyIdController = TextEditingController();
  final _step2OwnerNameController = TextEditingController();
  final _areaOfAuthorityController = TextEditingController();
  final _colonyNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _categoryController = TextEditingController();
  final _totalAreaController = TextEditingController();
  final _unitController = TextEditingController();
  final _authorizationStatusController = TextEditingController();

  // Image controllers for Step 3
  final _frontViewImageController = TextEditingController();
  final _sideViewImageController = TextEditingController();
  final _additionalImageController = TextEditingController();
  final _locationImageController = TextEditingController();

  bool _saving = false;
  String _errorMessage = '';
  int? _createdBillId;

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
    print('🔄 Initializing Bill Form Screen...');
    print('📋 Edit Mode: ${widget.isEditMode}');
    print('📋 Bill ID: ${widget.bill?.id}');

    _repository = CustomerRepository(ApiClient(storage: LocalStorage()));
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentStep = _tabController.index;
      });
    });

    if (widget.isEditMode && widget.bill != null) {
      _createdBillId = widget.bill!.id;
      _loadBillData();
    }
  }

  void _loadBillData() {
    print('📥 Loading bill data for ID: ${widget.bill!.id}');

    // Step 1 data
    _municipalityNameController.text = widget.bill!.municipalityName ?? '';
    _propertyIdController.text = widget.bill!.propertyDetailsPropertyId ?? '';
    _ownerNameController.text = widget.bill!.name ?? '';
    _mobileController.text = widget.bill!.mobileNo ?? '';

    // Step 2 data
    _step2PropertyIdController.text =
        widget.bill!.integratedPidPropertyId ?? '';
    _step2OwnerNameController.text =
        widget.bill!.integratedPidOwnerOccupierName ?? '';
    _areaOfAuthorityController.text = widget.bill!.areaOfAuthority ?? '';
    _colonyNameController.text = widget.bill!.colonyName ?? '';
    _addressController.text = widget.bill!.addressOfProperty ?? '';
    _categoryController.text = widget.bill!.category ?? '';
    _totalAreaController.text = widget.bill!.totalArea ?? '';
    _unitController.text = widget.bill!.unit ?? '';
    _authorizationStatusController.text =
        widget.bill!.authorizationStatus ?? '';

    // Step 3 data (images)
    if (widget.bill!.frontViewUrl != null) {
      _frontViewImageController.text = widget.bill!.frontViewUrl!;
    }
    if (widget.bill!.sideViewUrl != null) {
      _sideViewImageController.text = widget.bill!.sideViewUrl!;
    }
    if (widget.bill!.additionalUrl != null) {
      _additionalImageController.text = widget.bill!.additionalUrl!;
    }
    if (widget.bill!.locationUrl != null) {
      _locationImageController.text = widget.bill!.locationUrl!;
    }

    print('✅ Bill data loaded successfully');
  }

  @override
  void dispose() {
    _tabController.dispose();

    // Step 1 controllers
    _municipalityNameController.dispose();
    _propertyIdController.dispose();
    _ownerNameController.dispose();
    _mobileController.dispose();

    // Step 2 controllers
    _step2PropertyIdController.dispose();
    _step2OwnerNameController.dispose();
    _areaOfAuthorityController.dispose();
    _colonyNameController.dispose();
    _addressController.dispose();
    _categoryController.dispose();
    _totalAreaController.dispose();
    _unitController.dispose();
    _authorizationStatusController.dispose();

    // Step 3 controllers
    _frontViewImageController.dispose();
    _sideViewImageController.dispose();
    _additionalImageController.dispose();
    _locationImageController.dispose();

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
        // Step 1 में केवल Mobile का validation
        if (_mobileController.text.isNotEmpty &&
            _mobileController.text.length < 10) {
          return false;
        }
        return true; // ✅ अन्य fields required नहीं हैं
      case 1:
        // Step 2 में कोई required validation नहीं - ✅ CHANGED
        return true;
      case 2:
        // Images optional
        return true;
      default:
        return true;
    }
  }

  Map<String, dynamic> _getCurrentStepData() {
    final Map<String, dynamic> data = {
      'source_type': 'bill_distribution',
    };

    switch (_currentStep) {
      case 0: // Basic Info
        // ✅ API के हिसाब से exact field names
        if (_municipalityNameController.text.trim().isNotEmpty) {
          data['municipality_name'] = _municipalityNameController.text.trim();
        }
        if (_propertyIdController.text.trim().isNotEmpty) {
          data['property_details_property_id'] =
              _propertyIdController.text.trim();
        }
        if (_ownerNameController.text.trim().isNotEmpty) {
          data['name'] = _ownerNameController.text.trim();
        }
        if (_mobileController.text.trim().isNotEmpty) {
          data['mobile_no'] = _mobileController.text.trim();
        }
        break;
      case 1: // Property Details
        // ✅ API के हिसाब से exact field names
        if (_step2PropertyIdController.text.trim().isNotEmpty) {
          data['integrated_pid_property_id'] =
              _step2PropertyIdController.text.trim();
        }
        if (_step2OwnerNameController.text.trim().isNotEmpty) {
          data['integrated_pid_owner_occupier_name'] =
              _step2OwnerNameController.text.trim();
        }
        if (_areaOfAuthorityController.text.trim().isNotEmpty) {
          data['area_of_authority'] = _areaOfAuthorityController.text.trim();
        }
        if (_colonyNameController.text.trim().isNotEmpty) {
          data['colony_name'] = _colonyNameController.text.trim();
        }
        if (_addressController.text.trim().isNotEmpty) {
          data['address_of_property'] = _addressController.text.trim();
        }
        if (_categoryController.text.trim().isNotEmpty) {
          data['category'] = _categoryController.text.trim();
        }
        if (_totalAreaController.text.trim().isNotEmpty) {
          // Try to parse as number if possible
          final totalAreaText = _totalAreaController.text.trim();
          final totalAreaNum = int.tryParse(totalAreaText);
          data['total_area'] = totalAreaNum ?? totalAreaText;
        }
        if (_unitController.text.trim().isNotEmpty) {
          data['unit'] = _unitController.text.trim();
        }
        if (_authorizationStatusController.text.trim().isNotEmpty) {
          data['authorization_status'] =
              _authorizationStatusController.text.trim();
        }
        break;
      case 2: // Images
        // Images will be handled separately
        break;
    }

    // ✅ Debug: Print the data being sent
    print('📤 API Request Data for Step ${_currentStep + 1}:');
    data.forEach((key, value) {
      print('   $key: $value');
    });

    return data;
  }

  Future<void> _submitForm() async {
    if (!_validateCurrentStep()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please check the entered data in Step ${_currentStep + 1}',
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

    setState(() {
      _saving = true;
      _errorMessage = '';
    });

    print('🚀 Submitting form data for Step ${_currentStep + 1}...');

    try {
      // Get form data
      final stepData = _getCurrentStepData();
      print('📊 Step Data: $stepData');
      // stepData['verifiy_vy'] = 'vy';

      // Prepare image files if we're in step 2 (images)
      Map<String, File>? imageFiles;

      if (_currentStep == 2) {
        imageFiles = {};

        // Check for new image files
        if (_frontViewFile != null) {
          imageFiles['front_view'] = _frontViewFile!;
          print('📸 Front view image selected');
        }
        if (_sideViewFile != null) {
          imageFiles['side_view'] = _sideViewFile!;
          print('📸 Side view image selected');
        }
        if (_additionalFile != null) {
          imageFiles['additional'] = _additionalFile!;
          print('📸 Additional image selected');
        }
        if (_locationFile != null) {
          imageFiles['location'] = _locationFile!;
          print('📍 Location image selected');
        }

        // If no new files but we have existing URLs in edit mode
        if (widget.isEditMode && imageFiles.isEmpty) {
          // Create a map of existing image URLs
          final Map<String, dynamic> existingImages = {};

          if (_frontViewImageController.text.isNotEmpty) {
            existingImages['front_view'] = _frontViewImageController.text;
          }
          if (_sideViewImageController.text.isNotEmpty) {
            existingImages['side_view'] = _sideViewImageController.text;
          }
          if (_additionalImageController.text.isNotEmpty) {
            existingImages['additional'] = _additionalImageController.text;
          }
          if (_locationImageController.text.isNotEmpty) {
            existingImages['location'] = _locationImageController.text;
          }

          if (existingImages.isNotEmpty) {
            stepData['property_images'] = existingImages;
            print('🖼️ Existing images data added');
          }
        }
      }

      Map<String, dynamic> response;

      if (widget.isEditMode && widget.bill != null) {
        // Edit mode - update current step data
        print('✏️ Updating bill ID: ${widget.bill!.id}');

        response = await _repository.updateCustomer(
          widget.bill!.id!,
          stepData,
          imageFiles: imageFiles?.isNotEmpty == true ? imageFiles : null,
        );

        print('✅ Bill update API response received');

        // Show success dialog
        await _showSuccessDialog();
      } else {
        // CREATE NEW BILL IS NOT ALLOWED
        throw Exception('Cannot create new bill. Only update mode is allowed.');
      }

      final updatedBill = Bill.fromJson(response);
      print('📋 Updated Bill: ${updatedBill.id} - ${updatedBill.name}');

      setState(() => _saving = false);

      // Call callback to refresh list if on last step
      if (_currentStep == 2) {
        widget.onSaveSuccess?.call();
        print('📞 Calling onSaveSuccess callback');
        if (mounted) {
          Navigator.of(context).pop(updatedBill);
        }
      }
    } catch (e) {
      print('❌ Error submitting form: $e');
      setState(() {
        _saving = false;
        _errorMessage = e.toString();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: ${e.toString()}',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(12),
          ),
        );
      }
    }
  }

  Future<void> _showSuccessDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green.shade600, size: 24),
              const SizedBox(width: 10),
              Text(
                'Success',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: textPrimary,
                ),
              ),
            ],
          ),
          content: Text(
            _currentStep == 2
                ? 'Images saved successfully! The bill is now complete.'
                : 'Step ${_currentStep + 1} data saved successfully!',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (_currentStep < 2) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Click on next tab to continue',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
                      backgroundColor: primaryColor,
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Text(
                'OK',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _takePhotoForField(String imageType) async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final file = File(pickedFile.path);

        setState(() {
          switch (imageType) {
            case 'front_view':
              _frontViewFile = file;
              break;
            case 'side_view':
              _sideViewFile = file;
              break;
            case 'additional':
              _additionalFile = file;
              break;
            case 'location':
              _locationFile = file;
              break;
          }
        });

        print('📸 Photo taken for $imageType');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error taking photo: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showImageSourceDialog(String label, String imageType) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            label,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading:
                    const Icon(Icons.camera_alt_rounded, color: photosColor),
                title: Text(
                  'Take Photo',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _takePhotoForField(imageType);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showRemoveImageDialog(String label, String imageType) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.delete_rounded, color: Colors.red.shade600, size: 24),
              const SizedBox(width: 10),
              Text(
                'Remove Image?',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: textPrimary,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to remove $label? This action cannot be undone.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  color: textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  switch (imageType) {
                    case 'front_view':
                      _frontViewFile = null;
                      break;
                    case 'side_view':
                      _sideViewFile = null;
                      break;
                    case 'additional':
                      _additionalFile = null;
                      break;
                    case 'location':
                      _locationFile = null;
                      break;
                  }
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '$label removed. Click "Update" to save changes.',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    ),
                    backgroundColor: photosColor,
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 3),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
              ),
              child: Text(
                'Remove',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
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
              widget.isEditMode ? 'Update Bill' : 'New Bill Entry',
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
          if (_errorMessage.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.red.shade50,
              child: Row(
                children: [
                  Icon(Icons.error_outline,
                      color: Colors.red.shade700, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage,
                      style: GoogleFonts.inter(
                        color: Colors.red.shade700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  IconButton(
                    icon:
                        Icon(Icons.close, size: 16, color: Colors.red.shade700),
                    onPressed: () => setState(() => _errorMessage = ''),
                  ),
                ],
              ),
            ),
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
      Icons.image_rounded,
    ];
    final stepColors = [primaryColor, locationColor, specificationsColor];
    final stepTitles = ['Basic Info', 'Property Details', 'Images'];

    return GestureDetector(
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
                  controller: _municipalityNameController,
                  label: 'Municipality Name', // ✅ * HATA DIYA
                  icon: Icons.location_city_rounded,
                ),
                const SizedBox(height: 8),
                _buildCompactTextField(
                  controller: _propertyIdController,
                  label: 'Property Id', // ✅ * HATA DIYA
                  icon: Icons.tag_rounded,
                ),
                const SizedBox(height: 8),
                _buildCompactTextField(
                  controller: _ownerNameController,
                  label: 'Owner/Occupier Name', // ✅ * HATA DIYA
                  icon: Icons.person_outline_rounded,
                ),
                const SizedBox(height: 8),
                _buildCompactTextField(
                  controller: _mobileController,
                  label: 'Mobile No.',
                  icon: Icons.phone_android_rounded,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value != null &&
                        value.isNotEmpty &&
                        value.length < 10) {
                      return 'Enter valid mobile number';
                    }
                    return null; // ✅ खाली भी रह सकता है
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  'Note: You can update any field. All fields are optional.', // ✅ Updated message
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
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
                controller: _step2PropertyIdController,
                label: 'Property Id', // ✅ * HATA DIYA
                icon: Icons.tag_rounded,
              ),
              const SizedBox(height: 8),
              _buildCompactTextField(
                controller: _step2OwnerNameController,
                label: 'Owner/Occupier Name', // ✅ * HATA DIYA
                icon: Icons.person_outline_rounded,
              ),
              const SizedBox(height: 8),
              _buildCompactTextField(
                controller: _areaOfAuthorityController,
                label: 'Area Of the Authority', // ✅ * HATA DIYA
                icon: Icons.map_rounded,
              ),
              const SizedBox(height: 8),
              _buildCompactTextField(
                controller: _colonyNameController,
                label: 'Name Of the Colony', // ✅ * HATA DIYA
                icon: Icons.landscape_rounded,
              ),
              const SizedBox(height: 8),
              _buildCompactTextField(
                controller: _addressController,
                label: 'Address of Property', // ✅ * HATA DIYA
                icon: Icons.home_rounded,
                maxLines: 2,
              ),
              const SizedBox(height: 8),
              _buildCompactTextField(
                controller: _categoryController,
                label: 'Category', // ✅ * HATA DIYA
                icon: Icons.category_rounded,
              ),
              const SizedBox(height: 8),
              _buildCompactTextField(
                controller: _totalAreaController,
                label: 'Total Area', // ✅ * HATA DIYA
                icon: Icons.aspect_ratio_rounded,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              _buildCompactTextField(
                controller: _unitController,
                label: 'Unit', // ✅ * HATA DIYA
                icon: Icons.square_foot_rounded,
              ),
              const SizedBox(height: 8),
              _buildCompactTextField(
                controller: _authorizationStatusController,
                label: 'Authorized Area / Unauthorized', // ✅ * HATA DIYA
                icon: Icons.verified_rounded,
              ),
              const SizedBox(height: 8),
              Text(
                'Note: Update as many fields as needed. All fields are optional.', // ✅ Updated message
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: textSecondary,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
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
                        // Front View Image Field
                        if (widget.isEditMode &&
                            widget.bill?.frontViewUrl != null &&
                            widget.bill!.frontViewUrl!.isNotEmpty)
                          _buildImagePreview(
                            imageUrl: widget.bill!.frontViewUrl!,
                            label: 'Front View Image',
                            imageType: 'front_view',
                          )
                        else
                          _buildImageField(
                            label: 'Front View Image',
                            icon: Icons.home_rounded,
                            imageType: 'front_view',
                          ),
                        const SizedBox(height: 8),

                        // Side View Image Field
                        if (widget.isEditMode &&
                            widget.bill?.sideViewUrl != null &&
                            widget.bill!.sideViewUrl!.isNotEmpty)
                          _buildImagePreview(
                            imageUrl: widget.bill!.sideViewUrl!,
                            label: 'Side View Image',
                            imageType: 'side_view',
                          )
                        else
                          _buildImageField(
                            label: 'Side View Image',
                            icon: Icons.camera_alt_rounded,
                            imageType: 'side_view',
                          ),
                        const SizedBox(height: 8),

                        // Additional Images Field
                        if (widget.isEditMode &&
                            widget.bill?.additionalUrl != null &&
                            widget.bill!.additionalUrl!.isNotEmpty)
                          _buildImagePreview(
                            imageUrl: widget.bill!.additionalUrl!,
                            label: 'Additional Images',
                            imageType: 'additional',
                          )
                        else
                          _buildImageField(
                            label: 'Additional Images',
                            icon: Icons.add_photo_alternate_rounded,
                            imageType: 'additional',
                          ),
                        const SizedBox(height: 8),

                        // Location Image Field
                        if (widget.isEditMode &&
                            widget.bill?.locationUrl != null &&
                            widget.bill!.locationUrl!.isNotEmpty)
                          _buildImagePreview(
                            imageUrl: widget.bill!.locationUrl!,
                            label: 'Location Image',
                            imageType: 'location',
                          )
                        else
                          _buildImageField(
                            label: 'Location Image',
                            icon: Icons.map_rounded,
                            imageType: 'location',
                          ),
                        const SizedBox(height: 8),

                        Text(
                          'Note: Images are optional. You can add or update later.',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: textSecondary,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
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

  Widget _buildImagePreview({
    required String imageUrl,
    required String label,
    required String imageType,
  }) {
    return Material(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: textPrimary,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(12),
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
            child: Column(
              children: [
                // Image Preview
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade100,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.broken_image_rounded,
                                color: Colors.grey.shade400,
                                size: 40,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Image not available',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                            strokeWidth: 2,
                            color: photosColor,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Image Path
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          imageUrl,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.grey.shade700,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.link_rounded,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _showImageSourceDialog(label, imageType);
                        },
                        icon: const Icon(Icons.change_circle_rounded, size: 16),
                        label: Text(
                          'Change Image',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: photosColor.withOpacity(0.1),
                          foregroundColor: photosColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: photosColor, width: 1),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(color: Colors.red.shade200, width: 1),
                      ),
                      child: IconButton(
                        onPressed: () {
                          _showRemoveImageDialog(label, imageType);
                        },
                        icon: Icon(
                          Icons.delete_rounded,
                          size: 18,
                          color: Colors.red.shade600,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageField({
    required String label,
    required IconData icon,
    required String imageType,
  }) {
    final bool hasImage = imageType == 'front_view' && _frontViewFile != null ||
        imageType == 'side_view' && _sideViewFile != null ||
        imageType == 'additional' && _additionalFile != null ||
        imageType == 'location' && _locationFile != null;

    String displayText = '';
    if (hasImage) {
      switch (imageType) {
        case 'front_view':
          displayText = _frontViewFile?.path ?? '';
          break;
        case 'side_view':
          displayText = _sideViewFile?.path ?? '';
          break;
        case 'additional':
          displayText = _additionalFile?.path ?? '';
          break;
        case 'location':
          displayText = _locationFile?.path ?? '';
          break;
      }
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _showImageSourceDialog(label, imageType);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                        letterSpacing: 0.2,
                      ),
                    ),
                    if (hasImage && displayText.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          displayText.length > 30
                              ? '${displayText.substring(0, 30)}...'
                              : displayText,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: textSecondary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: photosColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  hasImage ? Icons.check_circle : Icons.upload_rounded,
                  size: 16,
                  color: hasImage ? Colors.green : Colors.black54,
                ),
              ),
            ],
          ),
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
            // Update button for current step
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
                                Icons.update_rounded,
                                size: 20,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Update',
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
}
