import { render, screen, waitFor } from "@testing-library/react";
import Question from "./Question";
import axios from "axios";

jest.mock("axios");
const mockedAxios = axios as jest.Mocked<typeof axios>;

const scrambledWord = "owdr";
const questionId = "some-id";
const questionNumber = 2;
const stubFunction = () => null;

test("renders the scrambled word loaded from the API", async () => {
  mockedAxios.get.mockImplementation(() =>
    Promise.resolve({ data: { id: questionId, scrambled_word: scrambledWord } })
  );

  render(
    <Question
      questionNumber={questionNumber}
      setId={stubFunction}
      setScore={stubFunction}
    />
  );

  await waitFor(() => screen.getByText(scrambledWord));
});

test("renders the current question number", async () => {
  mockedAxios.get.mockImplementation(() =>
    Promise.resolve({ data: { id: questionId, scrambled_word: scrambledWord } })
  );

  render(
    <Question
      questionNumber={questionNumber}
      setId={stubFunction}
      setScore={stubFunction}
    />
  );

  await waitFor(() => screen.getByText(`Question ${questionNumber}`));
});

test("emits the question ID", async () => {
  mockedAxios.get.mockImplementation(() =>
    Promise.resolve({ data: { id: questionId, scrambled_word: scrambledWord } })
  );

  let id = "";
  const setId = (emittedId: string) => {
    id = emittedId;
  };

  render(
    <Question
      questionNumber={questionNumber}
      setId={setId}
      setScore={stubFunction}
    />
  );

  await waitFor(() => screen.getByText(scrambledWord));
  expect(id).toBe(questionId);
});

test("renders the Skip component", async () => {
  mockedAxios.get.mockImplementation(() =>
    Promise.resolve({ data: { id: questionId, scrambled_word: scrambledWord } })
  );

  render(
    <Question
      questionNumber={questionNumber}
      setId={stubFunction}
      setScore={stubFunction}
    />
  );

  await waitFor(() => screen.getByTestId("skip"));
});
