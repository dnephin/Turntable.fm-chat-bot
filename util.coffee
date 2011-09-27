###
 util.coffee
###

# Logging
log = (m) ->
	dtfmt = new Date().toString('yyyy-MM-dd HH:mm:ss')
	console.log("#{dtfmt} - #{m}")

# Get room reference
window.getRoom = ->
	for k of turntable
		v = turntable[k]
		continue if not v
		return v if v.creatorId

# Get roommanager reference
window.getRoomManager = ->
	for k of room
		v = room[k]
		continue if not v
		return v if v.myuserid

# Generate a random number within a range
randomDelay = (min=2, max=70) ->
	(Math.random() * max + min) * 1000

# Choise randomly from a list
randomChoice = (options) ->
	idx = Math.floor(Math.random() * (options.length))
	options[idx]

# Check for presence of at least one string from a list of strings within text
stringInText = (strings, text, forceWord=true) ->
	text = text.toLowerCase()
	for string in strings
		string = string.toLowerCase()
		string = new RegExp("\\b#{string}\\b") if forceWord
		if text.search(string) > -1
			return true
	return false

