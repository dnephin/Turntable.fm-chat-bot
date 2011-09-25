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

