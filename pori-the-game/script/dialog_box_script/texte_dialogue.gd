extends RichTextLabel

func _process(_delta):
	"""
	Actualise en temps réel le texte de la boite de dialogue
	:param _delta: a laisser, jamais utilisé mais obligatoire pour que la fonction soit reconnue
	:comportement: changer le texte de la boite de dialogue
	"""
	set_text(global_var.texte_dialogue)
