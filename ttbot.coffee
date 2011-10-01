###
 ttbot.coffee

 Behaviour:
	- Respond to idle checks
	- Keep from going idle
	- Jump onto the decks when a spot opens
###

class EventHandler

	start: ->
		@stop()
		tt.addEventListener('message', @handler)

	stop: ->
		tt.removeEventListener('message', @handler)


# Cast votes based on preferences.
# Depends on VoteMonitor
class AutoVoter extends EventHandler

	# Id of the last response timeout
	responseTimeout: null

	# Handler for song changes
	handler: (e) =>
		return if e.command != "newsong"
		@clearPending()
		
		song = e.room.metadata.current_song.metadata
	
		# Song is mine
		if e.room.metadata.current_dj == tt.user.id
			log "I'm playing #{song.song} - #{song.artist}"
			return
	
		log "Song: #{song.song} - #{song.artist}"
		# Good
		if stringInText(goodArtists, song.artist, false)
			log "Going to upvote."
			@responseTimeout = setTimeout("voteYes()", randomDelay(3, 40))
			return
		# Bad
		if stringInText(badArtists, song.artist, false)
			log "Going to downvote."
			@responseTimeout = setTimeout("voteNo()", randomDelay(20))
			return
	
		# Unknown
		log 'Voting with room.'
		func = -> voteWithRoom(eventHandlers.voteMonitor, ->
			log 'Saying a random phrase.'
			say(randomChoice(randomPhrases))
		)
		@responseTimeout = setTimeout(func, randomDelay(45))

	# Clear old callbacks
	clearPending: ->
		log "Clearing vote callback."
		clearTimeout(@responseTimeout) if @responseTimeout


# Handle DJ leaving the decks event
class StageJumper extends EventHandler

	handler: (e) =>
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


# Respond to idle checks
class AutoResponder extends EventHandler
	
	# Timestamp of the last response to an idle check
	lastIdleResponse: util.now()

	# Handle idle check in chat
	handler: (e) =>
		return if e.command != 'speak'
	
		return if not stringInText(nameAliases, e.text)
		@playAlertSound()

		return if not stringInText(idleAliases, e.text) || e.text.length > 35
		
		if util.now() - @lastIdleResponse < maxIdleResponseFreq
			log "Responded to idle request recently. Doing nothing."
			return
	
		@lastIdleResponse = util.now()
		log "Suspected idle check: #{e.text}"
		resp = randomChoice(idleResponses)
		setTimeout(->
			log "Responding with #{resp}"
			say(resp)
		, randomDelay(2, 8))

	playAlertSound: ->
		for i in [0..5]
			setTimeout( ->
				turntablePlayer.playEphemeral(UI_SOUND_CHAT, true)
			, i*700)


# Keep track of vote changes, since TT only tracks upvotes
class VoteMonitor extends EventHandler

	score: 0
	voters: 0
	upvoters: []
	downvoters: []

	handler: (e) =>
		if e.command == 'newsong'
			@score = @voters = 0
			@upvoters = []
			@downvoters = []
			document.title = 'tt.fm'
		return if e.command != 'update_votes'
		@updateCounters(e.room.metadata)
		@updateTitle(e.room.metadata)
		@recordVote(e.room.metadata.votelog[0])

	updateCounters: (data) ->
		@score = data.upvotes / data.downvotes
		@voters = data.upvotes + data.downvotes

	updateTitle: (data) ->
		document.title = "+#{data.upvotes} -#{data.downvotes} | tt.fm"

	recordVote: (data) ->
		if data[1] == 'up'
			@upvoters.push(data[0])
		else
			@downvoters.push(data[0])

	getVoters: () ->
		u = room.users
		ups = [u[userid].name for userid in @upvoters]
		downs = [u[userid].name for userid in @downvoters]
		log "Up votes:#{ups.join(',')} - Down Votes:#{downs.join(',')}"


# Set turntable.lastMotionTime periodically
setInterval("updateIdle()", 1100)

# Setup
eventHandlers =
	voteMonitor: new VoteMonitor()
	autoVoter: new AutoVoter()
	stageJumper: new StageJumper()
	autoResponder: new AutoResponder()

# TODO: trigger these on room change, and clear them on leaving a room
# Also reset room/rooman references on room change

startBot = () ->
	eventHandlers.autoVoter.start()
	eventHandlers.stageJumper.start()
	eventHandlers.autoResponder.start()

eventHandlers.voteMonitor.start()
