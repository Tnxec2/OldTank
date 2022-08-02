extends Node2D

signal change_bullet_type(bulletType)
signal change_count_enemys(countEnemys)
signal game_over

var enemy_tank = preload("res://actors/EnemyTank.tscn")
var truck = preload("res://actors/Truck.tscn")
var tree = preload("res://staticobjects/Tree.tscn")
var hill = preload("res://staticobjects/Hill.tscn")
var fort = preload("res://staticobjects/Fort.tscn")
var radar = preload("res://staticobjects/Radar.tscn")
var helli = preload("res://actors/Helli.tscn")
var plane = preload("res://actors/Helli.tscn") # TODO: plane

var health = preload("res://pickups/Health.tscn")
var cannone = preload("res://pickups/Cannone.tscn")
var missile = preload("res://pickups/Missile.tscn")
var bomb = preload("res://pickups/Bomb.tscn")

const pickup_types = preload("res://pickups/PickupTypes.gd")

onready var ground = $Ground
onready var player = $Player
onready var camera = $Player/Camera2D

const TILE_SIZE = 16
const HALF_TILE_SIZE = 8

const MIN_SWIPE_DISTANCE = 32
var swipe_movement_vector = Vector2(0,0)
var swipe_position_init
var swipe_position_release

var limits = [0, 0, 0, 0] # left, right, top, bottom


var count_enemys = 0
var game_over = false

var current_bullet_type = 0 # 0 - Shots, 1 - Cannone, 2 - Missile

var rand = RandomNumberGenerator.new()

var last_clicked_body = null

var flag_count = 1
var fort_areas = [] # Rect2 Array, containt areas of all forts

var player_located = false


func _ready():
	rand.randomize()
	get_map_size()
	set_camera_limits()

	spawn_forts()
	if G.difficulty > 0:
		spawn_radars()
		
	rand_player_position()
	
	spawn_hills()
	spawn_trees()
	spawn_enemys()

	emit_signal("change_count_enemys", count_enemys)
	emit_signal("change_bullet_type", current_bullet_type)
	G.player = player


func _process(delta):
	if last_clicked_body && is_instance_valid(last_clicked_body):
		$MissileAim.global_position = last_clicked_body.position
		$MissileAim.show()
	else:
		$MissileAim.hide()


func get_map_size():
	var map_limits = ground.get_used_rect()
	var map_cellsize = ground.cell_size
	limits[0] = map_limits.position.x * map_cellsize.x
	limits[1] = map_limits.end.x * map_cellsize.x
	limits[2] = map_limits.position.y * map_cellsize.y
	limits[3] = map_limits.end.y * map_cellsize.y
	G.map_size = Vector2(limits[1]-limits[0], limits[3]-limits[2])


func set_camera_limits():
	camera.limit_left = limits[0]
	camera.limit_right = limits[1]
	camera.limit_top = limits[2]
	camera.limit_bottom = limits[3]


func rand_player_position():
	var x = 0
	var y = 0
	var collides = true
	while collides:
		x = rand.randf_range(10,G.map_size.x-10)
		y = rand.randf_range(10,G.map_size.y-10)
		player.position = Vector2(x, y)
		collides = false
		for r in fort_areas:
			if r.intersects(Rect2(x-8,y-8,x+8,y+8), true):
				collides = true


func spawn_hills():
	var hill_amount = G.map_size.x * G.map_size.y / 50000
	for i in range(0, hill_amount):
		var x = rand.randf_range(10,G.map_size.x-10)
		var y = rand.randf_range(10,G.map_size.y-10)
		var collides = false
		for r in fort_areas:
			if r.intersects(Rect2(x-8,y-8,x+8,y+8), true):
				collides = true
		if (!collides):
			var h = hill.instance()
			h.position = Vector2(x, y)
			h.connect("clicked", self, "_on_Body_clicked", [h])
			add_child(h)


