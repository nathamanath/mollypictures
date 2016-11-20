# mollypictures

Was looking for an excuse to make something using Erlang,
so I made a placeholder image site.

* Image manipulation is done with imagemagick,
* Web server is cowboy,
* Caching is handled by nginx.

You can see it running here: http://molly.nathansplace.co.uk

## Build / run

```sh
  $ rebar3 as prod release
  $ docker build -t mollypictures .
  $ docker run -d -p 8080:80 -t mollypictures
```

Then visit `http://localhost:8080` for usage.

## Image folders

To speed up image generation, several versions of each image are stored. The
idea being to reduce the size of source images being loaded into imagemagick.

For now, images are duplicated to make the following folders

* large: 1920x1080
* medium: 960x540
* small: 480x270

Each contains portrait and landscape folder

Source images are randomly picked from smallest folder with dimensions greater
or equal to those requested.

Will run k-means on generated images after a while to find optimal sizes.
