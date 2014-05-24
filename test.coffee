http = require('http')
filewatch = require('./index')
server = http.createServer (req, res)->
	options = 
		tryParseJson: true
	filewatch.watchTree "./testFolder", options, (err, f, c, p, data)->
		if not err?
	    console.log "File changed #{f}"
	    console.log "Data is #{data}"


server.listen 3001

