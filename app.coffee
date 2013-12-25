###
Module dependencies.
###
command = require 'commander'
argv = require 'optimist'
twitter = require 'twitter'
request = require 'request'
clc = require 'cli-color'
moment = require 'moment'
util = require 'util'

config = require './config'

# Command Settings
command
	.version('0.0.1')


# Style settings
style =
	date: clc.xterm(220)
	name: clc.xterm(111).bold
	sname: clc.xterm(20)
	text: clc.xterm(250)

# twitter settings
tw = new twitter({
	consumer_key: config.consumer_key,
	consumer_secret: config.consumer_secret,
	access_token_key: config.access_token,
	access_token_secret: config.access_secret })

moment.lang 'ens'

# Read Stream
tw.stream 'user', {}, (stream) ->
	stream.on 'data', (data) ->
		if data.text
			date = moment(data.created_at).format('HH:mm')
			console.log "#{style.date(date)} #{style.name(data.user.name)} #{style.sname(data.user.screen_name)} :\n #{style.text(data.text)}\n"
 
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
