extends KinematicBody2D

signal health_changed
signal dead

export (PackedScene) var Bullet
export (int) var speed
export (float) var rotation_speed
export (float) var gun_cooldown
export (int) var max_health

var velocity = Vector2()
var can_shoot = true
var alive = true
var health

func _ready():
	health = max_health
	emit_signal("health_changed", health)
	$GunTimer.wait_time = gun_cooldown

func control(delta):
	pass

func _physics_process(delta):
	if not alive:
			return
	control(delta)
	move_and_slide(velocity)

func take_damage(amount):
	health -= amount
	health = max(health, 0)
	emit_signal('health_changed', health * 100/max_health)
	if health <= 0:
		explode()

func heal(amount):
	health += amount
	health = clamp(health, 0, max_health)
	emit_signal('health_changed', health * 100/max_health)
	
func explode():
	$CollisionShape2D.disabled = true
	alive = false
	$Turret.hide()
	$Body.hide()
	$Explosion.show()
	$Explosion.play()
	emit_signal('dead')

func _on_GunTimer_timeout():
	can_shoot = true

func _on_Explosion_animation_finished():
	queue_free()
