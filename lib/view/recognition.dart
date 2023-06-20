import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:translator/translator.dart';

class RecognitionScreen extends StatefulWidget {
  const RecognitionScreen({super.key});

  @override
  State<RecognitionScreen> createState() => _RecognitionScreenState();
}

class _RecognitionScreenState extends State<RecognitionScreen> {
  bool isScanning = false;
  XFile? imageFile;
  String scannedText = '';
  String translatedText = '';
  final translator = GoogleTranslator();

  void translate(String text) async {
    Translation output = await translator.translate(text, to: 'ko');
    setState(() {
      translatedText = output.text;
    });
  }

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        setState(() {
          isScanning = true;
          imageFile = pickedImage;
        });
        getText(pickedImage);
      }
    } catch (e) {
      setState(() {
        isScanning = false;
        imageFile = null;
        scannedText = 'Error occured while scanning';
      });
    }
  }

  // Improved version of Function for Text Recognition
  void getText(XFile image) async {
    final selectedImage = InputImage.fromFilePath(image.path);
    final textDetector = TextRecognizer();
    RecognizedText recognizedText =
        await textDetector.processImage(selectedImage);
    await textDetector.close();
    scannedText = '';
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = '$scannedText${line.text}';
      }
      scannedText = '$scannedText\n';
    }
    setState(() {
      isScanning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      reverse: true,
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isScanning) const CircularProgressIndicator(),
            if (!isScanning && imageFile == null)
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  border: Border.all(
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(
                    16,
                  ),
                ),
              ),
            if (imageFile != null)
              Container(
                height: 500,
                width: 500,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  border: Border.all(
                    width: 2,
                  ),
                ),
                child: Image.file(
                  File(imageFile!.path),
                  fit: BoxFit.fill,
                ),
              ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // pick image button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                  ),
                  onPressed: () {
                    getImage(ImageSource.gallery);
                    translatedText = '';
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.image,
                        ),
                        Text(
                          "Gallery",
                        )
                      ],
                    ),
                  ),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                  ),
                  onPressed: () {
                    getImage(ImageSource.camera);
                    translatedText = '';
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.camera_alt,
                        ),
                        Text(
                          "Camera",
                        )
                      ],
                    ),
                  ),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                  ),
                  onPressed: () {
                    setState(() {
                      isScanning = false;
                      imageFile = null;
                      scannedText = '';
                      translatedText = '';
                    });
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.refresh_outlined,
                        ),
                        Text(
                          "Reset",
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            if (imageFile == null)
              const Text(
                'Choose or take a picture of text you want',
              ),
            const SizedBox(height: 20),
            if (imageFile != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  renderCard('인식된 텍스트', scannedText),
                ],
              ),
            if (scannedText != '')
              ElevatedButton(
                onPressed: () => translate(scannedText),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '번역하기',
                  ),
                ),
              ),
            if (scannedText != '' && translatedText != '')
              renderCard('번역결과', translatedText),
          ],
        ),
      ),
    );
  }

  Widget renderCard(String title, String text) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
          ),
          Container(
            margin: const EdgeInsets.all(9),
            padding: const EdgeInsets.all(6),
            color: Colors.white,
            child: Text(
              text,
              maxLines: null,
            ),
          ),
        ],
      ),
    );
  }
}
