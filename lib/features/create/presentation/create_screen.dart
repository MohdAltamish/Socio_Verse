import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class CreateScreen extends ConsumerStatefulWidget {
  const CreateScreen({super.key});

  @override
  ConsumerState<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends ConsumerState<CreateScreen>
    with WidgetsBindingObserver {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;

      _cameraController = CameraController(
        _cameras.first,
        ResolutionPreset.high,
        enableAudio: true,
      );

      await _cameraController!.initialize();
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _cameraController;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _startRecording() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    if (_cameraController!.value.isRecordingVideo) return;

    try {
      await _cameraController!.startVideoRecording();
      if (mounted) {
        setState(() {
          _isRecording = true;
        });
      }
    } catch (e) {
      debugPrint('Error starting recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    if (_cameraController == null ||
        !_cameraController!.value.isRecordingVideo) {
      return;
    }

    try {
      final XFile videoFile = await _cameraController!.stopVideoRecording();
      if (mounted) {
        setState(() {
          _isRecording = false;
        });
        // Navigate to Editor screen with the video path
        context.push('/editor', extra: videoFile.path);
      }
    } catch (e) {
      debugPrint('Error stopping recording: $e');
    }
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
  }

  Future<void> _pickVideoFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? video = await picker.pickVideo(source: ImageSource.gallery);

      if (video != null && mounted) {
        context.push('/editor', extra: video.path);
      }
    } catch (e) {
      debugPrint('Error picking video: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          // Camera preview or placeholder
          if (_isCameraInitialized && _cameraController != null)
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: CameraPreview(_cameraController!),
            )
          else
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1A1A2E),
                    Color(0xFF16213E),
                    Color(0xFF0F3460),
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.videocam_rounded,
                      color: AppColors.textSecondary.withValues(alpha: 0.5),
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Initializing Camera...',
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Top toolbar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.close,
                      color: AppColors.textPrimary,
                      size: 28,
                    ),
                  ),
                  const Spacer(),
                  const _TopToolItem(icon: Icons.music_note, label: 'Sounds'),
                  const SizedBox(width: 20),
                  const _TopToolItem(
                    icon: Icons.auto_fix_high,
                    label: 'Effects',
                  ),
                  const SizedBox(width: 20),
                  const _TopToolItem(icon: Icons.text_fields, label: 'Text'),
                  const SizedBox(width: 20),
                  const _TopToolItem(
                    icon: Icons.emoji_emotions_outlined,
                    label: 'Stickers',
                  ),
                ],
              ),
            ),
          ),

          // Right side strip
          Positioned(
            right: 12,
            top: MediaQuery.of(context).padding.top + 80,
            child: const Column(
              children: [
                _SideToolItem(icon: Icons.flip_camera_ios, label: 'Flip'),
                SizedBox(height: 20),
                _SideToolItem(icon: Icons.speed, label: 'Speed'),
                SizedBox(height: 20),
                _SideToolItem(
                  icon: Icons.face_retouching_natural,
                  label: 'Beauty',
                ),
                SizedBox(height: 20),
                _SideToolItem(icon: Icons.filter_vintage, label: 'Filters'),
                SizedBox(height: 20),
                _SideToolItem(icon: Icons.timer, label: 'Timer'),
              ],
            ),
          ),

          // Bottom controls
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 20,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Record button row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Gallery thumbnail
                    GestureDetector(
                      onTap: _pickVideoFromGallery,
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.textPrimary,
                            width: 2,
                          ),
                          color: AppColors.card,
                        ),
                        child: const Icon(
                          Icons.photo_library,
                          color: AppColors.textPrimary,
                          size: 22,
                        ),
                      ),
                    ),

                    // Record button
                    GestureDetector(
                      onLongPressStart: (_) => _startRecording(),
                      onLongPressEnd: (_) => _stopRecording(),
                      onTap: _toggleRecording,
                      child: _RecordButton(isRecording: _isRecording),
                    ),

                    // Templates
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.grid_view_rounded,
                          color: AppColors.textPrimary,
                          size: 28,
                        ),
                        const SizedBox(height: 4),
                        Text('Templates', style: AppTypography.labelSmall),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Hint text
                Text(
                  'Hold for video',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textTertiary,
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

class _TopToolItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _TopToolItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.textPrimary, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textPrimary,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _SideToolItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SideToolItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.textPrimary, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textPrimary,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _RecordButton extends StatefulWidget {
  final bool isRecording;

  const _RecordButton({required this.isRecording});

  @override
  State<_RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<_RecordButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(_RecordButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording && !oldWidget.isRecording) {
      _controller.forward(from: 0.0);
    } else if (!widget.isRecording && oldWidget.isRecording) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          width: 80,
          height: 80,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Progress ring
              if (widget.isRecording)
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    value: _controller.value,
                    strokeWidth: 4,
                    color: AppColors.pink,
                    backgroundColor: AppColors.textSecondary.withValues(
                      alpha: 0.3,
                    ),
                  ),
                ),

              // Outer ring
              Container(
                width: widget.isRecording ? 76 : 80,
                height: widget.isRecording ? 76 : 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.textPrimary,
                    width: widget.isRecording ? 3 : 4,
                  ),
                ),
              ),

              // Inner circle
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: widget.isRecording ? 32 : 60,
                height: widget.isRecording ? 32 : 60,
                decoration: BoxDecoration(
                  color: AppColors.pink,
                  borderRadius: BorderRadius.circular(
                    widget.isRecording ? 8 : 30,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
