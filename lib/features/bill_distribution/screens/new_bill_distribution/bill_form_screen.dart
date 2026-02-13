import 'package:data_care_app/core/network/api_client.dart';
import 'package:data_care_app/core/storage/local_storage.dart';
import 'package:data_care_app/data/repositories/customer_repository.dart';
import 'package:data_care_app/features/bill_distribution/screens/model/bill_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';

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

  // ✅ SIRF EK IMAGE FILE - FRONT VIEW
  File? _frontViewFile;

  // ✅ Latitude & Longitude - NO TEXT FIELDS, sirf variables
  double? _currentLatitude;
  double? _currentLongitude;
  bool _isLocationCaptured = false;

  // Controllers for Step 1 (Basic Info) - READ ONLY
  final _municipalityNameController = TextEditingController();
  final _propertyIdController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _mobileController = TextEditingController();

  // Controllers for Step 2 (Property Details) - READ ONLY
  final _step2PropertyIdController = TextEditingController();
  final _step2OwnerNameController = TextEditingController();
  final _areaOfAuthorityController = TextEditingController();
  final _colonyNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _categoryController = TextEditingController();
  final _totalAreaController = TextEditingController();
  final _unitController = TextEditingController();
  final _authorizationStatusController = TextEditingController();

  // ✅ SIRF EK IMAGE controller - FRONT VIEW
  final _frontViewImageController = TextEditingController();

  bool _saving = false;
  bool _isSubmitting = false;
  String _errorMessage = '';
  int? _createdBillId;
  Bill? _nextBill;

  // Premium Color Theme
  static const Color primaryColor = Color(0xFFFF6B35);
  static const Color propertyInfoColor = Color(0xFF6366F1);
  static const Color locationColor = Color(0xFF14B8A6);
  static const Color specificationsColor = Color(0xFFEF4444);
  static const Color photosColor = Color(0xFF10B981);
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color borderColor = Color(0xFFE2E8F0);

  static const double _radius = 14;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (mounted && _currentStep != _tabController.index) {
        setState(() => _currentStep = _tabController.index);
      }
    });

    if (widget.isEditMode && widget.bill != null) {
      _createdBillId = widget.bill!.id;
      _loadBillData();

      // ✅ Load existing location data
      _currentLatitude = double.tryParse(widget.bill!.latitude ?? '');
      _currentLongitude = double.tryParse(widget.bill!.longitude ?? '');
      _isLocationCaptured =
          _currentLatitude != null && _currentLongitude != null;
    }
  }

  void _loadBillData() {
    if (widget.bill == null) return;

    // Step 1 - READ ONLY
    _municipalityNameController.text = widget.bill!.municipalityName ?? '';
    _propertyIdController.text = widget.bill!.propertyDetailsPropertyId ?? '';
    _ownerNameController.text = widget.bill!.name ?? '';
    _mobileController.text = widget.bill!.mobileNo ?? '';

    // Step 2 - READ ONLY
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

    // ✅ SIRF EK IMAGE
    _frontViewImageController.text = widget.bill!.frontViewUrl ?? '';

    // ✅ Load latitude and longitude
    _currentLatitude = double.tryParse(widget.bill!.latitude ?? '');
    _currentLongitude = double.tryParse(widget.bill!.longitude ?? '');
    _isLocationCaptured = _currentLatitude != null && _currentLongitude != null;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _imageScrollController.dispose();

    _nameController.dispose();
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

    // ✅ SIRF EK IMAGE controller
    _frontViewImageController.dispose();

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

  bool _validateCurrentStep() => true;

  // ✅ Auto-capture location in background
  Future<void> _captureLocationForUpdate() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('⚠️ GPS is disabled');
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
        print('⚠️ Location permission permanently denied');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      setState(() {
        _currentLatitude = position.latitude;
        _currentLongitude = position.longitude;
        _isLocationCaptured = true;
      });

      print('📍 Location captured: $_currentLatitude, $_currentLongitude');
    } catch (e) {
      print('❌ Error capturing location: $e');
    }
  }

  Map<String, dynamic> _getCurrentStepData() {
    final Map<String, dynamic> data = {
      'source_type': 'bill_distribution',
    };

    switch (_currentStep) {
      case 0: // Basic Info - READ ONLY
        break;
      case 1: // Property Details - READ ONLY
        break;
      case 2: // Images - SIRF YAHI UPDATE HOGA
        // ✅ EXACTLY JAISA AAPNE BATAYA - DIRECT LAT/LONG BACKGROUND MEIN
        if (!_isLocationCaptured) {
          _captureLocationForUpdate();
        }

        data.addAll({
          'latitude': _currentLatitude,
          'longitude': _currentLongitude,
        });
        break;
    }

    data['verify_by'] = "yes";

    print('📍 Latitude: ${_currentLatitude ?? "Not captured"}');
    print('📍 Longitude: ${_currentLongitude ?? "Not captured"}');

    return data;
  }

  Future<void> _submitForm() async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
      _saving = true;
      _errorMessage = '';
    });

    try {
      final stepData = _getCurrentStepData();

      // ✅ SIRF EK IMAGE file
      Map<String, File>? imageFiles;

      if (_currentStep == 2) {
        imageFiles = {};

        if (_frontViewFile != null) {
          imageFiles['front_view'] = _frontViewFile!;
        }

        if (imageFiles.isEmpty) {
          imageFiles = null;
        }
      }

      Map<String, dynamic> apiResponse;
      Bill updatedBill;

      if (widget.isEditMode || _createdBillId != null) {
        final billIdToUpdate =
            widget.isEditMode ? widget.bill!.id! : _createdBillId!;

        apiResponse = await _repository.updateCustomer(
          billIdToUpdate,
          stepData,
          imageFiles: imageFiles,
        );
      } else {
        throw Exception('Bill ID is required to update a bill.');
      }

      if (_currentStep == 2) {
        final Map<String, dynamic> parsedResponse =
            _parseUpdateResponse(apiResponse);
        updatedBill = parsedResponse['current'] as Bill;
        _nextBill = parsedResponse['next'] as Bill?;

        if (_createdBillId == null && updatedBill.id != null) {
          _createdBillId = updatedBill.id;
        }

        await _showSuccessDialogForImages(updatedBill);
      } else {
        updatedBill = _parseBillFromResponse(apiResponse);
        await _showSimpleSuccessDialog();
      }

      setState(() {
        _isSubmitting = false;
        _saving = false;
      });

      if (_currentStep == 2) {
        _handleCompletion(updatedBill);
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
        _saving = false;
        _errorMessage = e.toString();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
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

        final Bill currentBill = Bill.fromJson(currentData);
        Bill? nextBill;

        if (nextData != null) {
          nextBill = Bill.fromJson(nextData);
        }

        return {
          'current': currentBill,
          'next': nextBill,
        };
      }

      final Bill bill = _parseBillFromResponse(apiResponse);
      return {
        'current': bill,
        'next': null,
      };
    } catch (e) {
      print('Error parsing update response: $e');
      rethrow;
    }
  }

  Bill _parseBillFromResponse(Map<String, dynamic> apiResponse) {
    try {
      if (apiResponse.containsKey('data')) {
        final responseData = apiResponse['data'];
        if (responseData is List && responseData.isNotEmpty) {
          return Bill.fromJson(responseData[0]);
        } else if (responseData is Map<String, dynamic>) {
          return Bill.fromJson(responseData);
        }
      }
      return Bill.fromJson(apiResponse);
    } catch (e) {
      print('Error parsing bill from response: $e');
      rethrow;
    }
  }

  void _handleCompletion(Bill updatedBill) {
    widget.onSaveSuccess?.call();
    if (mounted) {
      Navigator.of(context).pop(updatedBill);
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
            'Data updated successfully!',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
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

  Future<void> _showSuccessDialogForImages(Bill updatedBill) async {
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
                'Image saved successfully!',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: textSecondary,
                ),
              ),
              if (_isLocationCaptured) ...[
                const SizedBox(height: 4),
                Text(
                  '📍 Location updated',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              if (_nextBill != null)
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
                              'Next Bill Available',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.blue.shade800,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Click "Load Next" to fill next bill',
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
            if (_nextBill != null)
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
            if (_nextBill == null)
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _handleCompletion(updatedBill);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Return to List',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  void _loadNextRecord() {
    if (_nextBill == null) return;

    _clearAllControllers();
    _loadNextBillData(_nextBill!);
    _tabController.animateTo(0);
    _clearImageFiles();
    _createdBillId = _nextBill!.id;
    _nextBill = null;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Next bill loaded successfully!',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _loadNextBillData(Bill nextBill) {
    // Step 1 - READ ONLY
    _municipalityNameController.text = nextBill.municipalityName ?? '';
    _propertyIdController.text = nextBill.propertyDetailsPropertyId ?? '';
    _ownerNameController.text = nextBill.name ?? '';
    _mobileController.text = nextBill.mobileNo ?? '';

    // Step 2 - READ ONLY
    _step2PropertyIdController.text = nextBill.integratedPidPropertyId ?? '';
    _step2OwnerNameController.text =
        nextBill.integratedPidOwnerOccupierName ?? '';
    _areaOfAuthorityController.text = nextBill.areaOfAuthority ?? '';
    _colonyNameController.text = nextBill.colonyName ?? '';
    _addressController.text = nextBill.addressOfProperty ?? '';
    _categoryController.text = nextBill.category ?? '';
    _totalAreaController.text = nextBill.totalArea ?? '';
    _unitController.text = nextBill.unit ?? '';
    _authorizationStatusController.text = nextBill.authorizationStatus ?? '';

    // ✅ SIRF EK IMAGE
    _frontViewImageController.text = nextBill.frontViewUrl ?? '';

    // ✅ Load latitude and longitude
    _currentLatitude = double.tryParse(nextBill.latitude ?? '');
    _currentLongitude = double.tryParse(nextBill.longitude ?? '');
    _isLocationCaptured = _currentLatitude != null && _currentLongitude != null;
  }

  void _clearAllControllers() {
    _municipalityNameController.clear();
    _propertyIdController.clear();
    _ownerNameController.clear();
    _mobileController.clear();
    _step2PropertyIdController.clear();
    _step2OwnerNameController.clear();
    _areaOfAuthorityController.clear();
    _colonyNameController.clear();
    _addressController.clear();
    _categoryController.clear();
    _totalAreaController.clear();
    _unitController.clear();
    _authorizationStatusController.clear();
    _frontViewImageController.clear();

    // ✅ Reset location
    _currentLatitude = null;
    _currentLongitude = null;
    _isLocationCaptured = false;
  }

  void _clearImageFiles() {
    setState(() {
      _frontViewFile = null;
    });
  }

  // ✅ Take photo from camera
  Future<void> _takePhoto() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1200,
        maxHeight: 1200,
      );

      if (pickedFile != null) {
        final file = File(pickedFile.path);

        setState(() {
          _frontViewFile = file;
        });

        // ✅ Auto-capture location when taking photo
        _captureLocationForUpdate();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Photo taken. Click "Update" to save.',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
            backgroundColor: photosColor,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
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

  void _showRemoveImageDialog() {
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
            'Are you sure you want to remove this image?',
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
                  _frontViewFile = null;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Image removed. Click "Update" to save changes.',
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
              widget.isEditMode ? 'View Bill' : 'Bill Entry',
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
          const Padding(
            padding: EdgeInsets.all(12),
            child: _StableMapPreview(),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStep1(), // ✅ READ ONLY
                _buildStep2(), // ✅ READ ONLY
                _buildStep3(), // ✅ SIRF EK IMAGE + LOCATION BACKGROUND
              ],
            ),
          ),
          _bottomBar(),
        ],
      ),
    );
  }

  Widget _stepBasic() {
    return _card(
      Column(
        children: [
          _field(_nameController, 'Owner name'),
          _field(_propertyIdController, 'Property ID'),
          _field(_municipalityController, 'Municipality'),
          _field(_mobileController, 'Mobile'),
        ],
      ),
    );
  }

  Widget _buildClickableTabBar() {
    final stepIcons = [
      Icons.person_rounded,
      Icons.location_on_rounded,
      Icons.image_rounded,
    ];
    final stepColors = [primaryColor, locationColor, specificationsColor];
    final stepTitles = ['Basic Info', 'Property Details', 'Image'];

    return Container(
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
              onTap: () => _tabController.animateTo(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
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
    );
  }

  // ✅ STEP 1 - READ ONLY
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
              _buildReadOnlyTextField(
                controller: _municipalityNameController,
                label: 'Municipality Name',
                icon: Icons.location_city_rounded,
              ),
              const SizedBox(height: 8),
              _buildReadOnlyTextField(
                controller: _propertyIdController,
                label: 'Property Id',
                icon: Icons.tag_rounded,
              ),
              const SizedBox(height: 8),
              _buildReadOnlyTextField(
                controller: _ownerNameController,
                label: 'Owner/Occupier Name',
                icon: Icons.person_outline_rounded,
              ),
              const SizedBox(height: 8),
              _buildReadOnlyTextField(
                controller: _mobileController,
                label: 'Mobile No.',
                icon: Icons.phone_android_rounded,
              ),
              const SizedBox(height: 8),
              Text(
                'This information cannot be edited',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
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

  // ✅ STEP 2 - READ ONLY
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
              _buildReadOnlyTextField(
                controller: _step2PropertyIdController,
                label: 'Property Id',
                icon: Icons.tag_rounded,
              ),
              const SizedBox(height: 8),
              _buildReadOnlyTextField(
                controller: _step2OwnerNameController,
                label: 'Owner/Occupier Name',
                icon: Icons.person_outline_rounded,
              ),
              const SizedBox(height: 8),
              _buildReadOnlyTextField(
                controller: _areaOfAuthorityController,
                label: 'Area Of the Authority',
                icon: Icons.map_rounded,
              ),
              const SizedBox(height: 8),
              _buildReadOnlyTextField(
                controller: _colonyNameController,
                label: 'Name Of the Colony',
                icon: Icons.landscape_rounded,
              ),
              const SizedBox(height: 8),
              _buildReadOnlyTextField(
                controller: _addressController,
                label: 'Address of Property',
                icon: Icons.home_rounded,
                maxLines: 2,
              ),
              const SizedBox(height: 8),
              _buildReadOnlyTextField(
                controller: _categoryController,
                label: 'Category',
                icon: Icons.category_rounded,
              ),
              const SizedBox(height: 8),
              _buildReadOnlyTextField(
                controller: _totalAreaController,
                label: 'Total Area',
                icon: Icons.aspect_ratio_rounded,
              ),
              const SizedBox(height: 8),
              _buildReadOnlyTextField(
                controller: _unitController,
                label: 'Unit',
                icon: Icons.square_foot_rounded,
              ),
              const SizedBox(height: 8),
              _buildReadOnlyTextField(
                controller: _authorizationStatusController,
                label: 'Authorized Area / Unauthorized',
                icon: Icons.verified_rounded,
              ),
              const SizedBox(height: 8),
              Text(
                'This information cannot be edited',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
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

  // ✅ STEP 3 - SIRF EK IMAGE, KOI LOCATION INPUT FIELD NAHI
  Widget _buildStep3() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            // ✅ LOCATION STATUS - SIRF STATUS, KOI INPUT FIELD NAHI
            // Container(
            //   decoration: BoxDecoration(
            //     color: cardColor,
            //     borderRadius: BorderRadius.circular(18),
            //     border:
            //         Border.all(color: locationColor.withOpacity(0.2), width: 1),
            //     boxShadow: [
            //       BoxShadow(
            //         color: locationColor.withOpacity(0.08),
            //         blurRadius: 15,
            //         offset: const Offset(0, 3),
            //       ),
            //     ],
            //   ),
            //   child: Padding(
            //     padding: const EdgeInsets.all(16),
            //     child: Row(
            //       children: [
            //         Container(
            //           padding: const EdgeInsets.all(10),
            //           decoration: BoxDecoration(
            //             color: locationColor.withOpacity(0.1),
            //             borderRadius: BorderRadius.circular(12),
            //           ),
            //           child: Icon(
            //             Icons.location_on_rounded,
            //             color: locationColor,
            //             size: 24,
            //           ),
            //         ),
            //         const SizedBox(width: 16),
            //         // Expanded(
            //         //   child: Column(
            //         //     crossAxisAlignment: CrossAxisAlignment.start,
            //         //     children: [
            //         //       Text(
            //         //         'GPS Location',
            //         //         style: GoogleFonts.inter(
            //         //           fontSize: 15,
            //         //           fontWeight: FontWeight.w700,
            //         //           color: textPrimary,
            //         //         ),
            //         //       ),
            //         //       const SizedBox(height: 4),
            //         //       Text(
            //         //         _isLocationCaptured
            //         //             ? '📍 Location ready to update'
            //         //             : '📍 Tap camera to capture location',
            //         //         style: GoogleFonts.inter(
            //         //           fontSize: 12,
            //         //           color: _isLocationCaptured
            //         //               ? Colors.green.shade700
            //         //               : Colors.grey.shade600,
            //         //           fontWeight: FontWeight.w500,
            //         //         ),
            //         //       ),
            //         //     ],
            //         //   ),
            //         // ),
            //       ],
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 12),

            // ✅ SIRF EK IMAGE - FRONT VIEW
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
                        if (widget.isEditMode &&
                            _frontViewImageController.text.isNotEmpty)
                          _buildImagePreview()
                        else
                          _buildImageField(),
                        const SizedBox(height: 8),
                        Text(
                          'Take a photo - Location will be auto-captured',
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

  // ✅ READ ONLY TEXT FIELD
  Widget _buildReadOnlyTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        height: maxLines > 1 ? null : 46,
        child: TextFormField(
          controller: controller,
          maxLines: maxLines,
          readOnly: true,
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
            ),
            prefixIcon: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.all(7),
              child: Icon(icon, size: 18, color: textPrimary),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
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
              borderSide:
                  BorderSide(color: textPrimary.withOpacity(0.5), width: 1.5),
            ),
          ),
        ),
      ),
    );
  }

  // ✅ IMAGE PREVIEW - SIRF EK IMAGE
  Widget _buildImagePreview() {
    return Material(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Front View Image',
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
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade100,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      _frontViewImageController.text,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.broken_image_rounded,
                                color: Colors.grey.shade400,
                                size: 48,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Image not available',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
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
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _takePhoto,
                        icon: const Icon(Icons.change_circle_rounded, size: 18),
                        label: Text(
                          'Change Image',
                          style: GoogleFonts.inter(
                            fontSize: 13,
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
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(color: Colors.red.shade200, width: 1),
                      ),
                      child: IconButton(
                        onPressed: _showRemoveImageDialog,
                        icon: Icon(
                          Icons.delete_rounded,
                          size: 20,
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

  // ✅ IMAGE FIELD - SIRF EK IMAGE
  Widget _buildImageField() {
    final bool hasImage = _frontViewFile != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _takePhoto,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
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
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [photosColor, photosColor.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: photosColor.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Icon(Icons.home_rounded, size: 24, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Front View Image',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                        letterSpacing: 0.2,
                      ),
                    ),
                    if (hasImage)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'Photo taken - Ready to upload',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: photosColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  hasImage ? Icons.check_circle : Icons.camera_alt_rounded,
                  size: 20,
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
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _currentStep == 2
                          ? [photosColor, photosColor.withOpacity(0.8)]
                          : [Colors.grey, Colors.grey.withOpacity(0.8)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: (_currentStep == 2 ? photosColor : Colors.grey)
                            .withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _currentStep == 2 ? _submitForm : null,
                      borderRadius: BorderRadius.circular(14),
                      child: _saving
                          ? const Center(
                              child: SizedBox(
                                height: 24,
                                width: 24,
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
                                  _currentStep == 2
                                      ? Icons.update_rounded
                                      : Icons.lock_rounded,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _currentStep == 2 ? 'Update' : 'Read Only',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
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
                  width: 52,
                  height: 52,
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
                          size: 22,
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
}

///
/// ✅ THIS widget fixes the EngineFlutterView crash
///
class _StableMapPreview extends StatefulWidget {
  const _StableMapPreview();

  @override
  State<_StableMapPreview> createState() => _StableMapPreviewState();
}

class _StableMapPreviewState extends State<_StableMapPreview>
    with AutomaticKeepAliveClientMixin {
  GoogleMapController? _controller;

  static const CameraPosition _camera =
      CameraPosition(target: LatLng(28.6139, 77.2090), zoom: 14);

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        height: 120,
        child: GoogleMap(
          initialCameraPosition: _camera,
          liteModeEnabled: true,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          onMapCreated: (c) => _controller = c,
          onTap: (_) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const FullScreenMap(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class FullScreenMap extends StatefulWidget {
  const FullScreenMap({super.key});

  @override
  State<FullScreenMap> createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {
  GoogleMapController? _controller;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select location')),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(28.6139, 77.2090),
          zoom: 16,
        ),
        onMapCreated: (c) => _controller = c,
      ),
    );
  }
}
