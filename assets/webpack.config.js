const webpack = require('webpack');
const path = require('path');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const HtmlWebpackPlugin = require('html-webpack-plugin');

const VENDOR_LIBS = ["axios", "apollo-client", "graphql", "react-apollo", "react", "react-dom", "react-router-dom"];

module.exports = {
    entry: {
        bundle: './src/index.js',
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
                use: ExtractTextPlugin.extract({loader: 'css-loader'}),
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
};
