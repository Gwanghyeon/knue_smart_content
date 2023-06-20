import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:knue_smart_content/common/const/color_schemes.g.dart';
import 'package:knue_smart_content/view/reading_text.dart';
import 'package:knue_smart_content/view/recognition.dart';
import 'package:knue_smart_content/view/dialog.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIdx = 0;

  tabs() => [
        const DialogScreen(),
        const ReadingScreen(),
        const RecognitionScreen(),
      ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
                        onPressed: () => Navigator.pop(context),
                        child: const Text('취소')),
                  ],
                ));
        return result;
      },
      child: Scaffold(
        backgroundColor: pastelBeige,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: pastelBeige,
          surfaceTintColor: pastelBeige,
          title: Text(
            'English Ⅱ',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        body: SafeArea(
          child: Stack(children: [
            // Container(
            //   decoration: const BoxDecoration(
            //     image: DecorationImage(
            //         image: AssetImage('asset/images/background_house.jpg'),
            //         fit: BoxFit.fill),
            //   ),
            // ),
            tabs()[currentIdx]
          ]),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: pastelGray,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: pastelBlack,
          showUnselectedLabels: true,
          currentIndex: currentIdx,
          onTap: (idx) {
            setState(() => currentIdx = idx);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.article),
              label: 'Dialog',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.text_fields),
              label: 'Reading',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera),
              label: 'TextRecognition',
            ),
          ],
        ),
      ),
    );
  }
}
