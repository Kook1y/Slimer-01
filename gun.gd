extends Area2D

func _physics_process(_delta):
	# Make the weapon face the mouse cursor position
	look_at(get_global_mouse_position())

func shoot():
	const BULLET = preload("res://bullet.tscn")
	var new_bullet = BULLET.instantiate()
	
	new_bullet.global_position = %ShootingPoint.global_position
	new_bullet.global_rotation = %ShootingPoint.global_rotation
	
	# CRITICAL FIX: 
	# We add the bullet to the root of the scene (or the level), not the gun itself.
	# If you add it to %ShootingPoint, the bullet will move/rotate WITH the player 
	# even after being fired.
	get_tree().root.add_child(new_bullet)

# OPTIONAL: 
# If you want the player to CLICK to shoot instead of using the Timer:
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"): # Replace "ui_accept" with your shoot input, e.g., "click"
		shoot()

# Keep this only if you still want it to shoot automatically while you aim
func _on_timer_timeout():
	shoot()
