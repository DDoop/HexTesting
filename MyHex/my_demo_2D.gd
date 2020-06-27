# Script to attach to a node which represents a hex grid
extends Node2D

const LOG_NONE = 0
const LOG_LOW = -50
const LOG_VERBOSE = -100

const LOG_LEVEL = LOG_LOW

var MyHexGrid = preload("res://MyHex/MyHexGrid.gd").new()
var MyHexCell = preload("res://MyHex/MyHexCell.gd").new()
var Tiles = preload("res://MyHex/MyTileMap.gd").new()

onready var highlight = get_node("Highlight")
onready var area_coords = get_node("Highlight/AreaCoords")
onready var hex_coords = get_node("Highlight/HexCoords")

onready var CursorPosLabel = get_parent().get_node("Camera2D/UI/Cursor Info/CursorPos")

var mouse_pos: Vector2 = Vector2()

func _ready():
	add_child(Tiles)
	
	# Coordinating hex scale and highlight
	MyHexGrid.hex_scale = Vector2(45, 50)
	sync_hex_scale_and_highlight()
		
	# Coordinating tile size with hex size:
	var hex_size = MyHexGrid.hex_scale
	Tiles.scale += Vector2(0.35, 0.35)


func get_adj_hex_pos(start, direction: Vector3) -> Vector3:
	var adj_hex = start.get_adjacent(direction)
	var value = MyHexGrid.get_hex_center(adj_hex)
	Util.low_log("get_adj_hex_pos(start=%s, direction=%s)" % [start, direction], value, 
				LOG_LEVEL)
	return value

func vector2_direction(v1: Vector2, v2: Vector2) -> Vector2:
	Util.low_log("direction from %s to %s" % [v1, v2], v2-v1, LOG_LEVEL)
	return v2 - v1

func vector2_triangulate(bottom_right_hex):
	var first_pos = MyHexGrid.get_hex_center(bottom_right_hex)
	var north_hex_pos = get_adj_hex_pos(bottom_right_hex, MyHexCell.DIR_N)
	var northwest_hex_pos = get_adj_hex_pos(bottom_right_hex, MyHexCell.DIR_NW)
	
	return triangulate(first_pos, north_hex_pos, northwest_hex_pos)	# added this without testing

func sync_hex_scale_and_highlight():
	if MyHexGrid.hex_scale != Vector2(50, 50): # This process should normalize hex & highlight size
		var xRatio = MyHexGrid.hex_scale.x / 50
		var yRatio = MyHexGrid.hex_scale.y / 50
		$Highlight.set_scale(Vector2(xRatio, yRatio))

func tile_iterate_and_map_to_world(start:Vector2, stop:Vector2):
	var outlist = []
	var temp = Vector2()
	for x in range(start.x, stop.x):
		for y in range(start.y, stop.y):
			temp = Tiles.map_to_world(Vector2(x, y))
			outlist.push_back(temp)
	return temp

func tile_triangulate(lower_right: Vector2):
	var north_tile = lower_right + Vector2(0, -1)
	var northwest_tile = lower_right + Vector2(-1, -1)
	
	var first_pos = Tiles.map_to_world(lower_right)
	var north_pos = Tiles.map_to_world(north_tile)
	var northwest_pos = Tiles.map_to_world(northwest_tile)
	
	return triangulate(first_pos, north_pos, northwest_pos)

func triangulate(start: Vector2, north: Vector2, northwest: Vector2):
	var start_to_north = start.distance_to(north)
	var start_to_northwest = start.distance_to(northwest)
	var north_to_northwest = north.distance_to(northwest)
	var north_to_start = north.distance_to(start)
	
	Util.low_log("start_to_north", start_to_north, LOG_LEVEL)
	Util.low_log("start_to_northwest", start_to_northwest, LOG_LEVEL)
	Util.low_log("north_to_northwest", north_to_northwest, LOG_LEVEL)
	Util.low_log("north_to_start", north_to_start, LOG_LEVEL)
	
	if (start_to_north) == (start_to_northwest) && (north_to_northwest) == (north_to_start):
		return true
	else:
		return false

# Any unhandled inputs passed to this object execute the following:
#func _unhandled_input(event):	
#	if 'position' in event:
#		var relative_pos = self.transform.affine_inverse() * event.position
#		# Display the coords used
#		if area_coords != null:	# This kind of check seems very useful to avoid null ref errors
#			area_coords.text = str(relative_pos)
#		if hex_coords != null:
#			hex_coords.text = str(MyHexGrid.get_hex_at(relative_pos).axial_coords)
#
#		# Snap the highlight to the nearest grid cell
#		if highlight != null:
#			highlight.position = MyHexGrid.get_hex_center(MyHexGrid.get_hex_at(relative_pos))

#func _unhandled_input(event):
#	if 'position' in event:
#		var mouse_pos = normalize_mouse_pos()
#		hex_coords.text = str(mouse_pos)
#		CursorPosLabel.text = str(mouse_pos)

func normalize_mouse_pos():
	if get_viewport() != null:
		Util.verbose_log("Got viewport successfully", str(get_viewport()), LOG_LEVEL)
		var irregular_pos = get_viewport().get_mouse_position()
		var viewport_size = get_viewport().get_visible_rect().size
		var value = Vector2(irregular_pos.x / viewport_size.x, irregular_pos.y / viewport_size.y)
		Util.verbose_log("normalize_mouse_position", value, LOG_LEVEL)
		return value
	else:
		Util.low_log("Tried to get_viewport() from normalize_mouse_position but got null",
					 "", LOG_LEVEL)

func _process(delta):
	mouse_pos = normalize_mouse_pos()
	CursorPosLabel.text = str(mouse_pos)
