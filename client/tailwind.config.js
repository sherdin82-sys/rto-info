/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        rto: {
          saffron: '#FF9933',
          navy: '#000080',
          emerald: '#138808',
          gold: '#FFB800',
          dark: '#0B132B',
          surface: '#1C2541',
          accent: '#3A86FF',
        }
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', '-apple-system', 'sans-serif'],
        plate: ['"Lucida Console"', 'Monaco', 'monospace'],
      }
    },
  },
  plugins: [],
}
