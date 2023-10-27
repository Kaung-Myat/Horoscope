import 'package:flutter/material.dart';
import 'package:zodiac/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _colorAnimation =
        ColorTween(begin: Colors.black, end: Colors.white).animate(_controller);
    _opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _controller.forward().whenComplete(() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/splash-img.jpg"),
                    fit: BoxFit.cover)),
          ),
          Positioned(
            top: 70,
            left: 17,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: const BoxDecoration(color: Colors.transparent),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _opacityAnimation.value,
                    child: Text(
                      "The only function of economic forecasting is to make astrology look respectable...",
                      style: TextStyle(
                          color: _colorAnimation.value,
                          fontSize: 23,
                          fontWeight: FontWeight.w700),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
