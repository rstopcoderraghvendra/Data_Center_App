import 'package:data_care_app/app/routes/route_names.dart';
import 'package:data_care_app/data/models/projects_model.dart';
import 'package:data_care_app/data/repositories/projects_repository%20copy.dart';
import 'package:data_care_app/features/auth/screens/login_screen.dart';
import 'package:data_care_app/features/home/screens/project_detail_screen.dart';
import 'package:data_care_app/core/network/api_client.dart';
import 'package:data_care_app/core/storage/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late ProjectRepository _projectRepository;
  List<Project> projects = [];
  bool _isLoading = true;
  String _error = '';
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _projectRepository = ProjectRepository(
      ApiClient(storage: LocalStorage()),
    );
    _checkUserAccess();
    _loadProjects();
  }

  Future<void> _checkUserAccess() async {
    final prefs = await SharedPreferences.getInstance();
    final isAccess = prefs.getString('is_access') ?? 'user';
    setState(() {
      _isAdmin = isAccess.toLowerCase() == 'admin';
    });
  }

  Future<void> _loadProjects() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final fetchedProjects = await _projectRepository.getProjects();
      setState(() {
        projects = fetchedProjects;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _createProject(Project project) async {
    try {
      final createdProject = await _projectRepository.createProject(project);
      setState(() {
        projects.add(createdProject);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Project created successfully'),
          backgroundColor: Colors.green.shade600,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create project: $e'),
          backgroundColor: Colors.red.shade600,
        ),
      );
    }
  }

  void _showCreateDialog() {
    showDialog(
      context: context,
      builder: (context) => CreateProjectDialog(
        onAdd: _createProject,
      ),
    );
  }

  void _logout() {
    showDialog(
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
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(fontSize: 13, color: Color(0xFF718096)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
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
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(10),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(RouteNames.profile);
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.storage_rounded, color: Color(0xFF667eea), size: 20),
            SizedBox(width: 6),
            Text(
              'Data-Core',
              style: TextStyle(
                color: Color(0xFF2D3748),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _loadProjects,
            icon: const Icon(Icons.refresh, color: Color(0xFF667eea), size: 20),
          ),
          IconButton(
            icon: const Icon(
              Icons.logout_rounded,
              color: Color(0xFFFC8181),
              size: 20,
            ),
            onPressed: _logout,
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: Column(
        children: [
          // Top Action Buttons - Show Create button only for admin
          // if (_isAdmin)
          //   Container(
          //     padding: const EdgeInsets.all(12),
          //     child: Row(
          //       children: [
          //         Expanded(child: Container()),
          //         const SizedBox(width: 10),
          //         Expanded(
          //           child: _buildTopButton(
          //             'Create hello',
          //             Icons.add_circle_outline,
          //             const Color(0xFF48BB78),
          //             _showCreateDialog,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),

          // Loading or Error or Projects GridView
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _error.isNotEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 60,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Error Loading Projects',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF4A5568),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _error,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF718096),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadProjects,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : projects.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEDF2F7),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(
                                    Icons.folder_open_rounded,
                                    size: 60,
                                    color: Color(0xFFA0AEC0),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'No Projects Yet',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF4A5568),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _isAdmin
                                      ? 'Click "Create" to add your first project'
                                      : 'No projects available',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF718096),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 1.20,
                            ),
                            itemCount: projects.length,
                            itemBuilder: (context, index) {
                              return _buildProjectCard(projects[index]);
                            },
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectCard(Project project) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProjectDetailScreen(
                  project: project,
                  onProjectUpdated: (updatedProject) {
                    // Update the project in your list
                    setState(() {
                      // Find and update the project in the list
                      final index = projects.indexOf(project);
                      if (index != -1) {
                        projects[index] = updatedProject;
                      }
                    });
                  },
                  projectRepository: _projectRepository,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Project Name
                Text(
                  project.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D3748),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),

                // Description
                _buildInfoRow(Icons.description, project.description,
                    maxLines: 2),
                const SizedBox(height: 6),

                // Dates
                _buildInfoRow(Icons.calendar_today,
                    '${_formatDate(project.startDate)} - ${_formatDate(project.endDate)}',
                    maxLines: 1),
                const SizedBox(height: 6),

                // Status
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(project.status),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    project.status.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {int maxLines = 1}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFEDF2F7),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Icon(icon, size: 12, color: const Color(0xFF667eea)),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF4A5568),
              fontWeight: FontWeight.w500,
            ),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
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
                const Text(
                  'John Doe',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'john.doe@example.com',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 6),
              children: [
                _buildDrawerItem(Icons.dashboard_rounded, 'Dashboard', true),
                _buildDrawerItem(Icons.folder_rounded, 'Projects', false),
                _buildDrawerItem(Icons.analytics_rounded, 'Reports', false),
                _buildDrawerItem(Icons.people_rounded, 'Team', false),
                const Divider(height: 20, thickness: 1),
                _buildDrawerItem(Icons.settings_rounded, 'Settings', false),
                _buildDrawerItem(Icons.help_rounded, 'Help & Support', false),
                _buildDrawerItem(Icons.info_rounded, 'About', false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, bool selected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xFF667eea).withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        dense: true,
        leading: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF667eea) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            size: 18,
            color: selected ? Colors.white : const Color(0xFF718096),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? const Color(0xFF667eea) : const Color(0xFF4A5568),
          ),
        ),
        onTap: () {},
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in_progress':
        return Colors.orange;
      case 'planning':
        return Colors.blue;
      case 'on_hold':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

