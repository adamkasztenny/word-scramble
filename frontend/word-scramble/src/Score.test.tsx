import { render, screen } from "@testing-library/react";
import Score from "./Score";

test("renders current score", () => {
  render(<Score score={5} />);
  const score = screen.getByText(/Score: 5/i);
  expect(score).toBeInTheDocument();
});
