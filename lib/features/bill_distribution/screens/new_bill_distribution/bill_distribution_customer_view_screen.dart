import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';

import 'package:data_care_app/core/constants/api_endpoints.dart';
import 'package:data_care_app/core/network/api_client.dart';
import 'package:data_care_app/core/storage/local_storage.dart';

class BillDistributionCustomerViewScreen extends StatefulWidget {
  final Map<String, dynamic> customerData;

  const BillDistributionCustomerViewScreen({
    super.key,
    required this.customerData,
  });

  @override
  State<BillDistributionCustomerViewScreen> createState() =>
      _BillDistributionCustomerViewScreenState();
}

class _BillDistributionCustomerViewScreenState
    extends State<BillDistributionCustomerViewScreen> {
  final ApiClient _apiClient = ApiClient(storage: LocalStorage());
  final ImagePicker _imagePicker = ImagePicker();

  late Map<String, dynamic> _data;
  bool _uploadingSideView = false;
  bool _loadingPreviousRecord = false;
  bool _loadingNextRecord = false;

  @override
  void initState() {
    super.initState();
    _data = _unwrapData(widget.customerData);
  }

  Map<String, dynamic> _unwrapData(Map<String, dynamic> raw) {
    final d = raw['data'];
    if (d is Map) return Map<String, dynamic>.from(d);
    return raw;
  }

  Map<String, dynamic>? _asMap(dynamic v) {
    if (v is Map) return Map<String, dynamic>.from(v);
    return null;
  }

  String _asString(dynamic v) {
    if (v == null) return '-';
    final s = v.toString().trim();
    if (s.isEmpty || s.toLowerCase() == 'null') return '-';
    return s;
  }

  bool _hasValue(String v) => v != '-';

  String _formatDate(String raw) {
    if (!_hasValue(raw)) return '-';
    try {
      final dt = DateTime.tryParse(raw);
      if (dt == null) return raw;
      final l = dt.toLocal();
      const m = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      final day = l.day.toString().padLeft(2, '0');
      final mon = m[l.month - 1];
      final year = l.year.toString();
      final hour12 = (l.hour % 12 == 0 ? 12 : l.hour % 12)
          .toString()
          .padLeft(2, '0');
      final min = l.minute.toString().padLeft(2, '0');
      final ampm = l.hour >= 12 ? 'PM' : 'AM';
      return '$day $mon $year, $hour12:$min $ampm';
    } catch (_) {
      return raw;
    }
  }

  void _copy(BuildContext context, String value) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied')),
    );
  }

  Uri? _locationUri({required String lat, required String lng}) {
    final latD = double.tryParse(lat);
    final lngD = double.tryParse(lng);
    if (latD == null || lngD == null) return null;
    return Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latD,$lngD',
    );
  }

  Uri? _directionUri({required String lat, required String lng}) {
    final latD = double.tryParse(lat);
    final lngD = double.tryParse(lng);
    if (latD == null || lngD == null) return null;
    return Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$latD,$lngD&travelmode=driving',
    );
  }

  Future<void> _openExternal(BuildContext context, Uri uri) async {
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open map')),
      );
    }
  }

  int? _customerId() {
    final v = _data['id'];
    if (v is int) return v;
    return int.tryParse(v?.toString() ?? '');
  }

  Future<void> _refreshCustomer() async {
    final id = _customerId();
    if (id == null) return;
    try {
      final response = await _apiClient.getJson(
        ApiEndpoints.billDistributionCustomersViewByCustomerId(id),
      );
      if (!mounted) return;
      setState(() {
        _data = _unwrapData(response);
      });
    } catch (_) {
      // Keep existing data on refresh failure
    }
  }

  Map<String, dynamic>? _extractCustomerMap(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is Map) return Map<String, dynamic>.from(data);

    final next = response['next'];
    if (next is Map) return Map<String, dynamic>.from(next);

    if (response.containsKey('id')) return Map<String, dynamic>.from(response);
    return null;
  }

  Future<void> _loadNextRecord() async {
    if (_loadingNextRecord) return;
    final id = _customerId();
    if (id == null) return;

    setState(() {
      _loadingNextRecord = true;
    });

    try {
      final response = await _apiClient.getJson(
        ApiEndpoints.billDistributionNextCustomerViewByCustomerId(id),
      );
      final nextCustomer = _extractCustomerMap(response);

      if (!mounted) return;
      if (nextCustomer == null || nextCustomer.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No next record found')),
        );
        return;
      }

      setState(() {
        _data = nextCustomer;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load next record: $e')),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _loadingNextRecord = false;
      });
    }
  }

  Future<void> _loadPreviousRecord() async {
    if (_loadingPreviousRecord) return;
    final id = _customerId();
    if (id == null) return;

    setState(() {
      _loadingPreviousRecord = true;
    });

    try {
      final response = await _apiClient.getJson(
        ApiEndpoints.billDistributionPreviousCustomerViewByCustomerId(id),
      );
      final previousCustomer = _extractCustomerMap(response);

      if (!mounted) return;
      if (previousCustomer == null || previousCustomer.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No previous record found')),
        );
        return;
      }

      setState(() {
        _data = previousCustomer;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load previous record: $e')),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _loadingPreviousRecord = false;
      });
    }
  }

  Future<void> _captureAndUploadSideView() async {
    if (_uploadingSideView) return;
    final id = _customerId();
    if (id == null) return;

    try {
      final locationData = await _captureCurrentLocationForUpload();
      final picked = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (picked == null) return;

      setState(() {
        _uploadingSideView = true;
      });

      await _apiClient.postMultipart(
        ApiEndpoints.uploadCustomerSideViewImageByCustomerId(id),
        {
          'source_type': 'bill_distribution',
          'verify_by': 'yes',
          ...locationData,
        },
        {'side_view': File(picked.path)},
      );

      if (!mounted) return;
      await _refreshCustomer();
      if (!mounted) return;
      await _showImageUploadedPopup();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload side image: $e')),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _uploadingSideView = false;
      });
    }
  }

  Future<Map<String, dynamic>> _captureCurrentLocationForUpload() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location service is disabled');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception('Location permission not granted');
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 12),
    );

    return {
      'latitude': position.latitude.toString(),
      'longitude': position.longitude.toString(),
    };
  }

  Future<void> _showImageUploadedPopup() async {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Upload Successful'),
          content: const Text('Side view image uploaded successfully.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showSideImageActions() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_camera_outlined),
                  title: const Text('Take photo'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _captureAndUploadSideView();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Color(0xFF2D3748),
        ),
      ),
    );
  }

  Widget _infoTile(
    BuildContext context, {
    required String label,
    required String value,
    IconData? leading,
    bool allowCopy = true,
  }) {
    final canCopy = allowCopy && _hasValue(value);
    return ListTile(
      dense: true,
      leading: leading == null
          ? null
          : Icon(leading, size: 18, color: const Color(0xFF718096)),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xFF718096),
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: SelectableText(
        value,
        style: const TextStyle(
          fontSize: 13,
          color: Color(0xFF2D3748),
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: canCopy
          ? IconButton(
              tooltip: 'Copy',
              onPressed: () => _copy(context, value),
              icon: const Icon(Icons.copy_rounded, size: 18),
            )
          : null,
    );
  }

  Widget _imagePanel({
    required String label,
    required String url,
    bool editable = false,
    VoidCallback? onEdit,
    bool showUploadingOverlay = false,
  }) {
    final hasUrl = _hasValue(url);
    return Card(
      elevation: 0,
      color: const Color(0xFFF7FAFC),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 4 / 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (hasUrl)
                    Image.network(
                      url,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _noImagePlaceholder(label),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        );
                      },
                    )
                  else
                    _noImagePlaceholder(label),
                  if (editable)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        tooltip: hasUrl ? 'Edit image' : 'Upload image',
                        onPressed: onEdit,
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.9),
                          foregroundColor: const Color(0xFF2D3748),
                        ),
                        icon: Icon(hasUrl ? Icons.edit_rounded : Icons.upload),
                      ),
                    ),
                  if (editable && !hasUrl)
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: onEdit,
                        icon: const Icon(Icons.upload_rounded, size: 18),
                        label: const Text('Upload'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF667eea),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  if (showUploadingOverlay)
                    Container(
                      color: Colors.black.withOpacity(0.35),
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation(Color(0xFFFFFFFF)),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2D3748),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _noImagePlaceholder(String label) {
    return Container(
      color: const Color(0xFFEDF2F7),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(12),
      child: Text(
        'No $label image',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF718096),
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = _data;
    final colony = _asMap(data['colony']);

    final id = _asString(data['id']);
    final projectId = _asString(data['project_id']);
    final name = _asString(data['name']);
    final municipality = _asString(data['municipality_name']);
    final propertyId = _asString(data['property_details_property_id']);
    final integratedPid = _asString(data['integrated_pid_property_id']);
    final integratedOwner = _asString(data['integrated_pid_owner_occupier_name']);
    final areaOfAuthority = _asString(data['area_of_authority']);
    final colonyName = _asString(data['colony_name']);
    final colonyId = _asString(data['colony_id']);
    final address = _asString(data['address_of_property']);
    final lat = _asString(data['latitude']);
    final lng = _asString(data['longitude']);
    final mobile = _asString(data['mobile_no']);
    final category = _asString(data['category']);
    final totalArea = _asString(data['total_area']);
    final unit = _asString(data['unit']);
    final authorizationStatus = _asString(data['authorization_status']);
    final verifyBy = _asString(data['verify_by']);
    final isActive = _asString(data['is_active']);
    final createdAt = _formatDate(_asString(data['created_at']));
    final updatedAt = _formatDate(_asString(data['updated_at']));

    final frontUrl = _asString(data['front_view_url']);
    final sideUrl = _asString(data['side_view_url']);
    final oldLat = _asString(data['old_latitude']);
    final oldLng = _asString(data['old_longitude']);
    final locationUri = _locationUri(lat: oldLat, lng: oldLng);
    final directionUri = _directionUri(lat: oldLat, lng: oldLng);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Details'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Card(
              elevation: 0,
              color: const Color(0xFFF7FAFC),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF667eea).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            color: Color(0xFF667eea),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF2D3748),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                address,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF718096),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: authorizationStatus.toLowerCase() ==
                                    'approved'
                                ? const Color(0xFF48BB78).withOpacity(0.12)
                                : const Color(0xFFF56565).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            authorizationStatus.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: authorizationStatus.toLowerCase() ==
                                      'approved'
                                  ? const Color(0xFF48BB78)
                                  : const Color(0xFFF56565),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _miniChip('ID', id),
                        _miniChip('Project', projectId),
                        _miniChip('Property ID', propertyId),
                        _miniChip('Mobile', mobile),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: FilledButton.tonalIcon(
                                  onPressed: locationUri == null
                                      ? null
                                      : () =>
                                          _openExternal(context, locationUri),
                                  icon: const Icon(
                                    Icons.my_location_rounded,
                                    size: 18,
                                  ),
                                  label: const Text('Location'),
                                  style: FilledButton.styleFrom(
                                    minimumSize: const Size.fromHeight(44),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: FilledButton.tonalIcon(
                                  onPressed: directionUri == null
                                      ? null
                                      : () =>
                                          _openExternal(context, directionUri),
                                  icon: const Icon(
                                    Icons.directions_rounded,
                                    size: 18,
                                  ),
                                  label: const Text('Direction'),
                                  style: FilledButton.styleFrom(
                                    minimumSize: const Size.fromHeight(44),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: _loadingPreviousRecord
                                      ? null
                                      : _loadPreviousRecord,
                                  icon: _loadingPreviousRecord
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.skip_previous_rounded,
                                          size: 18,
                                        ),
                                  label: Text(
                                    _loadingPreviousRecord
                                        ? 'Loading...'
                                        : 'Previous',
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(46),
                                    foregroundColor: const Color(0xFF475569),
                                    side: const BorderSide(
                                      color: Color(0xFFCBD5E1),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _loadingNextRecord
                                      ? null
                                      : _loadNextRecord,
                                  icon: _loadingNextRecord
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation(
                                              Colors.white,
                                            ),
                                          ),
                                        )
                                      : const Icon(
                                          Icons.skip_next_rounded,
                                          size: 18,
                                        ),
                                  label: Text(
                                    _loadingNextRecord ? 'Loading...' : 'Next',
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(46),
                                    backgroundColor: const Color(0xFF22C55E),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _sectionTitle('Property'),
          Card(
            elevation: 0,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Color(0xFFEDF2F7)),
            ),
            child: Column(
              children: [
                _infoTile(
                  context,
                  label: 'Municipality',
                  value: municipality,
                  leading: Icons.account_balance_outlined,
                ),
                const Divider(height: 1),
                _infoTile(
                  context,
                  label: 'Category',
                  value: category,
                  leading: Icons.category_outlined,
                ),
                const Divider(height: 1),
                _infoTile(
                  context,
                  label: 'Total Area',
                  value: _hasValue(totalArea) || _hasValue(unit)
                      ? '${_hasValue(totalArea) ? totalArea : ''}${_hasValue(totalArea) && _hasValue(unit) ? ' ' : ''}${_hasValue(unit) ? unit : ''}'
                          .trim()
                      : '-',
                  leading: Icons.square_foot_outlined,
                ),
                const Divider(height: 1),
                _infoTile(
                  context,
                  label: 'Area of Authority',
                  value: areaOfAuthority,
                  leading: Icons.domain_outlined,
                ),
                const Divider(height: 1),
                _infoTile(
                  context,
                  label: 'Integrated PID (Property)',
                  value: integratedPid,
                  leading: Icons.link_outlined,
                ),
                const Divider(height: 1),
                _infoTile(
                  context,
                  label: 'Integrated PID (Owner/Occupier)',
                  value: integratedOwner,
                  leading: Icons.badge_outlined,
                ),
              ],
            ),
          ),
          _sectionTitle('Location'),
          Card(
            elevation: 0,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Color(0xFFEDF2F7)),
            ),
            child: Column(
              children: [
                _infoTile(
                  context,
                  label: 'Colony',
                  value: colonyName,
                  leading: Icons.location_city_outlined,
                ),
                const Divider(height: 1),
                _infoTile(
                  context,
                  label: 'Colony ID',
                  value: colonyId,
                  leading: Icons.numbers_outlined,
                ),
                const Divider(height: 1),
                _infoTile(
                  context,
                  label: 'Address',
                  value: address,
                  leading: Icons.home_outlined,
                ),
                const Divider(height: 1),
                _infoTile(
                  context,
                  label: 'Latitude',
                  value: lat,
                  leading: Icons.my_location_outlined,
                ),
                const Divider(height: 1),
                _infoTile(
                  context,
                  label: 'Longitude',
                  value: lng,
                  leading: Icons.location_on_outlined,
                ),
              ],
            ),
          ),
          _sectionTitle('Images'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: _imagePanel(
                    label: 'Front view',
                    url: frontUrl,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _imagePanel(
                    label: 'Side view',
                    url: sideUrl,
                    editable: true,
                    onEdit: _uploadingSideView ? null : _showSideImageActions,
                    showUploadingOverlay: _uploadingSideView,
                  ),
                ),
              ],
            ),
          ),
          if (colony != null) ...[
            _sectionTitle('Colony (Object)'),
            Card(
              elevation: 0,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFFEDF2F7)),
              ),
              child: Column(
                children: [
                  _infoTile(
                    context,
                    label: 'ID',
                    value: _asString(colony['id']),
                    leading: Icons.numbers_outlined,
                  ),
                  const Divider(height: 1),
                  _infoTile(
                    context,
                    label: 'Code',
                    value: _asString(colony['code']),
                    leading: Icons.qr_code_rounded,
                  ),
                  const Divider(height: 1),
                  _infoTile(
                    context,
                    label: 'Name',
                    value: _asString(colony['name']),
                    leading: Icons.location_city_outlined,
                  ),
                ],
              ),
            ),
          ],
          _sectionTitle('Meta'),
          Card(
            elevation: 0,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Color(0xFFEDF2F7)),
            ),
            child: Column(
              children: [
                _infoTile(
                  context,
                  label: 'Verify By',
                  value: verifyBy,
                  leading: Icons.verified_outlined,
                ),
                const Divider(height: 1),
                _infoTile(
                  context,
                  label: 'Is Active',
                  value: isActive,
                  leading: Icons.toggle_on_outlined,
                ),
                const Divider(height: 1),
                _infoTile(
                  context,
                  label: 'Created At',
                  value: createdAt,
                  leading: Icons.event_available_outlined,
                ),
                const Divider(height: 1),
                _infoTile(
                  context,
                  label: 'Updated At',
                  value: updatedAt,
                  leading: Icons.update_outlined,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _miniChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFEDF2F7)),
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF2D3748),
          ),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: Color(0xFF718096),
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}
