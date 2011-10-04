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
# Delay to add to stage jumping
stageJumpDelay = 100

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
	'dilated peoples'
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
	'rakim'
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
	'...'
	'?'
	'^^'
	'heh'
	'hmmm'
	'i dunno about this track'
	'lol'
	'this reminds me of another song'
	'why'
	'word'
]

# Used as a regex
nameAliases = [
	'leetcat'
	'leet'
	'cat'
	'leecat'
	'lee'
]

generalNameAliases = [
	'djs'
	'everyone'
	'you all'
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
