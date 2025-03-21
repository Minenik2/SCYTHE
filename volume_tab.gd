extends Label  # The script is attached to a Label node

@export var audio_bus: String = "Master"  # The name of the audio bus this controller manages
@export var increase_button: Button       # Reference to the button for increasing volume
@export var decrease_button: Button       # Reference to the button for decreasing volume
@export var volume_step: float = 0.1      # Step size for volume adjustment

func _ready():
	# Validate the audio bus
	if AudioServer.get_bus_index(audio_bus) == -1:
		print("Error: Audio bus not found:", audio_bus)
		return

	# Connect button signals
	if increase_button:
		increase_button.pressed.connect(_on_increase_volume_pressed)
	else:
		print("Error: Increase button not assigned!")

	if decrease_button:
		decrease_button.pressed.connect(_on_decrease_volume_pressed)
	else:
		print("Error: Decrease button not assigned!")

	# Update the label text with the current volume at the start
	_update_label_text()

# Function to increase volume
func _on_increase_volume_pressed() -> void:
	var bus_index = AudioServer.get_bus_index(audio_bus)
	if bus_index == -1:
		print("Error: Invalid audio bus:", audio_bus)
		return

	var current_volume = AudioServer.get_bus_volume_db(bus_index)
	var new_volume = clamp(current_volume + volume_step, -80.0, 0.0)
	AudioServer.set_bus_volume_db(bus_index, new_volume)

	# Update the label text
	_update_label_text()

# Function to decrease volume
func _on_decrease_volume_pressed() -> void:
	var bus_index = AudioServer.get_bus_index(audio_bus)
	if bus_index == -1:
		print("Error: Invalid audio bus:", audio_bus)
		return

	var current_volume = AudioServer.get_bus_volume_db(bus_index)
	var new_volume = clamp(current_volume - volume_step, -80.0, 0.0)
	AudioServer.set_bus_volume_db(bus_index, new_volume)

	# Update the label text
	_update_label_text()

# Updates the label text to show the current volume
func _update_label_text():
	var bus_index = AudioServer.get_bus_index(audio_bus)
	if bus_index == -1:
		text = "Audio bus not found!"
		return

	var current_volume = AudioServer.get_bus_volume_db(bus_index)
	text = "Volume (" + audio_bus + "): " + str(round(current_volume)) + " dB"
