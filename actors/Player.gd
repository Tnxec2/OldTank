class_name Player
extends "res://actors/Tank.gd"

signal change_bomb_count
signal set_bomb
signal change_cannon_count
signal change_missile_count
signal flag_picked

export (PackedScene) var Bomb
export (PackedScene) var Shot
export (PackedScene) var Cannone
export (PackedScene) var Missile

onready var camera = $Camera2D
onready var turret = $Turret
onready var muzzle = $Turret/Muzzle
onready var sound_pickup = $Sounds/PickUpSound
onready var sound_hit = $Sounds/HitSound


var bomb_count
var cannone_count
var missile_count

const PickupTypes = preload("res://pickups/PickupTypes.gd")

const TURRET_ROTATE_BACK_DELAY = 1
var turret_rotate_timer = 0


func _ready():
	is_player = true

	bomb_count = 30
	cannone_count = 30
	missile_count = 15

	emit_signal("change_bomb_count", bomb_count)
	emit_signal("change_cannon_count", cannone_count)
	emit_signal("change_missile_count", missile_count)


func control(delta):
	if !alive || G.game_over:
		return
	position.x = clamp(position.x, camera.limit_left + $Body.texture.get_width()/2, camera.limit_right - $Body.texture.get_width()/2)
	position.y = clamp(position.y, camera.limit_top + $Body.texture.get_height()/2, camera.limit_bottom - $Body.texture.get_height()/2)
	if turret_rotate_timer > 0:
		turret_rotate_timer -= delta
	elif turret_rotate_timer < 0:
		turret_rotate_timer = 0
		turret.set_rotation(0)


func drive_to(target_vector: Vector2) -> void:
	if !alive:
		return
	look_at(position+target_vector)
	velocity = target_vector * speed
	

func take_damage(amount):
	if !alive || G.game_over:
		return
	health -= amount
	health = max(health, 0)
	emit_signal('health_changed', health * 100/max_health)
	sound_hit.play()
	if health <= 0:
		explode()


func shot_to(position: Vector2, bulletType: int, target: Node2D = null):
	if !alive || G.game_over:
		return
	turret_rotate_timer = TURRET_ROTATE_BACK_DELAY
	turret.look_at(position)
	#var dir = Vector2(1, 0).rotated(turret.global_rotation)
	var dir = (muzzle.global_position - global_position).normalized()
	match(bulletType):
		0:
			emit_signal('shoot', Shot, muzzle.global_position, dir)
		1:
			if cannone_count > 0:
				cannone_count -= 1
				emit_signal("change_cannon_count", cannone_count)
				emit_signal('shoot', Cannone, muzzle.global_position, dir)
		2:
			if can_shoot && missile_count > 0:
				can_shoot = false
				$GunTimer.start()
				missile_count -= 1
				emit_signal("change_missile_count", missile_count)
				emit_signal('shoot', Missile, muzzle.global_position, dir, target)
	
	
func setBomb():
	if !alive || G.game_over:
		return
	if bomb_count <= 0:
		return
	bomb_count -= 1
	emit_signal("change_bomb_count", bomb_count)
	emit_signal('set_bomb', Bomb, position)


func put_pickup(type: int, amount: int):
	if !alive || G.game_over:
		return
	sound_pickup.play()
	match(type):
		PickupTypes.Health:
			health += amount
			health = clamp(health, 0, 100)
			emit_signal("health_changed", health)
		PickupTypes.Bomb:
			bomb_count += amount
			emit_signal("change_bomb_count", bomb_count)
		PickupTypes.Cannone:
			cannone_count += amount
			emit_signal("change_cannon_count", cannone_count)
		PickupTypes.Missile:
			missile_count += amount
			emit_signal("change_missile_count", missile_count)
		PickupTypes.Flag:
			emit_signal("flag_picked")
		_:
			print("Put unknown pickup, type: ", type, ", amount: ", amount)
	
