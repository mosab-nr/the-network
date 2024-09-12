import 'package:flutter/material.dart';
import 'package:the_network/screens/others/suggestions/suggestions_screen.dart';
import 'package:the_network/screens/others/voting/voting_screen.dart';

import 'complaints/complaints_screen.dart';

class OtherScreen extends StatefulWidget {
  const OtherScreen({super.key});

  @override
  State<OtherScreen> createState() => _OtherScreenState();
}

class _OtherScreenState extends State<OtherScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'التصويت'),
            Tab(text: 'الشكاوى'),
            Tab(text: 'الإقتراحات'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children:  const [
              VotingScreen(),
              ComplaintsScreen(),
              SuggestionsScreen(),
            ],
          ),
        ),
      ],
    );
  }
}
