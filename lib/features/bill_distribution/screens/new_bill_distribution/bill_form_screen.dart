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
  }

  @override
  void dispose() {
    _tabController.dispose();
    _imageScrollController.dispose();

    _nameController.dispose();
    _propertyIdController.dispose();
    _ownerNameController.dispose();

    // Step 2 controllers
    _step2PropertyIdController.dispose();
    _step2OwnerNameController.dispose();
    _areaOfAuthorityController.dispose();
    _colonyNameController.dispose();
    _addressController.dispose();
    _mobileController.dispose();

    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 2) {
      _tabController.animateTo(_currentStep + 1);
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _nameController.text.isNotEmpty &&
            _propertyIdController.text.isNotEmpty &&
            _mobileController.text.length >= 10;
      case 1:
        return _addressController.text.isNotEmpty &&
            _municipalityController.text.isNotEmpty &&
            _colonyController.text.isNotEmpty;
      case 2:
        return true;
      default:
        return false;
    }
  }

  Future<void> _submitForm() async {
    if (!_validateCurrentStep()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fill required fields')),
      );
      return;
    }

    setState(() {
      _saving = true;
      _errorMessage = '';
    });

    setState(() => _saving = true);

    await Future.delayed(const Duration(milliseconds: 300));

    final bill = Bill(
      name: _nameController.text,
      propertyDetailsPropertyId: _propertyIdController.text,
      municipalityName: _municipalityController.text,
      integratedPidPropertyId: _integratedPidController.text,
      integratedPidOwnerOccupierName:
          _integratedOwnerController.text,
      areaOfAuthority: _areaOfAuthorityController.text,
      colonyName: _colonyController.text,
      addressOfProperty: _addressController.text,
      mobileNo: _mobileController.text,
      category: '',
      totalArea: '',
      unit: '',
      authorizationStatus: '',
      id: DateTime.now().millisecondsSinceEpoch,
      sourceType: '',
      createdBy: 1,
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (!mounted) return;

    setState(() => _saving = false);
    Navigator.pop(context, bill);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('New Bill'),
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
                _stepBasic(),
                _stepLocation(),
                _stepImages(),
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

  Widget _stepLocation() {
    return _card(
      Column(
        children: [
          _field(_addressController, 'Address'),
          _field(_colonyController, 'Colony'),
          _field(_integratedPidController, 'Integrated PID'),
          _field(_integratedOwnerController, 'Integrated owner'),
          _field(_areaOfAuthorityController, 'Area of authority'),
        ],
      ),
    );
  }

  Widget _stepImages() {
    final items = [
      'Front view',
      'Side view',
      'Additional photo',
      'Location photo',
    ];

    return _card(
      SizedBox(
        height: 120,
        child: Scrollbar(
          controller: _imageScrollController,
          thumbVisibility: true,
          trackVisibility: true,
          child: ListView.builder(
            controller: _imageScrollController,
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemBuilder: (context, index) {
              return Container(
                width: 160,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_radius),
                  border: Border.all(color: borderColor),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(_radius),
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add_a_photo_outlined),
                      const SizedBox(height: 8),
                      Text(items[index]),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _card(Widget child) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(_radius),
          border: Border.all(color: borderColor),
        ),
        child: child,
      ),
    );
  }

  Widget _field(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _bottomBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          height: 44,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _saving ? null : _submitForm,
            child: Text(_currentStep < 2 ? 'Continue' : 'Save'),
          ),
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
