TRASH = "trash"
COMPOST = "compost"
RECYCLING = "recycling"

all = [COMPOST, RECYCLING, TRASH]

def get_direction(trash_type):
    if trash_type == TRASH:
        return "left"
    else:
        return "right"

def pretty(trash_type):
    return trash_type.capitalize()
