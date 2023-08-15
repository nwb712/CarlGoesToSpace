extends Area2D

var grabbed = false

func _on_body_entered(body):
	if body is Player and not grabbed:
		grabbed = true
		EventManager.emit_signal("key_collected")
		$Sprite2D.visible = false
		$AudioStreamPlayer2D.play()


func _on_audio_stream_player_2d_finished():
	queue_free()
