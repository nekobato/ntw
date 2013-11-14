###
Module dependencies.
###
twitter = require 'twitter'
colors = require 'colors'
moment = require 'moment'
config = require './config'

tw = new twitter({consumer_key: config.consumer_key, consumer_secret: config.consumer_secret, access_token_key: config.access_token, access_token_secret: config.access_secret })
moment.lang 'ens'

tw.stream 'user', {}, (stream) ->
	stream.on 'data', (data) ->
		if data.text
			date = moment(data.created_at).format('HH:mm')
			console.log date.green + " " + "#{data.user.name}".bold.blue + " : #{data.text}"
###
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
###
