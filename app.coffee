###
Module dependencies.
###
twitter = require 'twitter'
colors = require 'colors'
moment = require 'moment'
config = require './config'
util = require 'util'
request = require 'request'

tw = new twitter({consumer_key: config.consumer_key, consumer_secret: config.consumer_secret, access_token_key: config.access_token, access_token_secret: config.access_secret })
moment.lang 'ens'

# Read Stream
tw.stream 'user', {}, (stream) ->
	stream.on 'data', (data) ->
		if data.text
			date = moment(data.created_at).format('HH:mm')
			console.log date.green + " " + "#{data.user.name}".bold.blue + " : #{data.text}"
 
# Twit
update = (msg) ->
	tw
		.verifyCredentials (data) ->
			console.log util.inspect(data)
		.updateStatus msg, (data) ->
			console.log util.inspect(data)
###
oauth = () ->
	url = 'https://api.twitter.com/oauth/request_token'
	request {url: url, method:"POST", header: {oauth_callback: '127.0.0.1/' }}, (err, res, body) ->
		if !err && res.statusCode == 200
			console.log body
oauth()
###

process.stdin.resume()
process.stdin.setEncoding 'utf8'
process.stdin.on 'data', (chunk) ->
	chunk.trim().split('\n').forEach (line) ->
		update(line)
process.stdin.on 'end', () ->
	console.log('>>> EOF')
