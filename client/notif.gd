extends Panel
# --------- GLOBAL VARIABLE --------- #
const TEXT_DISPLAY_MIN_TIME = 4.0
var text_duration = TEXT_DISPLAY_MIN_TIME
# --------- LOAD --------- #
@onready var message = $message
@onready var timer = $timeOut
# --------- _READY --------- #
func _ready():
	Network.connect("newUser", Callable(self, "afficheMessage"))
	hide()
# --------- FUNCTIONS --------- #
func afficheMessage(pseudo: String):
	message.text = "" + pseudo + "est connecté !"
	timer.start(text_duration)
	show()

func _on_Timer_timeout():
	hide()
