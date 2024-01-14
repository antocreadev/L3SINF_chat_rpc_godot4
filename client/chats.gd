extends Control
# --------- LOAD --------- #
@onready var main = $main/chat
@onready var pseudo = $main/messageContainer/pseudo
@onready var inputTextMessage = $main/messageContainer/inputTextMessage
# --------- SIGNAL --------- #
signal message_sent
# --------- _READY --------- #
func _ready():
	inputTextMessage.set_editable(false)
	Network.connect("message_received", Callable(self, "show_message"))
	Network.connect("connected", Callable(self, "_on_connected"))
	
# --------- FUNCTIONS --------- #
func _on_connected(p):
	inputTextMessage.set_editable(true)
	pseudo.text = String(p)
	

func send_message(text):
	var timeDict =Time.get_time_dict_from_system()
	var hour = timeDict.hour
	var minute = timeDict.minute
	var second = timeDict.second
	var temps = str(hour) + ":" + str(minute) + ":" + str(second)
	var mess = Message.new(1,temps,str(text))
	emit_signal("message_sent", mess)
	inputTextMessage.text= ''

func show_message(mess):
	main.text+= "\n" + to_dict_display(mess)
	
func to_dict_display(mess):
	return "    " + mess.timestamp + " [" + mess.pseudo + "] " + mess.content
