extends KinematicBody2D

signal health_changed
signal dead
signal shoot

export (PackedScene) var Bullet
export (int) var speed
export (float) var rotation_speed
export (float) var gun_cooldown
export (int) var max_health

export (int) var gun_shots = 1
export (float, 0, 1.5) var gun_spread = 0.2

onready var sound_explosion = $Sounds/ExplosionSound

var velocity = Vector2()
var can_shoot = true
var alive = true
var health

var is_player = false

# Random number generator
var rng = RandomNumberGenerator.new()

func _ready():
	health = max_health
	emit_signal("health_changed", health)
	$GunTimer.wait_time = gun_cooldown
	rng.randomize()


func control(delta):
	pass


func shoot(num, spread, target=null):
	if alive && can_shoot && !G.game_over:
		can_shoot = false
		$GunTimer.start()
		var dir = Vector2(1, 0).rotated($Turret.global_rotation)
		if num > 1:
			for i in range(num):
				var a = -spread + i * (2*spread)/(num-1)
				emit_signal('shoot', Bullet, $Turret/Muzzle.global_position, dir.rotated(a), target)
		else:
			emit_signal('shoot', Bullet, $Turret/Muzzle.global_position, dir, target)


func _physics_process(delta):
	if not alive:
		return
	control(delta)
	if is_player:
		move_and_slide(velocity)
	else:
		var collision = move_and_collide(velocity*delta)
		if collision != null and collision.collider != G.player:
			var angle = rng.randf_range(PI/4, PI/2)
			velocity = velocity.rotated(angle)
			rotate(angle)
			


func take_damage(amount):
	if !alive:
		return
	health -= amount
	health = max(health, 0)
	emit_signal('health_changed', health * 100/max_health)
	control_health()
	if health <= 0:
		explode()


func control_health():
	pass
	

func heal(amount):
	health += amount
	health = clamp(health, 0, max_health)
	emit_signal('health_changed', health * 100/max_health)
	

func explode():
	set_process(false)
	$CollisionShape2D.disabled = true
	alive = false
	$Turret.hide()
	$Body.hide()
	$Explosion.show()
	$Explosion.play()
	sound_explosion.play()
	emit_signal('dead')
	

func _on_GunTimer_timeout():
	can_shoot = true

func release_on_explosion():
	pass
	
	
func _on_Explosion_animation_finished():
	release_on_explosion()
	if !is_player:
		queue_free()
	else:
		$Explosion.hide()

