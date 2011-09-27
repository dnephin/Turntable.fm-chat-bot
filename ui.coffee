
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


buttonLeft = 520
styleButton = (ele) ->
	buttonLeft += 30
	$('.info').append(ele)
	ele.css
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
		left: "#{buttonLeft}px"
		top: '6px'
		cursor: 'pointer'


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


moveSettings = ->
	$('#menuh')
		.css
			width: '42px'
			top: '51px'
			left: '510px'
		.children('.menuItem.first').css(width: '34px')
		.children('.text').remove()


moveRoomButtons = ->
	list = $('.list').html('L').remove().click(room.listRoomsShow)
	random = $('.random').html('R').remove().click(tt.randomRoom)
	styleButton(list)
	styleButton(random)


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


fixUI = ->
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
