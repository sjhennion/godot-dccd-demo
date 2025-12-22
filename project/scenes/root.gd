extends Node3D

@onready var fixture = $Fixture
@onready var fixture_center_point = $FixtureCenterPoint
@onready var mobile_camera = $MobileCamera

#var mobile_camera := Node3D.new()

@onready var starting_camera_setup = $StartingCameraSetup
@onready var static_side_profile_setup = $StaticSideProfileSetup
@onready var side_profile_pan_setup = $SideProfilePanSetup
@onready var three_quarter_camera_setup = $ThreeQuarterCameraPanSetup
@onready var housing_side_setup = $HousingSideSetup

@onready var camera_setup_names: Array[String] = ["StartingCamera", "StaticSideProfile", "SideProfilePan", "ThreeQuarterPan", "HousingSide"]

@onready var camera_setups: Dictionary[String, Node3D] = {
	"StartingCamera": starting_camera_setup,
	"StaticSideProfile": static_side_profile_setup,
	"SideProfilePan": side_profile_pan_setup,
	"ThreeQuarterPan": three_quarter_camera_setup,
	"HousingSide": housing_side_setup,
}

@onready var menu_dot_display := $MobileCamera/StartingDotDisplay
@onready var title_card := $MobileCamera/TitleCard
@onready var menu_camera_setup := $StartingCameraSetup
@onready var arrow := $MobileCamera/ArrowWidget

@onready var starting_line := $UILines/StartingLine
@onready var side_line := $UILines/SideLine

var at_main_menu := true

var cur_camera_name := "StartingCamera"

#var cur_camera_setup_index := 0
var transition_start := Node3D.new()
var transitioning_camera := false

func setup_three_quarter_pan():
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TransitionType.TRANS_SINE)
	tween.tween_property(three_quarter_camera_setup, "position", Vector3(3.0, 0.0, 0.0), 5.0)
	tween.tween_property(three_quarter_camera_setup, "position", Vector3(-1.0, 0.0, 0.0), 5.0)
	tween.set_loops(0)

func setup_side_profile_pan():
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TransitionType.TRANS_SINE)
	tween.tween_property(side_profile_pan_setup, "position", Vector3(-1.5, 0.0, 1.0), 5.0)
	tween.tween_property(side_profile_pan_setup, "position", Vector3(1.0, 0.0, 1.0), 5.0)
	tween.set_loops(0)

func setup_starting_camera():
	var tween = get_tree().create_tween()
	var starting_pos: Vector3 = starting_camera_setup.position
	var y_target: float = starting_pos.y + 0.05
	tween.set_trans(Tween.TransitionType.TRANS_SINE)
	tween.tween_property(starting_camera_setup, "position:y", y_target, 5.0)
	tween.tween_property(starting_camera_setup, "position:y", starting_pos.y, 5.0)
	tween.set_loops(0)

func setup_starting_line():
	var line_starting_height := 1.1
	var line_grow_tween := get_tree().create_tween()
	line_grow_tween.set_trans(Tween.TransitionType.TRANS_SINE)
	line_grow_tween.tween_property(starting_line, "height", line_starting_height, 1.5)

func _ready():
	mobile_camera.position = starting_camera_setup.position
	mobile_camera.rotation = starting_camera_setup.rotation

	setup_side_profile_pan()
	setup_three_quarter_pan()
	setup_main_menu_dot_display()
	setup_title_card()
	setup_starting_line()
	setup_fixture()

func setup_fixture():
	#await get_tree().create_timer(1.0).timeout
	var fixture_tween := get_tree().create_tween()
	fixture_tween.set_trans(Tween.TransitionType.TRANS_SINE)
	fixture_tween.tween_property(fixture, "position", fixture_center_point.position, 7.0)
	fixture_tween.tween_callback(func():
		print("Fixture setup complete")
		#setup_starting_camera()
	)

