import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    Center(child: Text('الجامعات')),
    Center(child: Text('المسابقات')),
    Center(child: Text('الملخصات')),
    Center(child: Text('أخرى')),
  ];

  final List<Widget> _otherTabs = [
    Center(child: Text('التصويت')),
    Center(child: Text('الشكاوى')),
    Center(child: Text('الإقتراحات')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIndex == 3
          ? DefaultTabController(
              length: 3,
              child: Scaffold(
                appBar: AppBar(
                  bottom: const TabBar(
                    tabs: [
                      Tab(text: 'التصويت'),
                      Tab(text: 'الشكاوى'),
                      Tab(text: 'الإقتراحات'),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: _otherTabs,
                ),
              ),
            )
          : _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            label: 'الجامعات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events_outlined),
            label: 'المسابقات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            label: 'الملخصات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'أخرى',
          ),
        ],
      ),
    );
  }
}