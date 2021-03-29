import React from "react";
import { render, screen } from "@testing-library/react";
import App from "./App";

test("renders title", () => {
  render(<App />);

  const title = screen.getByText(/Word Scramble/i);
  expect(title).toBeInTheDocument();
});

test("renders initial question number", () => {
  render(<App />);

  const firstQuestion = screen.getByText(/Question 1/i);
  expect(firstQuestion).toBeInTheDocument();
});

test("renders initial score", () => {
  render(<App />);

  const initialScore = screen.getByText(/Score: 0/i);
  expect(initialScore).toBeInTheDocument();
});

test("renders initial time remaining", () => {
  render(<App />);

  const initialTimeRemaining = screen.getByText(/Time Remaining: 3:00/i);
  expect(initialTimeRemaining).toBeInTheDocument();
});
