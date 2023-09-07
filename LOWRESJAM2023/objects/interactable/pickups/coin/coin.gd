extends Area2D



func _on_body_entered(body):
	if body is Player:
		EventManager.emit_signal("coin_collected")
		$AnimatedSprite2D.play("collected") 
		$AudioStreamPlayer2D.play()



func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "collected":
		queue_free()
