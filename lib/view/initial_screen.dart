import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:knue_smart_content/common/const/color_schemes.g.dart';
import 'package:knue_smart_content/view/main_screen.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  // 애니메이션 초기화 작업
  void _initializeAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 1,
      ),
    );

    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pastelBeige,
      body: WillPopScope(
        onWillPop: () async {
          final result = await showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    content: const Text('앱을 종료합니다'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            SystemNavigator.pop();
                          },
                          child: const Text('확인')),
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('취소')),
                    ],
                  ));
          return result;
        },
        child: Stack(
          children: [
            // 배경 이미지
            // Container(
            //   decoration: const BoxDecoration(
            //     image: DecorationImage(
            //         image: AssetImage('asset/images/background_sky_trees.jpg'),
            //         fit: BoxFit.fill),
            //   ),
            // ),
            // 학생 이미지
            Positioned(
              bottom: 0,
              right: 15,
              left: 15,
              child: Image.asset(
                'asset/images/initial_screen.png',
                height: 186,
              ),
            ),
            // title
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 제목
                Text(
                  'English Ⅱ',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                const Text(
                  'Lesson 3. The Joy of Language',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 90),
                // 로딩 문구
                Text(
                  'by 조광현',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                // 페이지 이동 버튼
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 60,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const MainScreen(),
                      ));
                    },
                    child: AnimatedBuilder(
                        animation: _animation,
                        builder: (context, _) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Opacity(
                              opacity: _animation.value,
                              child: Text(
                                'START!',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: pastelBlack,
                                    ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
                const SizedBox(height: 42),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
