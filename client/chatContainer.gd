extends Control
# --------- LOAD --------- #
@onready var chatBox = $chats
@onready var connectionBox = $connect
@onready var userList = $users
@onready var msgBubble = $notif
# --------- _READY --------- #
func _ready():
	chatBox.visible = false
	
	connectionBox.visible = true
	userList.visible = false
	chatBox.connect("message_sent", Callable(self, "_on_ChatBox_message_sent"))
	connectionBox.connect("sendPseudo", Callable(self, "getPseudo"))
	Network.connect("newUser", Callable(self, "notifNewClient"))
	Network.connect("afficheNewUser", Callable(self, "afficheNewUsers"))
	Network.connect("askPseudo", Callable(self, "getPseudo"))
	Network.connect("disconnectClient", Callable(self, "afficheNewUsers"))

# --------- FUNCTIONS --------- #
func notifNewClient(pseudo: String):
	msgBubble.afficheMessage(pseudo)

func afficheNewUsers(users):
	userList.updateUsers(users)
	
func getPseudo():
	var login = get_node("connect")
	var pseudo = login.SendPseudo()
	Network.SendPseudo(pseudo)
	
func _on_ChatBox_message_sent(mess):
	Network.send_message_to_server(mess)
