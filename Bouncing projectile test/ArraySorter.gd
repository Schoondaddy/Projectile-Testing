extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var array : Array = [-672, 388, -419, 924, -198, 764, -999, 435, -726, 268, 987, -264, 306, -674, 690, 172, -345, 821, -908, 610, 233, -457, 579, -301, 803, -222, 470, -517, 411, -810, 63, 976, -643, -528, 337, -966, 505, -77, 844, -132, 998, -711, 456, -839, 213, -488, 924, -575, 681, -234, 762, -897, 345, 678, -123, 890, -456, 321, -789, 234, -567, 890, -234, 123, -456, 789, -123, 456, -789, 123, -456, 789, -321, 654, -987, 543, -210, 876, -543, 210, -876, 543, -210, 876, -543, 210, -876, 543, -210, 876, -543, 210, -876, 543, -210, 876, -543, 210]
	var start_time = Time.get_ticks_usec()
	
	# Your array to sort
	var my_array = [5, 9, 3, 8, 2, 1, 4, 7, 6]
	
	# Call the sort function
	sort_array(array)
	
	var end_time = Time.get_ticks_usec()
	var elapsed_time = end_time - start_time


func sort_array(input_array : Array):
	var sorted_array : Array = []
	if input_array.size() > 1:
		sorted_array.append(input_array[0])
		for index in input_array.size():
			var place_found = false
			var i : int = 0
			while !place_found && i < sorted_array.size():
				if input_array[index] < sorted_array[i]:
					sorted_array.insert(i, input_array[index])
					place_found = true
				i += 1
			if place_found == false:
				sorted_array.append(input_array[index])
	return sorted_array
