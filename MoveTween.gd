extends Tween


func listen_to_completion(listener, function):
	connect("tween_completed", listener, function)
	pass

func move_to(c, t_pos):
	interpolate_property(
		c, 
		"position", 
		c.get_position(), 
		t_pos, 
		0.3, 
		Tween.TRANS_QUAD, 
		Tween.EASE_IN)
	start()
	pass
