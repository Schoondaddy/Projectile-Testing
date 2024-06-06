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
	var list_of_polygons = [] #This will be where all of the polygons will be stored
	var tile_set = tileMap.tile_set
	for cell in tileMap.get_used_cells(0):
		var tile_id = tileMap.get_cell_source_id(0, cell)
		if tile_id != -1: #Check if the tile exists
			var tile_size = tile_set.tile_size
			var polygon = tileMap.get_cell_tile_data(0, cell).get_collision_polygon_points(0,0) #Getting the shape of the tilemap tile
			for i in polygon.size(): #Correcting size and position of polygon points
				polygon[i].x = 0.0625 * polygon[i].x + 8 + cell.x * tile_size.x
				polygon[i].y = 0.0625 * polygon[i].y + 8 + cell.y * tile_size.y
			list_of_polygons.append(polygon) #Adding finished polygons to list of polygons
	
	for polygon in list_of_polygons:
		polygon.reverse() #Puts the points in correct clockwise order
		nav_poly.add_outline(polygon) #Adds the outline of the polygon to the navigation polygon
