extends Label3D

var text_chunks := []

var cur_full_text := ""
var cur_next_text := ""
var cur_text_index := 0

var initial_delay := 1.0
var letter_time := 0.08
var blink_time := 0.555555
var blink_target_count := 6
var blink_count := 0

var clear_called := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(initial_delay).timeout
	text = " "
	cursor_blink()

func start_clear() -> void:
	clear_called = true
	clear_text()

# Remove all the text like pressing backspace quickly
func clear_text() -> void:
	while text.length() > 0:
		text = text.substr(0, text.length() - 2)
		await get_tree().create_timer(0.005).timeout

func cursor_blink() -> void:
	if clear_called:
		return

	if blink_count % 2 == 0:
		text[text.length() - 1] = "█"
	else:
		text[text.length() - 1] = " "
	blink_count += 1
	if blink_count < blink_target_count:
		await get_tree().create_timer(blink_time).timeout
		cursor_blink()
	elif text_chunks.size() > 0:
		cur_full_text += cur_next_text + "\n"
		cur_next_text = text_chunks.pop_front()
		cur_text_index = 0
		text[text.length() - 1] = " "
		next_letter()
	else:
		post_blink()

func next_letter() -> void:
	if clear_called:
		return

	text = cur_full_text + cur_next_text.substr(0, cur_text_index) + " █"
	cur_text_index += 1
	var variation := 15.0
	var time_rand := 1.0 + ((randf() / variation) - (variation / 10.0 / 2.0))
	await get_tree().create_timer(letter_time * time_rand).timeout
	if cur_text_index <= cur_next_text.length():
		next_letter()
	else:
		blink_count = 0
		blink_target_count = 6
		cursor_blink()

func post_blink() -> void:
	if clear_called:
		return

	if text[text.length() - 1] != "█":
		text[text.length() - 1] = "█"
	else:
		text[text.length() - 1] = " "

	await get_tree().create_timer(blink_time).timeout
	post_blink()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
