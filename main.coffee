# TODO: split into config.coffee, ttb.coffee, and util.coffee

window.getRoom = ->
	for k of turntable
		v = turntable[k]
		continue if not v
		return v if v.creatorId

window.getRoomManager = ->
	for k of room
		v = room[k]
		continue if not v
		return v if v.myuserid

# Turntable
tt = turntable
# Room instance variable
window.room = getRoom()
# Room manager
window.roomman = getRoomManager()
# Logging
log = (m) -> console.log(m)


# Max idle time that users will accept
maxIdleTime = 6 * 60 * 1000
# Max idle response frequency
maxIdleResponseFreq = 15 * 1000

# +Artists
goodArtists = [
	'apathy'
	'big l'
	'biz markie'
	'black milk'
	'black moon'
	'black star'
	'busta rhymes'
	'celph titled'
	'consequence'
	'dead prez'
	'dj premier'
	'dr. dre'
	'elzhi'
	'epmd'
	'eric sermon'
	'gang starr'
	'ghostface'
	'gorillaz'
	'group home'
	'hieroglyphics'
	'immortal technique'
	'j dilla'
	'jay dee'
	'jay-z'
	'jaylib'
	'kanye west'
	'krs one'
	'krs-one'
	'living legends'
	'm.o.p.'
	'mf doom'
	'mos def'
	'murs'
	'nas'
	'notorious b.i.g.'
	'people under the stairs'
	'pharoahe monch'
	'raekwon'
	'saigon'
	'slum village'
	'talib kweli'
	'the beatnuts'
	'the pharcyde'
	'the roots'
	'tribe called quest'
	'wu tang'
	'wu-tang'
	'zion i'
]

badArtists = [
	'50 cent'
	'curren$y'
	'drake'
	'kendrick'
	'lil wayne'
	'suave smooth'
	'wiz kadafi'
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
	'this reminds me of another song'
	'my next play is the fire'
]

nameAliases = [
	'dne'
	'dnep'
	'dneph'
	'dnephin'
	'djs'
	'you all'
]

idleAliases = [
	'afk'
	'checkin'
	'there'
	'idle'
	'ther'
]

idleResponses = [
	"..."
	"1.2.3."
	"I'm here."
	"here"
	"huh?"
	"i am here"
	"say again?"
	"say what?"
	"what"
	"what?"
	"why..."
	"why?"
	"ya"
	"yes..."
	'Roger'
	'never'
	'roger'
]

window.updateIdle = ->
	tt.lastMotionTime = util.now()

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


djLeft = (e) ->
	return if e.command != "rem_dj"
	if tt.user.id == e.user[0].userid
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

tt.addEventListener('message', songChange)
tt.addEventListener('message', djLeft)
tt.addEventListener('message', handleTalk)

