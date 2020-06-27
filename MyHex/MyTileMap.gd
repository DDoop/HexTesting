extends TileMap

#export(Vector2) var hex_cell_size setget cell_size_set, cell_size_get

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#cell_size = Vector2(27, 35)	# Ratio of 27:35 produces desirable border, eval to 0.7714
	z_index = -1
	cell_half_offset = true
	cell_tile_origin = TILE_ORIGIN_CENTER
	centered_textures = true
	cell_half_offset = HALF_OFFSET_Y
	mode = TileMap.MODE_CUSTOM
	
	var my_transform: Transform2D = Transform2D(Vector2(25, 0), 
												Vector2(0, 32), 
												Vector2(-32, -32)
												)
	
	cell_custom_transform = my_transform
	
	tile_set = load("res://MyHex/MyTileset.tres")
	for x in range(-50, 50):
		for y in range(-50, 50):
			set_cell(x, y, 2)
	set_cell(0, 0, 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
