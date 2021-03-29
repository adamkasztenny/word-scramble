import React, { useState, useEffect } from "react";
import axios from "axios";
import Skip from "./Skip";

interface Props {
  questionNumber: number;
  setId: (id: string) => void;
  setScore: (score: number) => void;
}

interface Response {
  id: string;
  scrambled_word: string;
}

function Question(props: Props) {
  const [scrambledWord, setScrambledWord] = useState("");
  const [questionId, setQuestionId] = useState("");

  const setId = props.setId;
  const setScore = props.setScore;

  useEffect(() => {
    const getScrambledWord = async () => {
      try {
        const result = await axios.get<Response>(
          "/api/question"
        );
        setQuestionId(result.data.id);
        setId(result.data.id);
        setScrambledWord(result.data.scrambled_word);
      } catch (error) {
        console.log(error);
      }
    };
    getScrambledWord();
  }, [setId, props.questionNumber]);

  return (
    <div>
      <h3>Question {props.questionNumber}</h3>
      <h4 className="border border-primary">{scrambledWord}</h4>
      <span data-testid="skip">
        <Skip questionId={questionId} setPoints={setScore} />
      </span>
    </div>
  );
}

export default Question;
