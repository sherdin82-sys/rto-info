import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../domain/models/quiz_question_entity.dart';
import '../data/quiz_questions_data.dart';

enum ExamPhase { notStarted, inProgress, completed }

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
    return Scaffold(
      appBar: AppBar(title: const Text('RTO Mock Exam (LL Test)')),
      body: switch (_phase) {
        ExamPhase.notStarted => _buildIntroView(),
        ExamPhase.inProgress => _buildQuizView(),
        ExamPhase.completed => _buildResultView(),
      },
    );
  }

  // --- Intro View ---
  Widget _buildIntroView() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.electricBlue.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.school,
                size: 64,
                color: AppColors.electricBlue,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Parivahan Sarathi Mock Test',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Learner’s Licence (LL) Theory Test Simulator',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _introRuleItem(
                      Icons.format_list_numbered,
                      'Total Questions: 15 multiple-choice questions',
                    ),
                    const Divider(height: 16),
                    _introRuleItem(
                      Icons.check_circle_outline,
                      'Passing Criteria: 60% (At least 9 correct answers)',
                    ),
                    const Divider(height: 16),
                    _introRuleItem(
                      Icons.menu_book,
                      'Topics: Road signs, right of way, overtaking, and MV Act rules',
                    ),
                    const Divider(height: 16),
                    _introRuleItem(
                      Icons.lightbulb_outline,
                      'Instant Feedback: Explanations provided after every question',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                icon: const Icon(Icons.play_arrow),
                label: const Text(
                  'Start Practice Test',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: _startExam,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _introRuleItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.saffron),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  // --- Active Quiz View ---
  Widget _buildQuizView() {
    final question = _questions[_currentIndex];
    final selectedOption = _userAnswers[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;

    return Column(
      children: [
        // Progress header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${_currentIndex + 1} of ${_questions.length}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: AppColors.electricBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: Colors.grey.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation(
                    AppColors.electricBlue,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Question & Options
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Question Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Text(
                    question.question,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Options
              ...List.generate(question.options.length, (optIndex) {
                final optionText = question.options[optIndex];
                final isSelected = selectedOption == optIndex;
                final isCorrect = optIndex == question.correctIndex;

                Color cardColor = Theme.of(context).cardColor;
                Color borderColor = Colors.grey.withOpacity(0.3);
                Widget? trailingIcon;

                if (_answeredCurrent) {
                  if (isCorrect) {
                    cardColor = Colors.green.withOpacity(0.12);
                    borderColor = Colors.green;
                    trailingIcon = const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    );
                  } else if (isSelected && !isCorrect) {
                    cardColor = Colors.red.withOpacity(0.12);
                    borderColor = Colors.red;
                    trailingIcon = const Icon(Icons.cancel, color: Colors.red);
                  }
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _selectOption(optIndex),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: borderColor,
                          width: isSelected || (_answeredCurrent && isCorrect)
                              ? 2
                              : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? AppColors.electricBlue
                                  : Colors.grey.withOpacity(0.2),
                            ),
                            child: Center(
                              child: Text(
                                String.fromCharCode(
                                  65 + optIndex,
                                ), // A, B, C, D
                                style: TextStyle(
                                  color: isSelected ? Colors.white : null,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              optionText,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
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

              // Explanation Box (Shown after answering)
              if (_answeredCurrent) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.lightbulb,
                        color: Colors.amber,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'EXPLANATION',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              question.explanation,
                              style: const TextStyle(fontSize: 13, height: 1.3),
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
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: _nextQuestion,
                child: Text(
                  _currentIndex < _questions.length - 1
                      ? 'Next Question'
                      : 'View Exam Results',
                ),
              ),
            ),
          ),
      ],
    );
  }

  // --- Completed Result View ---
  Widget _buildResultView() {
    final score = _calculateScore();
    final total = _questions.length;
    final percentage = (score / total) * 100;
    final isPassed = score >= 9;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Score Badge Card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isPassed
                  ? [const Color(0xFF065F46), const Color(0xFF047857)]
                  : [const Color(0xFF991B1B), const Color(0xFFB91C1C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Icon(
                isPassed ? Icons.verified : Icons.error_outline,
                size: 54,
                color: Colors.white,
              ),
              const SizedBox(height: 12),
              Text(
                isPassed ? 'CONGRATULATIONS! TEST PASSED' : 'TEST NOT CLEARED',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your Score: $score / $total (${percentage.toStringAsFixed(1)}%)',
                style: const TextStyle(
                  color: Colors.amberAccent,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                isPassed
                    ? 'You have qualified the Parivahan Learner’s Licence simulation!'
                    : 'Minimum 9 correct answers (60%) required to pass. Practice more and try again.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Action Buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Retake Test'),
                onPressed: _startExam,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back to Home'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),

        const Text(
          'Question Review',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        // Question-by-question review
        ...List.generate(_questions.length, (i) {
          final q = _questions[i];
          final userAns = _userAnswers[i];
          final isCorrect = userAns == q.correctIndex;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        isCorrect ? Icons.check_circle : Icons.cancel,
                        color: isCorrect ? Colors.green : Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Q${i + 1}: ${q.question}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 16),
                  Text(
                    'Correct Answer: ${q.options[q.correctIndex]}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  if (!isCorrect && userAns != null)
                    Text(
                      'Your Answer: ${q.options[userAns]}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  const SizedBox(height: 6),
                  Text(
                    q.explanation,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
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
