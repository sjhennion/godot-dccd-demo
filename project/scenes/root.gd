extends Node3D

@onready var fixture = $Fixture
@onready var mobile_camera = $MobileCamera

#var mobile_camera := Node3D.new()

@onready var static_side_profile_setup = $StaticSideProfileSetup
@onready var side_profile_pan_setup = $SideProfilePanSetup
@onready var three_quarter_camera_setup = $ThreeQuarterCameraPanSetup
@onready var housing_side_setup = $HousingSideSetup

@onready var camera_setups: Array[Node3D] = [static_side_profile_setup, side_profile_pan_setup, three_quarter_camera_setup, housing_side_setup]
var cur_camera_setup_index := 0
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
	mobile_camera.position = static_side_profile_setup.position
	mobile_camera.rotation = static_side_profile_setup.rotation

	setup_side_profile_pan()
	setup_three_quarter_pan()

func camera_transition_finished():
	transitioning_camera = false
	#mobile_camera = camera_setups[cur_camera_setup_index]

func lerp_transition(weight: float) -> void:
	mobile_camera.position = transition_start.position.lerp(camera_setups[cur_camera_setup_index].position, weight)
	mobile_camera.rotation = transition_start.rotation.lerp(camera_setups[cur_camera_setup_index].rotation, weight)

func cycle_camera():
	if transitioning_camera:
		pass
		#return

	cur_camera_setup_index = cur_camera_setup_index + 1 if cur_camera_setup_index + 1 < camera_setups.size() else 0
	transition_start.position = mobile_camera.position
	transition_start.rotation = mobile_camera.rotation

	var tween1 = get_tree().create_tween()
	tween1.set_trans(Tween.TransitionType.TRANS_SINE)
	tween1.tween_method(lerp_transition, 0.0, 1.0, 1.0)
	tween1.tween_callback(camera_transition_finished)

	transitioning_camera = true

func _input(event):
	if event.is_action_pressed("CycleCamera"):
		cycle_camera()
#	if event.is_action_pressed("TransitionToHousing"):
#		transition_to_housing()

var setup_complete := false

func _process(delta: float) -> void:
	if not transitioning_camera:
		mobile_camera.position = camera_setups[cur_camera_setup_index].position
		mobile_camera.rotation = camera_setups[cur_camera_setup_index].rotation
