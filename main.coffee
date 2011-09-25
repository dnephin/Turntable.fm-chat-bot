###
 Objectives:
 - Prevent idle time from going over x seconds
 - Automatically grab a DJ spot
 - Respond to idle checks
###

# Turntable
tt = turntable
# Room instance variable
room = turntable.ODHwjeo
# Room manager
roomman = gPRzNzkxTaCcJb
# Logging
log = (m) -> console.log(m)

# Max idle time that users will accept
maxIdleTime = 6 * 60 * 1000
# Max idle response frequency
maxIdleResponseFreq = 15 * 1000

# +Artists
goodArtists = [
	'big l'
	'biz markie'
	'black star'
	'epmd'
	'eric sermon'
	'gang starr'
	'gorillaz'
	'group home'
	'hieroglyphics'
	'j dilla'
	'jay dee'
	'jay-z'
	'jaylib'
	'kanye west'
	'mf doom'
	'mos def'
	'nas'
	'people under the stairs'
	'saigon'
	'talib kweli'
	'the pharcyde'
	'the roots'
	'wu tang'
	'wu-tang'
]

badArtists = [
	'50 cent'
	'curren$y'
	'kendrick'
	'lil wayne'
	'suave smooth'
]

randomPhrases = [
	'heh'
	'hmmm'
	'i dunno about this track'
	'.'
	'word'
	'lol'
	'...'
	'^^'
	'why'
]

nameAliases = [
	'dne'
	'dnep'
	'dnephin'
	'djs'
]

idleAliases = [
	'afk'
	'checkin'
	'there'
	'idle'
]

idleResponses = [
	"I'm here."
	"here"
	"what?"
	"..."
	"say again?"
	"1.2.3."
]

window.updateIdle = ->
	turntable.lastMotionTime = util.now()

randomDelay = (min=2, max=70) ->
	(Math.random() * max + min) * 1000

randomChoice = (options) ->
	idx = Math.floor(Math.random() * (options.length))
	options[idx]

stringInText = (strings, text) ->
	for string in strings
		string = string.toLowerCase()
		if text.indexOf(string) > -1
			return true
	return false

window.say = (msg) ->
	updateIdle()
	lastVisibleAction = util.now()
	chatForm = $(room.nodes.chatForm)
	chatForm.find('input').val(msg)
	chatForm.submit()

window.voteYes = ->
	updateIdle()
	lastVisibleAction = util.now()
	roomman.callback('upvote')
	log "Votes yes."

window.voteNo = ->
	updateIdle()
	lastVisibleAction = util.now()
	roomman.callback('downvote')
	log "Voted no."

window.responseTimeout = null
window.lastVisibleAction = util.now()
songChange = (e) ->
	return if e.command != "newsong"
	# clear old callbacks
	clearTimeout(window.responseTimeout) if window.responseTimeout
	
	song = e.room.metadata.current_song.metadata

	# Song is mine
	if e.room.metadata.current_dj == tt.user.id
		log "I'm playing #{song.song} - #{song.artist}"
		return

	log "Song: #{song.song} - #{song.artist}"
	# Good
	if stringInText(goodArtists, song.artist)
		log "Going to upvote."
		responseTimeout = setTimeout("voteYes()", randomDelay())
		return
	# Bad
	if stringInText(badArtists, song.artist)
		log "Going to downvote."
		responseTimeout = setTimeout("voteNo()", randomDelay())
		return

	# Unknown
	action = randomChoice(['none', 'say', 'voteYes()', 'voteNo()'])
	if action == 'none'
		if util.now() - lastVisibleAction > maxIdleTime
			action = randomChoice(['say', 'voteYes()', 'voteNo()'])
		else
			log 'Unknown artist, decided to do nothing.'
			return
	if action == 'say'
		log 'Saying a random phrase.'
		phrase = randomChoice(randomPhrases)
		responseTimeout = setTimeout("say('#{phrase}')", randomDelay())
		return

	log 'Voting randomly'
	responseTimeout = setTimeout(action, randomDelay())


# TODO: this is not working
djLeft = (e) ->
	return if e.command != "rem_dj"
	if tt.user.id == e.user.userid
		log "I just stepped off or got booted."
		return
	if room.isDj()
		log "I'm already on the decks."
		return

	updateIdle()
	roomman.callback("become_dj", roomman.become_dj.data('spot'))
	log "Grabbing the spot!"


window.lastIdleResponse = util.now()
handleTalk = (e) ->
	return if e.command != 'speak'

	if stringInText(nameAliases, e.text) and stringInText(idleAliases, e.text)
		if util.now() - lastIdleResponse < maxIdleResponseFreq
			log "Responded to idle request recently. Doing nothing."
			return

		window.lastIdleResponse = util.now()
		log "Suspected idle check: #{e.text}"
		resp = randomChoice(idleResponses)
		log "Responding with #{resp}"
		say(resp)


# set turntable.lastMotionTime periodically
setInterval("updateIdle()", 1100)

turntable.addEventListener('message', songChange)
turntable.addEventListener('message', djLeft)
turntable.addEventListener('message', handleTalk)

