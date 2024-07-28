extends Control

var MissingPageClass = preload("res://Menus/Journal/PageMissing.tscn")

signal toggle_journal(open)

# We navigate through the journal by incrementing the left page number
# e.g. if _current_page == 0, we are viewing page 0 on the left, and 1 on the right
var _pages = []
var _left_page_idx = 0

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


func unlock_page(page_idx):
	assert(page_idx >= 0 and page_idx <= _pages.size())
	_pages[page_idx][IS_UNLOCKED_IDX] = false


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


func _update_page(panel, page_number):
	# Remove the page in the panel if there is one	
	if panel.get_child_count() > 0:
		panel.remove_child(panel.get_child(0))
	
	if page_number >= _pages.size():
		return # Do not try and display the page if it doesn't exist!
	
	# Update the page in the panel
	if not _pages[page_number][IS_UNLOCKED_IDX]:
		panel.add_child(MissingPageClass.instantiate())
	else:
		panel.add_child(_pages[page_number][PAGE_IDX])


func _update_journal(new_left_idx):
	assert(new_left_idx < _pages.size())
	_update_page($leftPagePanel, new_left_idx)
	_update_page($rightPagePanel, new_left_idx+1)
	$pageAudioPlayer.play()
