import json
import logging
import os
import time
import traceback

import httpx
from fastapi import FastAPI, HTTPException, Request
from opentelemetry import trace

tracer = trace.get_tracer(__name__)
logger = logging.getLogger(__name__)

app = FastAPI()


@app.get('/')
def read_root():
    logger.info('Root request')
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
    data_dict = {'hello': 'world'}
    logging.info('This is the message field', extra={'json_fields': data_dict})
    return request.headers


@app.get('/trace')
def send_hello():
    with tracer.start_as_current_span('custom span'):
        time.sleep(2)

    return 'Hello world!'


@app.get('/two_pow/{num}')
def calc_square(num: int):
    val = 0
    for i in range(num):
        val = add_nums(val, num)

    logger.info(f'result is {val}')
    return {'result': val}


@tracer.start_as_current_span('add_nums')
def add_nums(a, b):
    logger.info(f'adding {b} to {a}')
    return a + b


@app.get('/error')
def error():
    try:
        test = []
        return test[0]
    except IndexError as e:
        logger.error(
            json.dumps({
                'exception': str(type(e).__name__),
                'message': f'{type(e).__name__}: {e}',
                'stack_trace': traceback.format_exc(),
            })
        )
        raise HTTPException(status_code=500, detail='Internal server error')
