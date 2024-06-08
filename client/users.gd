extends Node2D
# --------- LOAD --------- #
@onready var sectionScrollUsers = $main/container/sectionScroll/users
@onready var h1 = $main/container/h1

# --------- _READY --------- #
func _ready():
	pass
	
# --------- FUNCTIONS --------- #
func updateUsers(users):
	clean()
	for user in users:
		var new_node = Label.new()
		new_node.name=str(users[user].pseudoId)
		sectionScrollUsers.add_child(new_node)
		new_node.set_text("%s (%d) "%[users[user].pseudo,users[user].pseudoId])
	nbUser(len(users))

func clean():
	for user in sectionScrollUsers.get_children():
		user.queue_free()
	
func nbUser(n: int):
	h1.text = "%d nombre d'utilisateurs connectés : "%[n]
