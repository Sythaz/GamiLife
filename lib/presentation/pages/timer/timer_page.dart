import 'package:flutter/material.dart';
import 'package:gamilife/presentation/pages/timer/helpers/timer_session.dart';

import '../../../core/constants/colors.dart';
import 'helpers/format_duration.dart';
import 'widgets/timer_controller.dart';
import 'widgets/timer_display.dart';

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
    TimerSession.work(minutes: 25),
    TimerSession.breakSession(minutes: 5),
    TimerSession.work(minutes: 25),
    TimerSession.breakSession(minutes: 5),
    TimerSession.work(minutes: 25),
    TimerSession.breakSession(minutes: 5),
    TimerSession.work(minutes: 25),
    TimerSession.breakSession(minutes: 30, label: 'Long Break!'),
  ];

  // Inilah List sesi untuk bagian custom session yang dibuat sendiri oleh user nanti
  final List<TimerSession> _customSession = [
    // TimerSession.work(minutes: 25)
  ];

  // Variable untuk menentukan mode sekarang
  TimerMode _currentMode = TimerMode.popular;

  int _currentSessionIndexPopular = 0;
  int _currentSessionIndexCustom = 0;

  // Variable untuk timer
  DateTime? _timerEndTime;
  Duration _remainingPopular = Duration.zero;
  Duration _remainingCustom = Duration.zero;
  bool _isRunning = false;

  void _startTimer() {
    setState(() {
      // Kita ambil durasi sesi terakhir
      final durationEndTime = _currentMode == TimerMode.popular
          ? _remainingPopular
          : _customSession.isEmpty
          ? Duration.zero
          : _remainingCustom;

      // Set [_timerEndTime] menjadi durasi sesi terakhir
      _timerEndTime = DateTime.now().add(durationEndTime);

      // Set [_isRunning] menjadi true agar timer berjalan
      _isRunning = true;
    });
  }

  void _pauseTimer() {
    // Jika timer tidak sedang null maka menghentikan timer dengan mengisi [_remaining] dengan waktu yang tersisa
    if (_timerEndTime != null && _isRunning) {
      // Menghitung waktu yang tersisa dari [_timerEndTime]
      final endTimeDiff = _timerEndTime!.difference(DateTime.now());

      setState(() {
        // Mengisi [_remaining] dengan waktu yang tersisa
        if (_currentMode == TimerMode.popular) {
          // Mengecek jika waktu yang tersisa menjadi negatif maka set [_remaining] menjadi 0
          // Dan jika tidak negatif maka set [_remaining] menjadi waktu yang tersisa
          _remainingPopular = endTimeDiff.isNegative
              ? Duration.zero
              : endTimeDiff;
        } else {
          _remainingCustom = endTimeDiff.isNegative
              ? Duration.zero
              : endTimeDiff;
        }
        // Menghentikan timer
        _isRunning = false;
      });
    }
  }

  void _resetTimer() {
    setState(() {
      // Mengisi [_remaining] dengan durasi sesi asli sesuai mode
      if (_currentMode == TimerMode.popular) {
        _remainingPopular =
            _popularSession[_currentSessionIndexPopular].duration;
      } else {
        // Cek jika sesi custom masih kosong maka waktu tersisa adalah 0
        if (_customSession.isEmpty) {
          _remainingCustom = Duration.zero;
        } else {
          // Jika tidak kosong maka ambil waktu sesi asli
          _remainingCustom =
              _customSession[_currentSessionIndexCustom].duration;
        }
      }

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
        // Jika sesi belum sesi terakhir, lanjut ke sesi selanjutnya
        if (_currentSessionIndexPopular < _popularSession.length - 1) {
          _currentSessionIndexPopular++;
        } else {
          // Jika sudah sampai ke sesi terakhir, maka kembali ke sesi pertama
          _currentSessionIndexPopular = 0;
        }
        _remainingPopular =
            _popularSession[_currentSessionIndexPopular].duration;
        _timerEndTime = DateTime.now().add(_remainingPopular);
        // Jika mode custom
      } else if (_currentMode == TimerMode.custom) {
        // Jika custom session masih kosong
        if (_customSession.isEmpty) return;

        if (_currentSessionIndexCustom < _customSession.length - 1) {
          _currentSessionIndexCustom++;
        } else {
          // Jika sudah sampai ke sesi terakhir, maka kembali ke sesi pertama [0]
          _currentSessionIndexCustom = 0;
        }
        _remainingCustom = _customSession[_currentSessionIndexCustom].duration;
        _timerEndTime = DateTime.now().add(_remainingCustom);
      }

      // Menghentikan timer
      _isRunning = false;
    });
  }

  void _changeSession(int newIndex) {
    setState(() {
      // Jika mode popular
      if (_currentMode == TimerMode.popular) {
        _currentSessionIndexPopular = newIndex;
        _remainingPopular =
            _popularSession[_currentSessionIndexPopular].duration;
        _timerEndTime = DateTime.now().add(_remainingPopular);
        // Jika mode custom
      } else if (_currentMode == TimerMode.custom) {
        // Jika custom session masih kosong
        if (_customSession.isEmpty) return;

        _currentSessionIndexCustom = newIndex;
        _remainingCustom = _customSession[_currentSessionIndexCustom].duration;
        _timerEndTime = DateTime.now().add(_remainingCustom);
      }

      // Menghentikan timer
      _isRunning = false;
    });
  }

  @override
  void initState() {
    super.initState();

    if (_currentMode == TimerMode.popular) {
      _remainingPopular = _popularSession[_currentSessionIndexPopular].duration;
    } else if (_customSession.isNotEmpty) {
      _remainingCustom = _customSession[_currentSessionIndexCustom].duration;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        bottom: false,
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

                // Widget untuk menampilkan waktu
                TimerDisplayWidget(
                  isRunning: _isRunning,
                  timerEndTime: _timerEndTime,
                  remaining: _currentMode == TimerMode.popular
                      ? _remainingPopular
                      : _remainingCustom,
                  onTap: () {
                    // TODO: Tambahkan date/hour picker
                  },
                ),

                // Widget untuk menampilkan controller timer (start, pause, reset, next)
                TimerControllerWidget(
                  currentMode: _currentMode,
                  isRunning: _isRunning,
                  startTimer: _startTimer,
                  pauseTimer: _pauseTimer,
                  resetTimer: _resetTimer,
                  nextSession: _nextSession,
                  remainingCustom: _remainingCustom,
                  remainingPopular: _remainingPopular,
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
                              _pauseTimer();
                              setState(() {
                                // Set [_currentMode] menjadi TimerMode.popular
                                _currentMode = TimerMode.popular;
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
                              _pauseTimer();
                              setState(() {
                                // Set [_currentMode] menjadi TimerMode.custom
                                _currentMode = TimerMode.custom;
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
                SizedBox(height: 16),
                _currentMode == TimerMode.custom && _customSession.isEmpty
                    ? AddNewSessionButton()
                    : Expanded(
                        child: ListView.builder(
                          itemCount: _currentMode == TimerMode.popular
                              ? _popularSession.length
                              : _customSession.length,
                          itemBuilder: (context, index) {
                            return _currentMode == TimerMode.custom &&
                                    index == _customSession.length - 1
                                ? AddNewSessionButton()
                                : SessionContainer(
                                    index: index,
                                    changeSession: () => _changeSession(index),
                                    currentMode: _currentMode,
                                    currentSessionIndexPopular:
                                        _currentSessionIndexPopular,
                                    currentSessionIndexCustom:
                                        _currentSessionIndexCustom,
                                    popularSession: _popularSession,
                                    customSession: _customSession,
                                  );
                          },
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

class SessionContainer extends StatelessWidget {
  final int index;
  final VoidCallback changeSession;

  final TimerMode currentMode;

  final int currentSessionIndexPopular;
  final int currentSessionIndexCustom;

  final List<TimerSession> popularSession;
  final List<TimerSession> customSession;

  const SessionContainer({
    super.key,
    required this.index,
    required this.changeSession,
    required this.currentMode,
    required this.currentSessionIndexPopular,
    required this.currentSessionIndexCustom,
    required this.popularSession,
    required this.customSession,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // TODO: Tambahkan fungsi edit session
      // onTap: ,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        height: 70,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Icon session
                  Container(
                    height: double.infinity,
                    width: 50,
                    decoration: BoxDecoration(
                      color: currentMode == TimerMode.popular
                          ? currentSessionIndexPopular == index
                                ? AppColors.primary
                                : AppColors.gray0
                          : currentSessionIndexCustom == index
                          ? AppColors.primary
                          : AppColors.gray0,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      currentMode == TimerMode.popular
                          ? popularSession[index].icon
                          : customSession.isNotEmpty
                          ? customSession[index].icon
                          : Icons.error_outline,
                      size: 32,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Durasi dan label session
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        // Format durasi sesi 00:00 dari function format
                        formatSessionDuration(
                          currentMode == TimerMode.popular
                              ? popularSession[index].duration
                              : customSession[index].duration,
                        ),
                        style: TextStyle(
                          color: AppColors.gray3,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        currentMode == TimerMode.popular
                            ? popularSession[index].label
                            : customSession[index].label,
                        style: TextStyle(
                          color: AppColors.gray3,
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Icon play atau changeSession (restart)
              GestureDetector(
                onTap: changeSession,
                // Background icon
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: currentMode == TimerMode.popular
                        ? currentSessionIndexPopular == index ||
                                  currentSessionIndexPopular == index - 1
                              ? AppColors.primary
                              : AppColors.gray0
                        : currentSessionIndexCustom == index ||
                              currentSessionIndexCustom == index - 1
                        ? AppColors.primary
                        : AppColors.gray0,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  // Icon Button
                  child: currentMode == TimerMode.popular
                      ? currentSessionIndexPopular == index ||
                                currentSessionIndexPopular == index - 1
                            ? Icon(
                                Icons.restart_alt_rounded,
                                color: AppColors.white,
                              )
                            : Icon(
                                Icons.play_arrow_rounded,
                                color: AppColors.white,
                              )
                      : currentSessionIndexCustom == index
                      ? Icon(Icons.restart_alt_rounded, color: AppColors.white)
                      : Icon(Icons.play_arrow_rounded, color: AppColors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddNewSessionButton extends StatelessWidget {
  const AddNewSessionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.only(top: 0),
      onPressed: () {},
      icon: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        child: const Icon(
          Icons.add,
          color: AppColors.primary,
          size: 32,
          // Agar icon lebih besar
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
