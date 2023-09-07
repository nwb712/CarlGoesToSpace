extends Node2D

enum Screens {TUTORIALRUN, TUTORIALJUMP,TUTORIALDASH, TUTORIALSTUCK, STARTGAME}

var current_screen = Screens.TUTORIALRUN

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("menu_next"):
		current_screen += 1
		match current_screen:
			Screens.TUTORIALJUMP:
				$Player.position = $TutorialJump/SpawnPt.global_position
				# GameManager.respawn_pos = $TutorialJump/SpawnPt.global_position
			Screens.TUTORIALDASH:
				$Player.position = $TutorialDash/SpawnPt.global_position
				# GameManager.respawn_pos = $TutorialDash/SpawnPt.global_position
			Screens.TUTORIALSTUCK:
				$Player.position = $TutorialStuck/SpawnPt.global_position
				# GameManager.respawn_pos = $TutorialStuck/SpawnPt.global_position
			Screens.STARTGAME:
				get_tree().change_scene_to_file("res://the_world.tscn")
