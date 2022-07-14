extends Node2D

signal clicked(position)
signal swipedTo(vector)

signal set_bomb
signal change_killed_enemys
signal game_over

const MIN_SWIPE_DISTANCE = 32
var PP = Vector2(0,0)
var s1
var s2

var limits = [0, 0, 0, 0] # left, right, top, bottom

var map_size = Vector2.ZERO
var killed_enemys = 0
var game_over = false

enum BulletType {
	SHOT,
	CANNON,
	MISSILE
}

func _ready():
	get_map_size()
	set_camera_limits()
	$Player.position =  Vector2(map_size.x/2, map_size.y/2)
	emit_signal("change_killed_enemys", killed_enemys)

func get_map_size():
	var map_limits = $Ground.get_used_rect()
	var map_cellsize = $Ground.cell_size
	limits[0] = map_limits.position.x * map_cellsize.x
	limits[1] = map_limits.end.x * map_cellsize.x
	limits[2] = map_limits.position.y * map_cellsize.y
	limits[3] = map_limits.end.y * map_cellsize.y
	map_size = Vector2(limits[1]-limits[0], limits[3]-limits[2])

func set_camera_limits():
	$Player/Camera2D.limit_left = limits[0]
	$Player/Camera2D.limit_right = limits[1]
	$Player/Camera2D.limit_top = limits[2]
	$Player/Camera2D.limit_bottom = limits[3]


# func _unhandled_input(event):
func _unhandled_input(event):
	if game_over:
		return
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		# print("Mouse Click/Unclick at: ", event.position)
		if event.is_pressed():
			s1 = get_global_mouse_position() # get initial position
		else:
			s2 = get_global_mouse_position() # get final position on release of mouse button
			if s2.distance_to(s1) > MIN_SWIPE_DISTANCE:
				PP = (s2 - s1).normalized()  # obtain the movement vector 
				emit_signal("swipedTo", PP)
			else:
				emit_signal("clicked", s2)
	elif event is InputEventMouseMotion:
		#print("Mouse Motion at: ", event.position)
		pass
	# Print the size of the viewport.
	#print("Viewport Resolution is: ", get_viewport_rect().size

func game_over():
	game_over = true
	emit_signal("game_over")

func _on_HUD_bomb_pressed():
	if !game_over:
		$Player.setBomb()

func _on_HUD_cannon_pressed():
	if !game_over:
		print('_on_Buttons_cannon_pressed')

func _on_HUD_shot_pressed():
	if !game_over:
		print('_on_Buttons_shot_pressed')

func _on_HUD_missile_pressed():
	if !game_over:
		print('_on_Buttons_missile_pressed')

func _on_Player_set_bomb(bomb, _position):
	var b = bomb.instance()
	b.position = _position
	add_child(b)

func _on_Player_shoot(bullet, _position, _direction, _target=null):
	var b = bullet.instance()
	add_child(b)
	b.start(_position, _direction, _target)

func _on_Player_dead():
	game_over()
