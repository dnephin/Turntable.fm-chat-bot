###
 ui.coffee

 UI improvements and additional features.
###


tt_yellow = '#d9a527'
tt_red = '#7a0000'

# Make space in the info ba
cleanupInfoBar = ->
	$('.url').remove()
	i = $('.info').css
		'background-position': '0 42px'
		'background-image': $('.header').css('background-image')
	i.children('.faqButton, .feedback').remove()
	i.find('.room .name').css
		color: '#ddd'
		'font-family': 'Open Sans'
		height: '24px'
		padding: 0
	$('.share-on').remove()


styleButton = (ele) ->
	buttonLeft += 30
	$('.info').append(ele)
	style =
		background: tt_red
		'text-align': 'center'
		color: '#dbcb98'
		'font-weight': 'bold'
		'font-size': '22px'
		height: '25px'
		width: '25px'
		'margin-left': '5px'
		border: '1px solid #dbcb98'
		position: 'absolute'
		left: "#{buttonLeft}px"
		top: '6px'
		cursor: 'pointer'
	ele.css(style)
	ele.hover(->
		$(@).css
			background: '#900000'
			border: '1px outset #dbcb98'
	, -> $(@).css(style))


# Add song button
moveAddSong = ->
	a = $('.addSongsButton')
		.remove()
		.html('+')
		# TODO: can i get a reference to this from the original element?
		.click ->
			# Copied From TT
            $("#playlist .queueView").hide()
            $("#playlist .addSongsView").show()
            $("#plupload .plupload.html5").css("width", $("#pickfiles").css("width"))
            $("#plupload .plupload.html5").css("height", $("#pickfiles").css("height"))

	styleButton(a)

cleanupAddSongViews = ->
	e = $('.searchText')
		.hide()
		.siblings('.songSearch').css
			top: '6px'
			background: 'transparent'
		.siblings('.orText').hide()
		.siblings('.upload-button').css(
			top: '36px'
			background: 'transparent'
			left: '76px'
			'font-weight': 'bold'
			'text-decoration': 'underline'
		).html('Upload')
		.siblings('.cancelButton').css(
			top: '66px'
			background: 'transparent'
			'font-weight': 'bold'
			'text-decoration': 'underline'
		).html('Cancel')
	$('.buy').remove()


moveSettings = ->
	$('#menuh')
		.css
			width: '42px'
			top: '51px'
			left: '510px'
		.children('.menuItem.first').css(width: '34px')
		.children('.text').remove()


moveRoomButtons = ->
	list = $('.list').html('l').remove().click(room.listRoomsShow)
	random = $('.random').html('~').remove().click(tt.randomRoom)
	styleButton(list)
	styleButton(random)


cleanupChat = ->
	# Clear space
	add_height = 69
	c = $('.queueView .songlist')
	c.css(top: 0)
		.height(c.height() + add_height)
	turntable.playlist.setPlaylistHeight(room.chatOffsetTop + add_height)
	# TODO: this doesn't prevent the grey box from showing when the size is changing
	# Setup callback when changed.
	$('.chatHeader').bind("mouseup mouseout", (e) ->
		turntable.playlist.setPlaylistHeight(room.chatOffsetTop + add_height)
	)

	$('.chat-container .input-box').css
		background: '#222'
	.children('input').css
		color: '#ddd'

	$('.header-text').remove()


cleanupRoomTip = ->
	$('.roomTip')
		.css
			background: 'transparent'
			color: tt_red
			top: '25px'
			left: '193px'
			height: '30px'
		.html('<p class="text">')


cleanupMeter = ->
	$('#meterGauge, #meterNeedle').hide()
	voteButtons = $('.roomView').children('div').children('a[id]')
	$(voteButtons[1])
		.css(left: '241px')
	$(voteButtons).click( ->
		eventHandlers.autoVoter.clearPending()
	)


loadFonts = ->
	google.load("webfont", "1")
	google.setOnLoadCallback ->
		WebFont.load
			google:
				families: ['Open Sans']


