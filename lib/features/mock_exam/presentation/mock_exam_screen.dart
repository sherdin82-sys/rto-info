import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/app_app_bar.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/premium_card.dart';
import '../data/quiz_questions_data.dart';
import '../domain/models/quiz_question_entity.dart';

enum ExamPhase { notStarted, inProgress, completed }

/// MockExamScreen provides an interactive Learner's Licence (LL) theory test simulation
/// compliant with Parivahan Sarathi exam formats and Section 139 MV Act rules.
class MockExamScreen extends StatefulWidget {
  const MockExamScreen({super.key});

  @override
  State<MockExamScreen> createState() => _MockExamScreenState();
}

class _MockExamScreenState extends State<MockExamScreen> {
  ExamPhase _phase = ExamPhase.notStarted;
  int _currentIndex = 0;
  final Map<int, int> _userAnswers = {}; // questionIndex -> selectedOptionIndex
  bool _answeredCurrent = false;

  final List<QuizQuestion> _questions = QuizQuestionsData.questions;

  void _startExam() {
    setState(() {
      _phase = ExamPhase.inProgress;
      _currentIndex = 0;
      _userAnswers.clear();
      _answeredCurrent = false;
    });
  }

  void _selectOption(int optionIndex) {
    if (_answeredCurrent) return;

    setState(() {
      _userAnswers[_currentIndex] = optionIndex;
      _answeredCurrent = true;
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _answeredCurrent = _userAnswers.containsKey(_currentIndex);
      });
    } else {
      setState(() {
        _phase = ExamPhase.completed;
      });
    }
  }

  int _calculateScore() {
    int score = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_userAnswers[i] == _questions[i].correctIndex) {
        score++;
      }
    }
    return score;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppAppBar(
        title: 'RTO Mock Exam',
        subtitle: _phase == ExamPhase.inProgress
            ? 'Question ${_currentIndex + 1} of ${_questions.length}'
            : 'Parivahan Sarathi LL Simulator',
      ),
      body: SafeArea(
        child: switch (_phase) {
          ExamPhase.notStarted => _buildIntroView(isDark),
          ExamPhase.inProgress => _buildQuizView(isDark),
          ExamPhase.completed => _buildResultView(isDark),
        },
      ),
    );
  }

  // --- Intro View ---
  Widget _buildIntroView(bool isDark) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.l,
          vertical: AppSpacing.xl,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.electricBlue.withOpacity(0.2),
                    AppColors.saffron.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.electricBlue.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.school_rounded,
                size: 56,
                color: AppColors.electricBlue,
              ),
            ),
            const SizedBox(height: AppSpacing.l),
            Text(
              'Parivahan Sarathi Mock Test',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : AppColors.lightTextPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Learner’s Licence (LL) Theory Test Simulator',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            PremiumCard(
              padding: const EdgeInsets.all(AppSpacing.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 18,
                        color: AppColors.saffron,
                      ),
                      const SizedBox(width: AppSpacing.s),
                      Text(
                        'EXAMINATION GUIDELINES',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.m),
                  _introRuleItem(
                    isDark,
                    Icons.format_list_numbered_rounded,
                    'Total Questions',
                    '15 multiple-choice questions curated from official state RTO question banks.',
                  ),
                  const Divider(height: AppSpacing.l),
                  _introRuleItem(
                    isDark,
                    Icons.verified_outlined,
                    'Passing Criteria',
                    'Minimum 60% score required (at least 9 correct answers out of 15).',
                  ),
                  const Divider(height: AppSpacing.l),
                  _introRuleItem(
                    isDark,
                    Icons.traffic_rounded,
                    'Syllabus Coverage',
                    'Mandatory road signs, traffic signals, right-of-way, and Motor Vehicles Act rules.',
                  ),
                  const Divider(height: AppSpacing.l),
                  _introRuleItem(
                    isDark,
                    Icons.lightbulb_outline_rounded,
                    'Instant Explanations',
                    'Immediate detailed feedback and legal reasoning displayed after answering each question.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            AppButton(
              label: 'Start Practice Test',
              icon: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 20,
              ),
              onPressed: _startExam,
            ),
          ],
        ),
      ),
    );
  }

  Widget _introRuleItem(
    bool isDark,
    IconData icon,
    String title,
    String description,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.electricBlue.withOpacity(0.12),
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
          child: Icon(icon, size: 18, color: AppColors.electricBlue),
        ),
        const SizedBox(width: AppSpacing.m),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- Active Quiz View ---
  Widget _buildQuizView(bool isDark) {
    final question = _questions[_currentIndex];
    final selectedOption = _userAnswers[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;

    return Column(
      children: [
        // Progress header
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.l,
            vertical: AppSpacing.m,
          ),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            border: Border(
              bottom: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.electricBlue.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Text(
                          'Question ${_currentIndex + 1} / ${_questions.length}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppColors.electricBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${(progress * 100).toInt()}% Completed',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.xs),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: isDark
                      ? AppColors.darkSurfaceAlt
                      : AppColors.lightSurfaceAlt,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.electricBlue,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Question & Options List
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.l),
            children: [
              // Question Card
              PremiumCard(
                padding: const EdgeInsets.all(AppSpacing.l),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'QUESTION ${_currentIndex + 1}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: AppColors.saffron,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s),
                    Text(
                      question.question,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 1.4,
                        color: isDark
                            ? Colors.white
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.l),

              // Options
              ...List.generate(question.options.length, (optIndex) {
                final optionText = question.options[optIndex];
                final isSelected = selectedOption == optIndex;
                final isCorrect = optIndex == question.correctIndex;

                Color cardColor = isDark
                    ? AppColors.darkSurface
                    : AppColors.lightSurface;
                Color borderColor = isDark
                    ? AppColors.darkBorder
                    : AppColors.lightBorder;
                Color letterBg = isDark
                    ? AppColors.darkSurfaceAlt
                    : AppColors.lightSurfaceAlt;
                Color letterColor = isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary;
                Widget? trailingIcon;

                if (_answeredCurrent) {
                  if (isCorrect) {
                    cardColor = AppColors.success.withOpacity(0.12);
                    borderColor = AppColors.success;
                    letterBg = AppColors.success;
                    letterColor = Colors.white;
                    trailingIcon = const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.success,
                    );
                  } else if (isSelected && !isCorrect) {
                    cardColor = AppColors.error.withOpacity(0.12);
                    borderColor = AppColors.error;
                    letterBg = AppColors.error;
                    letterColor = Colors.white;
                    trailingIcon = const Icon(
                      Icons.cancel_rounded,
                      color: AppColors.error,
                    );
                  }
                } else if (isSelected) {
                  borderColor = AppColors.electricBlue;
                  letterBg = AppColors.electricBlue;
                  letterColor = Colors.white;
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.s),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppRadius.card),
                    onTap: () => _selectOption(optIndex),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.m,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(AppRadius.card),
                        border: Border.all(
                          color: borderColor,
                          width: isSelected || (_answeredCurrent && isCorrect)
                              ? 1.8
                              : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: letterBg,
                            ),
                            child: Center(
                              child: Text(
                                String.fromCharCode(
                                  65 + optIndex,
                                ), // A, B, C, D
                                style: TextStyle(
                                  color: letterColor,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.m),
                          Expanded(
                            child: Text(
                              optionText,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? Colors.white
                                    : AppColors.lightTextPrimary,
                              ),
                            ),
                          ),
                          if (trailingIcon != null) trailingIcon,
                        ],
                      ),
                    ),
                  ),
                );
              }),

              // Explanation Box (shown immediately after selecting an answer)
              if (_answeredCurrent) ...[
                const SizedBox(height: AppSpacing.m),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.l),
                  decoration: BoxDecoration(
                    color: AppColors.electricBlue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(AppRadius.card),
                    border: Border.all(
                      color: AppColors.electricBlue.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.lightbulb_rounded,
                        color: AppColors.saffron,
                        size: 22,
                      ),
                      const SizedBox(width: AppSpacing.s),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'OFFICIAL EXPLANATION',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                                color: AppColors.electricBlue,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              question.explanation,
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.4,
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),

        // Bottom Continue Bar
        if (_answeredCurrent)
          Container(
            padding: const EdgeInsets.all(AppSpacing.l),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
            ),
            child: AppButton(
              label: _currentIndex < _questions.length - 1
                  ? 'Next Question'
                  : 'View Exam Results',
              icon: Icon(
                _currentIndex < _questions.length - 1
                    ? Icons.arrow_forward_rounded
                    : Icons.assessment_rounded,
                color: Colors.white,
                size: 20,
              ),
              onPressed: _nextQuestion,
            ),
          ),
      ],
    );
  }

  // --- Completed Result View ---
  Widget _buildResultView(bool isDark) {
    final score = _calculateScore();
    final total = _questions.length;
    final percentage = (score / total) * 100;
    final isPassed = score >= 9;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.l),
      children: [
        // Score Badge Card
        Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isPassed
                  ? [const Color(0xFF065F46), const Color(0xFF047857)]
                  : [const Color(0xFF881337), const Color(0xFF9F1239)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppRadius.xl),
            boxShadow: [
              BoxShadow(
                color: (isPassed ? Colors.green : Colors.red).withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(
                isPassed ? Icons.verified_rounded : Icons.warning_amber_rounded,
                size: 56,
                color: Colors.white,
              ),
              const SizedBox(height: AppSpacing.m),
              Text(
                isPassed ? 'CONGRATULATIONS! TEST PASSED' : 'TEST NOT CLEARED',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: AppSpacing.s),
              Text(
                'Score: $score / $total (${percentage.toStringAsFixed(1)}%)',
                style: const TextStyle(
                  color: AppColors.metallicGold,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.s),
              Text(
                isPassed
                    ? 'You have successfully qualified the Parivahan Learner’s Licence simulation test!'
                    : 'Minimum 9 correct answers (60%) required to pass. Please review explanations and reattempt.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.l),

        // Action Buttons
        Row(
          children: [
            Expanded(
              child: AppButton(
                label: 'Retake Test',
                icon: const Icon(Icons.refresh_rounded, size: 20),
                variant: AppButtonVariant.secondary,
                onPressed: _startExam,
              ),
            ),
            const SizedBox(width: AppSpacing.m),
            Expanded(
              child: AppButton(
                label: 'Back to Home',
                icon: const Icon(
                  Icons.home_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),

        Text(
          'QUESTION REVIEW',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
        const SizedBox(height: AppSpacing.m),

        // Question-by-question review
        ...List.generate(_questions.length, (i) {
          final q = _questions[i];
          final userAns = _userAnswers[i];
          final isCorrect = userAns == q.correctIndex;

          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.m),
            child: PremiumCard(
              padding: const EdgeInsets.all(AppSpacing.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        isCorrect
                            ? Icons.check_circle_rounded
                            : Icons.cancel_rounded,
                        color: isCorrect ? AppColors.success : AppColors.error,
                        size: 20,
                      ),
                      const SizedBox(width: AppSpacing.s),
                      Expanded(
                        child: Text(
                          'Q${i + 1}: ${q.question}',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: isDark
                                ? Colors.white
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: AppSpacing.l),
                  Text(
                    'Correct Answer: ${q.options[q.correctIndex]}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.success,
                    ),
                  ),
                  if (!isCorrect && userAns != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Your Answer: ${q.options[userAns]}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.s),
                  Text(
                    q.explanation,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
