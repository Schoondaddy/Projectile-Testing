extends TileMap

const TileLightPath = preload("res://tile_light.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	for cell in get_used_cells(0):
		var polygon = get_cell_tile_data(0, cell).get_collision_polygon_points(0,0)
		
		for point in polygon:
			pass
		var light = TileLightPath.instantiate()
		add_child(light)
		light.global_position.x = cell.x * tile_set.tile_size.x + .5 * tile_set.tile_size.x
		light.global_position.y = cell.y * tile_set.tile_size.y + .5 * tile_set.tile_size.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#This all is just to get it to account for rotation and stuff
	var light_polygon = $"../Player/LightPivot/Area2D/CollisionPolygon2D"
	var polygon_points_global : PackedVector2Array
	
	for point in light_polygon.polygon:
		var global_point = light_polygon.global_position + point.rotated(light_polygon.global_rotation)
		polygon_points_global.append(global_point)
	polygon_points_global.insert(2, polygon_points_global[0])
	polygon_points_global.remove_at(0)
	
	
	
	for child in get_children():
		if child is PointLight2D && Geometry2D.is_point_in_polygon(child.global_position, polygon_points_global):
			print("sigma")