func spawn_trees():
	var tree_amount = G.map_size.x * G.map_size.y / 50000
	var x = 0
	var y = 0
	for i in range(0, tree_amount):
		x = rand.randf_range(10,G.map_size.x-10)
		y = rand.randf_range(10,G.map_size.y-10)
		var collides = false
		for r in fort_areas:
			if r.intersects(Rect2(x-HALF_TILE_SIZE,y-HALF_TILE_SIZE,x+HALF_TILE_SIZE,y+HALF_TILE_SIZE), true):
				collides = true
		if (!collides):
			var h = tree.instance()
			h.position = Vector2(x, y)
			h.connect("clicked", self, "_on_Body_clicked", [h])
			add_child(h)


func spawn_enemys():
	var max_count_enemys = (G.world_size + 1) * (G.difficulty + 1) * 10
	for i in max_count_enemys:
		respawn_enemy()


func respawn_enemy():
	var enemy = enemy_tank.instance()
	var collides = true
	while collides:
		var x = rand.randf_range(10,G.map_size.x-10)
		var y = rand.randf_range(10,G.map_size.y-10)
		enemy.position = Vector2(x, y)
		collides = false
		for r in fort_areas:
			if r.intersects(Rect2(x-HALF_TILE_SIZE,y-HALF_TILE_SIZE,x+HALF_TILE_SIZE,y+HALF_TILE_SIZE), true):
				collides = true
	
	enemy.limits = limits
	enemy.connect("dead", self, "_on_EnemyTank_dead")
	enemy.connect("shoot", self, "_on_Enemy_shoot")
	enemy.connect("clicked", self, "_on_Body_clicked", [enemy])
	enemy.set_player(player)
	add_child(enemy)
	count_enemys += 1


func spawn_truck():
	var tr = truck.instance()
	tr.limits = limits
	tr.connect("drop_object", self, "_on_Truck_drop_object")
	tr.connect("clicked", self, "_on_Body_clicked", [tr])
	add_child(tr)


func spawn_forts():
	var count_forts = 1
	for i in count_forts:
		spawn_fort()
	flag_count = fort_areas.size()


func spawn_fort():
	var f = fort.instance()
	var x = rand.randf_range(10,G.map_size.x-10-64)
	var y = rand.randf_range(10,G.map_size.y-10-48)
	f.position = Vector2(x, y)
	f.init(player)
	f.connect("shoot", self, "_on_FortTower_shoot")
	add_child(f)
	fort_areas.append(Rect2(f.position, Vector2(64, 48)))


func spawn_radars():
	var count_radars = floor(G.map_size.x * G.map_size.y / 400000)
	prints("count_radars", count_radars)
	for i in count_radars:
		spawn_radar()


func spawn_radar():
	var rad = radar.instance()
	var collides = true
	while collides:
		var x = rand.randf_range(10,G.map_size.x-10)
		var y = rand.randf_range(10,G.map_size.y-10)
		rad.position = Vector2(x, y)
		collides = false
		for r in fort_areas:
			if r.intersects(Rect2(x-HALF_TILE_SIZE,y-HALF_TILE_SIZE,x+HALF_TILE_SIZE,y+HALF_TILE_SIZE), true):
				collides = true
	
	rad.connect("locate_player", self, "_on_Radar_locate_player")
	rad.set_player(player)
	add_child(rad)


func spawn_helli():
	var h = helli.instance()
	h.limits = limits
	h.set_player(player)
	h.connect("shoot", self, "_on_Enemy_shoot")
	h.connect("clicked", self, "_on_Body_clicked", [h])
	add_child(h)


func spawn_plane():
	var h = plane.instance()
	h.limits = limits
	h.set_player(player)
	h.connect("shoot", self, "_on_Enemy_shoot")
	h.connect("clicked", self, "_on_Body_clicked", [h])
	add_child(h)
	

