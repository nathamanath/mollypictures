# mollypictures

Was looking for an excuse to make something using Erlang,
so I made a placeholder image site.

* Image manipulation is done with imagemagick,
* Web server is cowboy,
* Caching is handled by nginx.

You can see it running here: http://mollypictures.com

## Build / run

```sh
  $ rebar3 as prod release
  $ docker build -t ubuntu/mollypictures .
  $ docker run -d -p 8080:80 -t ubuntu/mollypictures
```

Then visit `http://localhost:8080` for usage.
