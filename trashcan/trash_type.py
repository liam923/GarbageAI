TRASH = "trash"
COMPOST = "compost"
RECYCLING = "landfill"

all = [COMPOST, RECYCLING, TRASH]

def get_direction(trash_type):
<<<<<<< HEAD
    if trash_type == TRASH or trash_type == COMPOST or trash_type == "Compost":
=======
    if trash_type == TRASH or trash_type == COMPPOST:
>>>>>>> 9177638b8cc179741c0dedf24fa5b492aef089b1
        return "left"
    else:
        return "right"

def pretty(trash_type):
    if trash_type == RECYCLING:
        return "Recycling"
    return trash_type.capitalize()
