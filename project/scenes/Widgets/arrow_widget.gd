extends Node3D

@onready var arrow := $SubViewport/Arrow

func reveal():
	arrow.reveal()

func start_clear():
	arrow.start_clear()

func reset_to_main():
	arrow.reset_to_main()
