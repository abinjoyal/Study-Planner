import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/edit_profile_provider.dart';
import '../widgets/profile_avatar.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _degreeController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final editState = ref.read(editProfileNotifierProvider);
    _nameController = TextEditingController(text: editState.name);
    _emailController = TextEditingController(text: editState.email);
    _degreeController = TextEditingController(text: editState.degree);
    _phoneController = TextEditingController(text: editState.phoneNumber ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _degreeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _selectBirthday(
      BuildContext context, DateTime? currentBirthday) async {
    final now = DateTime.now();
    final initialDate = currentBirthday ?? DateTime(2003, 1, 1);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1960),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFF95700),
              onPrimary: Colors.white,
              onSurface: Color(0xFF0F172A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      ref.read(editProfileNotifierProvider.notifier).setBirthday(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final editState = ref.watch(editProfileNotifierProvider);
    final notifier = ref.read(editProfileNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF9F6),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF0F172A), size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar Section
              Center(
                child: Column(
                  children: [
                    ProfileAvatar(
                      avatarUrl: editState.avatarUrl,
                      radius: 54,
                      showCameraBadge: false,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Choose Your Avatar',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Avatar Selector Strip (5 presets)
                    SizedBox(
                      height: 72,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: kPresetAvatars.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 14),
                        itemBuilder: (context, index) {
                          final avatarPath = kPresetAvatars[index];
                          final isSelected = editState.avatarUrl == avatarPath;

                          return GestureDetector(
                            onTap: () => notifier.setAvatar(avatarPath),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 62,
                              height: 62,
                              padding: const EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFFF95700)
                                      : Colors.transparent,
                                  width: 3,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: const Color(0xFFF95700)
                                              .withValues(alpha: 0.35),
                                          blurRadius: 10,
                                          offset: const Offset(0, 3),
                                        )
                                      ]
                                    : null,
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  avatarPath,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => Container(
                                    color: const Color(0xFFFFEDD5),
                                    child: Center(
                                      child: Text(
                                        '#${index + 1}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFFEA580C),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Form Inputs
              _buildInputField(
                label: 'Full Name',
                controller: _nameController,
                hintText: 'Enter your full name',
                icon: Icons.person_outline_rounded,
                onChanged: notifier.setName,
              ),

              const SizedBox(height: 16),

              _buildInputField(
                label: 'Email Address',
                controller: _emailController,
                hintText: 'Enter your email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                onChanged: notifier.setEmail,
              ),

              const SizedBox(height: 16),

              _buildInputField(
                label: 'Degree / Major',
                controller: _degreeController,
                hintText: 'e.g. B.Sc. Computer Science',
                icon: Icons.school_outlined,
                onChanged: notifier.setDegree,
              ),

              const SizedBox(height: 16),

              _buildInputField(
                label: 'Phone Number (Optional)',
                controller: _phoneController,
                hintText: '+1 234 567 8900',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                onChanged: notifier.setPhoneNumber,
              ),

              const SizedBox(height: 16),

              // Birthday Picker Tile
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Birthday',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () =>
                        _selectBirthday(context, editState.birthday),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.cake_outlined,
                            color: Color(0xFFF95700),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              editState.birthday != null
                                  ? '${editState.birthday!.day}/${editState.birthday!.month}/${editState.birthday!.year}'
                                  : 'Select your birthday',
                              style: TextStyle(
                                fontSize: 15,
                                color: editState.birthday != null
                                    ? const Color(0xFF0F172A)
                                    : const Color(0xFF94A3B8),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.calendar_today_rounded,
                            color: Color(0xFF94A3B8),
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              if (editState.errorMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1F2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFFE4E6)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded,
                          color: Color(0xFFE11D48), size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          editState.errorMessage!,
                          style: const TextStyle(
                            color: Color(0xFFE11D48),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 36),

              // Save Action Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: editState.isSaving
                      ? null
                      : () async {
                          final ok = await notifier.save();
                          if (ok && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Profile updated successfully!'),
                                backgroundColor: Color(0xFF16A34A),
                              ),
                            );
                            Navigator.of(context).pop();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF95700),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                    shadowColor:
                        const Color(0xFFF95700).withValues(alpha: 0.4),
                  ),
                  child: editState.isSaving
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Save Changes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFE2E8F0),
              width: 1.2,
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            onChanged: onChanged,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Icon(
                icon,
                color: const Color(0xFFF95700),
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
