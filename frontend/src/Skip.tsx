import axios from "axios";
import { useState } from "react";

interface SkipProps {
  questionId: string;
  setPoints: (score: number) => void;
}

interface Response {
  points: number;
}

function Skip(props: SkipProps) {
  const [skipped, setSkipped] = useState(false);

  const setPoints = props.setPoints;

  const skipQuestion = async () => {
    try {
      const result = await axios.delete<Response>(`http://localhost:8080/question/${props.questionId}`);
      if (result) {
        setSkipped(true);
        setPoints(result.data.points);
      }
    } catch (error) {
      console.log(error);
    }
  };

  return (
    <div>
      <button type="button" className="btn btn-warning" onClick={skipQuestion}>
        Skip
      </button>

      <div>{skipped ? "Skipped!" : null}</div>
    </div>
  );
}

export default Skip;
