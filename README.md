
Turntable.fm Bot
================

This project has not been maintained for a while now.

Objectives
----------
 - Prevent idle time from going over x seconds
 - Automatically grab a DJ spot when one becomes available
 - Respond to idle checks
 - Greatly improve the UI and finding songs in the playlist

Build
-----
```
coffee --bare -l --watch --compile *.coffee
```

Run Instructions
----------------
	1. Modify config.coffee
	2. Build the javascript using the command above
	3. Host the js files somewhere (these instructions assume locally on port 80)
	4. Run in the console:

		$.getScript('main.js')


Possible Additions
------------------
 - activity rating for the room (average idle time in the room?)
 - console log messages in the window
 - fix upload button
 - cancel afk response
 - Identify songs that have been played recently, and alert if you have them
 	(or even just move them down the queue)
 - call fixUI on room change, and reset handlers
 - If the track is bombing, say something in chat and skip
 - Lookup unknown artists on Freebase or last.fm to determine proximity to a 
 	good/bad artist and vote accordingly
 - could I use python nltk to get a better idea of the sentence structure?
