module.exports = {
  theme: {
    fontFamily: {
      body: ["Roboto", "sans-serif"],
    },
    extend: {
      colors: {
        primary: {
          default: "#000000",
          light: "#1e1f21",
        },
        fg: {
          default: "#f9f9f9",
          dark: "#999999",
        },
        secondary: {
          default: "#0078fd",
          light: "#3290fc",
        },
      },
    },
  },
  variants: {},
  plugins: [],
  future: {
    removeDeprecatedGapUtilities: true,
  },
};