func _unhandled_input(event):
	if game_over:
		return
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		# print("Mouse Click/Unclick at: ", event.position)
		if event.is_pressed():
			swipe_position_init = get_global_mouse_position() # get initial position
		else:
			swipe_position_release = get_global_mouse_position() # get final position on release of mouse button
			if swipe_position_release.distance_to(swipe_position_init) > MIN_SWIPE_DISTANCE:
				swipe_movement_vector = (swipe_position_release - swipe_position_init).normalized()  # obtain the movement vector
				player.drive_to(swipe_movement_vector)
			else:
				player.shot_to(swipe_position_release, current_bullet_type, last_clicked_body)
				last_clicked_body = null
				$MissileAim.hide()
				# emit_signal("clicked", swipe_position_release, current_bullet_type)
	elif event is InputEventMouseMotion:
		#print("Mouse Motion at: ", event.position)
		pass
	# Print the size of the viewport.
	#print("Viewport Resolution is: ", get_viewport_rect().size


func game_over(win: bool):
	game_over = true
	player.queue_free()
	emit_signal("game_over", win)
	$GameOver.play()
	

func _on_Body_clicked(body):
	last_clicked_body = body


func _on_Truck_drop_object(type, pickup_amount, position):
	if position.x < limits[0] || position.x > limits[1]:
		return
	if position.y < limits[2] || position.y > limits[3]:
		return
	var pickup = null
	match(type):
		pickup_types.Health:
			pickup = health.instance()
		pickup_types.Missile:
			pickup = missile.instance()
		pickup_types.Cannone:
			pickup = cannone.instance()
		pickup_types.Bomb:
			pickup = bomb.instance()
		_:
			print("Droped unknown pickup, type: ", type)
			return
	pickup.position = position
	pickup.type = type
	pickup.amount = pickup_amount
	pickup.add_to_group('pickups')
	add_child(pickup)


func _on_EnemyTank_dead():
	count_enemys -= 1
	emit_signal("change_count_enemys", count_enemys)
	
	
func _on_Enemy_shoot(bullet, _position, _direction, _target=null):
	var b = bullet.instance()
	add_child(b)
	b.start(_position, _direction, _target)
	
	
func _on_FortTower_shoot(bullet, _position, _direction):
	var b = bullet.instance()
	add_child(b)
	b.start(_position, _direction, null)


func _on_HUD_bomb_pressed():
	if !game_over:
		player.setBomb()


func _on_HUD_cannon_pressed():
	if !game_over:
		if player.cannone_count > 0:
			current_bullet_type = 1
		else:
			current_bullet_type = 0
		emit_signal("change_bullet_type", current_bullet_type)


func _on_HUD_shot_pressed():
	if !game_over:
		current_bullet_type = 0
		emit_signal("change_bullet_type", current_bullet_type)


func _on_HUD_missile_pressed():
	if !game_over:
		if player.missile_count > 0:
			current_bullet_type = 2
		else:
			current_bullet_type = 0
		emit_signal("change_bullet_type", current_bullet_type)


func _on_Player_set_bomb(bomb, _position):
	var b = bomb.instance()
	b.position = _position
	add_child(b)


func _on_Player_shoot(bullet, _position, _direction, _target=null):
	var b = bullet.instance()
	add_child(b)
	b.start(_position, _direction, _target)


func _on_Player_dead():
	game_over(false)


func _on_TruckTimer_timeout():
	spawn_truck()


func _on_Player_flag_picked():
	flag_count -= 1
	if flag_count <= 0:
		game_over(true)


func _on_Radar_locate_player(status: bool):
	player_located = status
	if status:
		spawn_helli()
		$HelliTimer.start()
		#TODO: timer start
		#$PlaneTimer.start() 
	for body in get_tree().get_nodes_in_group("air"):
		body.player_located = status


func _on_HelliTimer_timeout():
	if player_located:
		spawn_helli()


func _on_PlaneTimer_timeout():
	if player_located:
		spawn_plane()
