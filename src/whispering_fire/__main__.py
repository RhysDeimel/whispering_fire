# This file exists to fix a super obscure edge case with importing. I've long
# since lost the link to the post that helped me figure it out. Fight me.

# If you're pulling in other modules within this folder, don't forget to import
# them as demonstrated in the unused example below

import uvicorn
from . import main

uvicorn.run("whispering_fire.main:app", host="0.0.0.0")
