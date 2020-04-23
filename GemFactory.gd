extends Area2D

var Gem = load("res://Gem.tscn")
signal GemCreated

func enable():
	_on_GemFactory_area_exited(null)

func _on_GemFactory_area_exited(_area):
#		var areas = get_overlapping_areas()
#		if get_overlapping_areas().size() > 0:
#			return
		if $RayCast2D.is_colliding():
			return
		var gem = Gem.instance();
		gem.position = position
		emit_signal("GemCreated", gem)

