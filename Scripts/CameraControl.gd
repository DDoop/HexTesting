extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var camera = get_parent()
onready var view_rect = camera.get_viewport().get_visible_rect()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rect_size = view_rect.size	# Really only necessary if view_rect changes
