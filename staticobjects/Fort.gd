extends StaticBody2D

signal shoot

var tower = preload("res://staticobjects/Tower.tscn")
var wall_h = preload("res://staticobjects/FortWallH.tscn")
var wall_v = preload("res://staticobjects/FortWallV.tscn")
var flag = preload("res://pickups/Flag.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	

func init(player: KinematicBody2D):
	init_towers(player)
	init_walls()
	init_flag()


func init_towers(player: KinematicBody2D):
	var t1 = tower.instance()
	t1.position = Vector2(0,0)
	t1.set_player(player)
	t1.connect("shoot", self, "_on_Tower_shoot")
	add_child(t1) 
	var t2 = tower.instance()
	t2.position = Vector2(64,0)
	t2.set_player(player)
	t2.connect("shoot", self, "_on_Tower_shoot")
	add_child(t2) 
	var t3 = tower.instance()
	t3.position = Vector2(0,48)
	t3.set_player(player)
	t3.connect("shoot", self, "_on_Tower_shoot")
	add_child(t3) 
	var t4 = tower.instance()
	t4.position = Vector2(64,48)
	t4.set_player(player)
	t4.connect("shoot", self, "_on_Tower_shoot")
	add_child(t4) 
	

func init_walls():
		# Wall Top
	var w1 = wall_h.instance()
	w1.position = Vector2(16,0)
	add_child(w1)
	var w2 = wall_h.instance()
	w2.position = Vector2(32,0)
	add_child(w2)
	var w3 = wall_h.instance()
	w3.position = Vector2(48,0)
	add_child(w3)
	# Wall bottom
	var w4 = wall_h.instance()
	w4.position = Vector2(16,48)
	add_child(w4)
	var w5 = wall_h.instance()
	w5.position = Vector2(32,48)
	add_child(w5)
	var w6 = wall_h.instance()
	w6.position = Vector2(48,48)
	add_child(w6)
	# Wall left
	var w7 = wall_v.instance()
	w7.position = Vector2(0, 16)
	add_child(w7)
	var w8 = wall_v.instance()
	w8.position = Vector2(0, 32)
	add_child(w8)
	# Wall right
	var w9 = wall_v.instance()
	w9.position = Vector2(64, 16)
	add_child(w9)
	var w10 = wall_v.instance()
	w10.position = Vector2(64, 32)
	add_child(w10)
	

func init_flag():
	var f = flag.instance()
	f.position = Vector2(32, 24)
	add_child(f)


func _on_Tower_shoot(bullet, muzzle_position, target_dir):
	emit_signal("shoot", bullet, muzzle_position, target_dir)
