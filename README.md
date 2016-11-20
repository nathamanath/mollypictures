# mollypictures

Was looking for an excuse to make something using Erlang,
so I made a placeholder image site.

* Image manipulation is done with imagemagick,
* Web server is cowboy,
* Caching is handled by nginx,
* Docker image requests its own ssl certificate form lets encrypt, and keeps it
  updated.

You can see it running here: http://molly.nathansplace.co.uk

## Build / run

```sh
  $ make docker
  $ docker run docker run -p 8080:80
```

If you set environment variables `LE_EMAIL` and `LE_DOMAIN` it will attempt to
set up ssl certificates from lets encrypt on launch.

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
