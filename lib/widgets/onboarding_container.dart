import 'package:flutter/material.dart';

class OnBoardingContainer extends StatelessWidget {
  const OnBoardingContainer(
      {required this.desc,
      required this.title,
      required this.image,
      super.key});

  final String title, desc, image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height * .80,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset(image),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24.0, // size of the title text
                fontWeight: FontWeight.bold, // make the title text bold
                color: Colors.black, // color of the title text
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                  text: desc,
                  style: const TextStyle(
                    fontSize: 16.0, // size of the title text
                    // make the title text bold
                    color: Colors.red, // color of the title text
                  ),
                  children: const [
                    TextSpan(
                      text: ' Swipe to learn more',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
