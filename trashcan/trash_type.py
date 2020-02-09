TRASH = "trash"
COMPOST = "compost"
RECYCLING = "landfill"

all = [COMPOST, RECYCLING, TRASH]

def get_direction(trash_type):
    if trash_type == TRASH or trash_type == COMPOST or trash_type == "Compost":
        return "left"
    else:
        return "right"

def pretty(trash_type):
    if trash_type == RECYCLING:
        return "Recycling"
    return trash_type.capitalize()
