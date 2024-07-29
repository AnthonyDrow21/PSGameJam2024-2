extends Control

var MissingPageClass = preload("res://Menus/Journal/PageMissing.tscn")

signal toggle_journal(open)

# We navigate through the journal by incrementing the left page number
# e.g. if _current_page == 0, we are viewing page 0 on the left, and 1 on the right
var _pages = []
var _left_page_idx = 0
var _found = false

const PAGE_IDX = 0
const IS_UNLOCKED_IDX = 1

func _ready():
	_pages.append( [load("res://Menus/Journal/Page0.tscn").instantiate(), true] )
	_pages.append( [load("res://Menus/Journal/Page1.tscn").instantiate(), true] )
	_pages.append( [load("res://Menus/Journal/Page2.tscn").instantiate(), true] )
	_pages.append( [load("res://Menus/Journal/Page3.tscn").instantiate(), true] )
	_pages.append( [load("res://Menus/Journal/Page4.tscn").instantiate(), false] )
	_pages.append( [load("res://Menus/Journal/Page5.tscn").instantiate(), false] )
	_pages.append( [load("res://Menus/Journal/Page6.tscn").instantiate(), false] )
	_update_journal(_left_page_idx)


func on_journal_picked_up():
	_found = true


func on_journal_page_picked_up(pagename_item_id):
	# ItemDef id -> page index mapping
	if pagename_item_id == "journalpage_aquaregia":
		unlock_page(4)
	else:
		print("ERROR: Unkown journal page'", pagename_item_id, "' picked up")
		return

func unlock_page(page_idx):
	assert(page_idx >= 0 and page_idx <= _pages.size())
	_pages[page_idx][IS_UNLOCKED_IDX] = true
	
	if page_idx % 2 == 0:
		_left_page_idx = page_idx
	else:
		_left_page_idx = page_idx - 1

	_update_journal(_left_page_idx)	
	print("unlocked journal page ", page_idx)


func _on_exit_button_pressed():
	emit_signal("toggle_journal", false)


func _on_next_button_pressed():
	if _left_page_idx >= _pages.size() - 2:
		return # cannot increment page any further
	
	_left_page_idx += 2
	_update_journal(_left_page_idx)


func _on_previous_button_pressed():
	if _left_page_idx == 0:
		return # cannot increment page any further
	
	_left_page_idx -= 2
	_update_journal(_left_page_idx)


func _update_page(panel, label, page_number):
	# Remove the page in the panel if there is one	
	if panel.get_child_count() > 0:
		panel.remove_child(panel.get_child(0))
		label.text = ""
	
	if page_number >= _pages.size():
		return # Do not try and display the page if it doesn't exist!
	
	# Update the page in the panel
	if not _pages[page_number][IS_UNLOCKED_IDX]:
		panel.add_child(MissingPageClass.instantiate())
	else:
		panel.add_child(_pages[page_number][PAGE_IDX])
	label.text = str(page_number + 1)


func _update_journal(new_left_idx):
	assert(new_left_idx < _pages.size())
	_update_page($HBoxContainer2/MarginContainer/HBoxContainer/TextureRect/MarginContainer/VBoxContainer/leftPanelContainer,
				 $HBoxContainer2/MarginContainer/HBoxContainer/TextureRect/MarginContainer/VBoxContainer/leftPageNumber,
				 new_left_idx)
	_update_page($HBoxContainer2/MarginContainer2/HBoxContainer/TextureRect2/MarginContainer/VBoxContainer/rightPanelContainer,
				 $HBoxContainer2/MarginContainer2/HBoxContainer/TextureRect2/MarginContainer/VBoxContainer/rightPageNumber,
				 new_left_idx+1)
	
	$HBoxContainer2/MarginContainer/HBoxContainer/prevButton.disabled = (new_left_idx == 0)
	$HBoxContainer2/MarginContainer2/HBoxContainer/nextButton.disabled = (new_left_idx == _pages.size()-1)
	
	if _found:
		$pageAudioPlayer.play()

func _input(event):	
	if _found and event.is_action_pressed("toggle_journal"):
		if not visible and not get_tree().paused:
			emit_signal("toggle_journal", true)
		elif visible:
			emit_signal("toggle_journal", false)
