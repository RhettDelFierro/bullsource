const webpack = require('webpack');
const path = require('path');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const HtmlWebpackPlugin = require('html-webpack-plugin');

const VENDOR_LIBS = ["axios", "apollo-client", "graphql", "react-apollo",
                     "react", "react-dom", "react-router-dom", "moment",
                     'react-twitter-widgets', "draft-js", "immutable",
                     "slate", "keycode", 'react-frame-component'];

module.exports = {
    entry: {
        bundle: ['babel-polyfill','./src/index.js'],
        vendor: VENDOR_LIBS
    },
    output: {
        path: path.resolve(__dirname, 'dist'),
        filename: '[name].[chunkHash].js',
        publicPath: '/'
    },
    module: {
        rules: [
            {
                use: 'babel-loader',
                test: /\.js$/,
                exclude: /node_modules/
            },
            {
                // use: ExtractTextPlugin.extract({loader: 'css-loader'}),
                use: ExtractTextPlugin.extract({fallback: 'style-loader', loader: "css-loader?sourceMap&modules&localIdentName=[name]__[local]___[hash:base64:5]"}),
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
    ],
    devServer: {
        historyApiFallback: true,
        // inline: true,
        // port: 4000
    },
    devtool: 'cheap-module-inline-source-map',
};
