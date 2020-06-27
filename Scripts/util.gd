extends Node

const LOG_NONE = 0
const LOG_LOW = -50
const LOG_VERBOSE = -100

const UTIL_LOG_LEVEL = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

static func my_log(string_variable, variable= ""):
	var time = my_time()
	var format_string = "%s: %s" % [time, string_variable]
	print("%s: \n %s" % [format_string, variable])

static func my_time():
	var base_time = OS.get_time()
	return "%s:%s:%s" % [base_time["hour"], base_time["minute"], base_time["second"]]

static func loud_log(message, variable, log_level = UTIL_LOG_LEVEL):	# For any case which should alert
	if log_level <= LOG_NONE:
		my_log("LOUD " + message, variable)

static func low_log(message, variable, log_level = UTIL_LOG_LEVEL):	# For issues of import
	if log_level <= LOG_LOW:
		my_log("LOW " + message, variable)
		
static func verbose_log(message, variable, log_level = UTIL_LOG_LEVEL):	# For intense debugging
	if log_level <= LOG_VERBOSE:
		my_log("VERBOSE " + message, variable)

static func sprite_at_pos(position: Vector2, parent: Node, rotation: float=0.0):
	var sprite = Sprite.new()
	sprite.position = position
	sprite.texture = load("res://icon.png")
	sprite.rotate(deg2rad(rotation))
	parent.add_child(sprite)
