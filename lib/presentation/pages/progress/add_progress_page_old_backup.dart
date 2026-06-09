// // ignore_for_file: use_build_context_synchronously

// import 'package:flutter/material.dart';
// import 'package:gamilife/core/config/category_button_config.dart';
// import 'package:gamilife/core/enums/enums_button_category.dart';
// import 'package:gamilife/presentation/pages/progress/add_todo_section.dart';
// import 'package:gamilife/presentation/widgets/custom_category_button.dart';
// import 'package:go_router/go_router.dart';

// import '../../../core/constants/colors.dart';
// import '../../../data/models/progress_model.dart';
// import '../../../data/services/isar_service.dart';
// import '../../widgets/container_category_button.dart';
// import 'add_activity_section.dart';
// import 'add_summary_section.dart';

// class AddProgressPage extends StatefulWidget {
//   const AddProgressPage({super.key});

//   @override
//   State<AddProgressPage> createState() => _AddProgressPageState();
// }

// class _AddProgressPageState extends State<AddProgressPage> {
//   AddProgressActivityCategory _currentCategory =
//       AddProgressActivityCategory.activity;

//   final _activityCategoryController = TextEditingController();
//   final _summaryCategoryController = TextEditingController();
//   final _todoCategoryController = TextEditingController();

//   final _activityLinkController = TextEditingController();
//   final _summaryLinkController = TextEditingController();
//   final _todoLinkController = TextEditingController();

//   DateTime? selectedDateActivity;
//   TimeOfDay? selectedTimeActivity;

//   DateTime? selectedDateSummary;
//   TimeOfDay? selectedTimeSummary;

//   bool isSummaryWeekly = false;

//   DateTime? selectedDateTodo;
//   TimeOfDay? selectedTimeTodo;

//   final _isarService = IsarService();
//   bool _isSaving = false;

//   TextEditingController get _getCurrentCategoryController {
//     switch (_currentCategory) {
//       case AddProgressActivityCategory.activity:
//         return _activityCategoryController;
//       case AddProgressActivityCategory.summary:
//         return _summaryCategoryController;
//       case AddProgressActivityCategory.todo:
//         return _todoCategoryController;
//     }
//   }

//   TextEditingController get _getCurrentLinkController {
//     switch (_currentCategory) {
//       case AddProgressActivityCategory.activity:
//         return _activityLinkController;
//       case AddProgressActivityCategory.summary:
//         return _summaryLinkController;
//       case AddProgressActivityCategory.todo:
//         return _todoLinkController;
//     }
//   }

//   DateTime? get _selectedDate {
//     switch (_currentCategory) {
//       case AddProgressActivityCategory.activity:
//         return selectedDateActivity;
//       case AddProgressActivityCategory.summary:
//         return selectedDateSummary = DateTime.now();
//       case AddProgressActivityCategory.todo:
//         return selectedDateTodo;
//     }
//   }

//   TimeOfDay? get _selectedTime {
//     switch (_currentCategory) {
//       case AddProgressActivityCategory.activity:
//         return selectedTimeActivity;
//       case AddProgressActivityCategory.summary:
//         return selectedTimeSummary = TimeOfDay.now();
//       case AddProgressActivityCategory.todo:
//         return selectedTimeTodo;
//     }
//   }

//   List<String> selectedSkills = [];
//   Map<String, int> selectedSkillsPoint = {};

//   final isWeekend =
//       DateTime.now().weekday == DateTime.saturday ||
//       DateTime.now().weekday == DateTime.sunday;

//   bool _isNotificationEnabled = false;

//   @override
//   void dispose() {
//     _activityCategoryController.dispose();
//     _summaryCategoryController.dispose();
//     _todoCategoryController.dispose();
//     _activityLinkController.dispose();
//     _summaryLinkController.dispose();
//     _todoLinkController.dispose();
//     super.dispose();
//   }

//   Future<void> _saveProgress() async {
//     // Validasi deskripsi untuk semua kategori
//     if (_getCurrentCategoryController.text.trim().isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please fill in the description')),
//       );
//       return;
//     }

