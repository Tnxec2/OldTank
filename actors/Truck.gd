extends KinematicBody2D

const PickupTypes = preload("res://pickups/PickupTypes.gd")

signal drop_object(type)

var limits = [0, 0, 0, 0] # left, right, top, bottom

var speed = 10
var velocity = Vector2()
var alive = true
var healt = 10
var type = PickupTypes.Unknown
var pickup_amount = 0
var rand = RandomNumberGenerator.new()

func _ready():
	rand.randomize()
	var t = rand.randi_range(0, 40)
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
		
	print('spawn truck, type: ', type, ', amount: ', pickup_amount)
	var dir = rand.randi_range(0, 1) # 0 - right, 1 - left
	var x = 0
	if ( dir == 0):
		x = -$Sprite.texture.get_width()
	else:
		x = limits[1]
	var y = rand.randf_range(limits[2]+10,limits[3]-10)
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

func control(delta):
	if global_position.x > limits[1]+20 || global_position.x < limits[0]-20:
		queue_free()
	if global_position.y > limits[3]+20 || global_position.y < limits[2]-20:
		queue_free()
	
func _physics_process(delta):
	if not alive:
		return
	control(delta)
	move_and_slide(velocity)
	
func take_damage(damage):
	healt -= damage
	if healt <= 0:
		explode()
		
func explode():
	$CollisionShape2D.disabled = true
	alive = false
	$Sprite.hide()
	$Explosion.show()
	$Explosion.play()
	emit_signal('drop_object', type, pickup_amount, position)

func _on_Explosion_animation_finished():
	queue_free()
