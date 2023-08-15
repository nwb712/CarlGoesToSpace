class_name ElevatorSwitch
extends Area2D

@export_range(0.0, 1.0)
var progress = 1.0

var progress_pixels

var audio_timer = 0.0
var audio_timer_max = 2.0

func _ready():
	get_parent().connect("arrived", Callable(self, "_on_arrival"))


func _process(delta):
	audio_timer += delta


func _on_arrival():
	# if progress == check_elevator_progress():
	$AnimatedSprite2D.pause()
	$AnimatedSprite2D.set_frame_and_progress(0,0)


func _on_body_entered(body):
	if (body is Player) and progress != check_elevator_progress(): # and not get_parent().active:
		if audio_timer > audio_timer_max:
			audio_timer = 0.0
			$AudioStreamPlayer2D.play()
		get_parent().active = true
		get_parent().target = progress
		$AnimatedSprite2D.play()


func check_elevator_progress():
	return get_parent().get_elevator_progress()
