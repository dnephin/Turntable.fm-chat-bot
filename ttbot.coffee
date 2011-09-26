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

	if stringInText(nameAliases, e.text) and stringInText(idleAliases, e.text)
		if util.now() - lastIdleResponse < maxIdleResponseFreq
			log "Responded to idle request recently. Doing nothing."
			return

		window.lastIdleResponse = util.now()
		log "Suspected idle check: #{e.text}"
		resp = randomChoice(idleResponses)
		log "Responding with #{resp}"
		say(resp)


# Keep track of vote changes, since TT only tracks upvotes
class VoteMonitor

	score: 0
	voters: 0

	handleVotes: (e) =>
		@score = @voters = 0 if e.command == 'newsong'
		return if e.command != 'update_votes'
		data = e.room.metadata
		@score = data.upvotes / data.downvotes
		@voters = data.upvotes + data.downvotes


window.voteMonitor = new VoteMonitor()


# Set turntable.lastMotionTime periodically
setInterval("updateIdle()", 1100)

# TODO: trigger these on room change, and clear them on leaving a room

# clear old handlers first
tt.removeEventListener('message', songChange)
tt.removeEventListener('message', djLeft)
tt.removeEventListener('message', handleTalk)
tt.removeEventListener('message', voteMonitor.handleVotes)

# Add handlers
tt.addEventListener('message', songChange)
tt.addEventListener('message', djLeft)
tt.addEventListener('message', handleTalk)
tt.addEventListener('message', voteMonitor.handleVotes)

