extends TileMap


export (int) var map_size

var rand = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rand.randomize()
	for n in map_size:
		for m in map_size:
			var type = 0
			var r = rand.randi_range(0, 100)
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
