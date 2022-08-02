extends KinematicBody2D

signal clicked()
signal shoot(bullet, position, direction, target)

onready var sprite = $Sprite
onready var collisionShape = $CollisionShape2D
onready var explosion = $Explosion
onready var rotor = $Rotor

var missile = preload("res://bullets/EnemyMissile.tscn")

var limits = [0, 0, 0, 0] # left, right, top, bottom

var speed = 50
var velocity = Vector2()
var acceleration = Vector2()
var alive = true
var healt = 50
var can_shoot = true
const STEER_FORCE = 0.5

var rand = RandomNumberGenerator.new()

var player_located = true
var player = null
var target = null

func _ready():
	rand.randomize()
	rand_position()


func set_player(body):
	player = body
	

func rand_position():
	var dir = rand.randi_range(0, 1) # 0 - right, 1 - left
	var x = 0
	if ( dir == 0):
		x = -sprite.texture.get_width()
	else:
		x = limits[1]
	var y = player.global_position.y
	
	global_position = Vector2(x, y)
	randomRotate(dir)

func randomRotate(dir: int):
	var angle = 0
	if dir == 0: # drive to right
		angle = rand.randf_range(-PI/4, PI/4)
	else: # drive to left
		angle = rand.randf_range(PI/4*3, PI/4*5)
	velocity = Vector2(speed, 0).rotated(angle)
	rotate(angle)


func seek():
	var desired = (player.position - position).normalized() * speed
	var steer = (desired - velocity).normalized() * STEER_FORCE
	return steer


func control(delta):
	if global_position.x > limits[1]+20 || global_position.x < limits[0]-20:
		queue_free()
	if global_position.y > limits[3]+20 || global_position.y < limits[2]-20:
		queue_free()


func _physics_process(delta):
	if not alive:
		return
	control(delta)
	if player != null && is_instance_valid(player):
		if player_located:
			acceleration += seek()
		velocity += acceleration * delta
		velocity = velocity.clamped(speed)
		rotation = velocity.angle()
	position += velocity * delta
	shoot()


func shoot():
	if alive && can_shoot && target && is_instance_valid(player):
		can_shoot = false
		$GunTimer.start()
		var dir = (target.global_position - global_position).normalized()
		emit_signal('shoot', missile, $Muzzle.global_position, dir, target)
	
	
func take_damage(damage):
	healt -= damage
	if healt <= 0:
		explode()


func explode():
	collisionShape.disabled = true
	alive = false
	rotor.hide()
	sprite.hide()
	explosion.show()
	explosion.play()


func _on_Explosion_animation_finished():
	queue_free()


func _on_DetectRadius_body_entered(body):
	if body == player:
		target = body


func _on_DetectRadius_body_exited(body):
	if body == target:
		target = null


func _on_GunTimer_timeout():
	can_shoot = true
