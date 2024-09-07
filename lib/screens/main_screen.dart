import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:the_network/screens/universities/universities_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  @override
  void initState() {
    FlutterNativeSplash.remove();
    super.initState();
  }
  final List<Widget> _pages = [
    UniversitiesScreen(),
    // const Center(child: Text('الجامعات',style: TextStyle(color: Colors.black),)),
    const Center(child: Text('المسابقات',style: TextStyle(color: Colors.black),)),
    const Center(child: Text('الملخصات',style: TextStyle(color: Colors.black),)),
    const Center(child: Text('أخرى',style: TextStyle(color: Colors.black),)),
  ];

  String getTitle(int index) {
    switch (index) {
      case 0:
        return 'الجامعات';
      case 1:
        return 'المسابقات';
      case 2:
        return 'الملخصات';
      case 3:
        return 'أخرى';
      default:
        return 'الجامعات';
    }
  }

  // final List<Widget> _otherTabs = [
  //   const Center(child: Text('التصويت')),
  //   const Center(child: Text('الشكاوى')),
  //   const Center(child: Text('الإقتراحات')),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${getTitle(_currentIndex)}'),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined,color: Colors.black,),
            label: 'الجامعات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events_outlined,color: Colors.black),
            label: 'المسابقات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined,color: Colors.black),
            label: 'الملخصات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz,color: Colors.black),
            label: 'أخرى',
          ),
        ],
      ),
    );
  }
}