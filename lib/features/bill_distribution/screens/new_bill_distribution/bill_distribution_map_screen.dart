import 'package:data_care_app/core/constants/api_endpoints.dart';
import 'package:data_care_app/core/network/api_client.dart';
import 'package:data_care_app/core/storage/local_storage.dart';
import 'package:data_care_app/features/bill_distribution/screens/new_bill_distribution/bill_distribution_customer_view_screen.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BillDistributionMapScreen extends StatefulWidget {
  final int projectId;
  final int? colonyId;
  final String? colonyName;

  const BillDistributionMapScreen({
    super.key,
    required this.projectId,
    this.colonyId,
    this.colonyName,
  });

  @override
  State<BillDistributionMapScreen> createState() =>
      _BillDistributionMapScreenState();
}

class _BillDistributionMapScreenState extends State<BillDistributionMapScreen> {
  final ApiClient _apiClient = ApiClient(storage: LocalStorage());
  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;

  bool _isLoading = true;
  String? _errorMessage;
  bool _showSearchInput = false;
  String _searchQuery = '';
  bool _isSearchLoading = false;
  List<_CustomerLocation> _customers = [];
  List<_SearchCustomer> _searchResults = [];
  CameraPosition _initialCamera = _defaultCamera;

  static const CameraPosition _defaultCamera = CameraPosition(
    target: LatLng(28.6139, 77.2090),
    zoom: 10,
  );

  @override
  void initState() {
    super.initState();
    _loadCustomerLocations();
  }

  Future<void> _loadCustomerLocations() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _apiClient.getJson(
        ApiEndpoints.fetchCustomersByProjectId(widget.projectId),
        query: {
          if (widget.colonyId != null) 'colony_id': widget.colonyId.toString(),
          if (widget.colonyName != null && widget.colonyName!.trim().isNotEmpty)
            'colony_name': widget.colonyName!.trim(),
        },
      );

      final data = response['data'];
      if (data is! List) {
        throw Exception('Invalid customers response format');
      }

      final customers = data
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .map(_CustomerLocation.fromJson)
          .where((customer) =>
              customer.latitude != null && customer.longitude != null)
          .toList();

