extends "res://tank/Tank.gd"

export (float) var turret_speed
export (int) var detect_radius
var turret_target = null
var player = null

var limits = [0, 0, 0, 0] # left, right, top, bottom

var rand = RandomNumberGenerator.new()

func _ready():
	var circle = CircleShape2D.new()
	$DetectRadius/CollisionShape2D.shape = circle
	$DetectRadius/CollisionShape2D.shape.radius = detect_radius
	rand.randomize()
	randomRotate()
	
func randomRotate():
	var angle = rand.randf_range(0, PI)
	velocity = Vector2(speed, 0).rotated(angle)
	rotate(angle)
	$Turret.rotate(0)
	
func control(delta):
	wrap_around_map()

func drive_to(target_vector: Vector2) -> void:
	look_at(position+target_vector)
	velocity = target_vector * speed

func set_player(p):
	player = p

func setDirection(delta):
	if turret_target == null:
		return
	var vec_to_player = turret_target.global_position - global_position
	vec_to_player = vec_to_player.normalized()
	drive_to(vec_to_player)

func wrap_around_map():
	if global_position.x > limits[1]:
		global_position.x = limits[0] + 10
	elif global_position.x < limits[0]:
		global_position.x = limits[1] - 10
	if global_position.y > limits[3]:
		global_position.y = limits[2] + 10
	elif global_position.y < limits[2]:
		global_position.y = limits[3] - 10

func _process(delta):
	if turret_target:
		var target_dir = (turret_target.global_position - global_position).normalized()
		var current_dir = Vector2(1, 0).rotated($Turret.global_rotation)
		$Turret.global_rotation = current_dir.linear_interpolate(target_dir, turret_speed * delta).angle()
		if target_dir.dot(current_dir) > 0.9:
			shoot(gun_shots, gun_spread, turret_target)

func _on_DetectRadius_body_entered(body):
	turret_target = body

func _on_DetectRadius_body_exited(body):
	if body == turret_target:
		turret_target = null
