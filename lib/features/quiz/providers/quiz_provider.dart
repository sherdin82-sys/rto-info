import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../mock_exam/data/quiz_questions_data.dart';
import '../../../shared/models/quiz_question_entity.dart';

final quizQuestionsProvider = Provider<List<QuizQuestionEntity>>((ref) {
  return QuizQuestionsData.parivahanExamQuestions;
});
