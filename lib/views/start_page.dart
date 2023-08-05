import 'package:flutter/material.dart';

import 'package:google_nav_bar/google_nav_bar.dart';

import 'package:colour/views/daily_challenge_page.dart';
import 'package:colour/views/practice_modes_page.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 350),
          curve: Curves.fastLinearToSlowEaseIn);
    });
  }

  final List<Widget> _pages = <Widget>[
    const DailyChallengePage(),
    const PracticePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 16),
          child: GNav(
            tabBackgroundColor:
                Theme.of(context).colorScheme.secondaryContainer,
            gap: 8,
            onTabChange: _navigateBottomBar,
            padding: const EdgeInsets.all(8),
            tabs: [
              GButton(
                iconColor: Theme.of(context).colorScheme.onPrimaryContainer,
                iconActiveColor:
                    Theme.of(context).colorScheme.onPrimaryContainer,
                textColor: Theme.of(context).colorScheme.onPrimaryContainer,
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.lightbulb_circle,
                text: 'Practice',
                iconColor: Theme.of(context).colorScheme.onPrimaryContainer,
                iconActiveColor:
                    Theme.of(context).colorScheme.onPrimaryContainer,
                textColor: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ],
            selectedIndex: _selectedIndex,
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
