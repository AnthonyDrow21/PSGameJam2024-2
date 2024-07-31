# Holds item data definitions - we could create different scenes for each item, but
# this lets us put the data in one place and it works for now.
extends Node

var ItemDefClass = preload("res://Elements/ItemDef.tscn")

func _ready():
	# TODO: validate the items in ITEMS
	pass

func get_item(item_id : String):
	if ITEMS.has(item_id):
		return ITEMS[item_id]
	else:
		print("ERROR: Could not find item with item_id ", item_id)

const POTION_SOUND = "res://Assets/Sounds/Bubble3.wav"

var ITEMS = {
	"pink_potion" : ItemDefClass.instantiate().with_data("pink_potion", "Pink Potion", "A mystical pink potion", "anim_pink_potion", POTION_SOUND, "res://Assets/Items/Potions/Small Vial - PINK.png"),
	"black_potion" : ItemDefClass.instantiate().with_data("black_potion", "Black Potion", "A mystical black potion", "anim_black_potion", POTION_SOUND, "res://Assets/Items/Potions/Classic Jar - BLACK.png"),
	"green_potion" : ItemDefClass.instantiate().with_data("green_potion", "Green Potion", "A mystical green potion", "anim_green_potion", POTION_SOUND, "res://Assets/Items/Potions/Large Jar - TURQUOISE.png"),
	"gold_goblet" : ItemDefClass.instantiate().with_data("gold_goblet", "Gold", "Looks shiny...", "anim_gold_goblet", POTION_SOUND, "res://Assets/Items/Potions/GoldenChalice.png"),
	"water_bucket" : ItemDefClass.instantiate().with_data("water_bucket", "Bucket of Water", "Looks wet...", "anim_water_bucket", POTION_SOUND, "res://Assets/Items/Potions/WaterBucket.png"),
	"aqua_regia" : ItemDefClass.instantiate().with_data("aqua_regia", "Aqua Regia", "A mystical potion that can melt any metal", "anim_aqua_regia", POTION_SOUND, "res://Assets/Items/Acid.png"),
	"journal": ItemDefClass.instantiate().with_data("journal", "Old Journal", "A journal with alchemical recipes...this could be useful", "anim_journal", "res://Assets/Sounds/JournalPickup.ogg", "res://Assets/Items/Journal.png"),
	"journalpage_aquaregia": ItemDefClass.instantiate().with_data("journalpage_aquaregia", "Torn Journal Page", "A ripped journal page with some kind of ... alchemical symbols?", "anim_aqua_regia_recipe", "res://Assets/Sounds/JournalPageTurn.wav", "res://Assets/Items/Clues/AquaRegiaHintImage.png"),
	"journalpage_aquaregia_hint1": ItemDefClass.instantiate().with_data("journalpage_aquaregia_hint1", "Torn Journal Page", "A ripped journal page with some kind of ... alchemical symbols?", "anim_aqua_regia_recipe", "res://Assets/Sounds/JournalPageTurn.wav", "res://Assets/Items/Clues/AquaRegiaHintImage.png"),
	"journalpage_aquaregia_hint2": ItemDefClass.instantiate().with_data("journalpage_aquaregia_hint2", "Torn Journal Page", "A ripped journal page with some kind of ... alchemical symbols?", "anim_aqua_regia_recipe", "res://Assets/Sounds/JournalPageTurn.wav", "res://Assets/Items/Clues/AquaRegiaHintImage.png"),
	"journalpage_aquaregia_hint3": ItemDefClass.instantiate().with_data("journalpage_aquaregia_hint3", "Torn Journal Page", "A ripped journal page with some kind of ... alchemical symbols?", "anim_aqua_regia_recipe", "res://Assets/Sounds/JournalPageTurn.wav", "res://Assets/Items/Clues/AquaRegiaHintImage.png"),
	"journalpage_aquaregia_hint4": ItemDefClass.instantiate().with_data("journalpage_aquaregia_hint4", "Torn Journal Page", "A ripped journal page with some kind of ... alchemical symbols?", "anim_aqua_regia_recipe", "res://Assets/Sounds/JournalPageTurn.wav", "res://Assets/Items/Clues/AquaRegiaHintImage.png"),
	"light_potion" : ItemDefClass.instantiate().with_data("light_potion", "Light Potion", "A mystical light potion", "anim_light_bottle", POTION_SOUND, "res://Assets/Items/Potions/Small Vial - PINK.png", true),
	# Put more items here!
	}
