extends StaticBody2D

signal clicked()
signal shoot

var bullet = preload("res://bullets/TowerShot.tscn")

onready var muzzle_position = $Turret/Muzzle.global_position
onready var gun_timer = $GunTimer

var health
var turret_target = null
var player = null

func _ready():
	health = 100
	

func set_player(p):
	player = p
	

func take_damage(damage: int):
	health -= damage
	if health <= 0:
		queue_free()


func shoot():
	if turret_target:
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
