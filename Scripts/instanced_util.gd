extends Node

const DEBUG_NONE = 0
const DEBUG_LOW = -50
const DEBUG_VERBOSE = -100

const LOG_LEVEL = DEBUG_NONE

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func normalize_mouse_pos():
	if get_viewport() != null:
		Util.verbose_log("Got viewport successfully", str(get_viewport()), LOG_LEVEL)
		var irregular_pos = get_viewport().get_mouse_position()
		var viewport_rect = get_viewport().get_visible_rect().size
		var value = Vector2(irregular_pos.x / viewport_rect.x, irregular_pos.y / viewport_rect.y)
		Util.verbose_log("normalize_mouse_position", value, LOG_LEVEL)
		return value
	else:
		Util.low_log("Tried to get_viewport() from normalize_mouse_position but got null",
					 "", LOG_LEVEL)
