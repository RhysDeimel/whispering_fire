ARG PY_VERSION="3.12"

FROM python:${PY_VERSION}-slim AS build

WORKDIR /code
COPY . .
RUN pip install --no-cache-dir .



FROM python:${PY_VERSION}-slim AS app
ARG PY_VERSION
COPY --from=build /usr/local/lib/python${PY_VERSION}/site-packages/ /usr/local/lib/python${PY_VERSION}/site-packages/

EXPOSE 8080 
CMD ["python", "-m", "whispering_fire"]
