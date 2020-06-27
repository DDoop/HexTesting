extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var MyTiles = load("res://MyHex/MyTileMap.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	var my_tiles = MyTiles.new()
	add_child(my_tiles)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
