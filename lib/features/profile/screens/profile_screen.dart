// import 'package:flutter/material.dart';
// import '../../common/widgets/primary_button.dart';
// import '../../../app/routes/route_names.dart';
// import '../../../core/network/api_client.dart';
// import '../../../core/storage/local_storage.dart';
// import '../../../data/repositories/auth_repository.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   bool _isEditing = false;
//   bool _loading = true;
//   bool _saving = false;
//   late final AuthRepository _authRepository;
//   late final Map<String, TextEditingController> _controllers;

//   final _fields = const [
//     _ProfileField('name', 'Name', Icons.person_outline),
//     _ProfileField('dob', 'Date of birth', Icons.cake_outlined),
//     _ProfileField('gender', 'Gender', Icons.wc_outlined),
//     _ProfileField('address', 'Address', Icons.home_outlined, maxLines: 2),
//     _ProfileField('country', 'Country', Icons.public_outlined),
//     _ProfileField('state', 'State', Icons.map_outlined),
//     _ProfileField('city', 'City', Icons.location_city_outlined),
//     _ProfileField(
//       'pin_code',
//       'Pin code',
//       Icons.local_post_office_outlined,
//       keyboard: TextInputType.number,
//     ),
//     _ProfileField(
//         'date_of_joining', 'Date of joining', Icons.event_available_outlined),
//     _ProfileField(
//       'bill_distribution_entery_count',
//       'Bill entries',
//       Icons.receipt_long_outlined,
//       keyboard: TextInputType.number,
//     ),
//     _ProfileField(
//       'survey_data_entery_count',
//       'Survey entries',
//       Icons.assignment_outlined,
//       keyboard: TextInputType.number,
//     ),
//     _ProfileField(
//       'email',
//       'Email',
//       Icons.email_outlined,
//       keyboard: TextInputType.emailAddress,
//       alwaysReadOnly: true,
//     ),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _authRepository = AuthRepository(ApiClient(storage: LocalStorage()));
//     _controllers = {
//       'name': TextEditingController(text: 'Alex Johnson'),
//       'dob': TextEditingController(text: '1992-08-17'),
//       'gender': TextEditingController(text: 'Female'),
//       'address': TextEditingController(text: '123 Main Street'),
//       'country': TextEditingController(text: 'India'),
//       'state': TextEditingController(text: 'Gujarat'),
//       'city': TextEditingController(text: 'Ahmedabad'),
//       'pin_code': TextEditingController(text: '380015'),
//       'date_of_joining': TextEditingController(text: '2024-01-12'),
//       'bill_distribution_entery_count': TextEditingController(text: '24'),
//       'survey_data_entery_count': TextEditingController(text: '18'),
//       'email': TextEditingController(text: 'alex@example.com'),
//     };
//     _loadProfile();
//   }

//   @override
//   void dispose() {
//     for (final controller in _controllers.values) {
//       controller.dispose();
//     }
//     super.dispose();
//   }

//   Future<void> _loadProfile() async {
//     try {
//       final data = await _authRepository.me();
//       _controllers['name']?.text = data['name']?.toString() ?? '';
//       _controllers['dob']?.text = data['dob']?.toString() ?? '';
//       _controllers['gender']?.text = data['gender']?.toString() ?? '';
//       _controllers['address']?.text = data['address']?.toString() ?? '';
//       _controllers['country']?.text = data['country']?.toString() ?? '';
//       _controllers['state']?.text = data['state']?.toString() ?? '';
//       _controllers['city']?.text = data['city']?.toString() ?? '';
//       _controllers['pin_code']?.text = data['pin_code']?.toString() ?? '';
//       _controllers['date_of_joining']?.text =
//           data['date_of_joining']?.toString() ?? '';
//       _controllers['bill_distribution_entery_count']?.text =
//           data['bill_distribution_entery_count']?.toString() ?? '0';
//       _controllers['survey_data_entery_count']?.text =
//           data['survey_data_entery_count']?.toString() ?? '0';
//       _controllers['email']?.text = data['email']?.toString() ?? '';
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(e.toString())),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _loading = false);
//       }
//     }
//   }

