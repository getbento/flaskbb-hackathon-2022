# https://hub.docker.com/_/python/
FROM python:3.10

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN ln -snf /usr/share/zoneinfo/America/New_York /etc/localtime \
    && echo America/New_York > /etc/timezone

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        inetutils-traceroute \
        iputils-ping \
        postgresql-client \
        tzdata \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app/flaskbb

COPY . .

RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir wheel \
    && pip install --no-cache-dir -r requirements.txt \
    && pip install --no-cache-dir -r requirements-dev.txt

CMD ./docker-flaskbb-init.sh \
    && flaskbb --config flaskbb.cfg run --host 0.0.0.0

EXPOSE 5000
