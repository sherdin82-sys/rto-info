import express from 'express';
import { EXAM_QUESTIONS, getRandomExamQuestions } from '../data/mockExams.js';
import { TRAFFIC_SIGNS } from '../data/trafficSigns.js';
import { RTO_SERVICES } from '../data/rtoServices.js';

const router = express.Router();

// Get questions for Learner Licence Mock Exam
router.get('/exam/questions', (req, res) => {
  const count = parseInt(req.query.count, 10) || 10;
  const questions = getRandomExamQuestions(count).map(q => ({
    id: q.id,
    question: q.question,
    options: q.options
  }));
  return res.json({ success: true, count: questions.length, data: questions });
});

// Evaluate submitted mock exam
router.post('/exam/evaluate', (req, res) => {
  try {
    const { answers } = req.body; // e.g. { "1": 2, "2": 0, ... }
    if (!answers || typeof answers !== 'object') {
      return res.status(400).json({ error: 'Answers object is required' });
    }

    let correctCount = 0;
    const results = [];

    for (const [idStr, selectedIndex] of Object.entries(answers)) {
      const qId = parseInt(idStr, 10);
      const question = EXAM_QUESTIONS.find(q => q.id === qId);
      if (question) {
        const isCorrect = (question.correctAnswer === selectedIndex);
        if (isCorrect) correctCount++;
        results.push({
          id: question.id,
          question: question.question,
          options: question.options,
          selectedAnswer: selectedIndex,
          correctAnswer: question.correctAnswer,
          isCorrect,
          explanation: question.explanation
        });
      }
    }

    const totalQuestions = results.length || 1;
    const scorePercentage = Math.round((correctCount / totalQuestions) * 100);
    // Standard RTO passing criteria is >= 60%
    const isPassed = scorePercentage >= 60;

    return res.json({
      success: true,
      data: {
        score: correctCount,
        total: totalQuestions,
        percentage: scorePercentage,
        passed: isPassed,
        feedback: isPassed
          ? 'Congratulations! You passed the RTO Learner’s Licence practice exam!'
          : 'Score below passing mark (60%). Review incorrect traffic rules and try again.',
        details: results
      }
    });
  } catch (error) {
    console.error('Exam evaluation error:', error);
    return res.status(500).json({ error: 'Failed to evaluate exam' });
  }
});

// Get traffic signs
router.get('/traffic-signs', (req, res) => {
  const { category } = req.query;
  let list = [...TRAFFIC_SIGNS];
  if (category) {
    list = list.filter(s => s.category.toLowerCase() === category.toLowerCase());
  }
  return res.json({ success: true, count: list.length, data: list });
});

// Get RTO services, forms and fees
router.get('/services', (req, res) => {
  return res.json({ success: true, count: RTO_SERVICES.length, data: RTO_SERVICES });
});

export default router;
