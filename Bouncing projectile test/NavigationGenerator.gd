extends NavigationRegion2D

const upper_bound = -500
const lower_bound = 500
const rightmost_bound = 500
const leftmost_bound = -500

var nav_poly = NavigationPolygon.new()

@onready var tileMap = $"../TileMap"

func _ready():
	add_boundary()
	generate_polygon()
	nav_poly.make_polygons_from_outlines()
	self.navigation_polygon = nav_poly
	bake_navigation_polygon()

func add_boundary():
	
	
	var outline = PackedVector2Array([
		Vector2(leftmost_bound,upper_bound),
		Vector2(rightmost_bound,upper_bound),
		Vector2(rightmost_bound,lower_bound),
		Vector2(leftmost_bound,lower_bound)
	])
	nav_poly.add_outline(outline)
	
	
	


func generate_polygon():
	var list_of_polygons = []
	var tile_set = tileMap.tile_set
	
	for cell in tileMap.get_used_cells(0):
		var tile_id = tileMap.get_cell_source_id(0, cell)
		if tile_id != -1:
			var tile_size = tile_set.tile_size
			var polygon = tileMap.get_cell_tile_data(0, cell).get_collision_polygon_points(0,0)
			print (polygon)
			for i in polygon.size():
				polygon[i].x = polygon[i].x + (cell.x * tile_size.x)
				polygon[i].y = polygon[i].y + (cell.y * tile_size.y)
			
			
			list_of_polygons.append(polygon)
	
	var merged_polygon = PackedVector2Array()
	for polygon in list_of_polygons:
		merged_polygon = Geometry2D.merge_polygons(merged_polygon, polygon)
	merged_polygon = merged_polygon[0]
	print(merged_polygon)
	merged_polygon.reverse()
	print(merged_polygon)
	
	
	print(merged_polygon)
	var new_vertices = PackedVector2Array([Vector2(0, 0), Vector2(0, 50), Vector2(50, 50), Vector2(50, 0)])
	nav_poly.add_outline(merged_polygon)

