extends Panel
# --------- GLOBAL VARIABLE --------- #
const TEXT_DISPLAY_MIN_TIME = 4.0
var text_duration = TEXT_DISPLAY_MIN_TIME
# --------- LOAD --------- #
@onready var rtl_mess = $message
@onready var timer = $timeOut
# --------- _READY --------- #
func _ready():
	Network.connect("new_client", Callable(self, "display_message"))
	hide()
# --------- FUNCTIONS --------- #
func display_message(pseudo: String):
	rtl_mess.text = "User " + pseudo + " is connected"
	timer.start(text_duration)
	show()

func set_text_duration(s: float):
	text_duration = s

func _on_Timer_timeout():
	hide()
