extends Area2D


var collider

@export
var impulse = Vector2(0, -175)

var character
var body
var initial_position

var reset = false

func _ready():
	body = $CharacterBody2D
	initial_position = body.position


func _on_animated_sprite_2d_frame_changed():
	var frame = $AnimatedSprite2D.frame
	match frame:
		0:
			if body.position != initial_position:
				body.position = initial_position
				if reset:
					$AnimatedSprite2D.pause()
					character = null
		1:
			if body.position != initial_position + Vector2(0, 1):
				body.position = initial_position + Vector2(0, 1)
		2:
			if body.position != initial_position:
				body.position = initial_position
		3:
			if body.position != initial_position + Vector2(0, -1):
				body.position = initial_position + Vector2(0, -1)
				if character is Player:
					character.change_state(character.States.JUMP)
					character.nullify_next_state_change = true
					character.lock_fastfall = true
				character.velocity = impulse
				reset = true
				$AudioStreamPlayer2D.play()


func _on_body_entered(c):
	if c is Player:
		$AnimatedSprite2D.play()
		character = c
