###
Module dependencies.
###
OAuth = require 'oauth'
config = require './config'

oauth = new OAuth.OAuth 'http://twitter.com/oauth/request_token',
	'http://twitter.om/oauth/access_token',
	config.consumer_key,
	config.consumer_secret,
	'1.0A', null, 'HMAC-SHA1'

userstream = oauth.get 'https://userstream.twitter.com/2/user.json',
	config.access_token,
	config.access_secret

userstream.on 'response', (res) ->
	res.setEncoding 'utf8'
	twbuf = ""
	res.on 'data', (chunk) ->
		if chunk.match(/\n/)
			chunks = chunk.split(/\r?\n/)
			buf = chunks.pop() if chunks.length
			while c = chunks.shift()
				tweet = JSON.parse(c)
				console.log(tweet.user.screen_name + ' : ' + tweet.text) if tweet.created_at

	res.on 'error', (errmsg) ->
		console.log(errmsg)

	res.on 'end', () ->
		console.log(' - おわり NODE -')
userstream.end()

update = (twit) ->
		oauth.post 'https://api.twitter.com/1.1/statuses/update.json?status=' + twit,
		config.access_token,
		config.access_secret,
		(req, res) ->
			console.log(res)

process.stdin.resume()
process.stdin.setEncoding 'utf8'
process.stdin.on 'data', (chunk) ->
	chunk.trim().split('\n').forEach (line) ->
		update(line)
process.stdin.on 'end', () ->
	console.log('>>> EOF')
