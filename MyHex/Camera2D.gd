extends Camera2D

const LOG_NONE = 0
const LOG_LOW = -50
const LOG_DEBUG = -100

const LOG_LEVEL = LOG_NONE

const ACCELERATION: float = 0.55
const MAX_SPEED: float = 2.0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var dragging: bool = false
var drag_mouse_pos: Vector2 = Vector2()
var current_mouse_pos: Vector2 = Vector2()

var mouse_move_vect: Vector2 = Vector2() 

var keyboard_controls = ["l_arrow_key", "r_arrow_key", "u_arrow_key", "d_arrow_key"]

var velocity: Vector2 = Vector2(0,0)

onready var VelocityXLabel = get_node("UI/Velocity Display/VelocityX")
onready var VelocityYLabel = get_node("UI/Velocity Display/VelocityY")

# Called when the node enters the scene tree for the first time.
func _ready():
	current = true
	position = get_node("../Area2D").position


var cached_size: Vector2 = Vector2()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Need to keep the rect of this consistent with the window size:
	get_viewport().size = OS.get_window_size()
	if get_viewport().size != cached_size:
		Util.loud_log("cached_size does not match viewport size. cached_size", cached_size,
					LOG_LEVEL)
		Util.loud_log("get_viewport().size", get_viewport().size, LOG_LEVEL)
	cached_size = get_viewport().size 
	
	arrow_key_movement()
	
	if velocity != Vector2(0, 0):
		position += velocity
		
	VelocityXLabel.text = str(velocity.x)
	VelocityYLabel.text = str(velocity.y)

func arrow_key_movement() -> void:
	arrow_key("u_arrow_key")
	arrow_key("d_arrow_key")
	arrow_key("l_arrow_key")
	arrow_key("r_arrow_key")

func arrow_key(key_string) -> void:
	# Set internal operations:
	var assignment_list = dir_key_operator_assignment(key_string)
	var positive_movement: bool = assignment_list[0]
	var x_axis: bool = assignment_list[1]
	
	dir_key_pressed(key_string, positive_movement, x_axis)
	dir_key_released(key_string, positive_movement, x_axis)

func dir_key_operator_assignment(key_string):
	var positive_movement: bool
	var x_axis: bool
	
	# Direction check
	if (key_string == "d_arrow_key") || (key_string == "r_arrow_key"):
		positive_movement = true
	elif (key_string == "u_arrow_key") || (key_string == "l_arrow_key"):
		positive_movement = false
	
	# Axis check
	if (key_string == "d_arrow_key") || (key_string == "u_arrow_key"):
		x_axis = false
	elif (key_string == "r_arrow_key") || (key_string == "l_arrow_key"):
		x_axis = true
	
	return [positive_movement, x_axis]

func dir_key_pressed(key_string: String, positive_movement: bool, x_axis: bool):
	if Input.is_action_pressed(key_string):
		if x_axis == true:
			if positive_movement == true: # Moving right
				Util.low_log("Captured %s. velocity" % [key_string], velocity, LOG_LEVEL)
				velocity.x += ACCELERATION
			elif positive_movement == false: # Moving left
				Util.low_log("Captured %s. velocity" % [key_string], velocity, LOG_LEVEL)
				velocity.x -= ACCELERATION
		if x_axis == false:
			if positive_movement == true: # Moving down
				Util.low_log("Captured %s. velocity" % [key_string], velocity, LOG_LEVEL)
				velocity.y += ACCELERATION
			elif positive_movement == false: # Moving up
				Util.low_log("Captured %s. velocity" % [key_string], velocity, LOG_LEVEL)
				velocity.y -= ACCELERATION
	velocity_clamp()

func dir_key_released(key_string: String, positive_movement: bool, x_axis: bool):
	if Input.is_action_just_released(key_string):
		if x_axis == true:
			if positive_movement == true: # Moving right
				Util.low_log("Released u_arrow_key. velocity", velocity, LOG_LEVEL)
				while velocity.x > 0:
					velocity.x -= ACCELERATION
					if velocity.x < 0:
						velocity.x = 0
			elif positive_movement == false: # Moving left
				Util.low_log("Released u_arrow_key. velocity", velocity, LOG_LEVEL)
				while velocity.x < 0:
					velocity.x += ACCELERATION
					if velocity.x > 0:
						velocity.x = 0
		if x_axis == false:
			if positive_movement == true: # Moving down
				Util.low_log("Released u_arrow_key. velocity", velocity, LOG_LEVEL)
				while velocity.y > 0:
					velocity.y -= ACCELERATION
					if velocity.y < 0:
						velocity.y = 0
			elif positive_movement == false: # Moving up
				Util.low_log("Released u_arrow_key. velocity", velocity, LOG_LEVEL)
				while velocity.y < 0:
					velocity.y += ACCELERATION
					if velocity.y > 0:
						velocity.y = 0

func velocity_clamp() -> void:	# Prevents camera from moving too fast.
	if abs(velocity.x) > abs(MAX_SPEED):
		if velocity.x > 0:
			velocity.x = MAX_SPEED
		elif velocity.x < 0:
			velocity.x = -MAX_SPEED
	if abs(velocity.y) > abs(MAX_SPEED):
		if velocity.y > 0:
			velocity.y = MAX_SPEED
		elif velocity.y < 0:
			velocity.y = -MAX_SPEED
