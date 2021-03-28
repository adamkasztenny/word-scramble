import { useEffect, useState } from "react";

interface Props {
  timeInSeconds: number;
  onComplete: () => void;
}

function Timer(props: Props) {
  const [timeRemainingInSeconds, setTimeRemaining] = useState(
    props.timeInSeconds
  );

  const onComplete = props.onComplete;

  useEffect(() => {
    const oneSecondInMilliseconds = 1000;

    const timer = setInterval(() => {
      const currentTimeRemainingInSeconds = timeRemainingInSeconds - 1;

      if (currentTimeRemainingInSeconds < 0) {
        return;
      }

      if (currentTimeRemainingInSeconds === 0) {
        onComplete();
      }
      setTimeRemaining(currentTimeRemainingInSeconds);
    }, oneSecondInMilliseconds);

    return () => clearInterval(timer);
  }, [timeRemainingInSeconds, onComplete]);

  const mintuesRemaining = Math.floor(timeRemainingInSeconds / 60);
  const secondsRemaining = ("0" + (timeRemainingInSeconds % 60)).slice(-2);
  const formattedTimeRemaining = `${mintuesRemaining}:${secondsRemaining}`;

  return (
    <div className="alert alert-secondary" role="alert">
      Time Remaining: {formattedTimeRemaining}
    </div>
  );
}

export default Timer;
