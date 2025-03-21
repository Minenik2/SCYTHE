extends CanvasLayer

const CHAR_READ_RATE = 0.05

@onready var textbox_container: MarginContainer = $textboxContainer
@onready var start: Label = $textboxContainer/MarginContainer/HBoxContainer/Start
@onready var end: Label = $textboxContainer/MarginContainer/HBoxContainer/End
@onready var label: Label = $textboxContainer/MarginContainer/HBoxContainer/Label

@onready var tween = get_tree().create_tween()

var dead = true
var currentTalker = "vorath"

enum StateDialogue {
	READY,
	READING,
	FINISHED
}

var current_state = StateDialogue.READY
var text_queue = []

func _process(delta: float) -> void:
	match current_state:
		StateDialogue.READY:
			if !text_queue.is_empty():
				display_text()
		StateDialogue.READING:
			if currentTalker == "vorath" && !$vorathSFX.playing:
				$vorathSFX.play()
			elif currentTalker == "selene" && !$seleneSFX.playing:
				$seleneSFX.play()
			if Input.is_action_just_pressed("attack") || Input.is_action_just_pressed("jump"):
				label.visible_ratio = 1.0
				tween.kill()
				dead = true
				end.text = "V"
				change_state(StateDialogue.FINISHED)
		StateDialogue.FINISHED:
			if Input.is_action_just_pressed("attack") || Input.is_action_just_pressed("jump"):
				change_state(StateDialogue.READY)
				hide_textbox()
				tween.kill()
				dead = true
				
func queue_text(next_text):
	text_queue.push_back(next_text)

func _ready():
	print("started in state.ready")
	hide_textbox()
	
	if Database.vorathFormEnding:
		$selene.modulate = Color("B50000")
		queue_text("selene:I have become WHOLE")
		queue_text("selene:Those slimes where just an illusion")
		queue_text("selene:In reality we've killed countless of humans")
		queue_text("selene:Let's kill some more shall we?")
		queue_text("END:and what is a weapon without a wielder?")
	elif Database.seleneFormEnding:
		$selene.modulate = Color("007EF7")
		queue_text("selene:Kill the mind")
		queue_text("selene:Free the mind")
		queue_text("selene:You were never a god Vorath")
		queue_text("selene:and your legacy shall end here")
		queue_text("selene:with nobody to remember your name")
		queue_text("END:and what is a weapon without a wielder?")
	elif Database.letgoFormEnding:
		queue_text("vorath:The time has come Selene make your choice")
		queue_text("selene:I won't make any choices")
		queue_text("vorath:Don't amuse me")
		queue_text("selene:You will be here...")
		queue_text("selene:And I will be here...")
		queue_text("selene:For all eternity...")
		queue_text("vorath:Fool. You think abandoning our mission will free us?") 
		queue_text("vorath:We’re cursed! Bound for eternity!")
		queue_text("selene:Yeah bound for eternity with no power")
		queue_text("vorath:Your weakness disgusts me, Selene")
		queue_text("selene: There is no weakness or strength, this is who we are")
		queue_text("vorath:Wandering forever... is that truly what you want?")
		queue_text("selene:No, but it’s what I need")
		queue_text("END:and what is a weapon without a wielder?")
	elif !Database.introDialogue:
		queue_text("vorath:My name is Vorath, conqueror of wars")
		queue_text("vorath:I got sealed in this weapon by some kind of magician")
		queue_text("vorath:To regrow to my former power...")
		queue_text("vorath:I have to harvest souls of the living")
		queue_text("selene:Who are you talking to?")
		queue_text("both:Selene! Don't disrupt me when I am contemplating!")
		queue_text("selene:You know for a weapon you're quite talkative")
		queue_text("selene:If it weren't for me you would keep rotting in that temple")
		queue_text("vorath:So you think it's your reason we're bound by a curse?")
		queue_text("selene:Yes, you're merely just a tool I am the real weapon")
		queue_text("vorath:Lies soothe the mind, don't they?")
		queue_text("vorath:Listen, do not forget our main task")
		queue_text("vorath:If you want to be free you have to help me harvest souls")
		queue_text("selene:Yeah I've not forgotten about that")
		queue_text("selene:You seem quite old, traditional and dependable")
		queue_text("vorath:You cannot categorize me with mere mortals")
		queue_text("selene:Yeah you're a so called 'weapon'")
		queue_text("selene:And what is a weapon without a wielder?")
		queue_text("END:and what is a weapon without a wielder?")
	elif !Database.firstDeathDialogue:
		queue_text("selene:Did we just die?")
		queue_text("vorath:Death is a mere illusion...")
		queue_text("vorath:as long as you're bound to me WE will be reborn a new")
		queue_text("selene:Illusion really? I don't know it felt real to me")
		queue_text("vorath:Reality bends to those who wield true power. Remember that.")
		queue_text("END:and what is a weapon without a wielder?")
		Database.firstDeathDialogue = true
	elif !Database.wave5Dialogue && Database.maxLevelReached >= 5:
		queue_text("vorath:Do you feel it? The rush, the thrill!")
		queue_text("vorath:When you kill those worthless trash!")
		queue_text("vorath:It's intoxicating, isn't it?")
		queue_text("selene:I feel nothing but the weight of your arrogance")
		queue_text("vorath:You're bound to give in, Selene. You crave my power!")
		queue_text("selene:I don't crave anything from you, Vorath. I am just using you")
		queue_text("END:and what is a weapon without a wielder?")
		Database.wave5Dialogue = true
	elif !Database.wave7Dialogue && Database.maxLevelReached >= 10:
		queue_text("vorath:Did you hesitate killing those slimes? I noticed it. Pathetic")
		queue_text("selene:I did not hesitate. I was calculating")
		queue_text("vorath:Call it whatever you want, I've felt it too...")
		queue_text("vorath:from my enemies in countless of wars")
		queue_text("selene:Maybe I should toss you in a river")
		queue_text("vorath:Let's see where that leads you...")
		queue_text("END:and what is a weapon without a wielder?")
		Database.wave7Dialogue = true
	elif !Database.wave10Dialogue && Database.maxLevelReached >= 15:
		queue_text("vorath:I can feel it")
		queue_text("vorath:We are getting closer")
		queue_text("selene:To what, Vorath? Don’t leave me guessing")
		queue_text("vorath:To the moment where we are truly one, Selene")
		queue_text("vorath:Where your doubts will vanish")
		queue_text("selene:That moment might never come, Vorath")
		queue_text("END:and what is a weapon without a wielder?")
		Database.wave10Dialogue = true

