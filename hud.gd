extends CanvasLayer

@onready var speed_bar = $BuffContainer/SpeedBar

# We will call this from the Player script
func update_speed_bar(time_left, max_time):
	if time_left > 0:
		speed_bar.visible = true
		# Calculate percentage: (current / max) * 100
		speed_bar.value = (time_left / max_time) * 100
	else:
		speed_bar.visible = false
