from fastapi import FastAPI

app = FastAPI()


@app.get('/')
def read_root():
    return {'Hello': 'World'}


@app.get('/two_pow/{num}')
def calc_square(num: int):
    val = 0
    for i in range(num):
        val = add_nums(val, num)

    return {'result': val}


def add_nums(a, b):
    return a + b

