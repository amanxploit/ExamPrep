import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:exam_prep/core/constants/app_design.dart';
import 'package:exam_prep/core/constants/app_text_styles.dart';
import 'package:exam_prep/core/widgets/common_widgets.dart';
import 'package:exam_prep/data/models/flashcard.dart';
import 'package:exam_prep/data/models/revision_review.dart';
import 'package:exam_prep/features/revision/providers/revision_providers.dart';
import 'package:exam_prep/features/home/providers/home_providers.dart';
import 'package:exam_prep/core/services/calculation_service.dart';
import 'package:exam_prep/core/extensions/extensions.dart';

class FlashcardScreen extends ConsumerStatefulWidget {
  final String? chapterId;
  const FlashcardScreen({super.key, this.chapterId});

  @override
  ConsumerState<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends ConsumerState<FlashcardScreen> {
  int _currentIndex = 0;
  bool _showBack = false;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeExam = ref.watch(activeExamProvider).value;
    final flashcards = widget.chapterId != null
        ? ref.watch(chapterFlashcardsProvider(widget.chapterId!))
        : (activeExam != null ? ref.watch(flashcardsProvider(activeExam.id)) : []);

    if (activeExam == null && widget.chapterId == null) {
      return _buildNoExamState(context);
    }

    if (flashcards.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      children: [
        // Progress indicator
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Text('Flashcards', style: AppTextStyles.sectionTitle),
                  const Spacer(),
                  Text('${_currentIndex + 1} / ${flashcards.length}', style: AppTextStyles.caption),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: (_currentIndex + 1) / flashcards.length,
                minHeight: 4,
                backgroundColor: AppColors.track,
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              ),
            ],
          ),
        ),

        // Flashcard
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
                _showBack = false;
              });
            },
            itemCount: flashcards.length,
            itemBuilder: (context, index) {
              return _buildFlashcard(context, ref, flashcards[index]);
            },
          ),
        ),

        // Rating buttons
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: OutlinedPillButton(
                  label: 'Again',
                  icon: Icons.refresh_rounded,
                  onPressed: () => _rateCard(ref, flashcards[_currentIndex], ReviewRating.again),
                  color: AppColors.error,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedPillButton(
                  label: 'Hard',
                  icon: Icons.remove_rounded,
                  onPressed: () => _rateCard(ref, flashcards[_currentIndex], ReviewRating.hard),
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: PrimaryPillButton(
                  label: 'Good',
                  icon: Icons.check_rounded,
                  onPressed: () => _rateCard(ref, flashcards[_currentIndex], ReviewRating.good),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: PrimaryPillButton(
                  label: 'Easy',
                  icon: Icons.bolt_rounded,
                  onPressed: () => _rateCard(ref, flashcards[_currentIndex], ReviewRating.easy),
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNoExamState(BuildContext context) {
    return Center(
      child: EmptyStateCard(
        icon: Icons.school_rounded,
        title: 'No active exam',
        subtitle: 'Create or select an exam to study flashcards',
        action: PrimaryPillButton(
          label: 'Create exam',
          icon: Icons.add_rounded,
          onPressed: () => context.push('/exams/new'),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: EmptyStateCard(
        icon: Icons.style_rounded,
        title: 'No flashcards yet',
        subtitle: widget.chapterId != null
            ? 'Add flashcards to this chapter to start reviewing'
            : 'Create flashcards from chapters or add them manually',
        action: PrimaryPillButton(
          label: 'Add flashcard',
          icon: Icons.add_rounded,
          onPressed: () => _showAddFlashcardDialog(context, ref),
        ),
      ),
    );
  }

  Widget _buildFlashcard(BuildContext context, WidgetRef ref, Flashcard card) {
    return GestureDetector(
      onTap: () => setState(() => _showBack = !_showBack),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.border),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            final rotate = Tween(begin: 0.0, end: 1.0).animate(animation);
            return AnimatedBuilder(
              animation: rotate,
              child: child,
              builder: (context, child) {
                final isUnder = (rotate.value < 0.5);
                return Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(isUnder ? rotate.value * 3.14159 : (rotate.value - 1) * 3.14159),
                  alignment: Alignment.center,
                  child: child,
                );
              },
            );
          },
          child: _showBack ? _buildCardBack(context, card) : _buildCardFront(context, card),
        ),
      ),
    );
  }

  Widget _buildCardFront(BuildContext context, Flashcard card) {
    return Container(
      key: const ValueKey('front'),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text('Question', style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 20),
          Text(
            card.front,
            style: AppTextStyles.headline,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          if (card.tags.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: card.tags.map((tag) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.track,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(tag, style: AppTextStyles.caption),
              )).toList(),
            ),
            const SizedBox(height: 20),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.touch_app_rounded, size: 20, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Text('Tap to reveal', style: AppTextStyles.caption),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardBack(BuildContext context, Flashcard card) {
    return Container(
      key: const ValueKey('back'),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.successSoft,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text('Answer', style: AppTextStyles.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 20),
          Text(
            card.back,
            style: AppTextStyles.headline,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          if (card.confidence > 0) ...[
            Text('Confidence: ${(card.confidence * 100).round()}%', style: AppTextStyles.caption),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: card.confidence,
              minHeight: 4,
              backgroundColor: AppColors.track,
              valueColor: const AlwaysStoppedAnimation(AppColors.success),
            ),
            const SizedBox(height: 20),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.touch_app_rounded, size: 20, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Text('Tap to continue', style: AppTextStyles.caption),
            ],
          ),
        ],
      ),
    );
  }

  void _rateCard(WidgetRef ref, Flashcard card, ReviewRating rating) {
    // Update confidence based on rating
    double newConfidence = card.confidence;
    switch (rating) {
      case ReviewRating.again:
        newConfidence = (newConfidence - 0.2).clamp(0.0, 1.0);
        break;
      case ReviewRating.hard:
        newConfidence = (newConfidence + 0.05).clamp(0.0, 1.0);
        break;
      case ReviewRating.good:
        newConfidence = (newConfidence + 0.1).clamp(0.0, 1.0);
        break;
      case ReviewRating.easy:
        newConfidence = (newConfidence + 0.2).clamp(0.0, 1.0);
        break;
    }

    final updatedCard = card.copyWith(
      confidence: newConfidence,
      reviewCount: card.reviewCount + 1,
      lastReviewedAt: DateTime.now(),
    );

    final repo = ref.read(examRepositoryProvider);
    final review = FlashcardReview(
      userId: 'user_1',
      flashcardId: card.id,
      rating: rating,
      reviewedAt: DateTime.now(),
      previousConfidence: card.confidence,
      newConfidence: newConfidence,
    );

    repo.updateFlashcard(updatedCard);
    repo.addFlashcardReview(review);

    ref.invalidate(chapterFlashcardsProvider(card.chapterId ?? ''));
    ref.invalidate(flashcardsProvider(ref.read(activeExamProvider).value!.id));

    // Move to next card
    if (_currentIndex < 3) { // Will be updated with actual count
      setState(() {
        _showBack = false;
        _currentIndex++;
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Session complete!')),
      );
    }
  }

  void _showAddFlashcardDialog(BuildContext context, WidgetRef ref) {
    final frontController = TextEditingController();
    final backController = TextEditingController();
    final tagsController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.sheetTop)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          20 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.track,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text('Add Flashcard', style: AppTextStyles.sheetTitle),
            const SizedBox(height: 20),
            TextField(
              controller: frontController,
              decoration: const InputDecoration(
                labelText: 'Front (Question)',
                hintText: 'What is the capital of France?',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: backController,
              decoration: const InputDecoration(
                labelText: 'Back (Answer)',
                hintText: 'Paris',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: tagsController,
              decoration: const InputDecoration(
                labelText: 'Tags (comma separated)',
                hintText: 'geography, capitals, europe',
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedPillButton(
                    label: 'Cancel',
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryPillButton(
                    label: 'Add',
                    onPressed: () {
                      if (frontController.text.isNotEmpty && backController.text.isNotEmpty) {
                        final tags = tagsController.text
                            .split(',')
                            .map((t) => t.trim())
                            .where((t) => t.isNotEmpty)
                            .toList();
                        
                        final exam = ref.read(activeExamProvider).value;
                        if (exam != null) {
                          final flashcard = Flashcard(
                            userId: 'user_1',
                            chapterId: widget.chapterId,
                            front: frontController.text,
                            back: backController.text,
                            tags: tags,
                          );
                          repo.addFlashcard(flashcard);
                          ref.invalidate(flashcardsProvider(exam.id));
                          if (widget.chapterId != null) {
                            ref.invalidate(chapterFlashcardsProvider(widget.chapterId!));
                          }
                        }
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Flashcard added')),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}