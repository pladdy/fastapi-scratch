FROM python:3.9-bullseye

WORKDIR /opt/fastapi-scratch

RUN apt-get install openssl -y && update-ca-certificates
RUN openssl \
      req -newkey rsa:4096 \
      -x509 \
      -sha512 \
      -days 365 \
      -nodes \
      -out certificate.pem \
      -keyout privatekey.pem \
      -subj "/C=US/O=fastapi-scratch/CN=pladdy"

ENV POETRY_VERSION=1.1.14
RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/$POETRY_VERSION/get-poetry.py | python -
ENV PATH=/root/.poetry/bin:$PATH
RUN /bin/bash -c "source $HOME/.poetry/env"

COPY pyproject.toml poetry.lock .
RUN poetry install --no-dev --no-root
COPY . .
RUN poetry install --no-dev

EXPOSE 443
CMD poetry run uvicorn fastapi_scratch.main:app \
      --host 0.0.0.0 \
      --port 443 \
      --ssl-ca-certs=/etc/ssl/certs/ca-certificates.crt \
      --ssl-certfile=./certificate.pem \
      --ssl-keyfile=./privatekey.pem