      if (!mounted) return;
      setState(() {
        _customers = customers;
        if (customers.isNotEmpty) {
          _initialCamera = CameraPosition(
            target:
                LatLng(customers.first.latitude!, customers.first.longitude!),
            zoom: 16,
          );
        } else {
          _initialCamera = _defaultCamera;
        }
        _isLoading = false;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fitMapToMarkers();
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _showCustomerDetailsPopup(_CustomerLocation customer) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF667eea).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.person_pin_circle_rounded,
                      color: Color(0xFF667eea),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Customer Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: customer.authorizationStatus.toLowerCase() ==
                              'approved'
                          ? const Color(0xFF48BB78).withOpacity(0.12)
                          : const Color(0xFFF56565).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      customer.authorizationStatus.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: customer.authorizationStatus.toLowerCase() ==
                                'approved'
                            ? const Color(0xFF48BB78)
                            : const Color(0xFFF56565),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _detailRow('ID', customer.id.toString()),
              _detailRow('Name', customer.name),
              _detailRow('Municipality', customer.municipalityName),
              _detailRow('Mobile', customer.mobileNo ?? '-'),
              _detailRow('Latitude', customer.latitude?.toString() ?? '-'),
              _detailRow('Longitude', customer.longitude?.toString() ?? '-'),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF4A5568),
                      ),
                      child: const Text('Close'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        Navigator.pop(context);
                        await _openCustomerViewById(customer.id);
                      },
                  icon: const Icon(Icons.play_circle_fill_rounded, size: 18),
                  label: const Text('Start Survey'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF48BB78),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF2D3748),
          ),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  Future<void> _fitMapToMarkers() async {
    if (_mapController == null || _customers.isEmpty) return;
    try {
      if (_customers.length == 1) {
        final c = _customers.first;
        await _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(c.latitude!, c.longitude!), zoom: 16),
          ),
        );
        return;
      }

      final latitudes = _customers.map((e) => e.latitude!).toList();
      final longitudes = _customers.map((e) => e.longitude!).toList();
      final minLat = latitudes.reduce((a, b) => a < b ? a : b);
      final maxLat = latitudes.reduce((a, b) => a > b ? a : b);
      final minLng = longitudes.reduce((a, b) => a < b ? a : b);
      final maxLng = longitudes.reduce((a, b) => a > b ? a : b);

      if (minLat == maxLat && minLng == maxLng) {
        await _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(minLat, minLng), zoom: 16),
          ),
        );
        return;
      }

      final bounds = LatLngBounds(
        southwest: LatLng(minLat, minLng),
        northeast: LatLng(maxLat, maxLng),
      );

      await _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 56),
      );
    } catch (_) {
      final first = _customers.first;
      await _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(first.latitude!, first.longitude!),
            zoom: 14,
          ),
        ),
      );
    }
  }

  Future<void> _openCustomerViewById(int customerId) async {
    try {
      final response = await _apiClient.getJson(
        ApiEndpoints.billDistributionCustomersViewByCustomerId(customerId),
      );
      final data = response['data'];
      final mapData = data is Map
          ? Map<String, dynamic>.from(data)
          : Map<String, dynamic>.from(response);
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              BillDistributionCustomerViewScreen(customerData: mapData),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to open customer view: $e'),
          backgroundColor: Colors.red.shade600,
        ),
      );
    }
  }

  Future<void> _searchCustomers(String query) async {
    if (query.trim().isEmpty) {
      if (!mounted) return;
      setState(() {
        _searchResults = [];
        _isSearchLoading = false;
      });
      return;
    }

    setState(() {
      _isSearchLoading = true;
    });

    try {
      final response = await _apiClient.getJson(
        ApiEndpoints.billDistributionCustomersByProjectId(widget.projectId),
        query: {'search': query.trim(), 'page': '1', 'limit': '20'},
      );
      final data = response['data'];
      if (data is! List) throw Exception('Invalid search response');
      final results = data
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .map(_SearchCustomer.fromJson)
          .toList();
      if (!mounted) return;
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _searchResults = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Search failed: $e'),
          backgroundColor: Colors.red.shade600,
        ),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isSearchLoading = false;
      });
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      _searchCustomers(value);
    });
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _searchController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  List<_CustomerLocation> _getFilteredCustomers() {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return _customers;
    return _customers.where((customer) {
      return customer.name.toLowerCase().contains(query) ||
          customer.municipalityName.toLowerCase().contains(query) ||
          (customer.mobileNo ?? '').toLowerCase().contains(query) ||
          customer.id.toString().contains(query);
    }).toList();
  }

  Set<Marker> _buildMarkers(List<_CustomerLocation> customers) {
    return customers
        .map(
          (customer) => Marker(
            markerId: MarkerId('customer_${customer.id}'),
            position: LatLng(customer.latitude!, customer.longitude!),
            onTap: () => _showCustomerDetailsPopup(customer),
            infoWindow: InfoWindow.noText,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              customer.isActive
                  ? BitmapDescriptor.hueGreen
                  : BitmapDescriptor.hueRed,
            ),
          ),
        )
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    final filteredCustomers = _getFilteredCustomers();
    final visibleMarkers = _buildMarkers(filteredCustomers);
    final approvedCount = _customers
        .where((e) => e.authorizationStatus.toLowerCase() == 'approved')
        .length;
    final unapprovedCount = _customers.length - approvedCount;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF667eea),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bill Distribution Map',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Tap marker to view customer details',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            tooltip: 'Search',
            onPressed: () {
              setState(() {
                _showSearchInput = !_showSearchInput;
                if (!_showSearchInput) {
                  _searchController.clear();
                  _searchQuery = '';
                }
              });
            },
            icon: Icon(
              _showSearchInput ? Icons.close_rounded : Icons.search_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Color(0xFF667eea)),
              ),
            )
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          size: 46,
                          color: Color(0xFFF56565),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Failed to load map data',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF718096),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 14),
                        ElevatedButton(
                          onPressed: _loadCustomerLocations,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: _initialCamera,
                      markers: visibleMarkers,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      mapToolbarEnabled: false,
                      zoomControlsEnabled: false,
                      onMapCreated: (controller) {
                        _mapController = controller;
                        _fitMapToMarkers();
                      },
                    ),
                    Positioned(
                      top: 14,
                      left: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            _buildStatChip(
                              icon: Icons.location_pin,
                              label: 'Total',
                              value: _customers.length.toString(),
                              color: const Color(0xFF667eea),
                            ),
                            _buildVerticalDivider(),
                            _buildStatChip(
                              icon: Icons.verified_rounded,
                              label: 'Approved',
                              value: approvedCount.toString(),
                              color: const Color(0xFF48BB78),
                            ),
                            _buildVerticalDivider(),
                            _buildStatChip(
                              icon: Icons.pending_actions_rounded,
                              label: 'Unapproved',
                              value: unapprovedCount.toString(),
                              color: const Color(0xFFF56565),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_showSearchInput)
                      Positioned(
                        top: 86,
                        left: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            style: const TextStyle(fontSize: 12),
                            onChanged: (value) {
                              _onSearchChanged(value);
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle: const TextStyle(fontSize: 12),
                              hintText: 'Search by Property ID, Mobile',
                              prefixIcon: const Icon(
                                Icons.search_rounded,
                                color: Color(0xFF667eea),
                              ),
                              suffixIcon: _searchQuery.isNotEmpty
                                  ? IconButton(
                                      onPressed: () {
                                        _searchController.clear();
                                        _onSearchChanged('');
                                      },
                                      icon: const Icon(Icons.clear_rounded),
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    if (_showSearchInput &&
                        (_isSearchLoading || _searchResults.isNotEmpty))
                      Positioned(
                        top: 142,
                        left: 12,
                        right: 12,
                        child: Container(
                          constraints: const BoxConstraints(maxHeight: 230),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: _isSearchLoading
                              ? const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    ),
                                  ),
                                )
                              : ListView.separated(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemCount: _searchResults.length,
                                  separatorBuilder: (_, __) =>
                                      const Divider(height: 1),
                                  itemBuilder: (context, index) {
                                    final item = _searchResults[index];
                                    return ListTile(
                                      dense: true,
                                      title: Text(
                                        item.name,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'PID: ${item.propertyId.isEmpty ? "-" : item.propertyId} • ${item.mobileNo}',
                                        style: const TextStyle(fontSize: 11),
                                      ),
                                      trailing: const Icon(
                                        Icons.open_in_new_rounded,
                                        size: 16,
                                      ),
                                      onTap: () async {
                                        await _openCustomerViewById(item.id);
                                      },
                                    );
                                  },
                                ),
                        ),
                      ),
                    if (widget.colonyName != null &&
                        widget.colonyName!.isNotEmpty)
                      Positioned(
                        bottom: 16,
                        left: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            'Selected Colony: ${widget.colonyName}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                        ),
                      ),
                    if (_customers.isEmpty)
                      Positioned(
                        bottom: 24,
                        left: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Text(
                            'No customer coordinates found for this project.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              '$label: $value',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D3748),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 18,
      color: const Color(0xFFE2E8F0),
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}

class _CustomerLocation {
  final int id;
  final String name;
  final String municipalityName;
  final String? mobileNo;
  final String authorizationStatus;
  final bool isActive;
  final double? latitude;
  final double? longitude;

  const _CustomerLocation({
    required this.id,
    required this.name,
    required this.municipalityName,
    required this.mobileNo,
    required this.authorizationStatus,
    required this.isActive,
    required this.latitude,
    required this.longitude,
  });

  factory _CustomerLocation.fromJson(Map<String, dynamic> json) {
    final parsedOldLat = _toDouble(json['old_latitude']);
    final parsedOldLng = _toDouble(json['old_longitude']);
    final parsedLat = _toDouble(json['latitude'] ?? json['lat']);
    final parsedLng = _toDouble(json['longitude'] ?? json['lng'] ?? json['lon']);

    // Prefer old_* fields as requested, but keep a fallback for backend variance.
    final latitude = parsedOldLat ?? parsedLat;
    final longitude = parsedOldLng ?? parsedLng;

    return _CustomerLocation(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: (json['name'] ?? '').toString(),
      municipalityName: (json['municipality_name'] ?? '').toString(),
      mobileNo: json['mobile_no']?.toString(),
      authorizationStatus:
          (json['authorization_status'] ?? 'unapproved').toString(),
      isActive: _toBool(json['is_active']),
      latitude: latitude,
      longitude: longitude,
    );
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    return double.tryParse(value.toString());
  }

  static bool _toBool(dynamic value) {
    if (value is bool) return value;
    final str = (value ?? '').toString().trim().toLowerCase();
    return str == 'true' || str == '1' || str == 'yes';
  }
}

class _SearchCustomer {
  final int id;
  final String name;
  final String propertyId;
  final String mobileNo;

  const _SearchCustomer({
    required this.id,
    required this.name,
    required this.propertyId,
    required this.mobileNo,
  });

  factory _SearchCustomer.fromJson(Map<String, dynamic> json) {
    return _SearchCustomer(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: (json['name'] ?? '').toString(),
      propertyId: (json['integrated_pid_property_id'] ?? '').toString(),
      mobileNo: (json['mobile_no'] ?? '').toString(),
    );
  }
}
