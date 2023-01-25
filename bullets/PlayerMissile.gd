extends "res://bullets/Bullet.gd"


func init_missile():
	if target != null:
		$MissileAim.show()
		$MissileAim.global_position = target.global_position
	else:
		$MissileAim.hide()


func control(delta):
	if target != null && is_instance_valid(target):
		$MissileAim.global_position = target.global_position


func release():
	$MissileAim.hide()
