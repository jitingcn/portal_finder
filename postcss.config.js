/* eslint-disable global-require,import/no-extraneous-dependencies,no-unused-vars */
const purgecss = require("@fullhuman/postcss-purgecss")({
  // Specify the paths to all of the template files in your project
  content: [
    "./app/javascript/stylesheets/**/*.*css",
    "./app/javascript/controllers/*.js",
    "./app/views/**/*.*",
    "./app/helpers/**/*.*",
  ],
  whitelistPatterns: [/leaflet/, /marker/],
  // This is the function used to extract class names from your templates
  defaultExtractor: (content) => {
    // Capture as liberally as possible, including things like `h-(screen-1.5)`
    const broadMatches = content.match(/[^<>"'`\s]*[^<>"'`\s:]/g) || [];

    // Capture classes within other delimiters like .block(class="w-1/2") in Pug
    const innerMatches = content.match(/[^<>"'`\s.()]*[^<>"'`\s.():]/g) || [];

    return broadMatches.concat(innerMatches);
  },
});
module.exports = {
  plugins: [
    require("postcss-import"),
    require("tailwindcss")("./app/javascript/stylesheets/tailwind.config.js"),
    require("postcss-nested"),
    require("autoprefixer"),
    require('postcss-flexbugs-fixes'),
    require('postcss-preset-env')({
      autoprefixer: {
        flexbox: 'no-2009'
      },
      stage: 3
    }),
    ...(process.env.NODE_ENV === "production" ? [purgecss] : []),
  ]
}
