import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:knue_smart_content/common/const/text.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator/translator.dart';

class ReadingScreen extends StatefulWidget {
  const ReadingScreen({super.key});

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  List<String> userSpeech = List.generate(targetConv.length, (index) => '');
  List<String> translatedText =
      List.generate(readingText.length, (index) => '');

  String selectedLocaleId = 'en-US';
  bool isSpeaking = false;
  double speechRate = 0.5;

  // Text to Speech
  final tts = FlutterTts();
  // Speech to Text
  final stt = SpeechToText();
  // Translator
  final translator = GoogleTranslator();

  Map<String, String> locales = {
    'en-US': 'US',
    'en-GB': 'UK',
    'en-CA': 'CA',
    'en-NZ': 'NZ'
  };

  // for initializing stt & tts
  void initSpeech() async {
    // stt
    await stt.initialize();
    // tts
    await tts.getDefaultEngine;
    await tts.getDefaultVoice;
    await tts.getLanguages;
    tts.setCompletionHandler(() {
      setState(() => isSpeaking = false);
    });
  }

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Slider(
                    min: 0.0,
                    max: 1.0,
                    divisions: 10,
                    value: speechRate,
                    onChanged: (value) {
                      stopSpeaking();
                      setState(() => speechRate = value);
                    },
                  ),
                ),
                const SizedBox(width: 6),
                DropdownButton<String>(
                  value: selectedLocaleId,
                  items: locales.entries
                      .map((locale) => DropdownMenuItem<String>(
                            value: locale.key,
                            child: Text(
                              locale.value,
                            ),
                          ))
                      .toList(),
                  onChanged: ((value) {
                    setState(() => selectedLocaleId = value!);
                  }),
                ),
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: readingText.length,
            itemBuilder: (context, index) =>
                dialogCard(readingText[index], index),
          ))
        ],
      ),
    );
  }

  Widget dialogCard(String text, int index) {
    return Card(
      key: Key(index.toString()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () {
              if (!isSpeaking) {
                startSpeaking(text);
              } else {
                stopSpeaking();
              }
            },
            child: Container(
              margin: const EdgeInsets.all(9),
              padding: const EdgeInsets.all(6),
              child: Row(
                children: [
                  Icon(
                    isSpeaking
                        ? Icons.stop_circle_outlined
                        : Icons.play_circle_outline,
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      text,
                      maxLines: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // GestureDetector(
          //   onTap: () {
          //     stt.isListening ? stopListening() : startListening(index);
          //   },
          //   child: Container(
          //     margin: const EdgeInsets.all(9),
          //     padding: const EdgeInsets.all(6),
          //     decoration: const BoxDecoration(
          //       color: Colors.white,
          //     ),
          //     child: Row(
          //       children: [
          //         Expanded(child: Text(userSpeech[index])),
          //         AvatarGlow(
          //           animate: stt.isListening,
          //           endRadius: 12,
          //           glowColor: pastelOrange,
          //           child: Icon(
          //             Icons.mic,
          //             color: (stt.isListening) ? pastelOrange : pastelBlack,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          TextButton(
              onPressed: () => translate(index, text),
              child: const Text('번역하기')),
          if (text != '')
            Container(
              margin: const EdgeInsets.all(9),
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Text(
                translatedText[index],
                maxLines: null,
              ),
            )
        ],
      ),
    );
  }

  void startSpeaking(String text) async {
    await tts.setLanguage(selectedLocaleId);
    await tts.setSpeechRate(speechRate);
    int isOn = await tts.speak(text);
    if (isOn == 1) {
      setState(() => isSpeaking = true);
    } else {
      setState(() => isSpeaking = false);
    }
  }

  void stopSpeaking() async {
    await tts.stop();
    setState(() => isSpeaking = false);
  }

  // Function for Speech to Text
  void startListening(int index) async {
    setState(() => userSpeech[index] = '');

    await stt.listen(
        listenMode: ListenMode.dictation,
        localeId: 'en-US',
        onResult: (result) {
          setState(() {
            userSpeech[index] = result.recognizedWords;
            if (result.hasConfidenceRating && result.confidence > 0) {}
          });
        });
    setState(() {});
  }

  void stopListening() async {
    await stt.stop();
    setState(() {});
  }

// Fuction for Trnaslation
  Future<void> translate(int index, String text) async {
    Translation output = await translator.translate(text, to: 'ko');
    setState(() => translatedText[index] = output.text);
  }
}
