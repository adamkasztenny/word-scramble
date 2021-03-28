import { render, screen, waitFor } from "@testing-library/react";
import Timer from "./Timer";

test("counts down to 0 starting from the number of seconds provided", async () => {
  render(<Timer timeInSeconds={2} onComplete={() => null} />);

  await waitFor(() => screen.getByText("Time Remaining: 0:02"));
  await waitFor(() => screen.getByText("Time Remaining: 0:01"));
  await waitFor(() => screen.getByText("Time Remaining: 0:00"));

  const endingTimerValue = screen.getByText("Time Remaining: 0:00");
  expect(endingTimerValue).toBeInTheDocument();
});

test("emits when the timer is complete", async () => {
  let callbackCalled = false;
  const onComplete = () => {
    callbackCalled = true;
  };

  render(<Timer timeInSeconds={1} onComplete={onComplete} />);

  await waitFor(() => screen.getByText("Time Remaining: 0:01"));
  await waitFor(() => screen.getByText("Time Remaining: 0:00"));

  expect(callbackCalled).toBe(true);
});
