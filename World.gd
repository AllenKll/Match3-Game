extends Node2D

enum{
	NONE_SELECTED,
	ONE_SELECTED,
	TWO_SELECTED,
	SWAPPED,
	MOVING,
}

var Gem = load("res://Gem.tscn")
var GemFactory = load("res://GemFactory.gd")
var gems = []
var numGemsMoving = 0
var selectedGem = [null, null]
var state = NONE_SELECTED

# Called when the node enters the scene tree for the first time.
func _ready():
	for node in $Board.get_children():
		if node is GemFactory:
			node.connect("GemCreated", self, "newGem")
			node.enable()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("ui_select"):
		var newPos = mouseToGrid(get_local_mouse_position())
		if gems.find(newPos) != -1:
			var instance = Gem.instance();
			instance.position = newPos
			newGem(instance)

	if numGemsMoving > 0:
		state = MOVING

	match state:
		MOVING:
			if selectedGem[0] != null:
				deselectGems()
			if numGemsMoving == 0:
				state = NONE_SELECTED
		ONE_SELECTED:
			pass
		NONE_SELECTED:
			pass
		TWO_SELECTED:
			swap_gems()
			deselectGems()
		SWAPPED:
			# check for match
			state = NONE_SELECTED
			pass
			
			

func validMatch():
	pass

func deselectGems():
	for i in range(2):
		if selectedGem[i]:
			selectedGem[i].deselect()
			selectedGem[i] = null


func swap_gems():
	selectedGem[0].swapTop(selectedGem[1].position)
	selectedGem[1].swapBottom(selectedGem[0].position)
	state = SWAPPED

func newGem(gem):
	gem.connect("gem_stopped", self, "onGemStopped")
	gem.connect("gem_moving", self, "onGemMoving")
	gem.connect("gem_selected", self, "onGemSelected")
	$Board.call_deferred("add_child", gem)
	gems.append(gem)

func onGemSelected(gem):
	match state:
		NONE_SELECTED:
			selectedGem[0] = gem
			state = ONE_SELECTED
		ONE_SELECTED:
			if gem == selectedGem[0]:
				deselectGems();
				state = NONE_SELECTED
			else:
				selectedGem[1] = gem
				state = TWO_SELECTED
		_:
			gem.deselect()

func onGemMoving():
	numGemsMoving += 1

func onGemStopped():
	numGemsMoving -= 1

func arrayToGrid(pos):
	var x = pos.x
	var y = pos.y
	
	pos.x = x * $Board.cell_size.x
	pos.y = y * $Board.cell_size.y
	
	return pos


func mouseToGrid(pos):
	var x = pos.x
	var y = pos.y
	
	pos.x = floor(x / $Board.cell_size.x) * $Board.cell_size.x
	pos.y = floor(y / $Board.cell_size.y) * $Board.cell_size.y
	
	return pos