extends Resource
class_name WeaponStats

@export var Name : String;
@export_multiline var Desc : String;
@export var Sprite : Texture2D;
#@export var Hitbox : Area2D;
@export var BaseDamage : int;
@export var Scaling : float = 0;
@export var BaseCooldown : float = 5;
#@export var Animations : AnimatedSprite2D;
@export var UseDisplacement : bool = true;
@export var LingerTime : float = 0.3;
@export var CanHitFriendly : bool = false;

#@export var HitboxPreview : Control;
