class_name Player
extends CharacterBody2D

@onready
var anim = $AnimatedSprite2D

enum States {IDLE, STAND, RUN, JUMP, DASH}
var state = States.STAND
var previous_state = States.IDLE
var queued_state_change = null

const SPEED = 60.0
const ACCELERATION = 10.0
const DASH_SPEED = 90.0
const JUMP_VELOCITY = -100.0
const GRAVITY = 400.0
const TERMINAL_VELOCITY = 100
const DASH_DURATION = .3
const RUN_SOUND_INTERVAL = .2

var can_move = true
var can_jump = true
var can_dash = true
var can_input = true
var nullify_next_state_change = false
var lock_fastfall = false
var idle_timer = 0.0
var dash_timer = 0.0
var run_sound_timer = 0.0

var respawn_pos = Vector2()

func _ready():
	EventManager.emit_signal("player_spawned", self)
	respawn_pos = self.position


# Switch to a new state-
func change_state(new_state):
	if nullify_next_state_change:
		nullify_next_state_change = false
		return
	if lock_fastfall:
		lock_fastfall = false
	if new_state is States:
		previous_state = state
		state = new_state
	if can_input:
		anim_update_state()


func _physics_process(delta):
	check_ground()
	check_idle(delta)
	apply_queued_state()
	_choose_state_process(delta)
	if can_move:
		move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		# print("I collided with ", collision.get_collider().name)
	anim_update()
	handle_reset()


func handle_reset():
	if Input.is_action_just_pressed("reset"):
		die()


func apply_queued_state():
	if queued_state_change:
		change_state(queued_state_change)
		queued_state_change = null


# Direct process to proper state method
func _choose_state_process(delta):
	match state:
		States.IDLE:
			_idle_process(delta)
		States.STAND:
			_stand_process(delta)
		States.RUN:
			_run_process(delta)
		States.JUMP:
			_jump_process(delta)
		States.DASH:
			_dash_process(delta)


# Check if state needs to be idle
func check_idle(delta):
	if state == States.STAND:
		idle_timer += delta
	else: 
		idle_timer = 0.0


# Check whether character is on ground and restore dash/jump when true
func check_ground():
	if is_on_floor():
		if can_jump == false:
			$Sounds/Land.play()
		can_jump = true
		can_dash = true


# Idle state process
func _idle_process(delta):
	_stand_process(delta)


# Stand state process
func _stand_process(delta):
	add_gravity(delta)

	if can_input:
		if handle_dash():
			change_state(States.DASH)
			return
		if handle_jump():
			change_state(States.JUMP)
			return
		handle_horizontal_movement()
		if abs(velocity.x) > 0.1:
			change_state(States.RUN)
		return
	


# Run state process
func _run_process(delta):
	add_gravity(delta)
	run_sound_timer += delta
	if run_sound_timer > RUN_SOUND_INTERVAL and can_input:
		run_sound_timer = 0.0
		$Sounds/Run.play()
	
	if can_input:
		if handle_dash():
			change_state(States.DASH)
			return
		if handle_jump():
			change_state(States.JUMP)
			return
		handle_horizontal_movement()
		if abs(velocity.x) < 0.1:
			change_state(States.STAND)
		return


# Jump state process
func _jump_process(delta):
	add_gravity(delta)
	
	if can_input:
		if handle_dash():
			change_state(States.DASH)
			return
		if handle_jump():
			change_state(States.JUMP)
			return
		handle_horizontal_movement()
		if is_on_floor():
			if abs(velocity.x) < 0.1:
				change_state(States.STAND)
			else:
				change_state(States.RUN)


# Dash state process
func _dash_process(delta):
	dash_timer += delta
	if can_input:
		if handle_jump():
			change_state(States.JUMP)
			return
	if dash_timer >= DASH_DURATION:
		if abs(velocity.x) > SPEED:
			if velocity.x > 0:
				velocity.x = move_toward(velocity.x, SPEED, SPEED)
			else:
				velocity.x = move_toward(velocity.x, -SPEED, SPEED)
		else:
			if is_on_floor():
				change_state(States.RUN)
			else:
				change_state(States.JUMP)
			dash_timer = 0.0
			return


# Adjust the velocity
func add_gravity(delta):
	if not is_on_floor() and velocity.y < TERMINAL_VELOCITY:
		velocity.y += GRAVITY * delta


# Handle dash input
func handle_dash():
	if Input.is_action_just_pressed("dash") and can_dash:
		can_dash = false
		$Sounds/Dash.play()
		velocity.y = 0
		if not anim.flip_h:
			velocity.x = DASH_SPEED
		else:
			velocity.x = -(DASH_SPEED)
		return true
	return false


# Handle horizontal input
func handle_horizontal_movement():
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		if abs(direction * SPEED) >= abs(velocity.x):
			velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION)
		return true
	else:
		if not previous_state == States.DASH or can_jump:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, SPEED)
		return false


# Handle jump input
func handle_jump():
	if Input.is_action_just_pressed("player_jump") and can_jump:
		can_jump = false
		$Sounds/Jump.play()
		velocity.y = JUMP_VELOCITY
		return true
	if state == States.JUMP:
		if not Input.is_action_pressed("player_jump") and velocity.y < 0 and not lock_fastfall:
			if JUMP_VELOCITY < velocity.y:
				velocity.y = move_toward(velocity.y, 0, GRAVITY * 2)
	return false


# Manage animations which require finer control over frames as well as updating facing
func anim_update():
	# Update facing
	if velocity.x > 0:
		anim.flip_h = false
	elif velocity.x < 0:
		anim.flip_h = true
	# State-specific anim handling
	match state:
		States.JUMP:
			pass
		States.DASH:
			pass


# Change the animation to properly reflect state
func anim_update_state():
	match state:
		States.IDLE:
			anim.play("idle")
		States.STAND:
			anim.play("stand")
		States.RUN:
			anim.play("run")
		States.JUMP:
			anim.play("jump_neutral")
		States.DASH:
			anim.play("dash")


# Kill the character
func die():
	can_input = false
	can_move = false
	$Sounds/Die.play()
	velocity = Vector2.ZERO
	anim.play("death")


# Respawn the character
func respawn(pos: Vector2):
	self.position = pos
	self.visible = true
	velocity = Vector2.ZERO
	$Sounds/Respawn.play()
	anim.play_backwards("death")


# Handle death/respawn detail which are anim-dependent
func _on_animated_sprite_2d_animation_finished():
	if anim.animation == "death":
		if anim.frame == 10:
			self.visible = false
			respawn(respawn_pos)
		else:
			can_input = true
			can_move = true
			change_state(States.STAND)
		
