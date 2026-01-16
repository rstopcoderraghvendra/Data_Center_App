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
    _ProfileField('dob', 'Date of birth', Icons.cake_outlined),
    _ProfileField('gender', 'Gender', Icons.wc_outlined),
    _ProfileField('address', 'Address', Icons.home_outlined, maxLines: 2),
    _ProfileField('country', 'Country', Icons.public_outlined),
    _ProfileField('state', 'State', Icons.map_outlined),
    _ProfileField('city', 'City', Icons.location_city_outlined),
    _ProfileField(
      'pin_code',
      'Pin code',
      Icons.local_post_office_outlined,
      keyboard: TextInputType.number,
    ),
    _ProfileField(
        'date_of_joining', 'Date of joining', Icons.event_available_outlined),
    _ProfileField(
      'bill_distribution_entery_count',
      'Bill entries',
      Icons.receipt_long_outlined,
      keyboard: TextInputType.number,
    ),
    _ProfileField(
      'survey_data_entery_count',
      'Survey entries',
      Icons.assignment_outlined,
      keyboard: TextInputType.number,
    ),
    _ProfileField(
      'email',
      'Email',
      Icons.email_outlined,
      keyboard: TextInputType.emailAddress,
      alwaysReadOnly: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _authRepository = AuthRepository(ApiClient(storage: LocalStorage()));
    _controllers = {
      'name': TextEditingController(text: 'Alex Johnson'),
      'dob': TextEditingController(text: '1992-08-17'),
      'gender': TextEditingController(text: 'Female'),
      'address': TextEditingController(text: '123 Main Street'),
      'country': TextEditingController(text: 'India'),
      'state': TextEditingController(text: 'Gujarat'),
      'city': TextEditingController(text: 'Ahmedabad'),
      'pin_code': TextEditingController(text: '380015'),
      'date_of_joining': TextEditingController(text: '2024-01-12'),
      'bill_distribution_entery_count': TextEditingController(text: '24'),
      'survey_data_entery_count': TextEditingController(text: '18'),
      'email': TextEditingController(text: 'alex@example.com'),
    };
    _loadProfile();
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _loadProfile() async {
    try {
      final data = await _authRepository.me();
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
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _saveProfile() async {
    if (_saving) {
      return;
    }
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
        'bill_distribution_entery_count': int.tryParse(
          _controllers['bill_distribution_entery_count']?.text ?? '',
        ),
        'survey_data_entery_count': int.tryParse(
          _controllers['survey_data_entery_count']?.text ?? '',
        ),
      };
      payload.removeWhere(
        (key, value) => value == null || value.toString().trim().isEmpty,
      );
      await _authRepository.updateProfile(payload);
      if (mounted) {
        setState(() => _isEditing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit_outlined),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : Column(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: colorScheme.primaryContainer,
                  child: Icon(
                    Icons.person,
                    color: colorScheme.onPrimaryContainer,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.upload_outlined),
                  label: const Text('Upload Photo'),
                ),
                const SizedBox(height: 12),
                ..._fields.expand((field) {
                  final controller = _controllers[field.key]!;
                  final readOnly = field.alwaysReadOnly;
                  final value = controller.text.trim();
                  if (_isEditing && !readOnly) {
                    return [
                      TextField(
                        controller: controller,
                        maxLines: field.maxLines,
                        keyboardType: field.keyboard,
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          labelText: field.label,
                          labelStyle: const TextStyle(fontSize: 12),
                          prefixIcon: Icon(field.icon),
                          isDense: true,
                          prefixIconConstraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 40,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ];
                  }
                  if (_isEditing && readOnly) {
                    return const [];
                  }
                  return [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              colorScheme.outlineVariant.withValues(alpha: 0.7),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(field.icon,
                              size: 20, color: colorScheme.primary),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  field.label,
                                  style: textTheme.labelSmall?.copyWith(
                                    color: colorScheme.outline,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  value.isEmpty ? '-' : value,
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ];
                }),
                if (_isEditing) ...[
                  const SizedBox(height: 4),
                  PrimaryButton(
                    label: _saving ? 'Saving...' : 'Update Profile',
                    onPressed: _saving ? () {} : _saveProfile,
                  ),
                ],
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.lock_outline),
                  title: const Text('Change Password'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).pushNamed(RouteNames.changePassword);
                  },
                ),
              ],
            ),
          ),
        ),
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
