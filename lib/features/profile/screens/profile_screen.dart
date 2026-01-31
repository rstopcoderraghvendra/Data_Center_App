import 'package:flutter/material.dart';
import '../../common/widgets/primary_button.dart';
import '../../../app/routes/route_names.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/local_storage.dart';
import '../../../data/repositories/auth_repository.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  bool _loading = true;
  bool _saving = false;
  late final AuthRepository _authRepository;
  late final Map<String, TextEditingController> _controllers;

  final _fields = const [
    _ProfileField('name', 'Name', Icons.person_outline),
    _ProfileField('email', 'Email', Icons.email_outlined,
        keyboard: TextInputType.emailAddress, alwaysReadOnly: true),
    _ProfileField('dob', 'Date of birth', Icons.cake_outlined),
    _ProfileField('gender', 'Gender', Icons.wc_outlined),
    _ProfileField('address', 'Address', Icons.home_outlined, maxLines: 2),
    _ProfileField('country', 'Country', Icons.public_outlined),
    _ProfileField('state', 'State', Icons.map_outlined),
    _ProfileField('city', 'City', Icons.location_city_outlined),
    _ProfileField('pin_code', 'Pin code', Icons.local_post_office_outlined,
        keyboard: TextInputType.number),
    _ProfileField(
        'date_of_joining', 'Date of joining', Icons.event_available_outlined),
  ];

  @override
  void initState() {
    super.initState();
    _authRepository = AuthRepository(ApiClient(storage: LocalStorage()));
    _controllers = {
      for (var field in _fields) field.key: TextEditingController(),
    };
    _controllers['bill_distribution_entery_count'] = TextEditingController();
    _controllers['survey_data_entery_count'] = TextEditingController();
    _loadProfile();
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Logout',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(fontSize: 13, color: Color(0xFF4A5568)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel',
              style: TextStyle(fontSize: 13, color: Color(0xFF718096)),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFC8181),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: const Text(
              'Logout',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _authRepository.logout();
      Navigator.of(context).pushNamedAndRemoveUntil(
        RouteNames.login,
        (route) => false,
      );
    }
  }

  Future<void> _loadProfile() async {
    try {
      final data = await _authRepository.me();
      setState(() {
        _controllers['name']?.text = data['name']?.toString() ?? '';
        _controllers['dob']?.text = data['dob']?.toString() ?? '';
        _controllers['gender']?.text = data['gender']?.toString() ?? '';
        _controllers['address']?.text = data['address']?.toString() ?? '';
        _controllers['country']?.text = data['country']?.toString() ?? '';
        _controllers['state']?.text = data['state']?.toString() ?? '';
        _controllers['city']?.text = data['city']?.toString() ?? '';
        _controllers['pin_code']?.text = data['pin_code']?.toString() ?? '';
        _controllers['date_of_joining']?.text =
            data['date_of_joining']?.toString() ?? '';
        _controllers['bill_distribution_entery_count']?.text =
            data['bill_distribution_entery_count']?.toString() ?? '0';
        _controllers['survey_data_entery_count']?.text =
            data['survey_data_entery_count']?.toString() ?? '0';
        _controllers['email']?.text = data['email']?.toString() ?? '';
      });
    } catch (e) {
      _showMessage('Failed to load profile');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _saveProfile() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final payload = <String, dynamic>{
        'name': _controllers['name']?.text.trim(),
        'dob': _controllers['dob']?.text.trim(),
        'gender': _controllers['gender']?.text.trim().toLowerCase(),
        'address': _controllers['address']?.text.trim(),
        'country': _controllers['country']?.text.trim(),
        'state': _controllers['state']?.text.trim(),
        'city': _controllers['city']?.text.trim(),
        'pin_code': _controllers['pin_code']?.text.trim(),
        'date_of_joining': _controllers['date_of_joining']?.text.trim(),
      };
      payload.removeWhere(
        (key, value) => value == null || value.toString().trim().isEmpty,
      );
      await _authRepository.updateProfile(payload);
      setState(() => _isEditing = false);
      _showMessage('Profile updated');
    } catch (e) {
      _showMessage('Failed to update');
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF667eea),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                ),
              ],
            ),
            child: const Icon(
              Icons.person,
              size: 32,
              color: Color(0xFF667eea),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            _controllers['name']!.text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              _controllers['email']!.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      _controllers['bill_distribution_entery_count']!.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Bill Entries',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 1,
                  height: 30,
                  color: Colors.white.withOpacity(0.3),
                ),
                Column(
                  children: [
                    Text(
                      _controllers['survey_data_entery_count']!.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Survey Entries',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
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

  Widget _buildFieldItem(_ProfileField field) {
    final controller = _controllers[field.key]!;
    final value = controller.text.trim();

    if (_isEditing && !field.alwaysReadOnly) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            field.label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF4A5568),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            maxLines: field.maxLines,
            keyboardType: field.keyboard,
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF7FAFC),
              prefixIcon:
                  Icon(field.icon, size: 18, color: const Color(0xFF667eea)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: Color(0xFF667eea), width: 1.5),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
          const SizedBox(height: 16),
        ],
      );
    }

    if (value.isEmpty && !_isEditing) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFEDF2F7),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(field.icon, size: 14, color: const Color(0xFF667eea)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  field.label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF718096),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                  maxLines: field.maxLines,
                ),
              ],
            ),
          ),
          if (field.alwaysReadOnly)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFEDF2F7),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Read Only',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF7FAFC),
        body: Center(
          child: CircularProgressIndicator(color: const Color(0xFF667eea)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: CustomScrollView(
        slivers: [
          // App Bar with Gradient Background
          SliverAppBar(
            backgroundColor: const Color(0xFF667eea),
            expandedHeight: 280,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 32,
                          color: Color(0xFF667eea),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        _controllers['name']!.text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          _controllers['email']!.text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  _controllers[
                                          'bill_distribution_entery_count']!
                                      .text,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  'Bill Entries',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 1,
                              height: 30,
                              color: Colors.white.withOpacity(0.3),
                            ),
                            Column(
                              children: [
                                Text(
                                  _controllers['survey_data_entery_count']!
                                      .text,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  'Survey Entries',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _isEditing ? Icons.check_rounded : Icons.edit_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                onPressed: () {
                  if (_isEditing) {
                    _saveProfile();
                  } else {
                    setState(() => _isEditing = true);
                  }
                },
              ),
            ],
          ),

          // Content section
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Profile Fields
                ..._fields.map((field) => _buildFieldItem(field)),

                // Action Buttons when editing
                if (_isEditing) ...[
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Save Button
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _saving ? null : _saveProfile,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                child: Center(
                                  child: _saving
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text(
                                          'Save Changes',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Cancel Button
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => setState(() => _isEditing = false),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: Colors.grey[300]!),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF718096),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Profile Actions when not editing
                if (!_isEditing) ...[
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Change Password
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                RouteNames.changePassword,
                              );
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEDF2F7),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF667eea),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Icon(
                                      Icons.lock_rounded,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Change Password',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right_rounded,
                                    color: Colors.grey[600],
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Logout
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _logout(context),
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFED7D7),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFC8181),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Icon(
                                      Icons.logout_rounded,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Logout',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right_rounded,
                                    color: Colors.grey[600],
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 30),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileField {
  final String key;
  final String label;
  final IconData icon;
  final TextInputType? keyboard;
  final int maxLines;
  final bool alwaysReadOnly;

  const _ProfileField(
    this.key,
    this.label,
    this.icon, {
    this.keyboard,
    this.maxLines = 1,
    this.alwaysReadOnly = false,
  });
}
