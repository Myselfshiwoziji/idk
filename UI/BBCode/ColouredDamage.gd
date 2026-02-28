@tool
extends RichTextEffect

var bbcode = "Damage";

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	char_fx.color = Color("ac3731");
	return true;
