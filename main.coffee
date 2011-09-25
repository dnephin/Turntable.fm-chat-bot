###
# Objectives:
# - prevent idle time from going over x
# - insta grab available spot
###

# Turntable
tt = turntable
# Room instance variable
room = turntable.ODHwjeo
# Room manager
roomman = gPRzNzkxTaCcJb
# Logging
log = (m) -> console.log(m)


# +Artists
goodArtists = [
	'the pharcyde'
	'the root'
	'saigon'
	'kanye west'
	'mos def'
	'talib kweli'
	'mf doom'
	'people under the strairs'
]

badArtists = [
	'curren$y'
	'lil wayne'
]

randomPhrases = [
	'heh'
	'hmmm'
	'i dunno about this track'
	'.'
	'word'
]

window.updateIdle = ->
	turntable.lastMotionTime = util.now()

randomDelay = (min=2, max=70) ->
	(Math.random() * max + min) * 1000

randomChoice = (options) ->
	idx = Math.floor(Math.random() * (options.length))
	options[idx]

window.say = (msg) ->
	updateIdle()
	chatForm = $(room.nodes.chatForm)
	chatForm.find('input').val(msg)
	chatForm.submit()

window.voteYes = ->
	updateIdle()
	roomman.callback('upvote')

window.voteNo = ->
	updateIdle()
	rooman.callback('downvote')

window.RESPONSE_TIMEOUT = null
songChange = (e) ->
	return if e.command != "newsong"
	# clear old callbacks
	clearTimeout(RESPONSE_TIMEOUT) if RESPONSE_TIMEOUT
	
	song = e.room.metadata.current_song.metadata

	# Song is mine
	if e.room.metadata.current_dj == tt.user.id
		log "I'm playing #{song.song} #{song.artist}"
		return

	# Good
	for artist in goodArtists
		artist = artist.toUpperCase()
		if song.artist.indexOf(artist) > -1
			log "Going to upvote."
			RESPONSE_TIMEOUT = setTimeout("voteYes()", randomDelay())
			return
	# Bad
	for artist in badArtists
		artist = artist.toUpperCase()
		if song.artist.indexOf(artist) > -1
			log "Going to downvote."
			RESPONSE_TIMEOUT = setTimeout("voteNo()", randomDelay())
			return

	# Unknown
	action = randomChoice(['none', 'say', 'voteYes()', 'voteNo()'])
	if action == 'none'
		log 'Unknown artist, decided to do nothing.'
		return
	if action == 'say'
		log 'Saying a random phrase.'
		phrase = randomChoice(randomPhrases)
		RESPONSE_TIMEOUT = setTimeout("say(#{phrase})", randomDelay())
		return
	if action == 'vote'
		log 'Voting randomly'
		RESPONSE_TIMEOUT = setTimeout(action, randomDelay())


djLeft = (e) ->
	return if e.command != "rem_dj"
	if tt.user.id == e.user.userid
		log "I just stepped off or got booted."
		return
	if tt.User.id in djIds
		log "I'm already on the decks."
		return

	updateIdle()
	roomman.callback("become_dj", roomman.become_dj.data('spot'))
	log "Grabbing the spot!"


# TODO: watch messages for someone complaining
handleTalk = (e) ->
	return if e.command != 'speak'


# set turntable.lastMotionTime periodically
setInterval("updateIdle()", 1100)

turntable.addEventListener('message', songChange)
turntable.addEventListener('message', djLeft)
turntable.addEventListener('message', handleTalk)

