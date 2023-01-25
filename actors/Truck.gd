class_name Truck
extends KinematicBody2D

const PickupTypes = preload("res://pickups/PickupTypes.gd")

signal drop_object(type)
signal clicked
signal dead

onready var sprite = $Sprite
onready var collisionShape = $CollisionShape2D
onready var explosion = $Explosion

var limits = [0, 0, 0, 0] # left, right, top, bottom

var speed = 10
var velocity = Vector2()
var alive = true
const MAX_HEALTH = 10
var health = 0
var type = PickupTypes.Unknown
var pickup_amount = 0
var rand = RandomNumberGenerator.new()
var old_position: Vector2 = Vector2.ZERO


func _ready():
	rand.randomize()
	rand_type()
	rand_position()
	old_position = position
	health = MAX_HEALTH
	$HealthBar.hide()


func rand_position():
	var dir = rand.randi_range(0, 1) # 0 - right, 1 - left
	var x = 0
	if ( dir == 0):
		x = -sprite.texture.get_width()
	else:
		x = limits[1]
	var y = rand.randf_range(limits[2]+10,limits[3]-10)
	global_position = Vector2(x, y)
	randomRotate(dir)


func rand_type():
	var t = rand.randi_range(0, 30)
	if t < 10:
		type = PickupTypes.Health
		pickup_amount = rand.randi_range(5, 10)
	elif t < 15:
		type = PickupTypes.Cannone
		pickup_amount = rand.randi_range(5, 10)
	elif t < 20:
		type = PickupTypes.Missile
		pickup_amount = rand.randi_range(1, 5)
	elif t < 25:
		type = PickupTypes.Bomb
		pickup_amount = rand.randi_range(1, 5)
	
	
func randomRotate(dir: int):
	var angle = 0
	if dir == 0: # drive to right
		angle = rand.randf_range(-PI/4, PI/4)
	else: # drive to left
		angle = rand.randf_range(PI/4*3, PI/4*5)
	velocity = Vector2(speed, 0).rotated(angle)
	rotate(angle)


func control(delta):
	if health < MAX_HEALTH:
		$HealthBar.set_global_position(Vector2(global_position.x-8, global_position.y-9))
		$HealthBar.set_rotation(-rotation)
	if global_position.x > limits[1]+20 || global_position.x < limits[0]-20:
		emit_signal("dead")
		queue_free()
	if global_position.y > limits[3]+20 || global_position.y < limits[2]-20:
		emit_signal("dead")
		queue_free()
	
	
func _physics_process(delta):
	if not alive:
		return
	control(delta)
	var collision = move_and_collide(velocity*delta)
	if collision != null and collision.collider != G.player:
		var angle = rand.randf_range(PI/4, PI/2)
		velocity = velocity.rotated(angle)
		rotate(angle)


func take_damage(damage):
	health -= damage
	$HealthBar.show()
	$HealthBar.rect_size.x = 16 * health / MAX_HEALTH
	if health <= 0:
		explode()
		
		
func explode():
	collisionShape.disabled = true
	alive = false
	sprite.hide()
	explosion.show()
	explosion.play()
	emit_signal('drop_object', type, pickup_amount, position)
	emit_signal("dead")
	

func _on_Explosion_animation_finished():
	queue_free()


func _on_Truck_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		emit_signal("clicked")


func _on_StuckTimer_timeout():
	if old_position.distance_to(position) <= 1:
		rotate(PI/2)
		velocity = velocity.rotated(PI/2)
	old_position = position
