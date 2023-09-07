extends StaticBody2D

var open = false

func open_gate():
	$AnimatedSprite2D.play()


func close_gate():
	$AnimatedSprite2D.play_backwards()


func _on_animated_sprite_2d_animation_finished():
	if not open:
		$CollisionShape2D.disabled = true
		open = true
	else:
		$CollisionShape2D.disabled = false
		open = false
