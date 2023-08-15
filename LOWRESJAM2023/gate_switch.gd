extends Area2D

var toggled = false

func _on_body_entered(body):
	if body is Player and not toggled:
		$AnimatedSprite2D.play()
		$AudioStreamPlayer2D.play()
		get_parent().open_gate()
		toggled = true
