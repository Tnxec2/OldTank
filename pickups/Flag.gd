extends "res://pickups/Pickup.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	type = PickupTypes.Flag
	amount = 1

func _exit_tree():
	for i in range(G.located_forts.size()):
		if G.located_forts[i] == global_position:
			var new_array = G.located_forts
			new_array.remove(i)
			G.located_forts = new_array
			break

