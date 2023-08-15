extends Area2D


const SAW_SPEED = 25


func _ready():
	EventManager.connect("damaged", Callable(self, "trigger_reset"))


func activate_blades():
	$Path1/PathFollow2D/Sawblade.speed = SAW_SPEED
	$Path2/PathFollow2D/Sawblade.speed = SAW_SPEED
	$Path3/PathFollow2D/Sawblade.speed = SAW_SPEED
	$Path4/PathFollow2D/Sawblade.speed = SAW_SPEED
	$Path5/PathFollow2D/Sawblade.speed = SAW_SPEED
	$Path6/PathFollow2D/Sawblade.speed = SAW_SPEED
	$Path7/PathFollow2D/Sawblade.speed = SAW_SPEED


func reset_blades():
	$Path1/PathFollow2D/Sawblade.speed = 0
	$Path2/PathFollow2D/Sawblade.speed = 0
	$Path3/PathFollow2D/Sawblade.speed = 0
	$Path4/PathFollow2D/Sawblade.speed = 0
	$Path5/PathFollow2D/Sawblade.speed = 0
	$Path6/PathFollow2D/Sawblade.speed = 0
	$Path7/PathFollow2D/Sawblade.speed = 0
	
	$Path1/PathFollow2D.progress_ratio = 0
	$Path2/PathFollow2D.progress_ratio = 0
	$Path3/PathFollow2D.progress_ratio = 0
	$Path4/PathFollow2D.progress_ratio = 0
	$Path5/PathFollow2D.progress_ratio = 0
	$Path6/PathFollow2D.progress_ratio = 0
	$Path7/PathFollow2D.progress_ratio = 0


func trigger_reset():
	reset_blades()


func _on_body_entered(body):
	if body is Player:
		activate_blades()
