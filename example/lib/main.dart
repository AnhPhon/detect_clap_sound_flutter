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

  /// Define [_isGrantedPermission] to get permission status.
  bool _isGrantedPermission = false;

  /// Define [_isRecording] to set status recording.
  bool _isRecording = false;

  /// Define [_clapSubscription] to set subscription and listening.
  StreamSubscription<int>? _clapSubscription;

  @override
  void initState() {
    super.initState();

    _getStatusRecordPermission();

    _listenDetectSound();
  }

  @override
  void dispose() {
    _clapSubscription?.cancel();
    super.dispose();
  }

  /// [_listenDetectSound] to listen recording and detect sound.
  void _listenDetectSound() {
    _clapSubscription = _detectClapSoundFlutterPlugin.onListenDetectSound().listen(
      (int times) {
        log('TechMind is listening detected sound $times');
      },
    );
  }

  /// [_getStatusRecordPermission] to get status record permission.
  Future<void> _getStatusRecordPermission() async {
    final status = await _detectClapSoundFlutterPlugin.getStatusPermission();

    _isGrantedPermission = status ?? false;
    setState(() {});
  }

  /// [_requestPermissions] to request record permissions.
  Future<void> _requestPermissions() async {
    await _detectClapSoundFlutterPlugin.requestPermission();
  }

  /// [_startRecording] to stat recording.
  Future<void> _startRecording() async {
    await _detectClapSoundFlutterPlugin.startRecording();

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
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'Record permission is granted: $_isGrantedPermission',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ExampleButton(
                onTap: () {
                  _requestPermissions();
                },
                label: 'Check status permission',
              ),
              ExampleButton(
                onTap: () {
                  _requestPermissions();
                },
                label: 'Request permission',
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
                label: 'Start recording',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
