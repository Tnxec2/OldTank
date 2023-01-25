extends StaticBody2D

signal clicked
signal shoot(bullet, muzzle_position, target_dir)
signal dead

var bullet = preload("res://bullets/TowerShot.tscn")

onready var muzzle_position = $Turret/Muzzle.global_position
onready var gun_timer = $GunTimer

var health
var turret_target = null
var player = null
var start_pause = true

func _ready():
	health = 100
	var circle = CircleShape2D.new()
	circle.radius = 80 + G.difficulty * 20
	$DetectRadius/CollisionShape2D.shape = circle


func set_player(p):
	player = p
	

func take_damage(damage: int):
	health -= damage
	if health <= 0:
		emit_signal("dead")
		queue_free()


func shoot():
	if !start_pause && turret_target && !G.game_over:
		var target_dir = (turret_target.global_position - global_position).normalized()
		emit_signal('shoot', bullet, muzzle_position, target_dir)
		gun_timer.start()


func _on_Tower_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		emit_signal("clicked")


func _on_DetectRadius_body_entered(body):
	if body == player:
		turret_target = body
		shoot()


func _on_DetectRadius_body_exited(body):
	if body == turret_target:
		turret_target = null


func _on_GunTimer_timeout():
	if turret_target:
		var target_dir = (turret_target.global_position - global_position).normalized()
		shoot()


func _on_StartTimer_timeout() -> void:
	start_pause = false
