extends Resource
class_name BaseUnit;

@export_subgroup("Unit information")
@export var Name : String;
@export var BaseAttack : int;
@export var BaseDefense : int;
@export var BaseMoveSpeed : int;
@export var BaseMaxHealth : int;
@export var BufferRadius : int = 0;
@export var BaseDamageRes : float = 0;
@export var HeldWeapons : Array[PackedScene];

@export_subgroup("Unit data")
@export var Controlling : bool;
@export var IsFriendly : bool;
@export var CanAttack : bool;
@export var Sprite : Texture2D;
@export var WeaponDisplacement : int;
