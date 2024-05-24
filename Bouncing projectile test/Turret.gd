extends Node2D
var bulletPath = preload("res://turret_bullet.tscn")
var rocketPath = preload("res://turret_rocket.tscn")
var can_fire : bool = true

func _ready():
	pass


func _process(delta):
	if can_fire:
		fire_bullet()

func fire_bullet():
	can_fire = false
	var bullet = bulletPath.instantiate()
	add_child(bullet)
	await get_tree().create_timer(1).timeout
	can_fire = true
	
