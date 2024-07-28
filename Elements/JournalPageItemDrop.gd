extends ItemDrop

@export var journal_page_idx = 4
signal journal_page_picked_up(page_idx)

func _ready():
	_initialized = true # avoid trying to initialize yet
	super()

func _pick_up_item(body):
	emit_signal("journal_page_picked_up", journal_page_idx)
	super(body)
