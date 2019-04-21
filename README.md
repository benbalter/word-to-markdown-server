# Word-to-markdown Server

This project contains a lightweight server implementation of [word-to-markdown](https://github.com/benbalter/word-to-markdown) for converting Word Documents as a service.

To run the server, simply run `script/server` and open `localhost:9292` in your browser. The server can also be run on Heroku.

A live version runs at [word2md.com](https://word2md.com).

You can also use it as a service by posting raw HTML to `/raw`, which will return the raw markdown in response.

## Usage

  Visit [the site](https://word2md.com), run it locally, or deploy to Heroku.

## Docker

```
docker build -t w2m .
docker run -p 5000:5000 w2m
open http://localhost:5000
```
