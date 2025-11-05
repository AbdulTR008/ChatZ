import 'package:chatz/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/onboarding_container.dart';
import '../screens/language_scr.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  List<Widget> pages = [
    const LanguagesScreen(),
    const OnBoardingContainer(
      title: "Welcome to Chat Z!",
      desc: "Get started and explore what [Your App Name] has to offer.",
      image:
          'assets/images/hello.jpg', // Assuming "Hello.png" is the correct path
    ),
    const OnBoardingContainer(
      title: "Meet Your Personal Assistant",
      desc:
          "Our friendly AI chatbot is here to guide you and answer your questions.",
      image: 'assets/images/chatbot.jpg',
    ),
    const OnBoardingContainer(
      title: "Connect and Chat",
      desc: "Easily send and receive messages with anyone, all within the app.",
      image: 'assets/images/app.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        color: const Color.fromARGB(255, 174, 243, 110),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                _pageController.jumpToPage(pages.length - 1);
              },
              child: Text('skip'),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SmoothPageIndicator(
                count: pages.length,
                controller: _pageController,
              ),
            ),
            TextButton(
              onPressed: () {
                if (_currentPage <= pages.length - 1) {
                  _pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn);
                }

                if (_currentPage >= pages.length) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AuthScreen(),
                    ),
                  );
                }

                setState(() {});
              },
              child: Text('next'),
            )
          ], 
        ),
      ),
      body: PageView(
        onPageChanged: (value) {
          print(value);
          _currentPage = value;
          _currentPage++;
        },
        controller: _pageController,
        children: pages,
      ),
    );
  }
}
