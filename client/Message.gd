class_name Message extends Object
# --------- GLOBAL VARIABLE --------- #
var mess_id: int
var net_id: int
var timestamp: String
var pseudo: String
var content: String

# --------- CONSTRUCTOR --------- #
func _init(id: int, ts: String, m: String):
	mess_id = 0
	net_id = id
	timestamp = ts
	content = m

# --------- FUNCTIONS --------- #
func custom_to_string_display():
	return timestamp + "[" + str(net_id) + "]" + str(content)

func custom_to_string():
	print(str(mess_id) + str(net_id) + timestamp + str(var_to_bytes(mess_id)) + content)

func to_dict():
	return {
		"mess_id": mess_id,
		"net_id": net_id,
		"pseudo": pseudo,
		"timestamp": timestamp,
		"content": content
	}

func to_bytes():
	pass
