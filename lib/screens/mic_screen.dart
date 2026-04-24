import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:permission_handler/permission_handler.dart';

class MicScreen extends StatefulWidget {
  final VoidCallback? onStop;
  const MicScreen({super.key, this.onStop});

  @override
  State<MicScreen> createState() => _MicScreenState();
}

class _MicScreenState extends State<MicScreen> {
  late stt.SpeechToText _speech;
  late FlutterTts _tts;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _tts = FlutterTts();
    _initTts();
  }

  void _initTts() async {
    await _tts.setLanguage("en-US");
    await _tts.setPitch(1.0);
    await _tts.setSpeechRate(0.5);
  }

  Future<void> _speak(String text) async {
    await _tts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.grey[700];

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF121212) : null,
          gradient: isDark
              ? null
              : const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFE0F7FA),
                    Color(0xFFB2EBF2),
                    Color(0xFF80DEEA),
                  ],
                ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    if (widget.onStop != null)
                      IconButton(
                        icon: Icon(Icons.close, color: textColor),
                        onPressed: widget.onStop,
                      ),
                    const Spacer(),
                    Text(
                      'AIVA Voice Assistant',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const Spacer(),
                    if (widget.onStop != null) const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  reverse: true,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
                    child: Column(
                      children: [
                        Text(
                          'Confidence: ${(_confidence * 100).toStringAsFixed(1)}%',
                          style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              )
                            ],
                          ),
                          child: Text(
                            _text,
                            style: TextStyle(
                              fontSize: 22.0,
                              color: textColor,
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: AvatarGlow(
                  animate: _isListening,
                  glowColor: const Color(0xFF00ACC1),
                  duration: const Duration(milliseconds: 2000),
                  repeat: true,
                  child: FloatingActionButton(
                    onPressed: _listen,
                    backgroundColor: const Color(0xFF00ACC1),
                    child: Icon(_isListening ? Icons.mic : Icons.mic_none, size: 30, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      var status = await Permission.microphone.status;
      if (status.isDenied) {
        status = await Permission.microphone.request();
        if (!status.isGranted) {
          setState(() => _text = "Microphone permission denied.");
          return;
        }
      }

      setState(() => _text = "Initializing...");

      bool available = await _speech.initialize(
        onStatus: (val) {
          if (val == 'done' || val == 'notListening') {
            setState(() => _isListening = false);
          }
        },
        onError: (val) {
          setState(() {
            _isListening = false;
            if (val.errorMsg == 'error_speech_timeout') {
              _text = "I didn't hear anything. Please try again!";
            } else if (val.errorMsg == 'error_network') {
              _text = "Network error. Please check your internet.";
            } else {
              _text = "Error: ${val.errorMsg}";
            }
          });
        },
      );

      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
            if (val.finalResult) {
              _isListening = false;
              _handleCommand(_text.toLowerCase());
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _handleCommand(String command) {
    if (command.isEmpty) return;
    
    if (command.contains('hello') || command.contains('hi')) {
      _speak("Hello! I am AIVA, your engineering assistant.");
    } else if (command.contains('calculator')) {
      Navigator.pushNamed(context, '/calculator');
    } else if (command.contains('planner')) {
      Navigator.pushNamed(context, '/planner');
    } else if (command.contains('scan')) {
      Navigator.pushNamed(context, '/ocr');
    } else {
      _speak("I heard you say: $command");
    }
  }
}
