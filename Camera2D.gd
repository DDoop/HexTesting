extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var area2d = get_node("../Area2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	position = area2d.position
	print("Camera2D.position: %s" % position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
