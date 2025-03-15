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

COPY --from=builder /app/start.sh /app/start.sh
COPY --from=builder /app/main.py /app/main.py  

COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscaled /app/tailscaled
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscale /app/tailscale
RUN mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale

# Make start.sh executable
RUN chmod +x /app/start.sh

EXPOSE 8080

# Run on container startup.
CMD ["/app/start.sh"]



