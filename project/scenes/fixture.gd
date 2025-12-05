extends Node3D

@onready var clutch_disc1 = $clutch_plate_front_outer_spline/Node/Node2/Mesh
@onready var clutch_disc2 = $clutch_plate_front_outer_spline2/Node/Node2/Mesh
@onready var clutch_disc3 = $clutch_plate_front_outer_spline3/Node/Node2/Mesh

@onready var clutch_disc4 = $clutch_plate_front_inner_spline/Node/Node2/Mesh
@onready var clutch_disc5 = $clutch_plate_front_inner_spline2/Node/Node2/Mesh
@onready var clutch_disc6 = $clutch_plate_front_inner_spline3/Node/Node2/Mesh

func _ready():
	clutch_disc1.offset = 1.0
	clutch_disc2.offset = 2.0
	clutch_disc3.offset = 3.0
