import 'dart:developer';

import 'package:detect_clap_sound_flutter/detect_clap_sound_flutter.dart';
import 'package:detect_clap_sound_flutter_example/widget/example_button.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// Define [_detectClapSoundFlutterPlugin] to use plugin.
  final DetectClapSoundFlutter _detectClapSoundFlutterPlugin = DetectClapSoundFlutter();

  /// Define [_hasPermission] to get permission status.
  bool _hasPermission = false;

  /// Define [_isRecording] to set status recording.
  bool _isRecording = false;

  /// Define [_clapSubscription] to set subscription and listening.
  StreamSubscription<int>? _clapSubscription;

  /// Define [_clapTimes] to count clap times.
  int _clapTimes = 0;

  @override
  void initState() {
    super.initState();

    _getStatusRecordPermission();

    _listenDetectSound();
  }

  @override
  void dispose() {
    _clapSubscription?.cancel();
    _detectClapSoundFlutterPlugin.dispose();
    super.dispose();
  }

  /// [_listenDetectSound] to listen recording and detect sound.
  void _listenDetectSound() {
    _clapSubscription = _detectClapSoundFlutterPlugin.onListenDetectSound().listen(
      (int times) {
        log('TechMind is listening detected sound $times');

        _clapTimes = _clapTimes + times;

        setState(() {});
      },
    );
  }

  /// [_getStatusRecordPermission] to get status record permission.
  Future<void> _getStatusRecordPermission() async {
    _hasPermission = await _detectClapSoundFlutterPlugin.hasPermission() ?? false;

    _isRecording = await _detectClapSoundFlutterPlugin.isRecording() ?? false;

    setState(() {});
  }

  /// [_requestPermissions] to request record permissions.
  Future<void> _requestPermissions() async {
    final status = await _detectClapSoundFlutterPlugin.requestPermission();

    _hasPermission = status ?? false;
    setState(() {});
  }

  /// [_startRecording] to stat recording.
  void _startRecording() {
    _detectClapSoundFlutterPlugin.startRecording();

    _isRecording = true;
    setState(() {});
  }

  /// [_stopRecording] to stop recording.
  Future<void> _stopRecording() async {
    final String? path = await _detectClapSoundFlutterPlugin.stopRecording();

    log('TechMind: Audio file path: $path');

    _isRecording = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: _checkEvenTimes() ? Colors.white : Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          centerTitle: true,
          title: const Text(
            'Detect Clap Sound',
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.width * .3),
                child: Text(
                  'Times: $_clapTimes',
                  style: TextStyle(
                    fontSize: 30,
                    color: _checkEvenTimes() ? Colors.black : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              ExampleButton(
                colorBG: !_hasPermission ? Colors.red : Colors.blue,
                onTap: () {
                  _requestPermissions();
                },
                label: 'Record permission is granted: $_hasPermission',
              ),
              ExampleButton(
                colorBG: _isRecording ? Colors.red : Colors.blue,
                onTap: () {
                  if (_isRecording) {
                    _stopRecording();
                  } else {
                    _startRecording();
                  }
                },
                label: _isRecording ? 'Stop recording' : 'Start recording',
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// [_checkEvenTimes] to check times even or not.
  /// If even then show turn on light or turn off light.
  bool _checkEvenTimes() {
    return _clapTimes % 2 == 0;
  }
}
