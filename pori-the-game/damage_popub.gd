extends Label

func setup(damage: int, is_player: bool = false):
	text = "-" + str(damage)
	if is_player:
		add_theme_color_override("font_color", Color(1, 0.2, 0.2))
	else:
		add_theme_color_override("font_color", Color(1, 0.5, 0))
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position", position + Vector2(0, -80), 0.8).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 0.0, 0.8).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1.5, 1.5), 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	await tween.finished
	queue_free()
