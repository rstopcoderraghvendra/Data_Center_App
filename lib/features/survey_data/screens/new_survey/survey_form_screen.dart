import 'package:data_care_app/core/network/api_client.dart';
import 'package:data_care_app/core/storage/local_storage.dart';
import 'package:data_care_app/data/repositories/customer_repository.dart';
import 'package:data_care_app/features/model/survey_model/survey_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';

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

  // ✅ Latitude & Longitude - NO TEXT FIELDS, only variables
  double? _currentLatitude;
  double? _currentLongitude;
  bool _isLocationCaptured = false;

  bool _saving = false;
  bool _isSubmitting = false;
  String _errorMessage = '';
  int? _createdSurveyId;
  Survey? _nextSurvey;

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

      // ✅ FIXED: Convert String to Double safely
      _currentLatitude = double.tryParse(widget.survey!.latitude ?? '');
      _currentLongitude = double.tryParse(widget.survey!.longitude ?? '');
      _isLocationCaptured =
          _currentLatitude != null && _currentLongitude != null;
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

    // Step 3 data (images) - Only load front view image
    _frontViewImageController.text = widget.survey!.displayFrontView ?? '';
    // Don't load other images
    _sideViewImageController.clear();
    _additionalImageController.clear();
    _locationImageController.clear();

    // ✅ FIXED: Convert String? to double? safely
    _currentLatitude = double.tryParse(widget.survey!.latitude ?? '');
    _currentLongitude = double.tryParse(widget.survey!.longitude ?? '');
    _isLocationCaptured = _currentLatitude != null && _currentLongitude != null;
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

  bool _validateCurrentStep() {
    return true;
  }

  Map<String, dynamic> _getCurrentStepData() {
    final Map<String, dynamic> data = {
      'source_type': 'survey',
    };

    switch (_currentStep) {
      case 0:
        data.addAll({
          'municipality_name': _municipalityNameController.text.trim(),
          'property_details_property_id': _propertyIdController.text.trim(),
          'name': _ownerNameController.text.trim(),
        });
        break;
      case 1:
        data.addAll({
          'integrated_pid_property_id': _step2PropertyIdController.text.trim(),
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
      case 2:
        // ✅ Auto-capture location if not already captured
        if (!_isLocationCaptured) {
          _captureLocationForUpdate();
        }

        data.addAll({
          'latitude': _currentLatitude,
          'longitude': _currentLongitude,
        });
        break;
    }

    return data;
  }

  // ✅ Auto-capture location in background
  Future<void> _captureLocationForUpdate() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('⚠️ Location services are disabled');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('⚠️ Location permission denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('⚠️ Location permissions permanently denied');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 5),
      );

      setState(() {
        _currentLatitude = position.latitude;
        _currentLongitude = position.longitude;
        _isLocationCaptured = true;
      });

      print('📍 Location auto-captured: $_currentLatitude, $_currentLongitude');
    } catch (e) {
      print('❌ Error auto-capturing location: $e');
    }
  }

  Future<void> _submitForm() async {
    if (_isSubmitting) {
      print('⏸️ Form already submitting, ignoring duplicate click');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _saving = true;
      _errorMessage = '';
    });

    try {
      // ✅ Auto-capture location for Step 3
      if (_currentStep == 2 && !_isLocationCaptured) {
        await _captureLocationForUpdate();
      }

      final stepData = _getCurrentStepData();
      stepData['verify_by'] = "yes";

      print('\n=== SURVEY FORM SUBMIT ===');
      print('Current Step: $_currentStep');
      print('Is Edit Mode: ${widget.isEditMode}');
      print('Created Survey ID: $_createdSurveyId');
      print('Project ID: ${widget.projectId}');
      print('📍 Latitude: ${_currentLatitude ?? "Not captured"}');
      print('📍 Longitude: ${_currentLongitude ?? "Not captured"}');
      print('Step Data: $stepData');

      Map<String, File>? imageFiles;

      if (_currentStep == 2) {
        imageFiles = {};

        if (_frontViewFile != null) {
          imageFiles['front_view'] = _frontViewFile!;
        }
        // Don't include other images
        if (imageFiles.isEmpty) {
          imageFiles = null;
        }
      }

      Map<String, dynamic> apiResponse;
      Survey updatedSurvey;

      if (widget.isEditMode || _createdSurveyId != null) {
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

      if (_currentStep == 2) {
        final Map<String, dynamic> parsedResponse =
            _parseUpdateResponse(apiResponse);
        updatedSurvey = parsedResponse['current'] as Survey;
        _nextSurvey = parsedResponse['next'] as Survey?;

        if (_createdSurveyId == null && updatedSurvey.id != null) {
          _createdSurveyId = updatedSurvey.id;
          print('📌 Stored new Survey ID: $_createdSurveyId');
        }

        await _showSuccessDialogForImages(updatedSurvey);
      } else {
        updatedSurvey = _parseSurveyFromResponse(apiResponse);

        if (_createdSurveyId == null && updatedSurvey.id != null) {
          _createdSurveyId = updatedSurvey.id;
          print('📌 Stored new Survey ID: $_createdSurveyId');
        }

        await _showSimpleSuccessDialog();
      }

      setState(() {
        _isSubmitting = false;
        _saving = false;
      });

      if (_currentStep == 2) {
        _handleCompletion(updatedSurvey);
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
        _saving = false;
        _errorMessage = e.toString();
      });

      print('❌ Error: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: ${e.toString()}',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
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

  Map<String, dynamic> _parseUpdateResponse(Map<String, dynamic> apiResponse) {
    try {
      if (apiResponse.containsKey('current') &&
          apiResponse.containsKey('next')) {
        final currentData = apiResponse['current'];
        final nextData = apiResponse['next'];

        final Survey currentSurvey = Survey.fromJson(currentData);
        Survey? nextSurvey;

        if (nextData != null) {
          nextSurvey = Survey.fromJson(nextData);
        }

        return {
          'current': currentSurvey,
          'next': nextSurvey,
        };
      }

      final Survey survey = _parseSurveyFromResponse(apiResponse);
      return {
        'current': survey,
        'next': null,
      };
    } catch (e) {
      print('Error parsing update response: $e');
      rethrow;
    }
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

  void _handleCompletion(Survey updatedSurvey) {
    widget.onSaveSuccess?.call();

    if (mounted) {
      Navigator.of(context).pop(updatedSurvey);
    }
  }

  Future<void> _showSimpleSuccessDialog() async {
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
            _currentStep == 0
                ? 'Basic information saved successfully!'
                : 'Location & details saved successfully!',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (!widget.isEditMode) {
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

  Future<void> _showSuccessDialogForImages(Survey updatedSurvey) async {
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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Front view image saved successfully!',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: textSecondary,
                ),
              ),
              if (_isLocationCaptured) ...[
                const SizedBox(height: 4),
                Text(
                  '📍 Location captured',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              if (_nextSurvey != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.arrow_forward_rounded,
                          color: Colors.blue.shade600, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Next Record Available',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.blue.shade800,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Click "Load Next" to fill next survey',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: Colors.blue.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          actions: [
            if (_nextSurvey != null)
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _loadNextRecord();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Load Next',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            // TextButton(
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //     _handleCompletion(updatedSurvey);
            //   },
            //   child: Text(
            //     _nextSurvey != null ? 'Return to List' : 'OK',
            //     style: GoogleFonts.inter(
            //       fontWeight: FontWeight.w600,
            //       color: _nextSurvey != null ? textSecondary : primaryColor,
            //     ),
            //   ),
            // ),
          ],
        );
      },
    );
  }

  void _loadNextRecord() {
    if (_nextSurvey == null) return;

    print('🔄 Loading next record: ID ${_nextSurvey!.id}');

    _clearAllControllers();
    _loadNextSurveyData(_nextSurvey!);
    _tabController.animateTo(0);
    _clearImageFiles();
    _nextSurvey = null;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Next record loaded successfully!',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _loadNextSurveyData(Survey nextSurvey) {
    print('📋 Loading next survey data: ID ${nextSurvey.id}');

    // Step 1 data
    _municipalityNameController.text = nextSurvey.municipalityName ?? '';
    _propertyIdController.text = nextSurvey.propertyDetailsPropertyId ?? '';
    _ownerNameController.text = nextSurvey.name ?? '';

    // Step 2 data
    _step2PropertyIdController.text = nextSurvey.integratedPidPropertyId ?? '';
    _step2OwnerNameController.text =
        nextSurvey.integratedPidOwnerOccupierName ?? '';
    _areaOfAuthorityController.text =
        nextSurvey.areaOfAuthority?.toString() ?? '';
    _colonyNameController.text = nextSurvey.colonyName ?? '';
    _addressController.text = nextSurvey.addressOfProperty ?? '';
    _mobileController.text = nextSurvey.mobileNo ?? '';
    _categoryController.text = nextSurvey.category?.toString() ?? '';
    _totalAreaController.text = nextSurvey.totalArea?.toString() ?? '';
    _unitController.text = nextSurvey.unit?.toString() ?? '';
    _authorizationStatusController.text =
        nextSurvey.authorizationStatus?.toString() ?? '';

    // Step 3 data (images) - Only load front view image
    _frontViewImageController.text = nextSurvey.displayFrontView ?? '';
    // Don't load other images
    _sideViewImageController.clear();
    _additionalImageController.clear();
    _locationImageController.clear();

    // ✅ FIXED: Convert String? to double? safely
    _currentLatitude = double.tryParse(nextSurvey.latitude ?? '');
    _currentLongitude = double.tryParse(nextSurvey.longitude ?? '');
    _isLocationCaptured = _currentLatitude != null && _currentLongitude != null;

    _createdSurveyId = nextSurvey.id;
  }

  void _clearAllControllers() {
    _municipalityNameController.clear();
    _propertyIdController.clear();
    _ownerNameController.clear();
    _step2PropertyIdController.clear();
    _step2OwnerNameController.clear();
    _areaOfAuthorityController.clear();
    _colonyNameController.clear();
    _addressController.clear();
    _mobileController.clear();
    _categoryController.clear();
    _totalAreaController.clear();
    _unitController.clear();
    _authorizationStatusController.clear();
    _frontViewImageController.clear();
    _sideViewImageController.clear();
    _additionalImageController.clear();
    _locationImageController.clear();
  }

  void _clearImageFiles() {
    setState(() {
      _frontViewFile = null;
      _sideViewFile = null;
      _additionalFile = null;
      _locationFile = null;
    });
  }

  // Image handling methods - Only keep front_view functionality
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
            // Other cases removed - functionality kept but won't be called
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
            // Other cases removed - functionality kept but won't be called
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
    // Only show dialog for front_view
    if (imageType != 'front_view') return;

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
              // ListTile(
              //   leading:
              //       const Icon(Icons.photo_library_rounded, color: photosColor),
              //   title: Text(
              //     'Choose from Gallery',
              //     style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              //   ),
              //   onTap: () {
              //     Navigator.pop(context);
              //     _pickImageForField(imageType);
              //   },
              // ),
            ],
          ),
        );
      },
    );
  }

  void _showRemoveImageDialog(String label, String imageType) {
    // Only show dialog for front_view
    if (imageType != 'front_view') return;

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
                      _frontViewImageController.clear();
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
              _buildCompactTextField(
                controller: _municipalityNameController,
                label: 'Municipality Name',
                icon: Icons.location_city_rounded,
              ),
              const SizedBox(height: 8),
              _buildCompactTextField(
                controller: _propertyIdController,
                label: 'Property Id',
                icon: Icons.tag_rounded,
              ),
              const SizedBox(height: 8),
              _buildCompactTextField(
                controller: _ownerNameController,
                label: 'Owner/Occupier Name',
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
              _buildCompactTextField(
                controller: _step2PropertyIdController,
                label: 'Property Id',
                icon: Icons.tag_rounded,
              ),
              const SizedBox(height: 8),
              _buildCompactTextField(
                controller: _step2OwnerNameController,
                label: 'Owner/Occupier Name',
                icon: Icons.person_outline_rounded,
              ),
              const SizedBox(height: 8),
              _buildCompactTextField(
                controller: _areaOfAuthorityController,
                label: 'Area Of the Authority',
                icon: Icons.map_rounded,
              ),
              const SizedBox(height: 8),
              _buildCompactTextField(
                controller: _colonyNameController,
                label: 'Name Of the Colony',
                icon: Icons.landscape_rounded,
              ),
              const SizedBox(height: 8),
              _buildCompactTextField(
                controller: _addressController,
                label: 'Address of Property',
                icon: Icons.home_rounded,
                maxLines: 2,
              ),
              const SizedBox(height: 8),
              _buildCompactTextField(
                controller: _mobileController,
                label: 'Mobile No.',
                icon: Icons.phone_android_rounded,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 8),
              _buildCompactTextField(
                controller: _categoryController,
                label: 'Category',
                icon: Icons.category_rounded,
              ),
              const SizedBox(height: 8),
              _buildCompactTextField(
                controller: _totalAreaController,
                label: 'Total Area',
                icon: Icons.aspect_ratio_rounded,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              _buildCompactTextField(
                controller: _unitController,
                label: 'Unit',
                icon: Icons.square_foot_rounded,
              ),
              const SizedBox(height: 8),
              _buildCompactTextField(
                controller: _authorizationStatusController,
                label: 'Authorized Area / Unauthorized',
                icon: Icons.verified_rounded,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Step 3 - ONLY FRONT VIEW IMAGE, other images hidden
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
                        // Front View Image Field (only one shown)
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

                        // ✅ Hidden Location Status - Only shows if captured
                        if (_isLocationCaptured)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on_rounded,
                                  size: 16,
                                  color: Colors.green.shade700,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '📍 Location will be updated',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: Colors.green.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 8),
                        Text(
                          'Note: Upload front view image to complete the survey',
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
    final bool hasImage = imageType == 'front_view' && _frontViewFile != null;

    String displayText = '';
    if (hasImage) {
      switch (imageType) {
        case 'front_view':
          displayText = _frontViewFile?.path ?? '';
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
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: SizedBox(
        height: maxLines > 1 ? null : 52,
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
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.all(8),
              child: Icon(icon, size: 18, color: textPrimary),
            ),
            filled: true,
            fillColor: backgroundColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: borderColor, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: textPrimary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: specificationsColor, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: specificationsColor, width: 1.5),
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
