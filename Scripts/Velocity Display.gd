extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var parent = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rect_size = parent.rect_size	# Could avoid having to do this for all children by doing it in the parent!