fixFonts = ->
	# TODO: move to css file
	$('#ttbstyle').remove()
	$('head').append("""
	<style id="ttbstyle">
		.chat-container .messages {
			background-color: black;
			font-family: 'Open Sans', sans-serif;
			color: white;
		}
		.chat-container .messages .message:nth-child(odd) {
			background-color: #151515;
		}
		.chat-container .input-box input {
			font-family: 'Open Sans', sans-serif;
		}
		.chat-container .messages .message .speaker {
			color: #dbcb98
		}

		.playlist-container .song, .playlist-container .uploading {
			background-color: black;
			color: white;
			border-bottom: 0;
			font-family: 'Open Sans', sans-serif;
		}
		.playlist-container .song.nth-child-even, .playlist-container .uploading:nth-child(even) {
			background-color: #151515;
			color: white;
		}
		.playlist-container .song:hover {
			background-color: #222;
		}
		.playlist-container .song .title, .playlist-container .processing .text, .playlist-container .uploading .text {
			color: white;
		}
		.playlist-container .queueView .song.currentSong {
			background-color: #{tt_red}
		}
		.playlist-container .song .progress {
			background-color: #333;
		}
	</style>
	""")


addSearch = ->
	$('#ttbss').remove()
	$('.header').append(
		$('<div id="ttbss">').append(
			$('<input>').keyup( (e) ->
				songSearcher.search($(@).val())
			).css
				border: 0
				background: 'transparent'
				color: 'white'
				outline: 'none'
				width: '216px'
				'font-family': 'Open Sans'
		).css
			border: 0
			background: 'black'
			color: 'white'
			top: '15px'
			left: '528px'
			position: 'absolute'
			'z-index': 200
			padding: '5px'
	)


cleanupScrollbars = ->

	$(".queueView .songlist, .chat-container .messages")
		.mousewheel( (event, delta) ->
			event.preventDefault()
			newPos = $(@).scrollTop() + delta * - mouseScrollSpeed
			$(@).scrollTop(newPos)
		)
	$('.queue.realPlaylist').css
			width: '100%'


# Place avatars
class PlaceAvatars

	placeAvatar: (user) =>
		placementId = user.placement
		placements = (d.placement for uid, d of room.users)

		x = y = 0
		i = -1
		while true
			i++

			xop = i % 7
			if xop in [1,5]
				x += 70
			if xop == 3
				x -= 70
			if xop in [2,4,6]
				x *= -1
			[x,y] = [0, y + 75] if i % 7 == 0 and i
			break if i == placementId
			break if i not in placements
			# Go random after 28 are placed
			return @getRandom() if i >= 27

		[x,y] = [x + 232, y + 250]
		user.placement = i
		return [x, y]

	getRandom: ->
		j = Math
		x = Math.floor(j.random() * 450)
		y = Math.floor(j.random() * 280) + 200
		return [x, y]

	draw: ->
		for uid, user of room.users
			room.refreshRoomUser(user)

	addListener: (user) =>
		a = roomman.getExistingAvatarById(user.avatarid)
		p = @placeAvatar(user)
		bs = roomman.blackswan.add_dancer(a, "back", p, true, false)
		roomman.add_tooltip(bs.div, user)
		uid = user.userid
		bs.body().click( -> roomman.callback("profile", uid))
			.css "cursor", "pointer"
		roomman.listeners[uid] = bs


pa = new PlaceAvatars()
roomman.add_listener = pa.addListener

addVoterButton = ->
	ele = $('<div>?</div>')
		.click -> eventHandlers.voteMonitor.getVoters()
	styleButton(ele)

addBotButton = ->
	ele = $('<div>b</div>')

	enabled = ->
		startBot()
		ele.click ->
			stopBot()
		ele.css('background-color': 'green')
	
	disable = ->
		stopBot()
		ele.click ->
			startBot()
		ele.css('background-color': tt-red)
	
	ele.click(enabled)
	styleButton(ele)

fixUI = ->
	window.buttonLeft = 494
	loadFonts()
	fixFonts()
	cleanupInfoBar()
	moveAddSong()
	cleanupAddSongViews()
	moveSettings()
	moveRoomButtons()
	cleanupChat()
	cleanupRoomTip()
	cleanupMeter()
	addSearch()
	cleanupScrollbars()
	addVoterButton()
	addBotButton()
	$('#footer').hide()

fixUI()
pa.draw()
