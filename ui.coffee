
# Make space in the info ba
cleanupInfoBar = ->
	$('.url').remove()


# Add song button
moveAddSong = ->
	a = $('.addSongsButton')
		.remove()
		.html('+')
		.css
			background: 'white'
			'text-align': 'center'
		.addClass('icon')
		# TODO: can i get a reference to this from the original element?
		.click( ->
			# Copied From TT
            $("#playlist .queueView").hide()
            $("#playlist .addSongsView").show()
            $("#plupload .plupload.html5").css("width", $("#pickfiles").css("width"))
            $("#plupload .plupload.html5").css("height", $("#pickfiles").css("height"))
		)

	p = $('.share-on')
	p.width(p.width() + 30)
		.append(a)

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


doAll = ->
	cleanupInfoBar()
	moveAddSong()
