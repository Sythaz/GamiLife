import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';

import '../../../core/constants/colors.dart';

// Karena kita memiliki 2 mode, sehingga kita deklarasikan enum dahulu
enum TimerMode { popular, custom }

// Class untuk helper / model agar dapat menyimpan informasi sesi timer lebih mudah
class TimerSession {
  final Duration duration;
  final String label;
  final bool isWork;

  TimerSession({
    required this.duration,
    required this.label,
    required this.isWork,
  });

  static TimerSession work(int minutes, {String label = 'Stay productive!'}) {
    return TimerSession(
      duration: Duration(minutes: minutes),
      label: label,
      isWork: true,
    );
  }

  static TimerSession breakSession(
    int minutes, {
    String label = 'Short Break!',
  }) {
    return TimerSession(
      duration: Duration(minutes: minutes),
      label: label,
      isWork: false,
    );
  }
}

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  // Inilah List sesi untuk bagian popular session
  final List<TimerSession> _popularSession = [
    // Begini cara penulisan jika tanpa class helper / model
    // TimerSession(duration: Duration(minutes: 25), label: 'Stay productive!', isWork: true),
    TimerSession.work(25),
    TimerSession.breakSession(5),
    TimerSession.work(25),
    TimerSession.breakSession(5),
    TimerSession.work(25),
    TimerSession.breakSession(5),
    TimerSession.work(25),
    TimerSession.breakSession(30, label: 'Long Break!'),
  ];

  // Inilah List sesi untuk bagian custom session yang dibuat sendiri oleh user nanti
  List<TimerSession> _customSession = [];

  // Variable untuk menentukan mode sekarang
  TimerMode _currentMode = TimerMode.popular;

  int _currentSessionIndexPopular = 0;
  int _currentSessionIndexCustom = 0;

  // Variable untuk timer
  DateTime? _timerEndTime;
  Duration _remaining = Duration.zero;
  bool _isRunning = false;

  void _startTimer() {
    setState(() {
      // Set [_remaining] berdasarkan waktu yang ditentukan oleh user
      _timerEndTime = _currentMode == TimerMode.popular
          ? DateTime.now().add(
              _popularSession[_currentSessionIndexPopular].duration,
            )
          : DateTime.now().add(
              _customSession[_currentSessionIndexCustom].duration,
            );
      // Set [_isRunning] menjadi true agar timer berjalan
      _isRunning = true;
    });
  }

  void _pauseTimer() {
    // Jika timer tidak sedang null maka menghentikan timer dengan mengisi [_remaining] dengan waktu yang tersisa
    if (_timerEndTime != null) {
      setState(() {
        // Mengisi [_remaining] dengan waktu yang tersisa
        _remaining = _timerEndTime!.difference(DateTime.now());
        // Menghentikan timer
        _isRunning = false;
      });
    }
  }

  void _resetTimer() {
    setState(() {
      // Mengisi [_remaining] dengan waktu yang awal
      _remaining = _currentMode == TimerMode.popular
          ? _popularSession[_currentSessionIndexPopular].duration
          : _customSession[_currentSessionIndexCustom].duration;

      // Menghapus waktu agar bisa dikembalikan ke waktu awal pada saat startTimer
      _timerEndTime = null;
      // Menghentikan timer
      _isRunning = false;
    });
  }

  void _nextSession() {
    setState(() {
      // Jika mode popular
      if (_currentMode == TimerMode.popular) {
        // Hanya untuk sesi sebelum terakhir
        if (_currentSessionIndexPopular < _popularSession.length - 1) {
          _currentSessionIndexPopular++;
          _remaining = _popularSession[_currentSessionIndexPopular].duration;
          _timerEndTime = DateTime.now().add(_remaining);
        } else {
          // Jika sudah sampai ke sesi terakhir, maka kembali ke sesi pertama
          _currentSessionIndexPopular = 0;
          _remaining = _popularSession[_currentSessionIndexPopular].duration;
          _timerEndTime = DateTime.now().add(_remaining);
        }
        // Jika mode custom
      } else if (_currentMode == TimerMode.custom) {
        if (_currentSessionIndexCustom < _customSession.length - 1) {
          _currentSessionIndexCustom++;
          _remaining = _customSession[_currentSessionIndexCustom].duration;
          _timerEndTime = DateTime.now().add(_remaining);
        } else {
          _currentSessionIndexCustom = 0;
          _remaining = _customSession[_currentSessionIndexCustom].duration;
          _timerEndTime = DateTime.now().add(_remaining);
        }
      }

      print('currentSessionIndexPopular: $_currentSessionIndexPopular');
      print('currentSessionIndexCustom: $_currentSessionIndexCustom');
      print('remaining: $_remaining');
    });
  }

  @override
  void initState() {
    _remaining = _currentMode == TimerMode.popular
        ? _popularSession[_currentSessionIndexPopular].duration
        : _customSession[_currentSessionIndexCustom].duration;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        // bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Center(
            child: Column(
              children: [
                Text(
                  'Timer Page',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    //
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _isRunning && _timerEndTime != null
                        ? TimerCountdown(
                            format: CountDownTimerFormat.hoursMinutesSeconds,
                            enableDescriptions: false,
                            spacerWidth: 0,
                            colonsTextStyle: TextStyle(
                              fontSize: 64,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                            timeTextStyle: TextStyle(
                              fontSize: 64,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                            endTime: _timerEndTime!,
                            onEnd: () {
                              print("Timer finished");
                            },
                          )
                        : Text(
                            // Saat pause, tampilkan sisa waktu manual
                            "${_remaining.inHours.remainder(60).toString().padLeft(2, '0')}:"
                            "${_remaining.inMinutes.remainder(60).toString().padLeft(2, '0')}:"
                            "${_remaining.inSeconds.remainder(60).toString().padLeft(2, '0')}",
                            style: TextStyle(
                              fontSize: 64,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: IconButton(
                        onPressed: () {
                          _resetTimer();
                        },
                        icon: const Icon(
                          Icons.restart_alt_rounded,
                          size: 32,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: IconButton(
                        onPressed: () {
                          _isRunning ? _pauseTimer() : _startTimer();
                        },
                        icon: _isRunning
                            ? const Icon(
                                Icons.pause_rounded,
                                size: 62,
                                color: AppColors.white,
                              )
                            : const Icon(
                                Icons.play_arrow_rounded,
                                size: 62,
                                color: AppColors.white,
                              ),
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: IconButton(
                        onPressed: () {
                          _nextSession();
                        },
                        icon: const Icon(
                          Icons.skip_next_rounded,
                          size: 32,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.gray0,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 3,
                      vertical: 3,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                //
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: _currentMode == TimerMode.popular
                                    ? AppColors.white
                                    : AppColors.gray0,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  'Popular',
                                  style: TextStyle(
                                    color: _currentMode == TimerMode.popular
                                        ? AppColors.primary
                                        : AppColors.gray2,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                // Set [_currentMode] menjadi TimerMode.custom
                                // _currentMode = TimerMode.custom;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: _currentMode == TimerMode.custom
                                    ? AppColors.white
                                    : AppColors.gray0,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  'Custom',
                                  style: TextStyle(
                                    color: _currentMode == TimerMode.custom
                                        ? AppColors.primary
                                        : AppColors.gray2,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
