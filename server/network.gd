extends Node

# --------- CONST --------- #
const MAX_PLAYERS = 20
const SERVER_PORT = 3002
const PSEUDO_ID = "pseudoId"
const PSEUDO = "pseudo"

# --------- GLOBAL VARIABLE --------- #
var dict = {}
var nbUser = 0

# --------- SIGNAL --------- #
signal serverCreated

# --------- _READY --------- #
func _ready():
	createServer()

# --------- RPC ANY PEER : client to server --------- #
@rpc("any_peer")
func pseudoClient(pseudo):
	var pseudoId = multiplayer.get_remote_sender_id()
	var user = findUserByPseudoId(pseudoId)
	if user:
		dict[user][PSEUDO] = pseudo
	newConnection()

@rpc("any_peer")
func chatMessage(message):
	var pseudoId = multiplayer.get_remote_sender_id()
	var user = findUserByPseudoId(pseudoId)
	if user:
		message[PSEUDO] = dict[user][PSEUDO]

	# Envoyer le message à tous les clients
	serverMessage.rpc(message)


@rpc("any_peer")
func getServeurTime(timeCli):
	var pseudoId = multiplayer.get_remote_sender_id()
	var timeServeur = Time.get_ticks_msec()
	timestampServer.rpc_id(pseudoId, timeServeur, timeCli)

# --------- RPC AUTHORITY : server to client --------- #
@rpc("authority")
func serverMessage():
	pass

@rpc("authority")
func timestampServer():
	pass

@rpc("authority")
func newUser():
	pass
	
@rpc("authority")
func deleteUser():
	pass

# --------- FUNCTIONS --------- #
func createServer():
	var net = ENetMultiplayerPeer.new()
	var is_created = net.create_server(SERVER_PORT, MAX_PLAYERS)
	if (is_created != OK):
		return
	serverCreated.emit()
	multiplayer.multiplayer_peer = net
	get_multiplayer().peer_connected.connect(addUser)
	get_multiplayer().peer_disconnected.connect(deleteUser)

func addUser(id: int):
	var usr = "user" + str(nbUser)
	dict[usr] = {PSEUDO_ID: id, PSEUDO: "pseudo"}
	nbUser += 1

func deleteUser(id: int):
	var user = findUserByPseudoId(id)
	if user:
		dict.erase(user)
		# Informer tous les clients de la déconnexion
		deleteUser.rpc(dict)
		nbUser -= 1

func newConnection():
	newUser.rpc(nbUser, dict)

func findUserByPseudoId(pseudoId):
	for userInDict in dict:
		if dict[userInDict][PSEUDO_ID] == pseudoId:
			return userInDict
	return null
