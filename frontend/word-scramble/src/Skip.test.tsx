import { render, screen, waitFor } from "@testing-library/react";
import Skip from "./Skip";
import axios from "axios";

jest.mock("axios");
const mockedAxios = axios as jest.Mocked<typeof axios>;

const questionId = "some-id";

test("skips the current question if the button was clicked", async () => {
  mockedAxios.get.mockImplementation(() =>
    Promise.resolve({ data: { points: -1 } })
  );

  render(<Skip questionId={questionId} setPoints={() => null} />);
  const skipButton = screen.getByText(/Skip/);
  skipButton.click();

  expect(axios.post).toHaveBeenCalledWith("http://localhost:8080/skip", {
    id: questionId,
  });
});

test("does not skip the current question if the button was not clicked", async () => {
  render(<Skip questionId={questionId} setPoints={() => null} />);

  expect(axios.post).not.toHaveBeenCalled();
});

test("emits the points lost when a question is skipped", async () => {
  mockedAxios.post.mockImplementation(() =>
    Promise.resolve({ data: { points: -10 } })
  );

  let points = 0;
  const setPoints = (emittedPoints: number) => {
    points = emittedPoints;
  };

  render(<Skip questionId={questionId} setPoints={setPoints} />);
  const skipButton = screen.getByText(/Skip/);
  skipButton.click();
  await waitFor(() => screen.getByText("Skipped!"));

  expect(points).toBe(-10);
});
