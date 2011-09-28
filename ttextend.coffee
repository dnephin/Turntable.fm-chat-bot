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

	search: (text) ->
		for file in tt.playlist.files
			song = file.metadata.song
			if song.startsWith(text)
				return @toTop(@eleFromName(song))

	toTop: (ele) ->
		containerPos = $('.queue.realPlaylist').offset()
		pos = ele.offset()
		$('.queueView .songlist').scrollTop pos.top - containerPos.top - 8

	eleFromName: (name) ->
		$("div[title=\"#{name}\"]")
		

songSearcher = new SongSearcher()
	

