extends Control
# --------- SIGNAL --------- #
signal pseudo_sent
# --------- LOAD --------- #
@onready var inputIp = $main/imputContainer/ip
@onready var inputPort = $main/imputContainer/port
@onready var inputPseudo = $main/imputContainer/pseudo
@onready var main = $"."
# --------- _READY --------- #
func _ready():
	pass

# --------- FUNCTIONS --------- #
func send_pseudo():
	return inputPseudo.text

func _on_Button_button_down():
	var ip = inputIp.text
	var port = inputPort.text
	var pseudo = inputPseudo.text
	if pseudo :
		var chat_scene = get_parent()
		main.visible=false
		chat_scene.visible = true
		if chat_scene.has_node("users") :
			chat_scene.get_node("users").visible=true
		if chat_scene.has_node("chats") :
			chat_scene.get_node("chats").visible=true
		if chat_scene.has_node("notif"):
			chat_scene.get_node("notif").visible = true
		Network.join_server(ip, port, pseudo)
