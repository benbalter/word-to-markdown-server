# Word-to-markdown demo site

**[Live demo](https://word-to-markdown.herokuapp.com/)**

This project contains a lightweight server implementation of [word-to-markdown](https://github.com/benbalter/word-to-markdown) for converting Word Documents as a service.

To run the server, simply run `script/server` and open `localhost:9292` in your browser. The server can also be run on Heroku.

A live version runs at [word-to-markdown.herokuapp.com](http://word-to-markdown.herokuapp.com).

You can also use it as a service by posting raw HTML to `/raw`, which will return the raw markdown in response.

## Usage

Deploy to Heroku

## Some notes

This requires a [multi-buildpack](https://github.com/ddollar/heroku-buildpack-multi) in order to install LibreOffice
