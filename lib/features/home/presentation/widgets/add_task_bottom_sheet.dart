import 'package:flutter/material.dart';
import '../../domain/entities/study_task.dart';

class AddTaskBottomSheet extends StatefulWidget {
  final Function(StudyTask) onTaskAdded;

  const AddTaskBottomSheet({
    super.key,
    required this.onTaskAdded,
  });

  static Future<void> show(
    BuildContext context, {
    required Function(StudyTask) onTaskAdded,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddTaskBottomSheet(onTaskAdded: onTaskAdded),
    );
  }

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _timeController = TextEditingController();

  final List<Map<String, dynamic>> _subjectPresets = [
    {'name': 'Maths', 'symbol': 'Σ', 'color': Color(0xFF3B82F6)},
    {'name': 'Physics', 'symbol': '⚛', 'color': Color(0xFFA855F7)},
    {'name': 'English', 'symbol': '📖', 'color': Color(0xFF10B981)},
    {'name': 'Chemistry', 'symbol': '🧪', 'color': Color(0xFFF59E0B)},
    {'name': 'General', 'symbol': '📝', 'color': Color(0xFFEC4899)},
  ];

  late Map<String, dynamic> _selectedPreset;

  @override
  void initState() {
    super.initState();
    _selectedPreset = _subjectPresets[0];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final task = StudyTask(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        iconSymbol: _selectedPreset['symbol'] as String,
        iconBackgroundColor: _selectedPreset['color'] as Color,
        isCompleted: false,
        estimatedTime: _timeController.text.trim().isNotEmpty
            ? _timeController.text.trim()
            : null,
      );

      widget.onTaskAdded(task);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 24,
        bottom: bottomInset + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Drag Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add New Task',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF64748B)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Subject / Category Selector
              const Text(
                'Subject / Category',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _subjectPresets.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final preset = _subjectPresets[index];
                    final isSelected =
                        _selectedPreset['name'] == preset['name'];
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedPreset = preset;
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (preset['color'] as Color).withValues(alpha: 0.15)
                              : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? (preset['color'] as Color)
                                : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              preset['symbol'] as String,
                              style: TextStyle(
                                fontSize: 14,
                                color: preset['color'] as Color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              preset['name'] as String,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isSelected
                                    ? (preset['color'] as Color)
                                    : const Color(0xFF475569),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Task Title Input
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Task Title *',
                  hintText: 'e.g., Maths - Chapter 5',
                  hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                        color: Color(0xFFF95700), width: 1.5),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter a task title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Task Description Input
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'e.g., Complete exercise questions 1-15',
                  hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                        color: Color(0xFFF95700), width: 1.5),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                ),
              ),
              const SizedBox(height: 12),

              // Estimated Time Input
              TextFormField(
                controller: _timeController,
                decoration: InputDecoration(
                  labelText: 'Estimated Time',
                  hintText: 'e.g., 1h 30m',
                  hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                        color: Color(0xFFF95700), width: 1.5),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                ),
              ),
              const SizedBox(height: 24),

              // Add Task Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF95700),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Add Task',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
