extends Hazard

@export
var uptime = 3.0
var uptimer = 0.0
@export
var downtime = 1.0
var downtimer = 0.0

@export
var length = 3

@export
var direction = 1

var laser_collision_tile = load("res://hazard_laser_collision_tile.tscn")
var collision_tiles = []

var laser_sprite = load("res://animated_laser.tscn")
var sprites = []
var current_sprite
var current_sprite_index = 0

enum States {OFF, EXTEND, ON}
var state = States.OFF

# Called when the node enters the scene tree for the first time.
func _ready():
	setup_sprites()
	setup_collision_areas()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		States.OFF:
			downtimer += delta
			if downtimer >= downtime:
				downtimer = 0.0
				state = States.EXTEND
				$Initial.play()
		States.EXTEND:
			if current_sprite == sprites[0]:
				if not current_sprite.is_playing():
					current_sprite.play("initial_expansion")
				if current_sprite.frame == 2:
					collision_tiles[current_sprite_index].disabled = false
					current_sprite_index += 1
					current_sprite = sprites[current_sprite_index]
			elif current_sprite_index != sprites.size() - 1:
				if not current_sprite.is_playing():
					current_sprite.play("extension")
				if current_sprite.frame == 2:
					collision_tiles[current_sprite_index].disabled = false
					current_sprite_index += 1
					current_sprite = sprites[current_sprite_index]
					current_sprite.play("extension")
			else:
				if current_sprite.frame == 3 and current_sprite.animation == "extension":
					current_sprite.play("impact")
					collision_tiles[current_sprite_index].disabled = false
				if current_sprite.frame == 2 and current_sprite.animation == "impact":
					current_sprite.play("splash")
					state = States.ON
		States.ON:
			$Ambient.play()
			uptimer += delta
			if uptimer >= uptime:
				$Ambient.stop()
				uptimer = 0.0
				state = States.OFF
				reset_sprites()
				turn_off_collision_areas()


func reset_sprites():
	for i in range(sprites.size()):
		sprites[i].pause()
		sprites[i].animation = "extension"
		sprites[i].frame = 0
	current_sprite_index = 0
	current_sprite = sprites[0]


func setup_sprites():
	var exp = laser_sprite.instantiate()
	add_child(exp)
	exp.position.x += 4 * direction
	if direction == -1:
		$Sprite2D.flip_h = true
		exp.flip_h = true
	sprites += [exp]
	for i in range(1, length):
		var instance = laser_sprite.instantiate()
		add_child(instance)
		instance.position.x += i * 8 * direction
		if direction == -1:
			instance.flip_h = true
		sprites += [instance]
	current_sprite = sprites[0]


func setup_collision_areas():
	var initial = laser_collision_tile.instantiate()
	add_child(initial)
	initial.position.x += 4 * direction
	collision_tiles += [initial]
	for i in range(1, length):
		var instance = laser_collision_tile.instantiate()
		add_child(instance)
		instance.position.x += i * 8 * direction
		collision_tiles += [instance]
	turn_off_collision_areas()


func turn_off_collision_areas():
	for i in range(collision_tiles.size()):
		collision_tiles[i].disabled = true
