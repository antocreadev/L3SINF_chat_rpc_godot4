extends Control

# --------- SIGNAL --------- #
signal connected
signal ask_pseudo
signal message_received
signal new_client2
signal new_client
signal deco_client

# --------- GLOBAL VARIABLE --------- #
var server_info = {}
var user = {}
var CLOCK_CLIENT = 0
var DECIMAL_COLLECTOR = 0

var my_data = {
	"pseudo" : "NA",
	"pseudoId": -1,
}

# --------- LOAD --------- #
@onready var CS = preload("res://chatContainer.tscn").instantiate()

# --------- _READY --------- #
func _ready():
	set_physics_process(false)

# --------- RPC ANY PEER : client to server --------- #
@rpc("any_peer")
func getServeurTime() : 
	pass

@rpc("any_peer")
func chatMessage():
	pass

@rpc("any_peer")
func pseudoClient(): 
	pass

# --------- RPC AUTHORITY : server to client --------- #
@rpc("authority")
func timestampServer(timeSer, timeCli):
	CLOCK_CLIENT = timeSer + (timeSer - Time.get_ticks_msec())
	set_physics_process(true)
	print(str(CLOCK_CLIENT) + "\n", str(timeSer) + "\n", str(timeCli))
	
@rpc("authority")
func newUser(numUser, dict):
	numUser -= 1
	print(dict)
	var usr = "user" + str(numUser)
	if dict.has(usr):
		user = dict
		emit_signal("new_client", user[usr].pseudo)
		emit_signal("new_client2", user)
		print(user)
	else:
		print("Clé '%s' introuvable dans le dictionnaire" % usr)

@rpc("authority")
func deleteUser(dict):
	user_deco(dict)


@rpc("authority")
func serverMessage(mess):
	emit_signal("message_received", mess)

# --------- FUNCTIONS --------- #
func join_server(ip, port, pseudo):
	var net = ENetMultiplayerPeer.new()
	my_data["pseudo"] = pseudo
	if (net.create_client(ip, int(port)) != OK):
		return
	multiplayer.multiplayer_peer = net
	get_multiplayer().connected_to_server.connect(_on_connected_to_server)
	get_multiplayer().server_disconnected.connect(_on_disconnected_from_server)
	sharePseudoInChats(pseudo)

func user_deco(dict):
	user = dict
	emit_signal("deco_client", user)

func _on_connection_failed():
	pass

func _on_disconnected_from_server():
	my_data["pseudoId"] = -1
	print(my_data["pseudoId"] )

func _physics_process(delta):
	CLOCK_CLIENT += int(delta*1000)
	DECIMAL_COLLECTOR += (delta * 1000) - int(delta * 1000)
	if DECIMAL_COLLECTOR >= 1.0:
		CLOCK_CLIENT += 1
		DECIMAL_COLLECTOR -= 1

func _on_connected_to_server():
	getServeurTime.rpc_id(1, Time.get_ticks_msec())
	
	var pseudoId= multiplayer.get_unique_id()
	my_data["pseudoId"] = pseudoId
	emit_signal("ask_pseudo")

func sharePseudoInChats(p) :
	emit_signal("connected", p) 
	

func send_pseudo(pseudo):
	pseudoClient.rpc_id(1, pseudo)

func send_message_to_server(mess: Message):
	chatMessage.rpc_id(1, mess.to_dict())
