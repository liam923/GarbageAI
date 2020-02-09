TRASH = "trash"
PAPER = "paper"
METAL = "metal"
GLASS = "glass"
PLASTIC = "plastic"
CARDBOARD = "cardboard"

def get_direction(trash_type):
    if trash_type == TRASH:
        return "left"
    else:
        return "right"
