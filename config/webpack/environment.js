const { environment } = require('@rails/webpacker')
const webpack = require('webpack')

environment.plugins.append('Provide',
    new webpack.ProvidePlugin({
      L: 'leaflet',
      _: 'lodash'
    }))
module.exports = environment
