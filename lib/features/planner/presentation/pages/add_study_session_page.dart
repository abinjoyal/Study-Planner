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
  late SubjectType _selectedSubject;

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
    _selectedSubject = session?.subjectType ?? SubjectType.maths;
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
      final session = StudySession(
        id: isEditing
            ? widget.sessionToEdit!.id
            : DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        subtitle: _subtitleController.text.trim(),
        timeLabel: _timeLabelController.text.trim(),
        duration: _durationController.text.trim(),
        subjectType: _selectedSubject,
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
              // Subject Dropdown
              const Text(
                'Subject Type',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1B1C4B),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<SubjectType>(
                    value: _selectedSubject,
                    isExpanded: true,
                    items: SubjectType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(
                          type.name.toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedSubject = val;
                          if (_titleController.text.isEmpty ||
                              SubjectType.values.any((t) =>
                                  t.name.toLowerCase() ==
                                  _titleController.text.toLowerCase())) {
                            _titleController.text =
                                val.name[0].toUpperCase() + val.name.substring(1);
                          }
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Title
              const Text(
                'Title',
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
                  hintText: 'e.g. Maths, Physics',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Title is required' : null,
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
