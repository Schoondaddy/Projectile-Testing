extends Node2D

const fire_cooldown = .5

@onready var BulletSpawn = $BulletSpawnPos

var bulletPath = preload("res://turret_bullet.tscn")
var rocketPath = preload("res://turret_rocket.tscn")
var can_fire : bool = true


func _ready():
	pass


func _process(delta):
	look_at(get_global_mouse_position())

func shoot_handler():
	if can_fire:
		can_fire = false
		fire_bullet()
		await get_tree().create_timer(fire_cooldown).timeout
		can_fire = true

func fire_bullet():
	var mousePos = get_global_mouse_position()
	var bullet = rocketPath.instantiate()
	add_child(bullet)
	bullet.global_position = BulletSpawn.global_position
	bullet.rotation = atan2(mousePos.y - global_position.y, mousePos.x - global_position.x)

