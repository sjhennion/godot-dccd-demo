extends Node3D

@onready var cpfo1 = $clutch_plate_front_outer_spline
@onready var cpfo2 = $clutch_plate_front_outer_spline2
@onready var cpfo3 = $clutch_plate_front_outer_spline3

@onready var cpfi1 = $clutch_plate_front_inner_spline
@onready var cpfi2 = $clutch_plate_front_inner_spline2
@onready var cpfi3 = $clutch_plate_front_inner_spline3

@onready var housing = $housing_ring
@onready var planetary_gears = $planetary_gears
@onready var planetary_housing_top = $planetary_gear_assembly_top_housing

@onready var components: Dictionary[String, Node3D] = {
	"cpfo1": cpfo1,
	"cpfo2": cpfo2,
	"cpfo3": cpfo3,
	"cpfi1": cpfi1,
	"cpfi2": cpfi2,
	"cpfi3": cpfi3,
	"housing": housing,
	"planetary_gears": planetary_gears,
	"planetary_housing_top": planetary_housing_top,

}

@onready var expanded_positions: Dictionary[String, Vector3] = {
	"cpfo1": cpfo1.position,
	"cpfo2": cpfo2.position,
	"cpfo3": cpfo3.position,
	"cpfi1": cpfi1.position,
	"cpfi2": cpfi2.position,
	"cpfi3": cpfi3.position,
	"housing": housing.position,
	"planetary_gears": planetary_gears.position,
	"planetary_housing_top": planetary_housing_top.position,
}

const contract_point := Vector3(0.0, 0.0, -2.0)

@onready var contracted_positions: Dictionary[String, Vector3] = {
	"cpfo1": contract_point,
	"cpfo2": contract_point,
	"cpfo3": contract_point,
	"cpfi1": contract_point,
	"cpfi2": contract_point,
	"cpfi3": contract_point,
	"housing": contract_point,
	"planetary_gears": contract_point - Vector3(0.0, 0.0, 0.7),
	"planetary_housing_top": contract_point - Vector3(0.0, 0.0, 0.5)
}

var is_expanded := true

func _ready():
	pass

var expand_dur := 2.0

func contract() -> void:
	for key in contracted_positions.keys():
		var component := components[key]
		var pos := contracted_positions[key]
		var tween := get_tree().create_tween()
		tween.set_trans(Tween.TransitionType.TRANS_SINE)
		tween.tween_property(component, "position", pos, expand_dur)
	is_expanded = false

func expand() -> void:
	for key in expanded_positions.keys():
		var component := components[key]
		var pos := expanded_positions[key]
		var tween := get_tree().create_tween()
		tween.set_trans(Tween.TransitionType.TRANS_SINE)
		tween.tween_property(component, "position", pos, expand_dur)
	is_expanded = false

	is_expanded = true

func expand_contract() -> void:
	if is_expanded:
		contract()
	else:
		expand()

func _input(event):
	if event.is_action_pressed("ExpandContractFixture"):
		expand_contract()