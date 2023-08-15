extends Node2D

var coins = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	coins = GameManager.coins
	if coins >= 18:
		$Control/Rank.frame = 3
	elif coins > 10:
		$Control/Rank.frame = 2
	elif coins > 8:
		$Control/Rank.framer = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://the_world.tscn")
