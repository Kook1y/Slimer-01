extends Area2D

# This creates a dropdown menu in the Inspector
enum PotionType { HEALTH, SPEED, DAMAGE }
@export var type: PotionType = PotionType.HEALTH

# Variables to tweak in the Inspector
@export var value: float = 20.0       # Health restored or Speed added
@export var duration: float = 5.0     # How long the buff lasts (for Speed/Damage)

func _on_body_entered(body):
	# Check if the body is the Player and has the ability to receive buffs
	if body.has_method("apply_buff"):
		body.apply_buff(type, value, duration)
		
		# Optional: Play a sound effect here before destroying
		queue_free() # Remove the potion from the scene
