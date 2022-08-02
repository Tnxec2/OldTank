extends Node

var difficulty = 0 # 0 - easy, 1 - medium, 2 - hard
var world_size = 0 # 0 - small, 1 - middle, 2 - big

var player = null
var map_size: Vector2 = Vector2()
var located_forts: PoolVector2Array = PoolVector2Array()
