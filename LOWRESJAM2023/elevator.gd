extends Node2D

@export
var speed = 1.0

const DETECTOR_DELAY = 0.25

var platform_sprite
var path
var detector

var locations = []
var previous_location
var direction = true

@export
var active = false
@export
var continuous = false
var target = 0.0

signal arrived()

func _ready():
	path = $ElevatorPath/ElevatorPathFollow
	platform_sprite = $ElevatorPath/ElevatorPathFollow/ElevatorPlatform/AnimatedSprite2D
	detector = $ElevatorPath/ElevatorPathFollow/ElevatorPlatform/ElevatorDetector
	detector.connect("body_entered", Callable(self, "trigger_detector"))
	if not continuous:
		get_switch_locations()
	if continuous:
		target = 1.0


# load all switch progress values at ready
func get_switch_locations():
	var children = get_children()
	for c in children:
		if c is ElevatorSwitch:
			locations += [c.progress]
	previous_location = get_closest_switch_index()


func get_closest_switch_index():
	var closest = locations[0]
	for l in range(locations.size()):
		if abs(locations[l] - get_elevator_progress()) < 0.1:
			return l
	return 0


func select_next_switch():
	var current_switch = get_closest_switch_index()
	if direction:
		if current_switch == locations.size() - 1:
			direction = false
			current_switch = locations[current_switch-1]
		else:
			current_switch = locations[current_switch+1]
	else:
		if current_switch == 0:
			direction = true
			current_switch = locations[current_switch+1]
		else:
			current_switch = locations[current_switch-1]
	return current_switch


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if active:
		platform_sprite.play()
		path.progress_ratio = move_toward(path.progress_ratio, target, speed * delta)
		if continuous:
			if get_elevator_progress() == target or abs(get_elevator_progress() - target) < .001:
				if target == 1.0:
					target = 0.0
				elif target == 0.0:
					target = 1.0
		elif get_elevator_progress() == target or abs(get_elevator_progress() - target) < .001: # 
			emit_signal("arrived")
			active = false
			platform_sprite.pause()


func trigger_switch(progress):
	if not active:
		await get_tree().create_timer(DETECTOR_DELAY).timeout
		active = true
		target = progress
		platform_sprite.play()


func get_elevator_progress():
	return path.progress_ratio


func trigger_detector(body):
	if body is Player and not continuous:
		trigger_switch(select_next_switch())


"""
func get_next_switch_location():
	var children = get_children()
	var switch_locations = []
	for c in children:
		# print(str(get_elevator_progress()) + ' ' + str(children[c].progress))
		if c is ElevatorSwitch:
			if get_elevator_progress() != c.progress and not abs(get_elevator_progress() - c.progress) < .01:
				switch_locations += [c.progress]
	
	var closest = switch_locations[0]
	for l in range(1, switch_locations.size()):
		if abs(switch_locations[l] - get_elevator_progress()) < abs(closest - get_elevator_progress()):
			closest = switch_locations[l]
	
	print(closest)
	return closest
"""
