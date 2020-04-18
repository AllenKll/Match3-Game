extends Node2D

var Gem = load("res://Gem.tscn")
signal GemCreated

func enable():
	_on_GemFactory_area_exited(null)

func _on_GemFactory_area_exited(_area):
		#print( "creating gem")
		var gem = Gem.instance();
		gem.position = position
		emit_signal("GemCreated", gem)