//     // Validasi link jika diisi
//     final linkText = _getCurrentLinkController.text.trim();
//     if (linkText.isNotEmpty) {
//       final isValidUrl = Uri.tryParse(linkText)?.hasScheme ?? false;
//       final hasHttpScheme =
//           linkText.startsWith('http://') || linkText.startsWith('https://');

//       if (!isValidUrl || !hasHttpScheme) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text(
//               'Please enter a valid URL (must start with http:// or https://)',
//             ),
//             backgroundColor: Colors.orange,
//           ),
//         );
//         return;
//       }
//     }

//     if (_currentCategory == AddProgressActivityCategory.summary) {
//       // Validasi untuk summary
//       if (isSummaryWeekly) {
//         // Cek apakah minggu ini (Senin-Minggu) sudah ada weekly summary
//         final now = DateTime.now();
//         final weekday = now.weekday; // 1 (Monday) - 7 (Sunday)

//         // Hitung Senin minggu ini
//         final monday = now.subtract(Duration(days: weekday - 1));
//         final startOfWeek = DateTime(monday.year, monday.month, monday.day);

//         // Hitung Minggu minggu ini
//         final sunday = monday.add(Duration(days: 6));
//         final endOfWeek = DateTime(
//           sunday.year,
//           sunday.month,
//           sunday.day,
//           23,
//           59,
//           59,
//         );

//         // Ambil semua summary di minggu ini
//         final allProgress = await _isarService.getAllProgress();
//         final weeklySummaryExists = allProgress.any((progress) {
//           if (progress.type != ProgressType.summary) return false;
//           if (progress.isSummaryWeekly != true) return false;
//           if (progress.date == null) return false;

//           return progress.date!.isAfter(
//                 startOfWeek.subtract(Duration(seconds: 1)),
//               ) &&
//               progress.date!.isBefore(endOfWeek.add(Duration(seconds: 1)));
//         });

