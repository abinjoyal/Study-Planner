import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/study_session.dart';
import '../providers/planner_provider.dart';

class AddStudySessionPage extends ConsumerStatefulWidget {
  final StudySession? sessionToEdit;

  const AddStudySessionPage({
    super.key,
    this.sessionToEdit,
  });

  @override
  ConsumerState<AddStudySessionPage> createState() =>
      _AddStudySessionPageState();
}

class _AddStudySessionPageState extends ConsumerState<AddStudySessionPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _subtitleController;
  late TextEditingController _timeLabelController;
  late TextEditingController _durationController;

  @override
  void initState() {
    super.initState();
    final session = widget.sessionToEdit;
    _titleController = TextEditingController(text: session?.title ?? '');
    _subtitleController = TextEditingController(text: session?.subtitle ?? '');
    _timeLabelController =
        TextEditingController(text: session?.timeLabel ?? '08:00');
    _durationController =
        TextEditingController(text: session?.duration ?? '1h');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _timeLabelController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _saveSession() {
    if (_formKey.currentState?.validate() ?? false) {
      final isEditing = widget.sessionToEdit != null;
      final titleText = _titleController.text.trim();

      // Automatically infer subject type from title, or keep existing / custom
      SubjectType detectedSubject =
          widget.sessionToEdit?.subjectType ?? SubjectType.custom;
      final lowerTitle = titleText.toLowerCase();
      for (final type in SubjectType.values) {
        if (lowerTitle.contains(type.name.toLowerCase())) {
          detectedSubject = type;
          break;
        }
      }

      final session = StudySession(
        id: isEditing
            ? widget.sessionToEdit!.id
            : DateTime.now().millisecondsSinceEpoch.toString(),
        title: titleText,
        subtitle: _subtitleController.text.trim(),
        timeLabel: _timeLabelController.text.trim(),
        duration: _durationController.text.trim(),
        subjectType: detectedSubject,
        date: ref.read(plannerNotifierProvider).selectedDate,
      );

      final notifier = ref.read(plannerNotifierProvider.notifier);
      if (isEditing) {
        notifier.updateSession(session);
      } else {
        notifier.addSession(session);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.sessionToEdit != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Study Session' : 'New Study Session',
          style: const TextStyle(
            color: Color(0xFF1B1C4B),
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1B1C4B)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Text(
                'Subject / Title',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1B1C4B),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'e.g. Maths, Physics, Chemistry',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                ),
                validator: (val) =>
                    val == null || val.trim().isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 18),

              // Subtitle / Notes
              const Text(
                'Notes / Subtitle',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1B1C4B),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _subtitleController,
                decoration: InputDecoration(
                  hintText: 'e.g. Chapter 4 - Exercises',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Time & Duration Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Start Time',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1B1C4B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _timeLabelController,
                          decoration: InputDecoration(
                            hintText: '08:00',
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide:
                                  const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Duration',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1B1C4B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _durationController,
                          decoration: InputDecoration(
                            hintText: '1h, 30m',
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide:
                                  const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _saveSession,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6E1F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    elevation: 4,
                  ),
                  child: Text(
                    isEditing ? 'Update Session' : 'Save Session',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
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