//   Future<void> _saveProfile() async {
//     if (_saving) {
//       return;
//     }
//     setState(() => _saving = true);
//     try {
//       final payload = <String, dynamic>{
//         'name': _controllers['name']?.text.trim(),
//         'dob': _controllers['dob']?.text.trim(),
//         'gender': _controllers['gender']?.text.trim().toLowerCase(),
//         'address': _controllers['address']?.text.trim(),
//         'country': _controllers['country']?.text.trim(),
//         'state': _controllers['state']?.text.trim(),
//         'city': _controllers['city']?.text.trim(),
//         'pin_code': _controllers['pin_code']?.text.trim(),
//         'date_of_joining': _controllers['date_of_joining']?.text.trim(),
//         'bill_distribution_entery_count': int.tryParse(
//           _controllers['bill_distribution_entery_count']?.text ?? '',
//         ),
//         'survey_data_entery_count': int.tryParse(
//           _controllers['survey_data_entery_count']?.text ?? '',
//         ),
//       };
//       payload.removeWhere(
//         (key, value) => value == null || value.toString().trim().isEmpty,
//       );
//       await _authRepository.updateProfile(payload);
//       if (mounted) {
//         setState(() => _isEditing = false);
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Profile updated')),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(e.toString())),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _saving = false);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//     final textTheme = Theme.of(context).textTheme;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'),
//         actions: [
//           IconButton(
//             icon: Icon(_isEditing ? Icons.check : Icons.edit_outlined),
//             onPressed: () {
//               if (_isEditing) {
//                 _saveProfile();
//               } else {
//                 setState(() => _isEditing = true);
//               }
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Card(
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: _loading
//                 ? const Center(child: CircularProgressIndicator())
//                 : Column(
//               children: [
//                 CircleAvatar(
//                   radius: 36,
//                   backgroundColor: colorScheme.primaryContainer,
//                   child: Icon(
//                     Icons.person,
//                     color: colorScheme.onPrimaryContainer,
//                     size: 36,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 TextButton.icon(
//                   onPressed: () {},
//                   icon: const Icon(Icons.upload_outlined),
//                   label: const Text('Upload Photo'),
//                 ),
//                 const SizedBox(height: 12),
//                 ..._fields.expand((field) {
//                   final controller = _controllers[field.key]!;
//                   final readOnly = field.alwaysReadOnly;
//                   final value = controller.text.trim();
//                   if (_isEditing && !readOnly) {
//                     return [
//                       TextField(
//                         controller: controller,
//                         maxLines: field.maxLines,
//                         keyboardType: field.keyboard,
//                         style: const TextStyle(fontSize: 14),
//                         decoration: InputDecoration(
//                           labelText: field.label,
//                           labelStyle: const TextStyle(fontSize: 12),
//                           prefixIcon: Icon(field.icon),
//                           isDense: true,
//                           prefixIconConstraints: const BoxConstraints(
//                             minWidth: 40,
//                             minHeight: 40,
//                           ),
//                           contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 6,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                     ];
//                   }
//                   if (_isEditing && readOnly) {
//                     return const [];
//                   }
//                   return [
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 10,
//                       ),
//                       decoration: BoxDecoration(
//                         color: colorScheme.surface,
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                           color:
//                               colorScheme.outlineVariant.withValues(alpha: 0.7),
//                         ),
//                       ),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Icon(field.icon,
//                               size: 20, color: colorScheme.primary),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   field.label,
//                                   style: textTheme.labelSmall?.copyWith(
//                                     color: colorScheme.outline,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   value.isEmpty ? '-' : value,
//                                   style: textTheme.bodyMedium?.copyWith(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                   ];
//                 }),
//                 if (_isEditing) ...[
//                   const SizedBox(height: 4),
//                   PrimaryButton(
//                     label: _saving ? 'Saving...' : 'Update Profile',
//                     onPressed: _saving ? () {} : _saveProfile,
//                   ),
//                 ],
//                 const SizedBox(height: 12),
//                 ListTile(
//                   contentPadding: EdgeInsets.zero,
//                   leading: const Icon(Icons.lock_outline),
//                   title: const Text('Change Password'),
//                   trailing: const Icon(Icons.chevron_right),
//                   onTap: () {
//                     Navigator.of(context).pushNamed(RouteNames.changePassword);
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _ProfileField {
//   final String key;
//   final String label;
//   final IconData icon;
//   final TextInputType? keyboard;
//   final int maxLines;
//   final bool alwaysReadOnly;

//   const _ProfileField(
//     this.key,
//     this.label,
//     this.icon, {
//     this.keyboard,
//     this.maxLines = 1,
//     this.alwaysReadOnly = false,
//   });
// }

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
    _ProfileField('pin_code', 'Pin code', Icons.local_post_office_outlined,
        keyboard: TextInputType.number),
    _ProfileField(
        'date_of_joining', 'Date of joining', Icons.event_available_outlined),
    _ProfileField('bill_distribution_entery_count', 'Bill entries',
        Icons.receipt_long_outlined,
        keyboard: TextInputType.number),
    _ProfileField(
        'survey_data_entery_count', 'Survey entries', Icons.assignment_outlined,
        keyboard: TextInputType.number),
    _ProfileField('email', 'Email', Icons.email_outlined,
        keyboard: TextInputType.emailAddress, alwaysReadOnly: true),
  ];

  @override
  void initState() {
    super.initState();
    _authRepository = AuthRepository(ApiClient(storage: LocalStorage()));
    _controllers = {
      for (var field in _fields) field.key: TextEditingController(),
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
      body: Column(
        children: [
          _buildProfileHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
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
                              // Logout logic
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                ],
              ),
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
