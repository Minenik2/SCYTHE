extends Label

# Time interval for blinking (in seconds)
var blink_interval : float = 0.5

# Timer to track blink interval
var blink_timer : float = 0.0

func _ready():
	# Ensure the label starts visible
	visible = true

func _process(delta):
	# Update the timer
	blink_timer += delta
	
	# Toggle the visibility based on the blink interval
	if blink_timer >= blink_interval:
		visible = !visible
		blink_timer = 0.0  # Reset timer after toggling visibility
