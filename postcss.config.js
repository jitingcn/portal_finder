/* eslint-disable global-require,import/no-extraneous-dependencies,no-unused-vars */

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
  ]
}
