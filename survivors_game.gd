extends Node2D

# 1. Preload your three potion scenes
const HEALTH_POTION = preload("res://Health.tscn")
const SPEED_POTION = preload("res://Speed.tscn")
const DAMAGE_POTION = preload("res://Damage.tscn")

func _ready():
	# This runs the moment the game starts
	spawn_initial_speed_potion()

func spawn_initial_speed_potion():
	var speed_p = SPEED_POTION.instantiate()
	
	# Option A: Spawn at a specific coordinate (e.g., center of screen)
	speed_p.global_position = Vector2(500, 500) 
	
	# Option B: Spawn near the player if you have a %Player node
	# speed_p.global_position = %Player.global_position + Vector2(100, 0)
	
	add_child(speed_p)


func spawn_mob():
	var new_mob = preload("res://mob.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)

# 2. New function to spawn potions with weighted chances
func spawn_potion():
	var chance = randf() # Generates a number between 0.0 and 1.0
	var potion_to_spawn
	
	# Probability Logic:
	# 0.0 to 0.6 (60% chance) = Health
	# 0.6 to 0.9 (30% chance) = Speed
	# 0.9 to 1.0 (10% chance) = Damage
	if chance < 0.6:
		potion_to_spawn = HEALTH_POTION.instantiate()
	elif chance < 0.9:
		potion_to_spawn = SPEED_POTION.instantiate()
	else:
		potion_to_spawn = DAMAGE_POTION.instantiate()
	
	# Pick a random position on your PathFollow2D (relative to the player)
	%PathFollow2D.progress_ratio = randf()
	potion_to_spawn.global_position = %PathFollow2D.global_position
	
	add_child(potion_to_spawn)

func _on_timer_timeout() -> void:
	spawn_mob()
	
	# 3. Optional: Spawn a potion every time a mob spawns, 
	# or add a secondary timer for potions.
	if randf() < 0.2: # 20% chance to spawn a potion every timer tick
		spawn_potion()

func _on_player_health_deplated() -> void:
	%"Get Slimed".visible = true 
	get_tree().paused = true
	%"Get Slimed".visible = true 
	# If your MenuButton is inside "Get Slimed", it becomes visible too
	get_tree().paused = true
# Add this function to your existing script
func _on_menu_button_pressed() -> void:
	get_tree().paused = false # IMPORTANT: Unpause or the Menu will be frozen!
	get_tree().change_scene_to_file("res://menu.tscn")
