import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/quiz_question_entity.dart';
import '../../mock_exam/data/quiz_questions_data.dart';

final quizQuestionsProvider = Provider<List<QuizQuestion>>((ref) {
  return QuizQuestionsData.questions;
});
