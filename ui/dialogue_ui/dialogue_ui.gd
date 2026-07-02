extends CanvasLayer
@export var dialoguePath = "res://assets/dialogue/tutorial.json"	
@export var textSpeed := 0.05

@onready var portrait = $VBoxContainer/Panel/Portrait
@onready var char_name = $VBoxContainer/Panel/Name
@onready var textbox = $VBoxContainer/Panel/Text

var dialogue
var phraseNum = 0 
var finished = false
var default_img = "res://assets/dialogue/question.png"

signal dialogue_finished

func _ready():
	$Timer.wait_time = textSpeed
	dialogue = getDialogue()
	assert(dialogue, "Dialogue not found")
	nextPhrase()
		
func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		if finished:
			nextPhrase()
		else:
			textbox.visible_characters = len(textbox.text)

func getDialogue():
	
	var f = FileAccess.open(dialoguePath,FileAccess.READ)
	assert(FileAccess.file_exists(dialoguePath), "File path does not exist")
	var json_object = JSON.new()
	var parse_err = json_object.parse(f.get_as_text())
	var output = json_object.get_data()
	if typeof(output) == TYPE_ARRAY :
		return output
	else:
		return parse_err
	
func nextPhrase():
	if phraseNum >= len(dialogue):
		queue_free()
		return
		
	finished = false
	
	char_name.bbcode_text = dialogue[phraseNum]["Name"]
	textbox.bbcode_text = dialogue[phraseNum]["Text"]
	
	textbox.visible_characters = 0

	FileAccess.open(dialoguePath,FileAccess.READ)
	
	var safe_name = dialogue[phraseNum]["Name"].replace(" ", "")
	var img = "res://assets/dialogue/" + safe_name + dialogue[phraseNum]["Emotion"] + ".png"
	
	if FileAccess.file_exists(img):
		portrait.texture =  load(img)
		portrait.scale = Vector2(10,10)
	else:
		portrait.texture =  load(default_img)
		portrait.scale = Vector2(5,5)
		
	while textbox.visible_characters < len(textbox.text):
		textbox.visible_characters += 1 
		if(randi_range(0,100)*textSpeed > 1):
			$dialogueTick.play()
		$Timer.start()
		await $Timer.timeout
	
	finished = true
	phraseNum += 1
	return 
	
func close_dialogue():
	emit_signal("dialogue_finished")
	queue_free()
