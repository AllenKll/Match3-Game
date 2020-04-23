extends Area2D

export (bool) var movable = true;
export (Color) var color 
signal gem_stopped
signal gem_moving
signal gem_selected
var is_moving = false;
onready var tween = $MoveTween
var newPosition

var colors = [ 
	Color.red,
	Color.blue,
	Color.green,
	Color.yellow,
	Color.magenta,
	Color.cyan,
	Color.white,
	]


# Called when the node enters the scene tree for the first time.
func _ready():
	tween.listen_to_completion(self, "tweenDone") 
	color = colors[randi() % colors.size()]
	modulate = color

func _process(_delta):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if movable:
		if canFall() && !is_moving:
			emit_signal("gem_moving")
			fall();

func tweenDone(_object, _nodepath):
	if canFall():
		fall();
	else:	
		is_moving = false
		emit_signal("gem_stopped")
		

func swapTop(pos):
	emit_signal("gem_moving")
	tween.move_to( self, pos )
	is_moving = true;
	
func swapBottom(pos):
	emit_signal("gem_moving")
	tween.move_to( self,pos )
	is_moving = true;

func canFall():
	return !$Down.is_colliding()

func fall():
	is_moving = true;
	newPosition = position
	newPosition.y += 64
	tween.call_deferred("move_to", self, newPosition )
			

func deselect():
	$Selected_sprite.visible = false

func _on_Gem_input_event(viewport, event, shape_idx):
	if !is_moving && event.is_pressed():
		$Selected_sprite.visible = true
		emit_signal("gem_selected", self)
