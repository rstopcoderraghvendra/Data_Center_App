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
    // Add controllers for bill and survey entries separately
    // since they're not in _fields list anymore
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
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _authRepository.logout();

      // Navigate to login screen and clear all previous routes
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
        // Keep these for header display
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
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      color: Colors.blue[700],
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              const Spacer(),
              const Text(
                'Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  _isEditing ? Icons.check : Icons.edit,
                  color: Colors.white,
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
          const SizedBox(height: 10),
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 50,
              color: Colors.blue[700],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _controllers['name']!.text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _controllers['email']!.text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
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
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              field.label,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: controller,
              maxLines: field.maxLines,
              keyboardType: field.keyboard,
              decoration: InputDecoration(
                prefixIcon: Icon(field.icon, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
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
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(field.icon, color: Colors.grey[700], size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  field.label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: field.maxLines,
                ),
              ],
            ),
          ),
          if (field.alwaysReadOnly)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Read Only',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
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
        body: Center(
          child: CircularProgressIndicator(color: Colors.blue[700]),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // SliverAppBar with flexible space for header
          SliverAppBar(
            backgroundColor: Colors.blue[700],
            expandedHeight: 300, // Adjust this height as needed
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.blue[700],
                padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.blue[700],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _controllers['name']!.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _controllers['email']!.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                _controllers['bill_distribution_entery_count']!
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
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  _isEditing ? Icons.check : Icons.edit,
                  color: Colors.white,
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
                ..._fields.map((field) => _buildFieldItem(field)),
                if (_isEditing) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saving ? null : _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: _saving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : const Text('Save Changes'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => setState(() => _isEditing = false),
                      child: const Text('Cancel'),
                    ),
                  ),
                ],
                if (!_isEditing) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.lock, color: Colors.blue[700]),
                          title: const Text('Change Password'),
                          trailing: Icon(Icons.chevron_right,
                              color: Colors.grey[600]),
                          onTap: () {
                            Navigator.pushNamed(
                                context, RouteNames.changePassword);
                          },
                        ),
                        Divider(color: Colors.grey[300]),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.logout, color: Colors.red[400]),
                          title: Text(
                            'Logout',
                            style: TextStyle(color: Colors.red[400]),
                          ),
                          trailing: Icon(Icons.chevron_right,
                              color: Colors.grey[600]),
                          onTap: () {
                            _logout(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 20),
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
