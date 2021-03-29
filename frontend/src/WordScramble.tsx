import Score from "./Score";
import Question from "./Question";
import Answer from "./Answer";
import Timer from "./Timer";
import React, { useState } from "react";

function WordScramble() {
  const [questionId, setQuestionId] = useState("");
  const [score, setScore] = useState(0);
  const [questionNumber, setQuestionNumber] = useState(1);
  const [gameOver, setGameOver] = useState(false);

  const gameLengthInMinutes = 3;
  const gameLengthInSeconds = gameLengthInMinutes * 60;

  const setCurrentScore = (points: number) => {
    if (points) {
      setScore(score + points);
      setQuestionNumber(questionNumber + 1);
    }
  };

  return (
    <div className="container">
      <div className="jumbotron">
        <h1 className="text-center">Word Scramble</h1>
        <hr className="my-4" />
        <Score score={score} />
        {gameOver ? (
          <h2>Game Over!</h2>
        ) : (
          <span>
            <Timer
              timeInSeconds={gameLengthInSeconds}
              onComplete={() => setGameOver(true)}
            />
            <Question
              questionNumber={questionNumber}
              setId={setQuestionId}
              setScore={setCurrentScore}
            />
            <Answer id={questionId} setPoints={setCurrentScore} />
          </span>
        )}
      </div>
    </div>
  );
}

export default WordScramble;
