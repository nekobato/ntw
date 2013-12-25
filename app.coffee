#!usr/bin/env node

###
Module dependencies.
###
twitter = require 'twitter'
request = require 'request'
util = require 'util'
cmd = require 'commander'

config = require './config.json'
view = require './view.js'

# twitter settings
tw = new twitter({
	consumer_key: config.consumer_key,
	consumer_secret: config.consumer_secret,
	access_token_key: config.access_token,
	access_token_secret: config.access_secret })

# Controller
ctrl =
	tweet: (v)->
		console.log 'tweet'
		tw
			.verifyCredentials (data) ->
				console.log util.inspect(data)
			.updateStatus v, (data) ->
				console.log util.inspect(data)
	watch: (v) ->
		console.log 'watch start'
		tw.stream 'user', {}, (stream) ->
			# Keyboard hook
			process.stdin.resume()
			process.stdin.setEncoding 'utf8'
			process.stdin.on 'data', (chunk) ->
				chunk.trim().split('\n').forEach (line) ->
					update(line)
			process.stdin.on 'end', () ->
				console.log('>>> EOF')
			# Watch stream
			stream.on 'data', (data) ->
				console view.stream(data) if data.text

# Command Settings
cmd
	.version('0.0.1')
	.usage('[option] <message>')
	.option('-t, --tweet <Str>', 'Tweet message', ctrl.tweet)
	.option('-w, --watch', 'Watch Stream', ctrl.watch)
	.parse(process.argv)

	###
 oauth = () ->
	url = 'https://api.twitter.com/oauth/request_token'
	request {url: url, method:"POST", header: {oauth_callback: '127.0.0.1/' }}, (err, res, body) ->
		if !err && res.statusCode == 200
			console.log body
oauth()
###
