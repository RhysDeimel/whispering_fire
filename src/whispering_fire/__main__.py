# This file exists to fix a super obscure edge case with importing. I've long
# since lost the link to the post that helped me figure it out. Fight me.

# If you're pulling in other modules within this folder, don't forget to import
# them as demonstrated in the unused example below

import uvicorn
from opentelemetry import trace
from opentelemetry.exporter.cloud_trace import CloudTraceSpanExporter
from opentelemetry.instrumentation.fastapi import FastAPIInstrumentor
from opentelemetry.instrumentation.httpx import HTTPXClientInstrumentor
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import (
    SimpleSpanProcessor,
)

from whispering_fire.main import app

provider = TracerProvider()
trace.set_tracer_provider(provider)
cloud_trace_exporter = CloudTraceSpanExporter()
provider.add_span_processor(SimpleSpanProcessor(cloud_trace_exporter))
tracer = trace.get_tracer(__name__)

HTTPXClientInstrumentor().instrument()
FastAPIInstrumentor.instrument_app(app)

uvicorn.run(app, host='0.0.0.0', port=8080)
