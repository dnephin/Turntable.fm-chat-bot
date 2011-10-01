###
 config.coffee

 Artist lists, response lists, and idle settings.
###

# Max idle time that users will accept
maxIdleTime = 6 * 60 * 1000
# Max idle response frequency
maxIdleResponseFreq = 15 * 1000
# Scroll speed
mouseScrollSpeed = 25

goodArtists = [
	'apathy'
	'atmosphere'
	'big daddy kane'
	'big l'
	'biz markie'
	'black milk'
	'black moon'
	'black star'
	'blackalicious'
	'brother ali'
	'busta rhymes'
	'celph titled'
	'classified'
	'common'
	'consequence'
	'cunninLynguists'
	'de la soul'
	'dead prez'
	'dj premier'
	'dr. dre'
	'elzhi'
	'epmd'
	'erick sermon'
	'evidence'
	'gang starr'
	'geto boys'
	'ghostface'
	'gorillaz'
	'group home'
	'guru'
	'gza'
	'hieroglyphics'
	'immortal technique'
	'j dilla'
	'jay dee'
	'jay-z'
	'jaylib'
	'jurassic 5'
	'kanye west'
	'krs one'
	'krs-one'
	'living legends'
	'm.o.p.'
	'macklemore and ryan lewis'
	'madvillain'
	'mf doom'
	'mos def'
	'murs'
	'nas'
	'notorious b.i.g.'
	'outkast'
	'people under the stairs'
	'pharoahe monch'
	'public enemy'
	'q-tip'
	'raekwon'
	'saigon'
	'slum village'
	'souls of mischief'
	'talib kweli'
	'the beatnuts'
	'the coup'
	'the pharcyde'
	'the roots'
	'tribe called quest'
	'warren g'
	'wu tang'
	'wu-tang'
	'zion i'
	'rakim'
]

badArtists = [
	'50 cent'
	'curren$y'
	'dmx'
	'drake'
	'kendrick'
	'lil wayne'
	'lil\' wayne'
	'suave smooth'
	'tech n9ne'
	'wiz khalifa'
]

randomPhrases = [
	'.'
	'...'
	'?'
	'^^'
	'heh'
	'hmmm'
	'i dunno about this track'
	'lol'
	'my next play is the fire'
	'this reminds me of another song'
	'why'
	'word'
]

nameAliases = [
	'dj ...'
	'dj...'
	'djs'
	'dne'
	'dnep'
	'dneph'
	'dnephin'
	'everyone'
	'you all'
	'leetcat'
	'leet'
	'cat'
]

idleAliases = [
	'afk'
	'checkin'
	'check in'
	'here'
	'idle'
	'ther'
	'there'
	'respond'
]

idleResponses = [
	"..."
	"I'm here."
	"here"
	"huh?"
	"i am here"
	"i'm here"
	"say again?"
	"say what?"
	"what"
	"what?"
	"why..."
	"why?"
	"ya"
	"yes..."
	'?'
	'Roger'
	'never'
	'roger'
]
