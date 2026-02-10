import 'package:data_care_app/core/network/api_client.dart';
import 'package:data_care_app/core/storage/local_storage.dart';
import 'package:data_care_app/data/repositories/customer_repository.dart';
import 'package:data_care_app/features/model/survey_model/survey_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class SurveyFormScreen extends StatefulWidget {
  final Survey? survey;
  final bool isEditMode;
  final int? projectId;
  final VoidCallback? onSaveSuccess;

  const SurveyFormScreen({
    super.key,
    this.survey,
    this.isEditMode = false,
    this.projectId,
    this.onSaveSuccess,
  });

  @override
  State<SurveyFormScreen> createState() => _SurveyFormScreenState();
}

class _SurveyFormScreenState extends State<SurveyFormScreen>
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

  // Controllers for Step 1
  final _municipalityNameController = TextEditingController();
  final _propertyIdController = TextEditingController();
  final _ownerNameController = TextEditingController();

  // Controllers for Step 2
  final _step2PropertyIdController = TextEditingController();
  final _step2OwnerNameController = TextEditingController();
  final _areaOfAuthorityController = TextEditingController();
  final _colonyNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _mobileController = TextEditingController();
  final _categoryController = TextEditingController();
  final _totalAreaController = TextEditingController();
  final _unitController = TextEditingController();
  final _authorizationStatusController = TextEditingController();

  // Image URLs for Step 3 (using display getters from model)
  final _frontViewImageController = TextEditingController();
  final _sideViewImageController = TextEditingController();
  final _additionalImageController = TextEditingController();
  final _locationImageController = TextEditingController();

  bool _saving = false;
  bool _isSubmitting = false;
  String _errorMessage = '';
  int? _createdSurveyId;

  // Premium Color Theme (Same as Bill Form)
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
    _repository = CustomerRepository(ApiClient(storage: LocalStorage()));
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentStep = _tabController.index;
      });
    });

    if (widget.isEditMode && widget.survey != null) {
      _createdSurveyId = widget.survey!.id;
      _loadSurveyData();
    }
  }

  void _loadSurveyData() {
    if (widget.survey == null) return;

    // Step 1 data
    _municipalityNameController.text = widget.survey!.municipalityName ?? '';
    _propertyIdController.text = widget.survey!.propertyDetailsPropertyId ?? '';
    _ownerNameController.text = widget.survey!.name ?? '';

    // Step 2 data
    _step2PropertyIdController.text =
        widget.survey!.integratedPidPropertyId ?? '';
    _step2OwnerNameController.text =
        widget.survey!.integratedPidOwnerOccupierName ?? '';
    _areaOfAuthorityController.text =
        widget.survey!.areaOfAuthority?.toString() ?? '';
    _colonyNameController.text = widget.survey!.colonyName ?? '';
    _addressController.text = widget.survey!.addressOfProperty ?? '';
    _mobileController.text = widget.survey!.mobileNo ?? '';
    _categoryController.text = widget.survey!.category?.toString() ?? '';
    _totalAreaController.text = widget.survey!.totalArea?.toString() ?? '';
    _unitController.text = widget.survey!.unit?.toString() ?? '';
    _authorizationStatusController.text =
        widget.survey!.authorizationStatus?.toString() ?? '';

    // Step 3 data (images) - Use display getters from model
    _frontViewImageController.text = widget.survey!.displayFrontView ?? '';
    _sideViewImageController.text = widget.survey!.displaySideView ?? '';
    _additionalImageController.text = widget.survey!.displayAdditional ?? '';
    _locationImageController.text = widget.survey!.displayLocation ?? '';
  }

  @override
  void dispose() {
    _tabController.dispose();

    // Step 1 controllers
    _municipalityNameController.dispose();
    _propertyIdController.dispose();
    _ownerNameController.dispose();

    // Step 2 controllers
    _step2PropertyIdController.dispose();
    _step2OwnerNameController.dispose();
    _areaOfAuthorityController.dispose();
    _colonyNameController.dispose();
    _addressController.dispose();
    _mobileController.dispose();
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

  // ✅ CHANGED: Sab fields optional hai, koi validation nahi
  bool _validateCurrentStep() {
    // Sab steps ke liye hamesha true return karega
    // Kyunki koi bhi field required nahi hai
    return true;
  }

  Map<String, dynamic> _getCurrentStepData() {
    final Map<String, dynamic> data = {
      'source_type': 'survey',
    };

    switch (_currentStep) {
      case 0: // Basic Info
        data.addAll({
          'municipality_name': _municipalityNameController.text.trim(),
          'property_details_property_id': _propertyIdController.text.trim(),
          'name': _ownerNameController.text.trim(),
        });
        break;
      case 1: // Location & Details
        data.addAll({
          'property_id': _step2PropertyIdController.text.trim(),
          'integrated_pid_owner_occupier_name':
              _step2OwnerNameController.text.trim(),
          'area_of_authority': _areaOfAuthorityController.text.trim(),
          'colony_name': _colonyNameController.text.trim(),
          'address_of_property': _addressController.text.trim(),
          'mobile_no': _mobileController.text.trim(),
          'category': _categoryController.text.trim(),
          'total_area': _totalAreaController.text.trim(),
          'unit': _unitController.text.trim(),
          'authorization_status': _authorizationStatusController.text.trim(),
        });
        break;
      case 2: // Images
        // For images step, we'll handle files separately
        break;
    }

    return data;
  }

  // Future<void> _submitForm() async {
  //   // ✅ CRITICAL FIX: Prevent double submission
  //   if (_isSubmitting) {
  //     print('⏸️ Form already submitting, ignoring duplicate click');
  //     return;
  //   }

  //   // ✅ CHANGED: No validation check, directly proceed
  //   setState(() {
  //     _isSubmitting = true;
  //     _saving = true;
  //     _errorMessage = '';
  //   });

  //   try {
  //     // Get form data
  //     final stepData = _getCurrentStepData();
  //     // stepData['verifiy_vy'] = 'vy'; // Ensure source_type is always set

  //     // Debug print
  //     print('\n=== SURVEY FORM SUBMIT ===');
  //     print('Current Step: $_currentStep');
  //     print('Is Edit Mode: ${widget.isEditMode}');
  //     print('Created Survey ID: $_createdSurveyId');
  //     print('Project ID: ${widget.projectId}');
  //     print('Step Data: $stepData');

  //     // Prepare image files for upload
  //     Map<String, File>? imageFiles;

  //     if (_currentStep == 2) {
  //       imageFiles = {};

  //       // Check for new image files
  //       if (_frontViewFile != null) {
  //         imageFiles['front_view'] = _frontViewFile!;
  //         print('📸 Front view image selected');
  //       }
  //       if (_sideViewFile != null) {
  //         imageFiles['side_view'] = _sideViewFile!;
  //         print('📸 Side view image selected');
  //       }
  //       if (_additionalFile != null) {
  //         imageFiles['additional'] = _additionalFile!;
  //         print('📸 Additional image selected');
  //       }
  //       if (_locationFile != null) {
  //         imageFiles['location'] = _locationFile!;
  //         print('📸 Location image selected');
  //       }

  //       // If no new files, make sure imageFiles is null
  //       if (imageFiles.isEmpty) {
  //         imageFiles = null;
  //         print('📸 No new images to upload');
  //       }
  //     }

  //     Map<String, dynamic> apiResponse;
  //     Survey updatedSurvey;

  //     // ✅ SIMPLIFIED LOGIC: Always UPDATE if survey exists
  //     if (widget.isEditMode || _createdSurveyId != null) {
  //       // ✅ UPDATE MODE - Use existing survey ID
  //       final surveyIdToUpdate =
  //           widget.isEditMode ? widget.survey!.id! : _createdSurveyId!;

  //       print('🔄 UPDATE MODE: Survey ID $surveyIdToUpdate');

  //       apiResponse = await _repository.updateCustomer(
  //         surveyIdToUpdate,
  //         stepData,
  //         imageFiles: imageFiles,
  //       );

  //       print('✅ Update successful for ID $surveyIdToUpdate');
  //     } else {
  //       // ✅ CREATE MODE - Only for first time save (Step 0)
  //       print('🆕 CREATE MODE: Creating new survey');

  //       if (widget.projectId == null) {
  //         throw Exception('Project ID is required to create a new survey');
  //       }

  //       apiResponse = await _repository.createCustomer(
  //         projectId: widget.projectId!,
  //         data: stepData,
  //         imageFiles: imageFiles,
  //       );

  //       print('✅ Create successful');
  //     }

  //     // Parse response to get survey
  //     updatedSurvey = _parseSurveyFromResponse(apiResponse);

  //     // ✅ CRITICAL FIX: Store survey ID after first create
  //     if (_createdSurveyId == null && updatedSurvey.id != null) {
  //       _createdSurveyId = updatedSurvey.id;
  //       print('📌 Stored new Survey ID: $_createdSurveyId');
  //     }

  //     // ✅ Show success dialog
  //     await _showSuccessDialog();

  //     setState(() {
  //       _isSubmitting = false;
  //       _saving = false;
  //     });

  //     // ✅ If last step completed, return to list
  //     if (_currentStep == 2) {
  //       // Call callback to refresh list
  //       widget.onSaveSuccess?.call();

  //       if (mounted) {
  //         Navigator.of(context).pop(updatedSurvey);
  //       }
  //     }
  //   } catch (e) {
  //     setState(() {
  //       _isSubmitting = false;
  //       _saving = false;
  //       _errorMessage = e.toString();
  //     });

  //     print('❌ Error: $e');
  //     print('Stack trace: ${e.toString()}');

  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text(
  //             'Error: ${e.toString()}',
  //             style: GoogleFonts.inter(
  //               fontWeight: FontWeight.w600,
  //             ),
  //           ),
  //           backgroundColor: Colors.red,
  //           behavior: SnackBarBehavior.floating,
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //           margin: const EdgeInsets.all(12),
  //         ),
  //       );
  //     }
  //   }
  // }
  Future<void> _submitForm() async {
    // ✅ CRITICAL FIX: Prevent double submission
    if (_isSubmitting) {
      print('⏸️ Form already submitting, ignoring duplicate click');
      return;
    }

    // ✅ NEW: Check if we're on Step 3 (Images) and show verification popup
    if (_currentStep == 2) {
      // Check if any new image is selected OR existing images present
      final bool hasNewImages = _frontViewFile != null ||
          _sideViewFile != null ||
          _additionalFile != null ||
          _locationFile != null;

      final bool hasExistingImages = widget.isEditMode &&
          (_frontViewImageController.text.isNotEmpty ||
              _sideViewImageController.text.isNotEmpty ||
              _additionalImageController.text.isNotEmpty ||
              _locationImageController.text.isNotEmpty);

      // If there are images (new or existing), show verification popup
      if (hasNewImages || hasExistingImages) {
        final verificationResult = await _showImageVerificationPopup();
        if (verificationResult == null) {
          print('❌ Image verification cancelled by user');
          return;
        }

        // Get verification data from popup
        final verifyByText = verificationResult['verify_by']?.trim() ?? '';
        final agreedToTerms = verificationResult['agreed_to_terms'] ?? false;

        // Validate inputs
        if (verifyByText.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Please enter verification text',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
              backgroundColor: Colors.orange,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
          return;
        }

        if (!agreedToTerms) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Please agree to the terms to proceed',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
              backgroundColor: Colors.orange,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
          return;
        }

        // Now proceed with form submission with verify_by text
        await _proceedWithFormSubmission(verifyByText);
        return;
      } else {
        // No images at all - just proceed normally
        final shouldProceed = await _showNoImagesVerificationDialog();
        if (!shouldProceed) {
          print('❌ Image save cancelled by user');
          return;
        }
      }
    }

    // ✅ For non-image steps or when no images, proceed normally
    await _proceedWithFormSubmission('');
  }

// ✅ NEW: Main form submission method with verify_by parameter
  Future<void> _proceedWithFormSubmission(String verifyByText) async {
    setState(() {
      _isSubmitting = true;
      _saving = true;
      _errorMessage = '';
    });

    try {
      // Get form data
      final stepData = _getCurrentStepData();

      // ✅ Add verify_by field to the data
      stepData['verify_by'] = verifyByText;

      // Debug print
      print('\n=== SURVEY FORM SUBMIT ===');
      print('Current Step: $_currentStep');
      print('Is Edit Mode: ${widget.isEditMode}');
      print('Created Survey ID: $_createdSurveyId');
      print('Project ID: ${widget.projectId}');
      print('Verify By Text: $verifyByText');
      print('Step Data: $stepData');

      // Prepare image files for upload
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
          print('📸 Location image selected');
        }

        // If no new files, make sure imageFiles is null
        if (imageFiles.isEmpty) {
          imageFiles = null;
          print('📸 No new images to upload');
        }
      }

      Map<String, dynamic> apiResponse;
      Survey updatedSurvey;

      // ✅ SIMPLIFIED LOGIC: Always UPDATE if survey exists
      if (widget.isEditMode || _createdSurveyId != null) {
        // ✅ UPDATE MODE - Use existing survey ID
        final surveyIdToUpdate =
            widget.isEditMode ? widget.survey!.id! : _createdSurveyId!;

        print('🔄 UPDATE MODE: Survey ID $surveyIdToUpdate');

        apiResponse = await _repository.updateCustomer(
          surveyIdToUpdate,
          stepData,
          imageFiles: imageFiles,
        );

        print('✅ Update successful for ID $surveyIdToUpdate');
      } else {
        // ✅ CREATE MODE - Only for first time save (Step 0)
        print('🆕 CREATE MODE: Creating new survey');

        if (widget.projectId == null) {
          throw Exception('Project ID is required to create a new survey');
        }

        apiResponse = await _repository.createCustomer(
          projectId: widget.projectId!,
          data: stepData,
          imageFiles: imageFiles,
        );

        print('✅ Create successful');
      }

      // Parse response to get survey
      updatedSurvey = _parseSurveyFromResponse(apiResponse);

      // ✅ CRITICAL FIX: Store survey ID after first create
      if (_createdSurveyId == null && updatedSurvey.id != null) {
        _createdSurveyId = updatedSurvey.id;
        print('📌 Stored new Survey ID: $_createdSurveyId');
      }

      // ✅ Show success dialog
      await _showSuccessDialog();

      setState(() {
        _isSubmitting = false;
        _saving = false;
      });

      // ✅ If last step completed, return to list
      if (_currentStep == 2) {
        // Call callback to refresh list
        widget.onSaveSuccess?.call();

        if (mounted) {
          Navigator.of(context).pop(updatedSurvey);
        }
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
        _saving = false;
        _errorMessage = e.toString();
      });

      print('❌ Error: $e');
      print('Stack trace: ${e.toString()}');

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

