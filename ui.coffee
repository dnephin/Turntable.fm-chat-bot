
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
	c = $('.queueView .songlist')
	c.css(top: 0)
		.height(c.height() + 43)
	turntable.playlist.setPlaylistHeight(room.chatOffsetTop + 43)
	# TODO: this doesn't prevent the grey box from showing when the size is changing
	# Setup callback when changed.
	$('.chatHeader').bind("mouseup mouseout", (e) ->
		turntable.playlist.setPlaylistHeight(room.chatOffsetTop + 43)
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
	$(voteButtons[1]).css(left: '241px')


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
			font-family: 'Open Sans';
			color: white;
		}
		.chat-container .messages .message:nth-child(odd) {
			background-color: #151515;
		}
		.chat-container .input-box input {
			font-family: 'Open Sans';
		}
		.chat-container .messages .message .speaker {
			color: #dbcb98
		}

		.playlist-container .song, .playlist-container .uploading {
			background-color: black;
			color: white;
			border-bottom: 0;
			font-family: 'Open Sans';
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
	


fixUI = ->
	window.buttonLeft = 520
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
	$('#footer').hide()

fixUI()
