import 'package:data_care_app/app/routes/route_names.dart';
import 'package:data_care_app/core/network/api_client.dart';
import 'package:data_care_app/core/storage/local_storage.dart';
import 'package:data_care_app/data/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/bottom_tabs.dart';
import '../../bill_distribution/screens/bill_list_screen.dart';
import '../../survey_data/screens/survey_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _showSearch = false;
  final AuthRepository _authRepository =
      AuthRepository(ApiClient(storage: LocalStorage()));

  // Get current screen title based on index
  String get _currentScreenTitle {
    switch (_currentIndex) {
      case 0:
        return 'Bill Distribution';
      case 1:
        return 'Survey Data';
      default:
        return 'Data Care';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        companyName: 'Data Care',
        screenTitle: _currentScreenTitle, // Pass dynamic title
        showSearch: _showSearch,
        onSearchToggle: () {
          setState(() => _showSearch = !_showSearch);
        },
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          BillListScreen(),
          SurveyListScreen(),
        ],
      ),
      bottomNavigationBar: BottomTabs(
        currentIndex: _currentIndex,
        onChanged: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}
