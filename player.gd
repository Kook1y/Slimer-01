extends CharacterBody2D

signal health_deplated

var health = 100.0
var speed = 600.0 
var damage_multiplier = 1.0
var speed_timer_duration = 0.0
var speed_timer_active = false
var current_speed_time = 0.0

@onready var normal_music = %Normal_BGmusic
@onready var low_health_music = %Low_BGmusic

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# FIX: Use the 'speed' variable so buffs actually work!
	velocity = direction * speed 
	move_and_slide()
	
	if velocity.length() > 0.0:
		%HappyBoo.play_walk_animation()
	else: 
		%HappyBoo.play_idle_animation()
		  
	const DAMAGE_RATE = 15.0
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		update_health_ui() # Use a helper function
		if health <= 0.0: 
			stop_all_music() # Stop music before emitting death
			health_deplated.emit()

func _process(delta):
	if !get_tree().paused:
		manage_music()
	
	if speed_timer_active:
		current_speed_time -= delta
		var hud = %HUD # Use the unique name directly
		if hud and hud.has_method("update_speed_bar"):
			hud.update_speed_bar(current_speed_time, speed_timer_duration)

func manage_music():
	# If the nodes aren't there yet, don't do anything
	if not is_instance_valid(normal_music) or not is_instance_valid(low_health_music):
		return

	# If the game is paused (Death Screen), don't trigger new music
	if get_tree().paused:
		return

	if health >= 35:
		if low_health_music.playing: 
			low_health_music.stop()
		if not normal_music.playing: 
			normal_music.play()
	else:
		if normal_music.playing: 
			normal_music.stop()
		if not low_health_music.playing: 
			low_health_music.play()
func update_health_ui():
	# This is the "Null Guard" that stops the crash
	var health_bar = %HealthBar
	if health_bar:
		health_bar.value = health

func stop_all_music():
	if normal_music: normal_music.stop()
	if low_health_music: low_health_music.stop()

func apply_buff(type, value, duration):
	match type:
		0: # HEALTH
			health = min(health + value, 100)
			update_health_ui()
		1: # SPEED
			speed += value
			speed_timer_duration = duration
			current_speed_time = duration
			speed_timer_active = true
			await get_tree().create_timer(duration).timeout
			speed -= value
			speed_timer_active = false
		2: # DAMAGE
			damage_multiplier += value
			await get_tree().create_timer(duration).timeout
			damage_multiplier -= value
