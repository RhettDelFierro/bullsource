const webpack = require('webpack');
const path = require('path');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const HtmlWebpackPlugin = require('html-webpack-plugin');

const VENDOR_LIBS = ["apollo-client", "axios", "babel-core", "babel-loader", "babel-preset-env",
                     "babel-preset-react", "body-parser", "css-loader", "graphql","html-webpack-plugin",
                     "react", "react-apollo", "react-dom", "style-loader", "webpack", "webpack-dev-middleware"
                    ];

module.exports = {
    entry: {
      bundle: './src/index.js',
      vendor: VENDOR_LIBS
    },
    output: {
        path: path.resolve(__dirname, 'dist'),
        filename: '[name].[chunkHash].js',
        publicPath: 'dist/'
    },
    module: {
        rules: [
            {
                use: 'babel-loader',
                test: /\.js$/,
                exclude: /node_modules/
            },
            {
                loader: ExtractTextPlugin.extract({loader: 'css-loader'}),
                test: /\.css$/
            },
            {
                use: [{loader: 'url-loader', options: {limit: 40000} },'image-webpack-loader'],
                test: /\.(jpe?g|png|gif|svg)$/
            }
        ]
    },
    plugins: [
        new HtmlWebpackPlugin({
            template: 'src/index.html'
        }),
        new ExtractTextPlugin('style.css'),
        new webpack.optimize.CommonsChunkPlugin({names: ['vendor', 'manifest']})
    ]
};