// Create Project Dialog
class CreateProjectDialog extends StatefulWidget {
  final Function(Project) onAdd;

  const CreateProjectDialog({Key? key, required this.onAdd}) : super(key: key);

  @override
  State<CreateProjectDialog> createState() => _CreateProjectDialogState();
}

class _CreateProjectDialogState extends State<CreateProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startDate = now;
    _endDate = now.add(const Duration(days: 30));
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );

    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        if (_endDate.isBefore(picked)) {
          _endDate = picked.add(const Duration(days: 30));
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );

    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: const [
          Icon(Icons.add_circle, color: Color(0xFF667eea), size: 22),
          SizedBox(width: 8),
          Text(
            'Create New Project',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ],
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(
                  _nameController, 'Project Name', Icons.folder_rounded),
              const SizedBox(height: 12),
              _buildTextField(
                  _descriptionController, 'Description', Icons.description),
              const SizedBox(height: 12),

              // Start Date
              InkWell(
                onTap: () => _selectStartDate(context),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 18,
                        color: Color(0xFF667eea),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Start Date',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF718096),
                              ),
                            ),
                            Text(
                              _formatDate(_startDate),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_drop_down,
                        color: Color(0xFF667eea),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // End Date
              InkWell(
                onTap: () => _selectEndDate(context),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 18,
                        color: Color(0xFF667eea),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'End Date',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF718096),
                              ),
                            ),
                            Text(
                              _formatDate(_endDate),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_drop_down,
                        color: Color(0xFF667eea),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(fontSize: 13, color: Color(0xFF718096)),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final project = Project(
                id: 0,
                name: _nameController.text.trim(),
                description: _descriptionController.text.trim(),
                createdBy: 0,
                startDate: _startDate,
                endDate: _endDate,
                status: 'planning',
                isActive: true,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );
              widget.onAdd(project);
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF667eea),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          child: const Text(
            'Create',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 12),
        prefixIcon: Icon(icon, size: 18, color: const Color(0xFF667eea)),
        filled: true,
        fillColor: const Color(0xFFF7FAFC),
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
          borderSide: const BorderSide(color: Color(0xFF667eea), width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
      validator: (value) =>
          value?.isEmpty ?? true ? 'This field is required' : null,
    );
  }
}
