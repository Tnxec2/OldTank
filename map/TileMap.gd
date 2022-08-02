extends TileMap

var map_sizes = [40, 80, 120]
var map_size = 40

var rand = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	G.world_size = clamp(G.world_size, 0, 2)
	map_size = map_sizes[G.world_size]

	rand.randomize()
	fill_map_with_tilles()


func fill_map_with_tilles():
	for n in map_size:
		for m in map_size:
			var type = 0
			var r = rand.randi_range(0, 100)
			if ( r < 98):
				type = 0 # Empty
			elif (r < 99.5):
				type = 1 # Grass
			elif (r < 99.7):
				type = 2 # Hill1
			else:
				type = 3 # Hill2
			set_cell(n, m, type)


