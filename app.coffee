###
Module dependencies.
###
OAuth = require 'oauth'
byline = require 'byline'
config = require './config'

oauth = new OAuth.OAuth 'http://twitter.com/oauth/request_token',
	'http://twitter.om/oauth/access_token',
	config.consumer_key,
	config.consumer_secret,
	'1.0A', null, 'HMAC-SHA1'

req = oauth.get 'https://userstream.twitter.com/1.1/user.json',
	config.access_token,
	config.access_secret

req.on 'response', (res) ->
	res.setEncoding('utf8')
	ls = byline.createStream(res)

	ls.on 'data', (line) ->
		unless line is ''
			jsondata = JSON.parse(line)
			console.log(jsondata)

	ls.on 'end', () ->
		console.log(' - おわり NODE -')
req.end()
