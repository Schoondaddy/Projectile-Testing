extends TileMap

const TileLightPath = preload("res://tile_light.tscn")
const max_light_energy = 5.0

@onready var player = $"../Player"
@onready var light_polygon = $"../Player/LightPivot/Area2D/CollisionPolygon2D"

var greatest_distance : float


# Called when the node enters the scene tree for the first time.
func _ready():
	for point in light_polygon.polygon:
		if point.distance_to(Vector2(0,0)) > greatest_distance:
			greatest_distance = point.distance_to(Vector2(0,0))
	
	for cell in get_used_cells(0):
		var light = TileLightPath.instantiate()
		add_child(light)
		light.global_position.x = cell.x * tile_set.tile_size.x + .5 * tile_set.tile_size.x
		light.global_position.y = cell.y * tile_set.tile_size.y + .5 * tile_set.tile_size.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#This all is just to get it to account for rotation and stuff
	var polygon_points_global : PackedVector2Array
	
	for point in light_polygon.polygon:
		var global_point = light_polygon.global_position + point.rotated(light_polygon.global_rotation)
		polygon_points_global.append(global_point)
	
	for child in get_children():
		if child is PointLight2D:
			var charging_intensity : float = child.global_position.distance_to(player.global_position) / greatest_distance * .001
			if Geometry2D.is_point_in_polygon(child.global_position, polygon_points_global):
				print("sigma")
				child.energy = lerp(child.energy, max_light_energy, charging_intensity)
			else:
				child.energy = lerp(child.energy, 0.0, .005)
