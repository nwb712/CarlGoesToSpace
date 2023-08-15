extends Hazard

var path_follow
var has_path = false
var forward = true
@export var speed = 10

@export
var audio_timer_max = .25
var audio_timer = 0.0


func _process(delta):
	audio_timer += delta
	if audio_timer > audio_timer_max:
		audio_timer = 0.0
		$AudioStreamPlayer2D.play()


# Called when the node enters the scene tree for the first time.
func _ready():
	path_follow = get_parent()
	if path_follow is PathFollow2D:
		has_path = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if has_path:
		if path_follow.loop == false:
			check_direction()
			pass
		move(delta)


func move(delta):
	if forward:
		path_follow.progress += speed * delta
	else:
		path_follow.progress -= speed * delta


func check_direction():
	if forward and path_follow.progress_ratio >= 1.0:
		forward = not forward
	if not forward and path_follow.progress_ratio <= 0.0:
		forward = not forward
	
