import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/profile_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_avatar.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _bioController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _bioController = TextEditingController();

    // Pre-fill existing data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(profileProvider('me')).valueOrNull;
      if (state != null) {
        _usernameController.text = state.username;
        _bioController.text = state.bio;
      }
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final username = _usernameController.text.trim();
    final bio = _bioController.text.trim();

    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username cannot be empty'),
          backgroundColor: AppColors.pink,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      await ref
          .read(profileProvider('me').notifier)
          .updateProfile(username, bio);
      if (mounted) {
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save profile: $e'),
            backgroundColor: AppColors.pink,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileProvider('me')).valueOrNull;

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: const Icon(Icons.close, color: AppColors.textPrimary),
        ),
        title: Text(
          'Edit profile',
          style: AppTypography.headingMedium.copyWith(fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          if (_isSaving)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(right: 16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: AppColors.pink,
                    strokeWidth: 2,
                  ),
                ),
              ),
            )
          else
            GestureDetector(
              onTap: _saveProfile,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(
                    'Save',
                    style: AppTypography.buttonText.copyWith(
                      color: AppColors.pink,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: state == null
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.pink),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),
                  // Avatar Section
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      AppAvatar(imageUrl: state.avatarUrl, size: 96),
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          color: AppColors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          color: AppColors.textPrimary,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Change photo',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Username Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Username',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _usernameController,
                        style: AppTypography.bodyLarge,
                        decoration: InputDecoration(
                          hintText: 'Enter your username',
                          hintStyle: AppTypography.bodyLarge.copyWith(
                            color: AppColors.textTertiary,
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.divider),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.pink),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Bio Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bio',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _bioController,
                        style: AppTypography.bodyLarge,
                        maxLines: 4,
                        maxLength: 80,
                        decoration: InputDecoration(
                          hintText: 'Add a bio to your profile',
                          hintStyle: AppTypography.bodyLarge.copyWith(
                            color: AppColors.textTertiary,
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.divider),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.pink),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
