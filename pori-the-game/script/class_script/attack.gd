extends Resource
class_name Attack

@export var name: String
@export var multi: int = 1

func execute(_user: Node, _target: Node) -> void:
	push_error("execute() non implémentée")
