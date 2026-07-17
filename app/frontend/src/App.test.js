import { render, screen } from '@testing-library/react';
import App from './App';

test('renders User Manager app', () => {
  render(<App />);
  expect(screen.getByText(/User Manager/i)).toBeInTheDocument();
  expect(screen.getByPlaceholderText(/Enter name/i)).toBeInTheDocument();
  expect(screen.getByText(/Add/i)).toBeInTheDocument();
});