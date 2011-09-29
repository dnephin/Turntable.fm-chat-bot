###
 ttextend.coffee

 Setup global hooks into tt, and functions to perform common actions.
###


# Turntable
window.tt = turntable
# Room instance variable
window.room = getRoom()
# Room manager
window.roomman = getRoomManager()
# Timestamp of the last user visible action
window.lastVisibleAction = util.now()

# Update idle time 
window.updateIdle = ->
	turntable.lastMotionTime = util.now()


window.updateLastVisible = ->
	updateIdle()
	lastVisibleAction = util.now()


window.say = (msg) ->
	chatForm = $(room.nodes.chatForm)
	chatForm.find('input').val(msg)
	chatForm.submit()


window.voteYes = ->
	updateLastVisible()
	lastVisibleAction = util.now()
	roomman.callback('upvote')
	log "Voted yes."


window.voteNo = ->
	updateLastVisible()
	lastVisibleAction = util.now()
	roomman.callback('downvote')
	log "Voted no."


window.voteWithRoom = (votes, fallback) ->
	updateLastVisible()
	return voteYes() if votes.voters > 0 and votes.score > 0.5
	return voteNo() if votes.voters > 0
	fallback() if fallback

window.stopDJing = (delay=0) ->
	setTimeout( ->
		roomman.callback('rem_dj')
	, delay)


class SongSearcher

	lastText: null
	skipMatches: 0

	search: (text) ->
		if text.length < 1
			return @scrollTo 0

		@skipMatches = if text == @lastText then @skipMatches+1 else 0
		@lastText = text

		skipped = 0

		for file in tt.playlist.files
			# Search by song name first
			song = file.metadata.song
			if song.startsWith(text)
				if skipped < @skipMatches
					skipped++
					continue
				return @toTop(@eleFromName(song))

			# Search for artist name
			artist = file.metadata.artist
			if artist.startsWith(text)
				if skipped < @skipMatches
					skipped++
					continue
				eleTitle = @artistEleTitle(file.metadata)
				return @toTop(@eleFromName(eleTitle))


	scrollTo: (val) ->
		$('.queueView .songlist').scrollTop val

	toTop: (ele) ->
		containerPos = $('.queue.realPlaylist').offset()
		pos = ele.offset()
		newPos = pos.top - containerPos.top - ele.position().top
		@scrollTo newPos

	eleFromName: (name) ->
		$("div[title=\"#{name}\"]")

	artistEleTitle: (data) ->
		min = Math.floor(data.length / 60)
		sec = data.length % 60
		sec = "0#{sec}" if sec < 10
		"#{data.artist} - #{min}:#{sec}"
		

songSearcher = new SongSearcher()
	