// ✅ NEW: Image verification popup dialog
  Future<Map<String, dynamic>?> _showImageVerificationPopup() async {
    final TextEditingController verifyByController = TextEditingController();
    bool agreedToTerms = false;

    return await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Icon(Icons.verified_user_rounded,
                      color: Colors.purple.shade600, size: 24),
                  const SizedBox(width: 10),
                  Text(
                    'Image Verification',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: textPrimary,
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Verification text
                    Text(
                      'Verify By',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Input field for verify_by
                    TextFormField(
                      controller: verifyByController,
                      decoration: InputDecoration(
                        hintText: 'Enter verification text...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(color: borderColor, width: 1.2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: primaryColor, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                      maxLines: 1,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Checkbox for terms agreement
                    Row(
                      children: [
                        Checkbox(
                          value: agreedToTerms,
                          onChanged: (value) {
                            setState(() {
                              agreedToTerms = value ?? false;
                            });
                          },
                          activeColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'I confirm that the uploaded images are accurate and verified',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Info box
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.purple.shade100),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline_rounded,
                              color: Colors.purple.shade600, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'This verification text will be saved with your survey images.',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.purple.shade800,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(null),
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
                    if (verifyByController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Please enter verification text',
                            style:
                                GoogleFonts.inter(fontWeight: FontWeight.w600),
                          ),
                          backgroundColor: Colors.orange,
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                      return;
                    }

                    if (!agreedToTerms) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Please agree to the terms',
                            style:
                                GoogleFonts.inter(fontWeight: FontWeight.w600),
                          ),
                          backgroundColor: Colors.orange,
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                      return;
                    }

                    Navigator.of(context).pop({
                      'verify_by': verifyByController.text.trim(),
                      'agreed_to_terms': agreedToTerms,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: photosColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Submit',
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
      },
    );
  }

// ✅ NEW: No images verification dialog
  Future<bool> _showNoImagesVerificationDialog() async {
    return await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: Colors.orange.shade600, size: 24),
                  const SizedBox(width: 10),
                  Text(
                    'No Images Selected',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: textPrimary,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'You haven\'t selected any images for this survey.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.shade100),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline_rounded,
                            color: Colors.orange.shade600, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'You can add images later by editing this survey.',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.orange.shade800,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      color: textSecondary,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: photosColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Save Without Images',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Survey _parseSurveyFromResponse(Map<String, dynamic> apiResponse) {
    try {
      if (apiResponse.containsKey('data')) {
        final responseData = apiResponse['data'];
        if (responseData is List && responseData.isNotEmpty) {
          return Survey.fromJson(responseData[0]);
        } else if (responseData is Map<String, dynamic>) {
          return Survey.fromJson(responseData);
        }
      }
      return Survey.fromJson(apiResponse);
    } catch (e) {
      print('Error parsing survey from response: $e');
      rethrow;
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
                ? 'Images saved successfully! The survey is now complete.'
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
                if (_currentStep < 2 && !widget.isEditMode) {
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

  // Image handling methods
  Future<void> _pickImageForField(String imageType) async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
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
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
              widget.isEditMode ? 'Edit Survey' : 'New Survey Entry',
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
    final stepTitles = ['Basic Info', 'Location & Details', 'Images'];

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
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: primaryColor.withOpacity(0.1), width: 1),
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
              // ✅ CHANGED: Sab fields optional hai, validator nahi
              _buildCompactTextField(
                controller: _municipalityNameController,
                label: 'Municipality Name', // * removed
                icon: Icons.location_city_rounded,
              ),
              const SizedBox(height: 8),
              _buildCompactTextField(
                controller: _propertyIdController,
                label: 'Property Id', // * removed
                icon: Icons.tag_rounded,
              ),
              const SizedBox(height: 8),
              _buildCompactTextField(
                controller: _ownerNameController,
                label: 'Owner/Occupier Name', // * removed
                icon: Icons.person_outline_rounded,
              ),
              const SizedBox(height: 8),
              Text(
                'Note: Fill basic information and save to proceed',
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
              // ✅ CHANGED: Sab fields optional hai, validator nahi
              _buildCompactTextField(
                controller: _step2PropertyIdController,
                label: 'Property Id', // * removed
                icon: Icons.tag_rounded,
              ),
              const SizedBox(height: 8),
              _buildCompactTextField(
                controller: _step2OwnerNameController,
                label: 'Owner/Occupier Name', // * removed
                icon: Icons.person_outline_rounded,
              ),
              const SizedBox(height: 8),
              _buildCompactTextField(
                controller: _areaOfAuthorityController,
                label: 'Area Of the Authority', // * removed
                icon: Icons.map_rounded,
              ),
              const SizedBox(height: 8),
              _buildCompactTextField(
                controller: _colonyNameController,
                label: 'Name Of the Colony', // * removed
                icon: Icons.landscape_rounded,
              ),
              const SizedBox(height: 8),
              _buildCompactTextField(
                controller: _addressController,
                label: 'Address of Property', // * removed
                icon: Icons.home_rounded,
                maxLines: 2,
              ),
              const SizedBox(height: 8),
              _buildCompactTextField(
                controller: _mobileController,
                label: 'Mobile No.', // * removed
                icon: Icons.phone_android_rounded,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 8),
              _buildCompactTextField(
                controller: _categoryController,
                label: 'Category', // * removed
                icon: Icons.category_rounded,
              ),
              const SizedBox(height: 8),
              _buildCompactTextField(
                controller: _totalAreaController,
                label: 'Total Area', // * removed
                icon: Icons.aspect_ratio_rounded,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              _buildCompactTextField(
                controller: _unitController,
                label: 'Unit', // * removed
                icon: Icons.square_foot_rounded,
              ),
              const SizedBox(height: 8),
              _buildCompactTextField(
                controller: _authorizationStatusController,
                label: 'Authorized Area / Unauthorized', // * removed
                icon: Icons.verified_rounded,
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
                            _frontViewImageController.text.isNotEmpty)
                          _buildImagePreview(
                            imageUrl: _frontViewImageController.text,
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
                            _sideViewImageController.text.isNotEmpty)
                          _buildImagePreview(
                            imageUrl: _sideViewImageController.text,
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
                            _additionalImageController.text.isNotEmpty)
                          _buildImagePreview(
                            imageUrl: _additionalImageController.text,
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
                            _locationImageController.text.isNotEmpty)
                          _buildImagePreview(
                            imageUrl: _locationImageController.text,
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
                          'Note: Upload images or provide image paths',
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
            // Save/Submit button for current step
            Expanded(
              child: AbsorbPointer(
                absorbing: _saving || _isSubmitting,
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
                      onTap: () {
                        print('🎯 Save button tapped');
                        _submitForm();
                      },
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
                                  widget.isEditMode
                                      ? Icons.update_rounded
                                      : Icons.save_rounded,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  widget.isEditMode ? 'Update' : 'Save',
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
            ),
            if (_currentStep > 0) const SizedBox(width: 10),
            // Previous button only for steps 1 and 2
            if (_currentStep > 0)
              AbsorbPointer(
                absorbing: _saving || _isSubmitting,
                child: Container(
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
                          color:
                              _currentStep == 1 ? primaryColor : locationColor,
                        ),
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
