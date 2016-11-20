# mollypictures

Was looking for an excuse to make something using Erlang,
so I made a placeholder image site.

* Image manipulation is done with imagemagick,
* Web server is cowboy,
* Caching is handled by nginx,
* Lets encrypt is used for ssl certificates.

You can see it running here: http://molly.nathansplace.co.uk

## Build / run

```sh
  $ rebar3 as prod release
  $ docker build -t mollypictures .
  $ docker run -d -p 8080:80 -t mollypictures
```

Then visit `http://localhost:8080` for usage.

## Image selection

Several versions of source images are stored sorted into portrait and landscape
Source images are selected to look reasonable and to minimise file size.

This improves performance when generating smaller images.

For now, images are duplicated to make the following folders

* large: 1920x1280
* medium: 960x640
* small: 480x320

## TODO:

* endpoint to add new images
* resize source images based on actual usage
