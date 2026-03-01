@tool
extends RichTextEffect

var bbcode = "Slow";

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	char_fx.color = Color("363636");
	return true;