//         if (weeklySummaryExists) {
//           isSummaryWeekly = false;
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text(
//                 'You have already saved a weekly summary this week!',
//               ),
//               backgroundColor: AppColors.yellowAccent,
//             ),
//           );
//           return;
//         }
//       } else {
//         // Cek apakah hari ini sudah ada daily summary
//         final now = DateTime.now();
//         final today = DateTime(now.year, now.month, now.day);
//         final endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59);

//         final allProgress = await _isarService.getAllProgress();
//         final dailySummaryExists = allProgress.any((progress) {
//           if (progress.type != ProgressType.summary) return false;
//           if (progress.isSummaryWeekly == true) return false;
//           if (progress.date == null) return false;

//           return progress.date!.isAfter(today.subtract(Duration(seconds: 1))) &&
//               progress.date!.isBefore(endOfToday.add(Duration(seconds: 1)));
//         });

//         if (dailySummaryExists) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('You have already saved a daily summary today!'),
//               backgroundColor: AppColors.yellowAccent,
//             ),
//           );
//           return;
//         }
//       }
//     }

//     // Validasi per kategori
//     if (_currentCategory == AddProgressActivityCategory.activity) {
//       // Activity: validasi date, time, dan skills
//       if (_selectedDate == null) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(const SnackBar(content: Text('Please select a date')));
//         return;
//       }

//       if (_selectedTime == null) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(const SnackBar(content: Text('Please select a time')));
//         return;
//       }

//       if (selectedSkills.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Please select at least one skill')),
//         );
//         return;
//       }
//     } else if (_currentCategory == AddProgressActivityCategory.todo) {
//       // Todo: validasi date dan time
//       if (_selectedDate == null) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(const SnackBar(content: Text('Please select a date')));
//         return;
//       }

//       if (_selectedTime == null) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(const SnackBar(content: Text('Please select a time')));
//         return;
//       }
//     }

//     setState(() {
//       _isSaving = true;
//     });

//     try {
//       ProgressType type;
//       switch (_currentCategory) {
//         case AddProgressActivityCategory.activity:
//           type = ProgressType.activity;
//           break;
//         case AddProgressActivityCategory.summary:
//           type = ProgressType.summary;
//           break;
//         case AddProgressActivityCategory.todo:
//           type = ProgressType.todo;
//           break;
//       }

//       // Buat model progress
//       final progress = ProgressModel(
//         type: type,
//         description: _getCurrentCategoryController.text.trim(),
//         link: _getCurrentLinkController.text.trim().isEmpty
//             ? null
//             : _getCurrentLinkController.text.trim(),
//         skills: selectedSkills.isEmpty ? null : selectedSkills,
//         skillsPoint: selectedSkillsPoint.isEmpty ? null : selectedSkillsPoint,
//         date: _selectedDate,
//         time: _selectedTime != null
//             ? '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
//             : null,
//         isNotificationEnabled:
//             _currentCategory == AddProgressActivityCategory.todo
//             ? _isNotificationEnabled
//             : null,
//         isSummaryWeekly: _currentCategory == AddProgressActivityCategory.summary
//             ? isSummaryWeekly
//             : null,
//       );

//       // Simpan ke database
//       await _isarService.addProgress(progress);

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Progress saved successfully!'),
//             backgroundColor: Colors.green,
//           ),
//         );
//         context.pop();
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Failed to save progress: $e')));
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isSaving = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       top: false,
//       bottom: false,
//       child: Scaffold(
//         backgroundColor: AppColors.white,
//         appBar: AppBar(
//           backgroundColor: AppColors.white,
//           elevation: 2,
//           shadowColor: Colors.black.withAlpha((0.2 * 255).toInt()),
//           surfaceTintColor: Colors.transparent,
//           centerTitle: true,
//           leading: IconButton(
//             icon: const Icon(
//               Icons.arrow_back_ios_new_rounded,
//               fontWeight: FontWeight.bold,
//               color: AppColors.primary,
//             ),
//             onPressed: () {
//               context.pop();
//             },
//           ),
//           title: const Text(
//             'Add Progress',
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: AppColors.primary,
//             ),
//           ),
//           actions: [
//             Container(
//               margin: const EdgeInsets.only(right: 8),
//               child: InkWell(
//                 borderRadius: BorderRadius.circular(50),
//                 onTap: _isSaving ? null : _saveProgress,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8),
//                   child: _isSaving
//                       ? const SizedBox(
//                           width: 20,
//                           height: 20,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             valueColor: AlwaysStoppedAnimation<Color>(
//                               AppColors.primary,
//                             ),
//                           ),
//                         )
//                       : const Text(
//                           'Save',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: AppColors.primary,
//                           ),
//                         ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ContainerCategoryButton(
//                 currentCategory: _currentCategory,
//                 children: [
//                   CustomCategoryButton(
//                     label: 'Activity',
//                     currentCategory: _currentCategory,
//                     buttonCategory: AddProgressActivityCategory.activity,
//                     buttonColorLogic: ProgressCategoryButtonConfig.background(
//                       currentCategory: _currentCategory,
//                       buttonCategory: AddProgressActivityCategory.activity,
//                     ),
//                     textColorLogic: ProgressCategoryButtonConfig.text(
//                       currentCategory: _currentCategory,
//                       buttonCategory: AddProgressActivityCategory.activity,
//                     ),
//                     onSelected: (activityValue) {
//                       setState(() {
//                         _currentCategory = activityValue;
//                       });
//                     },
//                   ),
//                   CustomCategoryButton(
//                     label: 'Summary',
//                     currentCategory: _currentCategory,
//                     buttonCategory: AddProgressActivityCategory.summary,
//                     buttonColorLogic: ProgressCategoryButtonConfig.background(
//                       currentCategory: _currentCategory,
//                       buttonCategory: AddProgressActivityCategory.summary,
//                     ),
//                     textColorLogic: ProgressCategoryButtonConfig.text(
//                       currentCategory: _currentCategory,
//                       buttonCategory: AddProgressActivityCategory.summary,
//                     ),
//                     onSelected: (activityValue) {
//                       setState(() {
//                         _currentCategory = activityValue;
//                       });
//                     },
//                   ),
//                   CustomCategoryButton(
//                     label: 'To-do',
//                     currentCategory: _currentCategory,
//                     buttonCategory: AddProgressActivityCategory.todo,
//                     buttonColorLogic: ProgressCategoryButtonConfig.background(
//                       currentCategory: _currentCategory,
//                       buttonCategory: AddProgressActivityCategory.todo,
//                     ),
//                     textColorLogic: ProgressCategoryButtonConfig.text(
//                       currentCategory: _currentCategory,
//                       buttonCategory: AddProgressActivityCategory.todo,
//                     ),
//                     onSelected: (activityValue) {
//                       setState(() {
//                         _currentCategory = activityValue;
//                       });
//                     },
//                   ),
//                 ],
//               ),
//               SizedBox(height: 16),
//               Text(
//                 _currentCategory == AddProgressActivityCategory.activity
//                     ? '- What have you done?'
//                     : _currentCategory == AddProgressActivityCategory.summary
//                     ? '- Let\'s share your reflections!'
//                     : '- What are you planning to do?',
//                 style: const TextStyle(fontSize: 12, color: AppColors.gray3),
//               ),
//               Expanded(
//                 child: SingleChildScrollView(
//                   child:
//                       _currentCategory == AddProgressActivityCategory.activity
//                       ? AddActivitySection(
//                           getCurrentCategoryController:
//                               _getCurrentCategoryController,
//                           selectedSkills: selectedSkills,
//                           selectedSkillsPoint: selectedSkillsPoint,
//                           onChipSelected: (List<String> newSelectedSkillsList) {
//                             setState(() {
//                               // Hapus yang tidak dipilih menggunakan removeWhere dari map
//                               selectedSkillsPoint.removeWhere(
//                                 // Jika skill tidak ada di newSelectedSkillsList maka true dan hapus
//                                 (skill, _) =>
//                                     !newSelectedSkillsList.contains(skill),
//                               );

//                               // Tambahkan yang baru dipilih (dengan nilai default 1)
//                               for (final skill in newSelectedSkillsList) {
//                                 // Jika skill belum ada di map (putIfAbsent)
//                                 // maka tambahkan nama skill itu dengan nilai default 1
//                                 selectedSkillsPoint.putIfAbsent(skill, () => 1);
//                               }

//                               // Update selectedSkills dengan newSelectedSkillsList
//                               // yang telah dikirim dari SkillChipSelection onSelected
//                               selectedSkills = newSelectedSkillsList;
//                             });
//                           },
//                           selectedDate: _selectedDate,
//                           onDateChanged: (DateTime newDate) {
//                             setState(() {
//                               selectedDateActivity = newDate;
//                             });
//                           },
//                           selectedTime: _selectedTime,
//                           onTimeChanged: (TimeOfDay newTime) {
//                             setState(() {
//                               selectedTimeActivity = newTime;
//                             });
//                           },
//                           onChangedSkillSlider: (String skillName, int value) {
//                             setState(() {
//                               selectedSkillsPoint[skillName] = value;
//                             });
//                           },
//                           link: _getCurrentLinkController,
//                           onLinkChanged: (String value) {
//                             setState(() {
//                               _getCurrentLinkController.text = value;
//                             });
//                           },
//                         )
//                       : _currentCategory == AddProgressActivityCategory.summary
//                       ? AddSummarySection(
//                           getCurrentCategoryController:
//                               _getCurrentCategoryController,
//                           isWeekend: isWeekend,
//                           link: _getCurrentLinkController,
//                           onTapWeekly: (bool value) {
//                             setState(() {
//                               isSummaryWeekly = value;
//                               _saveProgress();
//                             });
//                           },
//                           onLinkChanged: (String value) {
//                             setState(() {
//                               _getCurrentLinkController.text = value;
//                             });
//                           },
//                         )
//                       : AddTodoSection(
//                           getCurrentCategoryController:
//                               _getCurrentCategoryController,
//                           selectedDate: _selectedDate,
//                           onDateChanged: (DateTime newDate) {
//                             setState(() {
//                               selectedDateTodo = newDate;
//                             });
//                           },
//                           selectedTime: _selectedTime,
//                           onTimeChanged: (TimeOfDay newTime) {
//                             setState(() {
//                               selectedTimeActivity = newTime;
//                             });
//                           },
//                           isNotificationEnabled: _isNotificationEnabled,
//                           onNotificationChanged: (bool value) {
//                             setState(() {
//                               _isNotificationEnabled = value;
//                             });
//                           },
//                         ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
