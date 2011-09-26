###
 config.coffee

 Artist lists, response lists, and idle settings.
###

# Max idle time that users will accept
maxIdleTime = 6 * 60 * 1000
# Max idle response frequency
maxIdleResponseFreq = 15 * 1000

goodArtists = [
	'apathy'
	'atmosphere'
	'big l'
	'biz markie'
	'black milk'
	'black moon'
	'black star'
	'blackalicious'
	'brother ali'
	'busta rhymes'
	'celph titled'
	'common'
	'consequence'
	'CunninLynguists'
	'de la soul'
	'dead prez'
	'dj premier'
	'dr. dre'
	'elzhi'
	'epmd'
	'erick sermon'
	'gang starr'
	'geto boys'
	'ghostface'
	'guru'
	'gorillaz'
	'group home'
	'hieroglyphics'
	'immortal technique'
	'j dilla'
	'jay dee'
	'jay-z'
	'jaylib'
	'gurassic 5'
	'kanye west'
	'krs one'
	'krs-one'
	'living legends'
	'm.o.p.'
	'macklemore and ryan lewis'
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
]

idleAliases = [
	'afk'
	'checkin'
	'check in'
	'here'
	'idle'
	'ther'
	'there'
]

idleResponses = [
	"..."
	"1.2.3."
	"I'm here."
	"here"
	"huh?"
	"i am here"
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
