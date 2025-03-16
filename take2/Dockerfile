FROM alpine:latest as builder
WORKDIR /app
COPY . ./

FROM python:3.11-alpine
RUN apk update && apk add ca-certificates iptables ip6tables python3 && rm -rf /var/cache/apk/*

# Create and activate a virtual environment
RUN python -m venv /venv
ENV PATH="/venv/bin:$PATH"
RUN pip install --upgrade pip
RUN pip install --no-cache-dir fastapi uvicorn

COPY --from=builder /app/bootstrap /var/runtime/bootstrap
COPY --from=builder /app/main.py /var/runtime/main.py  
# Copy Tailscale binaries from the tailscale image on Docker Hub.
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscaled /var/runtime/tailscaled
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscale /var/runtime/tailscale
RUN mkdir -p /var/run && ln -s /tmp/tailscale /var/run/tailscale && \
    mkdir -p /var/cache && ln -s /tmp/tailscale /var/cache/tailscale && \
    mkdir -p /var/lib && ln -s /tmp/tailscale /var/lib/tailscale && \
    mkdir -p /var/task && ln -s /tmp/tailscale /var/task/tailscale

# Run on container startup.
ENTRYPOINT ["/var/runtime/bootstrap"]




