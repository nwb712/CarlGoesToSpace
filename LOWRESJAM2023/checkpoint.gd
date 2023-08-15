extends Area2D


func _ready():
	EventManager.connect("checkpoint_changed", Callable(self, "_on_checkpoint_changed"))

func _on_checkpoint_changed():
	if GameManager.respawn_pos != self.position:
		$AnimatedSprite2D.set_frame_and_progress(0, 0)


func _on_body_entered(body):
	if body is Player:
		if GameManager.respawn_pos != self.position:
			$AudioStreamPlayer2D.play()
			$AnimatedSprite2D.play()
			GameManager.respawn_pos = self.position
			EventManager.emit_signal("checkpoint_changed")
