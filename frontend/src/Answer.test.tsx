import { render, screen, waitFor, fireEvent } from "@testing-library/react";
import Answer from "./Answer";
import axios from "axios";

jest.mock("axios");
const mockedAxios = axios as jest.Mocked<typeof axios>;
const correctAnswer = "correctAnswer";
const incorrectAnswer = "incorrectAnswer";

test("sends the correct answer to the question to the API", async () => {
  mockedAxios.post.mockImplementation(() =>
    Promise.resolve({ data: { correct: true, points: 4 } })
  );

  render(<Answer id={"123"} setPoints={() => null} />);
  answerQuestionCorrectly();

  expect(axios.post).toHaveBeenCalledWith("/api/question/123", {
    answer: correctAnswer,
  });
});

test("sends an incorrect answer to the question to the API", async () => {
  mockedAxios.post.mockImplementation(() =>
    Promise.resolve({ data: { correct: false, points: 0 } })
  );

  render(<Answer id={"123"} setPoints={() => null} />);
  answerQuestionIncorrectly();

  expect(axios.post).toHaveBeenCalledWith("/api/question/123", {
    answer: incorrectAnswer,
  });
});

test("emits the points for the correct answer", async () => {
  mockedAxios.post.mockImplementation(() =>
    Promise.resolve({ data: { correct: true, points: 10 } })
  );

  let points = -1;
  const setPoints = (emittedPoints: number) => {
    points = emittedPoints;
  };

  render(<Answer id={"123"} setPoints={setPoints} />);
  answerQuestionCorrectly();

  await waitFor(() => points === 10);
});

test("emits the points for an incorrect answer", async () => {
  mockedAxios.post.mockImplementation(() =>
    Promise.resolve({ data: { correct: false, points: 0 } })
  );

  let points = -1;
  const setPoints = (emittedPoints: number) => {
    points = emittedPoints;
  };

  render(<Answer id={"123"} setPoints={setPoints} />);
  answerQuestionIncorrectly();

  await waitFor(() => points === 0);
});

test("clears the input when the question is answered correctly", async () => {
  mockedAxios.post.mockImplementation(() =>
    Promise.resolve({ data: { correct: true, points: 10 } })
  );

  render(<Answer id={"123"} setPoints={() => null} />);

  answerQuestionCorrectly();
  expect((screen.getByTestId("answer") as HTMLInputElement).value).not.toBe("");

  await waitFor(() => (screen.getByTestId("answer") as HTMLInputElement).value === "");
});

test("shows a success border around the input when the question is answered correctly", async () => {
  mockedAxios.post.mockImplementation(() =>
    Promise.resolve({ data: { correct: true, points: 4 } })
  );

  render(<Answer id={"123"} setPoints={() => null} />);
  answerQuestionCorrectly();

  expect(screen.getByTestId("answer")).not.toHaveClass("border border-success");

  await waitFor(() => screen.getByTestId("answer").className === "border border-success");
});

test("shows a danger border around the input when the question is answered incorrectly", async () => {
  mockedAxios.post.mockImplementation(() =>
    Promise.resolve({ data: { correct: false } })
  );

  render(<Answer id={"123"} setPoints={() => null} />);
  answerQuestionIncorrectly();

  expect(screen.getByTestId("answer")).toHaveClass("border border-danger");

  await waitFor(() => screen.getByTestId("answer").className === "border border-danger");
});

function answerQuestionCorrectly() {
  fireEvent.change(screen.getByTestId("answer"), {
    target: { value: correctAnswer },
  });
}

function answerQuestionIncorrectly() {
  fireEvent.change(screen.getByTestId("answer"), {
    target: { value: incorrectAnswer },
  });
}
