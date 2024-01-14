extends Node2D
# --------- LOAD --------- #
@onready var sectionScrollUsers = $main/container/sectionScroll/users
@onready var h1 = $main/container/h1

# --------- _READY --------- #
func _ready():
	pass
	
# --------- FUNCTIONS --------- #
func updtae(users):
	clean()
	for i in users:
		print(i)
		var new_node = Label.new()
		new_node.name=str(users[i].pseudoId)
		sectionScrollUsers.add_child(new_node)
		new_node.set_text("%s (%d) "%[users[i].pseudo,users[i].pseudoId])
	set_nb_users(len(users))

func clean():
	for i in sectionScrollUsers.get_children():
		i.queue_free()

	
func set_nb_users(n: int):
	h1.text = "%d users connected"%[n]
