@tool
extends RichTextEffect

var bbcode = "Burn";

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	char_fx.color = Color("d7692d");
	return true;
