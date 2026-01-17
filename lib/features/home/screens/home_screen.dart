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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        companyName: 'Data Care',
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
