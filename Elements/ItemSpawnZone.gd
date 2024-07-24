extends Control

var ItemDropClass = preload("res://Elements/ItemDrop.tscn")

@export var shouldRespawnIfEmpty = false
@export var respawnTime_sec = 20 # unused if shouldRespawnIfEmpty is false
@export var maxNumberOfItems = 10
@export var minNumberOfItems = 1
@export var itemIds = []

var RNG = RandomNumberGenerator.new()

# Respawn variables- timer used to respawn items according to respawnTime_sec;
# _num_items_left_to_spawn used to track how many items (up to max) we've tried to respawn
var _respawn_item_timer : Timer = null
var _num_items_left_to_spawn : int = 0
var _respawning : bool = false

# Number of items in the zone- this gets reduced when player picks items out of spawn
# and when we spawn new items in
var _num_items = 0

# Bounds of the spawning zone
var minx : int
var miny : int
var maxx : int
var maxy : int

func _initialize():
	minx = self.global_position.x
	miny = self.global_position.y
	maxx = minx + self.size.x
	maxy = miny + self.size.y
	print("Creating zone (", minx, ",", maxx, ") (", miny, ",", maxy, ")")
	spawn_initial_items()

func item_removed_from_zone():
	_num_items -= 1
	if _num_items == 0 and shouldRespawnIfEmpty and not _respawning:
		_respawning = true
		_num_items_left_to_spawn = maxNumberOfItems
		respawn_timer_start()

func respawn_timer_start():
	#print("try respawn item; try: ", _num_items_left_to_spawn, "; itemcount: ", _num_items)
	# start a timer to respawn one item at a time until we have items between min and max
	_respawn_item_timer = Timer.new()
	add_child(_respawn_item_timer)
	_respawn_item_timer.start(respawnTime_sec)
	_respawn_item_timer.one_shot = true
	_respawn_item_timer.connect("timeout", _on_respawn_item_timer_timeout)

func _on_respawn_item_timer_timeout():
	_num_items_left_to_spawn -= 1
	remove_child(_respawn_item_timer)
	
	# stop respawning if we've already respawned
	if _num_items_left_to_spawn == 0:
		# but keep respawning if player picked up all the items we spawned already!
		if _num_items != 0:
			#print("done spawning")
			_respawning = false
			return
		else:
			_num_items_left_to_spawn = maxNumberOfItems
	
	spawn_item()
	respawn_timer_start()

func spawn_item():
	# Always spawn minimum number of items; after that
	# it's a 50/50 draw if we want to spawn additional items
	if _num_items >= minNumberOfItems:
		var shouldSpawnItem = randi() % 2
		if not shouldSpawnItem:
			return
	
	# pick a random item type from the list and put it at a random spot in the zone
	var item_id_index = randi_range(0, itemIds.size()-1) # uniform random int
	var xrand = RNG.randf_range(minx, maxx) # uniform random float
	var yrand = RNG.randf_range(miny, maxy) # uniform random float
		
	var item = ItemDropClass.instantiate().with_id(itemIds[item_id_index])
	item.picked_up.connect(item_removed_from_zone)
	get_parent().add_child(item)
	item.position.x = xrand
	item.position.y = yrand
	_num_items += 1

func spawn_initial_items():
	for i in range(0, maxNumberOfItems):
		spawn_item()
