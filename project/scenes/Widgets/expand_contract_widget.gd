extends Node3D

@onready var expand_contract := $SubViewport/ExpandContract

func _input(event):
	if event.is_action_pressed("ExpandContractFixture"):
		expand_contract._input(event)