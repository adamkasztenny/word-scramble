import axios from "axios";

interface SkipProps {
  questionId: string;
  setPoints: (score: number) => void;
}

interface Response {
  points: number;
}

function Skip(props: SkipProps) {
  const setPoints = props.setPoints;

  const skipQuestion = async () => {
    try {
      const result = await axios.delete<Response>(`/api/question/${props.questionId}`);
      if (result) {
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
    </div>
  );
}

export default Skip;
