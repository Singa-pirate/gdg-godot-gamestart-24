extends CanvasLayer
var game

# Called when the node enters the scene tree for the first time.
func _ready():
	game = get_tree().get_root().get_node("Game")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	get_tree().paused = not get_tree().paused


func _on_level_1_button_pressed():
	game.change_level(1)


func _on_level_2_button_pressed():
	game.change_level(2)
