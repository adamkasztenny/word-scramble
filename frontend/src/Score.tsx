interface ScoreProps {
  score: number;
}

function Score(props: ScoreProps) {
  return (
    <div className="alert alert-info" role="alert">
      Score: {props.score}
    </div>
  );
}

export default Score;
