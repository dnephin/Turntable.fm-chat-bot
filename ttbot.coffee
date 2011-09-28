###
 ttbot.coffee

 Behaviour:
	- Respond to idle checks
	- Keep from going idle
	- Jump onto the decks when a spot opens
###

# Global Id of the last response timeout
window.responseTimeout = null

# Handler for song changes
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
	if stringInText(goodArtists, song.artist, false)
		log "Going to upvote."
		responseTimeout = setTimeout("voteYes()", randomDelay(3, 40))
		return
	# Bad
	if stringInText(badArtists, song.artist, false)
		log "Going to downvote."
		responseTimeout = setTimeout("voteNo()", randomDelay(20))
		return

	# Unknown
	log 'Voting with room.'
	func = -> voteWithRoom(voteMonitor, ->
		log 'Saying a random phrase.'
		say(randomChoice(randomPhrases))
	)
	responseTimeout = setTimeout(func, randomDelay(45))


# Handle DJ leaving the decks event
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


# Timestamp of the last response to an idle check
window.lastIdleResponse = util.now()
# Handle idle check in chat
handleTalk = (e) ->
	return if e.command != 'speak'

	return if not stringInText(nameAliases, e.text) || not stringInText(idleAliases, e.text) || e.text.length > 35
	
	if util.now() - lastIdleResponse < maxIdleResponseFreq
		log "Responded to idle request recently. Doing nothing."
		return

	window.lastIdleResponse = util.now()
	log "Suspected idle check: #{e.text}"
	for i in [0..5]
		setTimeout( -> turntablePlayer.playEphemeral(UI_SOUND_CHAT, true),
		i*700)
	resp = randomChoice(idleResponses)
	setTimeout(->
		log "Responding with #{resp}"
		say(resp)
	, randomDelay(1.5, 6))


# Keep track of vote changes, since TT only tracks upvotes
class VoteMonitor

	score: 0
	voters: 0

	handleVotes: (e) =>
		if e.command == 'newsong'
			@score = @voters = 0
			document.title = 'tt.fm'
		return if e.command != 'update_votes'
		@updateCounters(e.room.metadata)
		@updateTitle(e.room.metadata)

	updateCounters: (data) ->
		@score = data.upvotes / data.downvotes
		@voters = data.upvotes + data.downvotes

	updateTitle: (data) ->
		document.title = "+#{data.upvotes} -#{data.downvotes} | tt.fm"


window.voteMonitor = new VoteMonitor()

# Set turntable.lastMotionTime periodically
setInterval("updateIdle()", 1100)

# TODO: trigger these on room change, and clear them on leaving a room
# Also reset room/rooman references on room change

startVoter = ->
	tt.removeEventListener('message', songChange)
	tt.addEventListener('message', songChange)

startStageJumper = ->
	tt.removeEventListener('message', djLeft)
	tt.addEventListener('message', djLeft)

startIdleResponder = ->
	tt.removeEventListener('message', handleTalk)
	tt.addEventListener('message', handleTalk)

startVoteMonitor = ->
	tt.removeEventListener('message', voteMonitor.handleVotes)
	tt.addEventListener('message', voteMonitor.handleVotes)

startBot = () ->
	startVoter()
	startStageJumper()
	startIdleResponder()

startVoteMonitor()
