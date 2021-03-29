import { useState, useEffect } from "react";
import axios from "axios";

interface Props {
  id: string;
  setPoints: (score: number) => void;
}

interface Response {
  correct: boolean;
  points: number;
}

function Answer(props: Props) {
  const [correct, setCorrect] = useState(false);
  const [answer, setAnswer] = useState("");

  const id = props.id;
  const setPoints = props.setPoints;

  useEffect(() => {
    setAnswer("");
  }, [id]);

  useEffect(() => {
    const getResult = async () => {
      try {
        const result = await axios.post<Response>(
          `http://localhost:8080/question/${id}`,
          { answer: answer }
        );
        setPoints(result.data.points);
        setCorrect(result.data.correct);

        if (result.data.correct) {
          setAnswer("");
        }
      } catch (error) {
        console.log(error);
      }
    };
    getResult();
  }, [answer, id, setPoints]);

  const handleChange = (event: any) => {
    setAnswer(event["target"]["value"]);
  };

  return (
    <div>
      <input
        data-testid="answer"
        type="text"
        value={answer}
        onChange={handleChange}
        className={correct ? "border border-success" : "border border-danger"}
      />
    </div>
  );
}

export default Answer;
