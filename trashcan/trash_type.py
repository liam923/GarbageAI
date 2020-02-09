TRASH = "trash"
PAPER = "paper"
METAL = "metal"
GLASS = "glass"
PLASTIC = "plastic"
CARDBOARD = "cardboard"

all = [TRASH, PAPER, METAL, GLASS, PLASTIC, CARDBOARD]

def get_direction(trash_type):
    if trash_type == TRASH:
        return "left"
    else:
        return "right"

def pretty(trash_type):
    return trash_type.capitalize()
