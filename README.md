# Whispering Fire
Playing around with FastAPI

```
pip install -e .[dev]
```


```
fastapi dev src/whispering_fire/main.py

# if package installed. Hooks into __main__
python -m whispering_fire
```

```
ruff format
ruff check
ruff check --fix
mypy .
```


```
http://localhost:8000/

# for Swagger UI
http://localhost:8000/docs

# For ReDoc
http://localhost:8000/redoc

# raw OpenAPI spec
http://127.0.0.1:8000/openapi.json
```
