import * as path from 'path';
import * as webpack from 'webpack';
import MiniCssExtractPlugin from "mini-css-extract-plugin";

const config: webpack.Configuration = {
  entry: ['./assets/app.ts', './assets/style.scss'],
  plugins: [
    new MiniCssExtractPlugin(),
  ],
  output: {
    path: path.resolve(__dirname, 'public'),
  },
  mode: 'production',
  optimization: {
    minimize: true,
  },
  module: {
    rules: [
      {
        test: /\.tsx?$/,
        loader: 'babel-loader',
      },
      {
        test: /\.s[ac]ss$/i,
        use: [
          MiniCssExtractPlugin.loader,
          "css-loader",
          {
            loader: 'postcss-loader',
            options: {
              postcssOptions: {
                plugins: [
                  [
                    'autoprefixer',
                  ],
                ],
              },
            },
          },
          "sass-loader",
        ],
      },
    ],
  },
};
export default config;