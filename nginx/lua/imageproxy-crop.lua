--- require magick and resty.http
local magick = require "magick"
local http = require "resty.http"

--- require magick and resty.http
local user_agent = 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.86 Safari/537.36'
local content_type = ''
local img_format = ''
local img = ''

--- url
local url = ngx.unescape_uri(ngx.var.arg_url)
url = string.gsub(url, '?$', '')

local httpc = http.new()

--- fetch image from remote url
local res, err = httpc:request_uri(url, {
  method = "GET",
  headers = {
    ['User-Agent'] = user_agent,
  }
})

if not res then
  ngx.say("failed to request: ", err)
  return
end

--- if HTTP 302, refetch from Location header
if res.status == 302 then
  url = res.headers["Location"]
  res, err = httpc:request_uri(url, {
     method = "GET"
  })
  if not res then
    ngx.say("failed to request: ", err)
    return
  end
end

--- if HTTP 4xx or 5xx, return default image
if res.status >= 400 and res.status < 600 then
  content_type = 'image/png'
  img_format = 'png'
  img = assert(magick.load_image('default.png'))
elseif res.status == 200 then
  content_type = res.headers['Content-Type']
  img_format = string.gsub(content_type, 'image/', '')
  img = assert(magick.load_image_from_blob(res.body))
end

--- width / height / x / y to integer
local width = tonumber(ngx.var.arg_width)
local height = tonumber(ngx.var.arg_height)
local x = tonumber(ngx.var.arg_x)
local y = tonumber(ngx.var.arg_y)

if x == "nil" then
  x = 0
elseif y == "nil" then
  y = 0
end

if height == "nil" then
  img:crop(width, width, x, y)
else 
  img:crop(width, height, x, y)
end

--- set format and strip
img:set_format(img_format)
img:strip()

local content = img:get_blob()
--- print content
ngx.header.content_type = content_type
ngx.print(content)


