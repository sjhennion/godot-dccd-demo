extends Node3D

@onready var fixture = $Fixture
@onready var fixture_center_point = $FixtureCenterPoint
@onready var mobile_camera = $MobileCamera

#var mobile_camera := Node3D.new()

@onready var starting_camera_setup = $MainMenu/StartingCameraSetup
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

@onready var menu_dot_display := $MainMenu/StartingDotDisplay
@onready var title_card := $MainMenu/TitleCard
@onready var menu_camera_setup := $MainMenu/StartingCameraSetup

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

func _ready():
	mobile_camera.position = starting_camera_setup.position
	mobile_camera.rotation = starting_camera_setup.rotation

	setup_side_profile_pan()
	setup_three_quarter_pan()
	setup_main_menu_dot_display()
	setup_title_card()
	setup_fixture()

func setup_fixture():
	await get_tree().create_timer(1.0).timeout
	var fixture_tween := get_tree().create_tween()
	fixture_tween.set_trans(Tween.TransitionType.TRANS_SINE)
	fixture_tween.tween_property(fixture, "position", fixture_center_point.position, 9.0)
	fixture_tween.tween_callback(func():
		print("Fixture setup complete")
	)

func setup_main_menu_dot_display():
	menu_dot_display.mouse_over_viewpoint = mobile_camera

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

func cycle_camera():
	if transitioning_camera:
		pass
		#return

	if at_main_menu:
		clear_main_menu()

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
	cur_camera_name = "StartingCamera"

	transition_start.position = mobile_camera.position
	transition_start.rotation = mobile_camera.rotation

	var tween1 = get_tree().create_tween()
	tween1.set_trans(Tween.TransitionType.TRANS_SINE)
	tween1.tween_method(lerp_transition, 0.0, 1.0, 1.0)
	tween1.tween_callback(camera_transition_finished)

	transitioning_camera = true
	at_main_menu = true

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