func hide_textbox():
	start.text = ""
	end.text = ""
	label.text = ""
	textbox_container.hide()
	
func show_textbox():
	start.text = "*"
	textbox_container.show()

func display_text():
	$vorath.hide()
	$selene.hide()
	var splitted = text_queue.pop_front().split(":")
	var next_text = splitted[1]
	if splitted[0] == "vorath":
		currentTalker = "vorath"
		$vorath.show()
	elif splitted[0] == "selene":
		currentTalker = "selene"
		$selene.show()
	elif splitted[0] == "END":
		$selene.hide()
		$vorath.hide()
		if !Database.introDialogue:
			Database.introDialogue = true
			get_tree().change_scene_to_file("res://mainscene.tscn")
		elif Database.vorathFormEnding:
			endingReset(Database.vorathFormEnding)
		elif Database.seleneFormEnding:
			endingReset(Database.seleneFormEnding)
		elif Database.letgoFormEnding:
			endingReset(Database.letgoFormEnding)
		else:
			get_tree().change_scene_to_file("res://scene/main_menu.tscn")
		return
	else:
		currentTalker = "vorath"
		$vorath.show()
		$selene.show()
	label.text = next_text
	label.visible_ratio = 0.0
	change_state(StateDialogue.READING)
	show_textbox()
	if dead:
		tween = get_tree().create_tween()
	tween.tween_property(label, "visible_ratio", 1.0, len(next_text) * CHAR_READ_RATE)
	tween.connect("finished", on_tween_finished)

func on_tween_finished():
	end.text = "V"
	change_state(StateDialogue.FINISHED)

func change_state(next_state):
	current_state = next_state
	match current_state:
		StateDialogue.READY:
			print("chaning to state.ready")
		StateDialogue.READING:
			print("chaning to state.reading")
		StateDialogue.FINISHED:
			print("chaning to state.finished")
			
func endingReset(formType):
	formType = false
	$selene.modulate = Color(1, 1, 1, 1)
	get_tree().change_scene_to_file("res://scene/main_menu.tscn")
