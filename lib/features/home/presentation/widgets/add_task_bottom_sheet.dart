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

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final titleText = _titleController.text.trim();
      final lowerTitle = titleText.toLowerCase();

      String symbol = '📝';
      Color color = const Color(0xFFFF6E1F);

      if (lowerTitle.contains('math')) {
        symbol = 'Σ';
        color = const Color(0xFF3B82F6);
      } else if (lowerTitle.contains('physic')) {
        symbol = '⚛';
        color = const Color(0xFFA855F7);
      } else if (lowerTitle.contains('chem')) {
        symbol = '🧪';
        color = const Color(0xFFF59E0B);
      } else if (lowerTitle.contains('eng')) {
        symbol = '📖';
        color = const Color(0xFF10B981);
      } else {
        const palette = [
          Color(0xFF2563EB),
          Color(0xFF9333EA),
          Color(0xFFFF6E1F),
          Color(0xFF10B981),
          Color(0xFFD97706),
          Color(0xFFE11D48),
          Color(0xFF0D9488),
          Color(0xFF4F46E5),
        ];
        final index = titleText.isNotEmpty
            ? (titleText.codeUnits.reduce((a, b) => a + b) % palette.length)
            : 0;
        color = palette[index];
      }

      final task = StudyTask(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: titleText,
        description: _descriptionController.text.trim(),
        iconSymbol: symbol,
        iconBackgroundColor: color,
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
