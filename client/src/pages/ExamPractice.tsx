import React, { useState, useEffect } from 'react';
import { ExamQuestion, ExamEvaluation } from '../types';
import { fetchExamQuestions, submitExamAnswers } from '../services/api';
import { GraduationCap, Timer, CheckCircle2, XCircle, RotateCcw, AlertTriangle, ArrowRight, ArrowLeft } from 'lucide-react';

export const ExamPractice: React.FC = () => {
  const [questions, setQuestions] = useState<ExamQuestion[]>([]);
  const [currentIndex, setCurrentIndex] = useState(0);
  const [selectedAnswers, setSelectedAnswers] = useState<Record<number, number>>({});
  const [evaluation, setEvaluation] = useState<ExamEvaluation | null>(null);
  const [loading, setLoading] = useState(false);
  const [timeLeft, setTimeLeft] = useState(600); // 10 minutes timer
  const [timerActive, setTimerActive] = useState(false);

  const startNewExam = () => {
    setLoading(true);
    setEvaluation(null);
    setSelectedAnswers({});
    setCurrentIndex(0);
    setTimeLeft(600);
    fetchExamQuestions(10)
      .then((data) => {
        setQuestions(data);
        setTimerActive(true);
      })
      .catch(console.error)
      .finally(() => setLoading(false));
  };

  useEffect(() => {
    startNewExam();
  }, []);

  // Timer countdown
  useEffect(() => {
    if (!timerActive || evaluation) return;
    const interval = setInterval(() => {
      setTimeLeft((prev) => {
        if (prev <= 1) {
          clearInterval(interval);
          handleSubmitExam();
          return 0;
        }
        return prev - 1;
      });
    }, 1000);
    return () => clearInterval(interval);
  }, [timerActive, evaluation, selectedAnswers]);

  const handleSelectOption = (qId: number, optionIdx: number) => {
    if (evaluation) return;
    setSelectedAnswers((prev) => ({
      ...prev,
      [qId]: optionIdx
    }));
  };

  const handleSubmitExam = async () => {
    setTimerActive(false);
    setLoading(true);
    try {
      const result = await submitExamAnswers(selectedAnswers);
      setEvaluation(result);
      window.scrollTo({ top: 0, behavior: 'smooth' });
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const formatTimer = (seconds: number) => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${String(mins).padStart(2, '0')}:${String(secs).padStart(2, '0')}`;
  };

  const currentQ = questions[currentIndex];

  return (
    <div className="max-w-3xl mx-auto space-y-6 px-4">
      {/* Header */}
      <div className="text-center space-y-2">
        <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-teal-50 dark:bg-teal-950/80 border border-teal-200 dark:border-teal-800 text-teal-700 dark:text-teal-300 text-xs font-semibold">
          <GraduationCap className="w-3.5 h-3.5" />
          <span>Sarathi Parivahan LL Test Simulator</span>
        </div>
        <h1 className="text-2xl sm:text-3xl font-extrabold text-slate-900 dark:text-white">
          RTO Learner's Licence Practice Exam
        </h1>
        <p className="text-xs sm:text-sm text-slate-500 dark:text-slate-400">
          Prepare for your official computer-based RTO Driving Licence theory test (Passing: 60%+)
        </p>
      </div>

      {/* Evaluation Results Banner */}
      {evaluation && (
        <div
          className={`rounded-3xl p-6 sm:p-8 text-white shadow-xl space-y-4 animate-fadeIn ${
            evaluation.passed
              ? 'bg-gradient-to-br from-emerald-900 via-teal-900 to-slate-900 border border-emerald-500/40'
              : 'bg-gradient-to-br from-rose-900 via-red-950 to-slate-900 border border-rose-500/40'
          }`}
        >
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              {evaluation.passed ? (
                <div className="w-12 h-12 rounded-2xl bg-emerald-500 flex items-center justify-center text-slate-950">
                  <CheckCircle2 className="w-7 h-7" />
                </div>
              ) : (
                <div className="w-12 h-12 rounded-2xl bg-rose-500 flex items-center justify-center text-white">
                  <XCircle className="w-7 h-7" />
                </div>
              )}
              <div>
                <span className="text-[10px] uppercase font-bold tracking-widest text-slate-300">
                  Exam Result
                </span>
                <h3 className="text-xl sm:text-2xl font-black">
                  {evaluation.passed ? 'TEST PASSED!' : 'NEEDS PRACTICE'}
                </h3>
              </div>
            </div>

            <div className="text-right">
              <span className="text-3xl sm:text-4xl font-black font-mono">
                {evaluation.score}/{evaluation.total}
              </span>
              <span className="text-xs text-slate-300 block font-semibold">
                Score: {evaluation.percentage}%
              </span>
            </div>
          </div>

          <p className="text-xs sm:text-sm text-slate-200 leading-relaxed border-t border-white/10 pt-3">
            {evaluation.feedback}
          </p>

          <button
            onClick={startNewExam}
            className="w-full bg-white text-slate-900 hover:bg-slate-100 font-bold py-3 rounded-xl shadow transition-all flex items-center justify-center gap-2 text-xs"
          >
            <RotateCcw className="w-4 h-4" />
            <span>Retake Mock Exam with Fresh Questions</span>
          </button>
        </div>
      )}

      {/* Active Question View */}
      {!evaluation && currentQ && (
        <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl p-6 sm:p-8 shadow-sm space-y-6">
          {/* Progress and Timer */}
          <div className="flex items-center justify-between border-b border-slate-100 dark:border-slate-800 pb-4">
            <div className="flex items-center gap-2">
              <span className="px-3 py-1 rounded-xl bg-blue-100 dark:bg-blue-950/80 text-blue-700 dark:text-blue-300 font-mono font-bold text-xs">
                Question {currentIndex + 1} of {questions.length}
              </span>
            </div>

            <div className="flex items-center gap-2 font-mono font-bold text-sm text-amber-600 dark:text-amber-400">
              <Timer className="w-4 h-4" />
              <span>{formatTimer(timeLeft)}</span>
            </div>
          </div>

          {/* Question Prompt */}
          <h3 className="text-base sm:text-lg font-bold text-slate-900 dark:text-white leading-relaxed">
            {currentQ.question}
          </h3>

          {/* Options List */}
          <div className="space-y-3">
            {currentQ.options.map((option, idx) => {
              const isSelected = selectedAnswers[currentQ.id] === idx;
              return (
                <button
                  key={idx}
                  onClick={() => handleSelectOption(currentQ.id, idx)}
                  className={`w-full text-left p-4 rounded-2xl border-2 transition-all flex items-start gap-3 text-xs sm:text-sm ${
                    isSelected
                      ? 'border-blue-600 bg-blue-50/70 dark:bg-blue-950/40 text-blue-950 dark:text-blue-100 font-semibold shadow-sm'
                      : 'border-slate-200 dark:border-slate-800 bg-slate-50 dark:bg-slate-800/40 text-slate-700 dark:text-slate-300 hover:border-slate-300 dark:hover:border-slate-700'
                  }`}
                >
                  <span
                    className={`w-6 h-6 rounded-full flex items-center justify-center font-mono text-xs shrink-0 font-bold ${
                      isSelected
                        ? 'bg-blue-600 text-white'
                        : 'bg-slate-200 dark:bg-slate-700 text-slate-700 dark:text-slate-300'
                    }`}
                  >
                    {String.fromCharCode(65 + idx)}
                  </span>
                  <span className="leading-relaxed mt-0.5">{option}</span>
                </button>
              );
            })}
          </div>

          {/* Navigation and Submit */}
          <div className="flex items-center justify-between pt-4 border-t border-slate-100 dark:border-slate-800">
            <button
              onClick={() => setCurrentIndex((prev) => Math.max(0, prev - 1))}
              disabled={currentIndex === 0}
              className="px-4 py-2 rounded-xl text-xs font-semibold text-slate-600 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800 disabled:opacity-30 flex items-center gap-1.5"
            >
              <ArrowLeft className="w-3.5 h-3.5" />
              <span>Previous</span>
            </button>

            {currentIndex < questions.length - 1 ? (
              <button
                onClick={() => setCurrentIndex((prev) => Math.min(questions.length - 1, prev + 1))}
                className="bg-blue-600 hover:bg-blue-700 text-white font-bold px-5 py-2.5 rounded-xl text-xs flex items-center gap-1.5 shadow-md"
              >
                <span>Next Question</span>
                <ArrowRight className="w-3.5 h-3.5" />
              </button>
            ) : (
              <button
                onClick={handleSubmitExam}
                className="bg-emerald-600 hover:bg-emerald-700 text-white font-bold px-6 py-2.5 rounded-xl text-xs flex items-center gap-1.5 shadow-md"
              >
                <CheckCircle2 className="w-4 h-4" />
                <span>Submit Exam Now</span>
              </button>
            )}
          </div>
        </div>
      )}

      {/* Review Section if Evaluated */}
      {evaluation && (
        <div className="space-y-4">
          <h3 className="font-bold text-base text-slate-900 dark:text-white">
            Detailed Answers & Explanations
          </h3>

          <div className="space-y-3">
            {evaluation.details.map((item, idx) => (
              <div
                key={item.id}
                className={`p-5 rounded-2xl border text-xs space-y-2.5 ${
                  item.isCorrect
                    ? 'bg-emerald-50/50 dark:bg-emerald-950/20 border-emerald-200 dark:border-emerald-900'
                    : 'bg-rose-50/50 dark:bg-rose-950/20 border-rose-200 dark:border-rose-900'
                }`}
              >
                <div className="flex items-start justify-between gap-2">
                  <span className="font-bold text-slate-900 dark:text-white">
                    {idx + 1}. {item.question}
                  </span>
                  <span
                    className={`px-2 py-0.5 rounded text-[10px] font-bold shrink-0 ${
                      item.isCorrect
                        ? 'bg-emerald-100 text-emerald-800 dark:bg-emerald-900/60 dark:text-emerald-300'
                        : 'bg-rose-100 text-rose-800 dark:bg-rose-900/60 dark:text-rose-300'
                    }`}
                  >
                    {item.isCorrect ? 'Correct' : 'Incorrect'}
                  </span>
                </div>

                <div className="space-y-1 text-slate-600 dark:text-slate-300">
                  <div>
                    <span>Your Answer: </span>
                    <strong className={item.isCorrect ? 'text-emerald-600' : 'text-rose-600'}>
                      {item.options[item.selectedAnswer] || 'Not Answered'}
                    </strong>
                  </div>
                  {!item.isCorrect && (
                    <div>
                      <span>Correct Answer: </span>
                      <strong className="text-emerald-600 dark:text-emerald-400">
                        {item.options[item.correctAnswer]}
                      </strong>
                    </div>
                  )}
                </div>

                <div className="bg-white/70 dark:bg-slate-900/70 p-3 rounded-xl border border-slate-200/60 dark:border-slate-800 text-[11px] text-slate-500 dark:text-slate-400">
                  <strong className="text-slate-700 dark:text-slate-300">Rule Explanation: </strong>
                  {item.explanation}
                </div>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
};
