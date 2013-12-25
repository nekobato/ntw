clc = require 'cli-color'
moment = require 'moment'

moment.lang 'ens'

View = () ->
	# Style settings
	@style =
		date: clc.xterm(220)
		name: clc.xterm(111).bold
		sname: clc.xterm(20)
		text: clc.xterm(250)

# Views
View.prototype.stream = (d) ->
	date = moment(d.created_at).format('HH:mm')
	return "#{@style.date(date)} #{@style.name(d.user.name)} #{@style.sname(d.user.screen_name)} :\n #{@style.text(d.text)}\n"

View.prototype.stream_online = (d) ->
	date = moment(d.created_at).format('HH:mm')
	return "#{@style.date(date)} #{@style.name(d.user.name)} #{@style.sname(d.user.screen_name)} #{@style.text(d.text)}"

# Export
module.exports = View
View.__proto__ = new View
