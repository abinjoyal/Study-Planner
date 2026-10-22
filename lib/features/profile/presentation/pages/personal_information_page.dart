import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/router/nav_bar.dart';
import '../providers/edit_profile_provider.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_avatar.dart';
import '../../domain/entities/user_profile.dart';

class PersonalInformationPage extends ConsumerStatefulWidget {
  final bool isFirstTime;
  final bool isInitialEdit;

  const PersonalInformationPage({
    super.key,
    this.isFirstTime = false,
    this.isInitialEdit = false,
  });

  @override
  ConsumerState<PersonalInformationPage> createState() =>
      _PersonalInformationPageState();
}

class _PersonalInformationPageState
    extends ConsumerState<PersonalInformationPage> {
  late bool _isEditing;
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _degreeController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.isFirstTime || widget.isInitialEdit;

    final currentProfile = ref.read(profileNotifierProvider).profile;
    if (widget.isFirstTime) {
      _nameController = TextEditingController();
      _emailController = TextEditingController();
      _degreeController = TextEditingController();
      _phoneController = TextEditingController();
    } else {
      _nameController =
          TextEditingController(text: currentProfile?.name ?? '');
      _emailController =
          TextEditingController(text: currentProfile?.email ?? '');
      _degreeController =
          TextEditingController(text: currentProfile?.degree ?? '');
      _phoneController =
          TextEditingController(text: currentProfile?.phoneNumber ?? '');
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.isFirstTime) {
        ref.read(editProfileNotifierProvider.notifier).resetForFirstTime();
      } else {
        ref.read(editProfileNotifierProvider.notifier).initFromCurrentProfile();
      }
    });
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

  Future<void> _handleSave() async {
    final notifier = ref.read(editProfileNotifierProvider.notifier);
    final ok = await notifier.save();

    if (!mounted) return;

    if (ok) {
      if (widget.isFirstTime) {
        // Save first time completion flags
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isProfileSetupCompleted', true);
        await prefs.setBool('isOnboardingCompleted', true);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Welcome, ${_nameController.text.trim()}! Your profile is ready.',
            ),
            backgroundColor: const Color(0xFF16A34A),
          ),
        );

        // Navigate to Home directly
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const MainNavBar()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Information updated successfully!'),
            backgroundColor: Color(0xFF16A34A),
          ),
        );

        if (widget.isInitialEdit) {
          Navigator.of(context).pop();
        } else {
          setState(() {
            _isEditing = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);
    final profile = profileState.profile;
    final editState = ref.watch(editProfileNotifierProvider);
    final editNotifier = ref.read(editProfileNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF9F6),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: !widget.isFirstTime,
        leading: widget.isFirstTime
            ? null
            : IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Color(0xFF0F172A),
                  size: 20,
                ),
                onPressed: () {
                  if (_isEditing && !widget.isInitialEdit) {
                    setState(() {
                      _isEditing = false;
                    });
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              ),
        title: Text(
          widget.isFirstTime ? 'Student Information' : 'Personal Information',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
          ),
        ),
        actions: [
          if (!widget.isFirstTime && !_isEditing)
            TextButton(
              onPressed: () {
                editNotifier.initFromCurrentProfile();
                _nameController.text = editState.name;
                _emailController.text = editState.email;
                _degreeController.text = editState.degree;
                _phoneController.text = editState.phoneNumber ?? '';
                setState(() {
                  _isEditing = true;
                });
              },
              child: const Text(
                'Edit',
                style: TextStyle(
                  color: Color(0xFFF95700),
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: _isEditing
              ? _buildEditMode(editState, editNotifier)
              : _buildViewMode(profile),
        ),
      ),
    );
  }

  Widget _buildViewMode(UserProfile? profile) {
    final birthday = profile?.birthday;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Account Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Manage your personal credentials and academic information',
          style: TextStyle(fontSize: 13.5, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 20),

        // Info Items
        _buildInfoTile(
          icon: Icons.person_rounded,
          iconColor: const Color(0xFF0284C7),
          iconBg: const Color(0xFFE0F2FE),
          label: 'Full Name',
          value: profile?.name.isNotEmpty == true
              ? profile!.name
              : 'Alex Johnson',
        ),

        _buildInfoTile(
          icon: Icons.email_rounded,
          iconColor: const Color(0xFFEA580C),
          iconBg: const Color(0xFFFFEDD5),
          label: 'Email Address',
          value: profile?.email.isNotEmpty == true
              ? profile!.email
              : 'alex@example.com',
        ),

        _buildInfoTile(
          icon: Icons.school_rounded,
          iconColor: const Color(0xFF9333EA),
          iconBg: const Color(0xFFF3E8FF),
          label: 'Degree & Department',
          value: profile?.degree.isNotEmpty == true
              ? profile!.degree
              : 'B.Sc. Computer Science',
        ),

        _buildInfoTile(
          icon: Icons.cake_rounded,
          iconColor: const Color(0xFFE11D48),
          iconBg: const Color(0xFFFFE4E6),
          label: 'Birthday',
          value: birthday != null
              ? '${birthday.day}/${birthday.month}/${birthday.year}'
              : 'May 14, 2003',
        ),

        _buildInfoTile(
          icon: Icons.phone_rounded,
          iconColor: const Color(0xFF16A34A),
          iconBg: const Color(0xFFDCFCE7),
          label: 'Phone Number',
          value: profile?.phoneNumber?.isNotEmpty == true
              ? profile!.phoneNumber!
              : '+1 234 567 8900',
        ),

        _buildInfoTile(
          icon: Icons.badge_rounded,
          iconColor: const Color(0xFF475569),
          iconBg: const Color(0xFFF1F5F9),
          label: 'Student ID',
          value: profile?.id ?? 'STU-2026-9812',
        ),
      ],
    );
  }

  Widget _buildEditMode(
    EditProfileState editState,
    EditProfileNotifier notifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isFirstTime) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFF7ED), Color(0xFFFFEDD5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFF95700).withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF95700).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    color: Color(0xFFF95700),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to StudyPlanner!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Enter your details to personalize your study dashboard.',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],

        // Avatar Section
        Center(
          child: Column(
            children: [
              ProfileAvatar(
                avatarUrl: editState.avatarUrl,
                radius: 48,
                showCameraBadge: false,
              ),
              const SizedBox(height: 10),
              const Text(
                'Choose Your Avatar',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 10),

              // Avatar Selector Strip
              SizedBox(
                height: 64,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: kPresetAvatars.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final avatarPath = kPresetAvatars[index];
                    final isSelected = editState.avatarUrl == avatarPath;

                    return GestureDetector(
                      onTap: () => notifier.setAvatar(avatarPath),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 56,
                        height: 56,
                        padding: const EdgeInsets.all(2.5),
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
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
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

        const SizedBox(height: 24),

        // Form Inputs
        _buildInputField(
          label: 'Full Name *',
          controller: _nameController,
          hintText: 'e.g. John Doe',
          icon: Icons.person_outline_rounded,
          onChanged: notifier.setName,
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
          label: 'Email Address',
          controller: _emailController,
          hintText: 'e.g. student@example.com',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          onChanged: notifier.setEmail,
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
              onTap: () => _selectBirthday(context, editState.birthday),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFEE2E2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFCA5A5)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: Color(0xFFE11D48),
                  size: 20,
                ),
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

        const SizedBox(height: 32),

        // Action Button
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: editState.isSaving ? null : _handleSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF95700),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              shadowColor: const Color(0xFFF95700).withValues(alpha: 0.4),
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
                : Text(
                    widget.isFirstTime ? 'Save & Continue' : 'Save Changes',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 24),
      ],
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

  Widget _buildInfoTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String label,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