func setup_main_menu_dot_display():
	menu_dot_display.mouse_over_viewpoint = mobile_camera

	"""
	var cur_rot: Vector3 = menu_dot_display.rotation
	var target_x_rot: float = menu_dot_display.rotation.x + PI / 32
	var target_y_rot: float = menu_dot_display.rotation.y + PI / 16
	var x_dur := 5.0
	var y_dur := 6.0

	var rot_x_tween := get_tree().create_tween()
	rot_x_tween.set_trans(Tween.TransitionType.TRANS_SINE)
	rot_x_tween.tween_property(menu_dot_display, "rotation:x", target_x_rot, x_dur)
	rot_x_tween.tween_property(menu_dot_display, "rotation:x", cur_rot.x, x_dur)
	rot_x_tween.set_loops()

	var rot_y_tween := get_tree().create_tween()
	rot_y_tween.set_trans(Tween.TransitionType.TRANS_SINE)
	rot_y_tween.tween_property(menu_dot_display, "rotation:y", target_y_rot, y_dur)
	rot_y_tween.tween_property(menu_dot_display, "rotation:y", cur_rot.y, y_dur)
	rot_y_tween.set_loops()

	var cur_pos: Vector3 = menu_dot_display.position
	var target_x_pos: float = menu_dot_display.position.x + 0.1
	var target_y_pos: float = menu_dot_display.position.y + 0.05
	var pos_x_dur := 6.0
	var pos_y_dur := 7.0

	var pos_x_tween := get_tree().create_tween()
	pos_x_tween.set_trans(Tween.TransitionType.TRANS_SINE)
	pos_x_tween.tween_property(menu_dot_display, "position:x", target_x_pos, pos_x_dur)
	pos_x_tween.tween_property(menu_dot_display, "position:x", cur_pos.x, pos_x_dur)
	pos_x_tween.set_loops()

	var pos_y_tween := get_tree().create_tween()
	pos_y_tween.set_trans(Tween.TransitionType.TRANS_SINE)
	pos_y_tween.tween_property(menu_dot_display, "position:y", target_y_pos, pos_y_dur)
	pos_y_tween.tween_property(menu_dot_display, "position:y", cur_pos.y, pos_y_dur)
	pos_y_tween.set_loops()
	"""

func setup_title_card():
	title_card.text_chunks.append("2004-2006 Subaru Impreza WRX STi")
	title_card.text_chunks.append("Driver Controlled Center Differential")
	title_card.text_chunks.append("Modeled in Zoo Design Studio")
	title_card.text_chunks.append("Stephan Hennion 2025")

func camera_transition_finished():
	transitioning_camera = false
	#mobile_camera = camera_setups[cur_camera_setup_index]

func lerp_transition(weight: float) -> void:
	mobile_camera.position = transition_start.position.lerp(camera_setups[cur_camera_name].position, weight)
	mobile_camera.rotation = transition_start.rotation.lerp(camera_setups[cur_camera_name].rotation, weight)

func clear_main_menu():
	at_main_menu = false
	menu_dot_display.start_clear()
	title_card.start_clear()
	arrow.start_clear()

	var line_shrink_tween := get_tree().create_tween()
	line_shrink_tween.set_trans(Tween.TransitionType.TRANS_SINE)
	line_shrink_tween.tween_property(starting_line, "height", 0.0, 1.0)

func tween_in_sideline() -> void:
	var line_side_height := 1.75
	var line_grow_tween := get_tree().create_tween()
	line_grow_tween.set_trans(Tween.TransitionType.TRANS_SINE)
	line_grow_tween.tween_property(side_line, "height", line_side_height, 2.0)

func cycle_camera():
	if transitioning_camera:
		pass
		#return

	if at_main_menu:
		clear_main_menu()
		tween_in_sideline()

	#cur_camera_setup_index = cur_camera_setup_index + 1 if cur_camera_setup_index + 1 < camera_setups.size() else 0
	var cur_camera_index := camera_setup_names.find(cur_camera_name)
	var next_camera_index := cur_camera_index + 1 if cur_camera_index + 1 < camera_setup_names.size() else 1
	cur_camera_name = camera_setup_names[next_camera_index]

	transition_start.position = mobile_camera.position
	transition_start.rotation = mobile_camera.rotation

	var tween1 = get_tree().create_tween()
	tween1.set_trans(Tween.TransitionType.TRANS_SINE)
	tween1.tween_method(lerp_transition, 0.0, 1.0, 1.0)
	tween1.tween_callback(camera_transition_finished)

	transitioning_camera = true

func reset_to_main():
	setup_title_card()
	menu_dot_display.reset_to_main()
	title_card.reset_to_main()
	arrow.reset_to_main()
	cur_camera_name = "StartingCamera"

	transition_start.position = mobile_camera.position
	transition_start.rotation = mobile_camera.rotation

	var tween1 = get_tree().create_tween()
	tween1.set_trans(Tween.TransitionType.TRANS_SINE)
	tween1.tween_method(lerp_transition, 0.0, 1.0, 1.0)
	tween1.tween_callback(camera_transition_finished)

	transitioning_camera = true
	at_main_menu = true

	var line_shrink_tween := get_tree().create_tween()
	line_shrink_tween.set_trans(Tween.TransitionType.TRANS_SINE)
	line_shrink_tween.tween_property(side_line, "height", 0.0, 1.0)

	setup_starting_line()

func _input(event):
	if event.is_action_pressed("CycleCamera"):
		cycle_camera()
	if event.is_action_pressed("ResetToMain"):
		reset_to_main()
#	if event.is_action_pressed("TransitionToHousing"):
#		transition_to_housing()

var setup_complete := false

func _process(delta: float) -> void:
	if not transitioning_camera:
		mobile_camera.position = camera_setups[cur_camera_name].position
		mobile_camera.rotation = camera_setups[cur_camera_name].rotation
