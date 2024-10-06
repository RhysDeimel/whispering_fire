ARG PY_VERSION="3.12"



FROM python:${PY_VERSION}-slim AS dev
WORKDIR /app

COPY . .
RUN pip install --no-cache-dir .

EXPOSE 8080 
CMD ["python", "-m", "whispering_fire"]



FROM python:${PY_VERSION} AS build
ARG PY_VERSION
WORKDIR /app

COPY --from=dev --link /usr/local/lib/python${PY_VERSION}/site-packages/ /usr/local/lib/python${PY_VERSION}/site-packages/
COPY --from=dev --link /app /app

RUN apt update && apt install patchelf
RUN pip install --no-cache-dir pyinstaller staticx
RUN pyinstaller -F --name app --clean src/whispering_fire/__main__.py
RUN staticx dist/app dist/static_app
RUN mkdir dist/tmp



FROM scratch AS run
COPY --from=build --chown=1001:1001 /app/dist/static_app /app
COPY --from=build --chown=1001:1001 /app/dist/tmp /tmp

USER 1001
EXPOSE 8080 
ENTRYPOINT ["/app"]

# PyInstaller does not bundle libc. Instead it expects to link dymamically to it.
#   This would not work in `scratch` because those files aren't there.
# To make this easier, we're using staticx to convert the dynamic executable into a static one.
#
# staticX extracts packed files into a temporary directory in /tmp
#  `scratch` does not have mkdir, so we need to create it, and then copy over
