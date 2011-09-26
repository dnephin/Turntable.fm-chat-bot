
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


# Add song button
moveAddSong = ->
	a = $('.addSongsButton')
		.remove()
		.html('+')
		.css
			background: tt_red
			'text-align': 'center'
			color: 'white'
			'font-weight': 'bold'
			'font-size': '22px'
			height: '25px'
			width: '25px'
			'border-radius': '6px'
			'margin-left': '5px'
			border: '1px solid white'
			position: 'absolute'
			left: '548px'
			top: '6px'
			cursor: 'pointer'

		# TODO: can i get a reference to this from the original element?
		.click ->
			# Copied From TT
            $("#playlist .queueView").hide()
            $("#playlist .addSongsView").show()
            $("#plupload .plupload.html5").css("width", $("#pickfiles").css("width"))
            $("#plupload .plupload.html5").css("height", $("#pickfiles").css("height"))

	$('.info').append(a)

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


moveSettings = ->
	$('#menuh')
		.css
			width: '42px'
			top: '51px'
			left: '390px'
		.children('.menuItem.first').css(width: '34px')
		.children('.text').remove()

moveRoomButtons = ->
	$('.room-buttons')
		.css
			'z-index': 1
			top: '64px'
			right: '-1px'
			width: '119px'
		.children('.list').css(width: '45px')
		.siblings('.random').css
			left: '45px'
			width: '65px'
			'border-right': '1px solid  black'

cleanupChat = ->
	# Clear space
	c = $('.queueView .songlist')
	c.css(top: 0)
		.height(c.height() + 42)
	turntable.playlist.setPlaylistHeight(room.chatOffsetTop + 42)
	# TODO: this doesn't prevent the grey box from showing when the size is changing
	# Setup callback when changed.
	$('.chatHeader').bind("mouseup mouseout", (e) ->
		turntable.playlist.setPlaylistHeight(room.chatOffsetTop + 42)
	)

	$('.chat-container .input-box').css
		background: '#222'
	.children('input').css
		color: '#ddd'

	$('.header-text').remove()


fixUI = ->
	cleanupInfoBar()
	moveAddSong()
	cleanupAddSongViews()
	moveSettings()
	moveRoomButtons()
	cleanupChat()
	$('#footer').hide()

fixUI()
