extends Resource
class_name Attack

@export var name: String
@export var multi: int = 1

func execute():
	push_error("execute() non implémentée")

@warning_ignore("unused_signal")
signal finished
