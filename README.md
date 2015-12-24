# nginx-imageproxy
  Image Proxy based on nginx + lua + leafo/magick

# Usage
  * Crop
   * http://NGINX_HOST/crop?url=URL_ESCAPED&width=WIDTH&height=HEIGHT&x=X_FROM&y=Y_FROM
   * Sample: http://NGINX_HOST/crop?url=https%3A%2F%2Ffarm6.staticflickr.com%2F5559%2F14743205623_1ab8225f67_c.jpg&width=90&height=90&x=5&y=8

  * Zoomcrop
   * http://NGINX_HOST/zoomcrop?url=URL_ESCAPED&width=WIDTH&height=HEIGHT
   * Sample: http://NGINX_HOST/zoomcrop?url=https%3A%2F%2Ffarm6.staticflickr.com%2F5559%2F14743205623_1ab8225f67_c.jpg&width=90&height=90

  * Resize
   * http://NGINX_HOST/resize?url=URL_ESCAPED&width=WIDTH&height=HEIGHT
   * Sample: http://NGINX_HOST/resize?url=https%3A%2F%2Ffarm6.staticflickr.com%2F5559%2F14743205623_1ab8225f67_c.jpg&width=90&height=90

# Preresqusities
  You'll need both LuaJIT (any version) and MagickWand installed.
  On Debian / Ubuntu, you might run:

  $ sudo apt-get install nginx-extras luajit libmagickwand-dev luarocks

  Then use luarocks install magick

  $ sudo luarocks install magick lua-resty-http

# Configuration
  Put sample config in nginx to /etc/nginx, modify as you need.

