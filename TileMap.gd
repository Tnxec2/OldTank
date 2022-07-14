extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for n in 80:
		for m in 80:
			var type = 0
			var r = rand_range(0, 100)
			if ( r < 98):
				type = 0
			elif (r < 99.5):
				type = 1
			elif (r < 99.7):
				type = 2
			else:
				type = 3
			set_cell(n, m, type)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
