extends Control
# --------- LOAD --------- #
@onready var chats = $chats
@onready var chatContainer = $connect
@onready var users = $users
@onready var notif = $notif
# --------- _READY --------- #
func _ready():
	chats.visible = false
	
	chatContainer.visible = true
	users.visible = false
	chats.connect("message_sent", Callable(self, "_on_chats_message_sent"))
	chatContainer.connect("pseudo_sent", Callable(self, "get_pseudo"))
	Network.connect("new_client", Callable(self, "pop_up_new_client"))
	Network.connect("new_client2", Callable(self, "display_new_list"))
	Network.connect("ask_pseudo", Callable(self, "get_pseudo"))
	Network.connect("deco_client", Callable(self, "display_new_list"))

# --------- FUNCTIONS --------- #
func pop_up_new_client(pseudo: String):
	print("pop up", pseudo)
	notif.display_message(pseudo)

func display_new_list(dict_users):
	users.updat(dict_users)
	
func get_pseudo():
	var login = get_node("connect")
	var pseudo = login.send_pseudo()
	Network.send_pseudo(pseudo)
	
func _on_chats_message_sent(mess):
	Network.send_message_to_server(mess)
