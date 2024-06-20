extends TileMap

const TileLightPath = preload("res://Scenes/Spawnables/tile_light.tscn")
const max_light_energy = .5

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
		light.global_position.x = (cell.x + .5) * tile_set.tile_size.x
		light.global_position.y = (cell.y + .5) * tile_set.tile_size.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	tile_lighting()

func tile_lighting():
	#This all is just to get it to account for rotation and stuff
	var polygon_points_global : PackedVector2Array
	
	for point in light_polygon.polygon:
		var global_point = light_polygon.global_position + point.rotated(light_polygon.global_rotation)
		polygon_points_global.append(global_point)
	
	for child in get_children():
		if child is PointLight2D:
			var charging_intensity : float = child.global_position.distance_to(player.global_position) / greatest_distance * .001
			
			#All of the stuff with corners is so it checks if all of the corners of the shape are in rather than the center
			
			var tile_size = tile_set.tile_size
			var tile : Vector2
			var corners_of_cell : PackedVector2Array
			var corner_is_in : bool = false
			
			tile.x = child.global_position.x - tile_size.x * .5
			tile.y = child.global_position.y - tile_size.y * .5
			
			corners_of_cell.append(tile)
			corners_of_cell.append(Vector2(tile.x + tile_size.x, tile.y))
			corners_of_cell.append(Vector2(tile.x + tile_size.x, tile.y + tile_size.y))
			corners_of_cell.append(Vector2(tile.x, tile.y + tile_size.y))
			
			for corner in corners_of_cell:
				if Geometry2D.is_point_in_polygon(corner, polygon_points_global):
					for cell in get_used_cells(0):
						if !corner_is_in:
							#All this is so it accounts for occlusion
							var tile_data = get_cell_tile_data(0, cell)
							var tile_occluder = tile_data.get_occluder(0)
							var global_polygon : PackedVector2Array
							
							if tile_occluder != null:
								global_polygon = tile_occluder.polygon
							
							#This makes the polygon global
							for point in global_polygon.size():
								global_polygon[point].x = (global_polygon[point].x + cell.x + .5) * tile_set.tile_size.x
								global_polygon[point].y = (global_polygon[point].y + cell.y + .5) * tile_set.tile_size.y
							
							var connections = generate_connections(global_polygon)
							var pathfinder = PolygonPathFinder.new()
							pathfinder.setup(global_polygon, connections)
							
							var intersections = pathfinder.get_intersections(player.global_position, child.global_position)
							
							if intersections.size() > 0:
								corner_is_in = true
			
			if corner_is_in:
				child.energy = lerp(child.energy, max_light_energy, charging_intensity)
				child.get_node("ColorRect").visible = true
			else:
				child.get_node("ColorRect").visible = false
				child.energy = lerp(child.energy, 0.0, .005)


func generate_connections(points):
	#Thingy i stole from copilot
	#I should stop stealing things from copilot
	#But most of my work is my own
	#I swear
	var connections = PackedInt32Array()
	for i in range(points.size() - 1):
		connections.append_array([i, i + 1])
	connections.append_array([points.size() - 1, 0])
	return connections
