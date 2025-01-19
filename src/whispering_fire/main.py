import os

import httpx
from fastapi import FastAPI, Request

app = FastAPI()


@app.get('/')
def read_root():
    return {'Hello': 'World'}


@app.get('/envs')
def get_envs():
    envs = []
    for name, value in os.environ.items():
        envs.append(f'{name}: {value}')

    return {'envs': envs}


@app.get('/weather')
def weather():
    r = httpx.get('https://wttr.in/Sydney?format=4')

    location, weather = r.text.split(': ')

    return {location: weather.strip()}


@app.get('/request')
def dump(request: Request):
    return request.headers


# @app.get('/trace')
# def send_hello():
#     with tracer.start_as_current_span('foo'):
#         return 'Hello world!'


@app.get('/two_pow/{num}')
def calc_square(num: int):
    val = 0
    for i in range(num):
        val = add_nums(val, num)

    return {'result': val}


def add_nums(a, b):
    return a + b
