# FROM python:3.7

# # AUTHOR raja

# ADD . /usr/src/app
# WORKDIR /usr/src/app

# COPY reuirements.txt ./

# RUN pip install -no-cache-dir -r requirements.txt

# EXPOSE 8000

# CMD exec gunicorn djangoapp.wsgi:application --bind 0.0.0.0:8000 --workers 3




# FROM python:3.8-alpine

# ENV PATH="/scripts:$(PATH)"
# RUN apk update && apk add curl vim git 
# COPY ./requirements.txt /requirements.txt
# # RUN apk --update
# # RUN apk add --update gcc
# # RUN apk add --no-cache --virtual .build-deps 
# # RUN apk add --no-cache --virtual gcc 
# # RUN apk add --no-cache --virtual musl-dev 
# # RUN apk add --no-cache --virtual curl
# # RUN apk add --no-cache  --linux-headers

# # RUN apk add --no-cache bash
# RUN apk add --update --no-cache --virtual .tmp gcc libc-dev linux-headers  --verbose
# RUN pip install -r /requirements.txt
# RUN apk del .tmp
# RUN mkdir /app
# COPY ./app /app
# WORKDIR /app
# COPY ./scripts /scripts
# RUN chmod +x /scripts/*
# RUN mkdir -p /vol/web/media
# RUN mkdir -p /vol/web/static
# RUN adduser -D user
# RUN chown -R user:user /vol
# RUN chmod -R 755 /vol/web
# USER user 
# CMD ["entrypoint.sh"]

# FROM python:3
# ENV PYTHONUNBUFFERED 1
# WORKDIR /app

# ADD . /app
# COPY ./requirements.txt  /app/requirements.txt
# RUN pip install -r requirements.txt
# COPY . /app


# pull official base image
# FROM python:3
# RUN mkdir /app
# COPY . /app
# WORKDIR /app
# ADD . /app
# # set work directory
# # WORKDIR /usr/src/app

# # set environment variables
# ENV PYTHONDONTWRITEBYTECODE 1
# ENV PYTHONUNBUFFERED 1

# # install dependencies
# RUN pip install --upgrade pip
# COPY ./requirements.txt .
# RUN pip install -r requirements.txt

# # copy project
# COPY . .




# Dockerfile

# Pull base image
# FROM python:3.7

# # Set environment variables
# ENV PYTHONDONTWRITEBYTECODE 1
# ENV PYTHONUNBUFFERED 1

# # Set work directory
# WORKDIR /code

# # Install dependencies
# RUN pip install pipenv
# # COPY Pipfile Pipfile.lock /code/
# RUN pipenv install --system

# # Copy project
# COPY . /code/


# FROM python:3.8.3-alpine

# ENV MICRO_SERVICE=/home/app/microservice
# RUN addgroup -S $APP_USER && adduser -S $APP_USER -G $APP_USER
# # set work directory


# RUN mkdir -p $MICRO_SERVICE
# RUN mkdir -p $MICRO_SERVICE/static

# # where the code lives
# WORKDIR $MICRO_SERVICE

# # set environment variables
# ENV PYTHONDONTWRITEBYTECODE 1
# ENV PYTHONUNBUFFERED 1

# # install psycopg2 dependencies
# RUN apk update \
#     && apk add --virtual build-deps gcc python3-dev musl-dev \
#     && apk add postgresql-dev gcc python3-dev musl-dev \
#     && apk del build-deps \
#     && apk --no-cache add musl-dev linux-headers g++
# # install dependencies
# RUN pip install --upgrade pip
# # copy project
# COPY . $MICRO_SERVICE
# RUN pip install -r requirements.txt
# COPY ./entrypoint.sh $MICRO_SERVICE

# CMD ["/bin/bash", "/home/app/microservice/entrypoint.sh"]

# FROM python:3
# RUN mkdir /project
# WORKDIR /project
# COPY requirements.txt /project/
# RUN pip install -r requirements.txt
# COPY . /project/


# FROM python:3.7-slim

# # Create a group and user to run our app
# ARG APP_USER=appuser
# RUN groupadd -r ${APP_USER} && useradd --no-log-init -r -g ${APP_USER} ${APP_USER}

# # Install packages needed to run your application (not build deps):
# #   mime-support -- for mime types when serving static files
# #   postgresql-client -- for running database commands
# # We need to recreate the /usr/share/man/man{1..8} directories first because
# # they were clobbered by a parent image.
# RUN set -ex \
#     && RUN_DEPS=" \
#     libpcre3 \
#     mime-support \
#     postgresql-client \
#     " \
#     && seq 1 8 | xargs -I{} mkdir -p /usr/share/man/man{} \
#     && apt-get update && apt-get install -y --no-install-recommends $RUN_DEPS \
#     && rm -rf /var/lib/apt/lists/*

# # Copy in your requirements file
# ADD requirements.txt /requirements.txt

# # OR, if you're using a directory for your requirements, copy everything (comment out the above and uncomment this if so):
# # ADD requirements /requirements

# # Install build deps, then run `pip install`, then remove unneeded build deps all in a single step.
# # Correct the path to your production requirements file, if needed.
# RUN set -ex \
#     && BUILD_DEPS=" \
#     build-essential \
#     libpcre3-dev \
#     libpq-dev \
#     " \
#     && apt-get update && apt-get install -y --no-install-recommends $BUILD_DEPS \
#     && pip install --no-cache-dir -r /requirements.txt \
#     \
#     && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $BUILD_DEPS \
#     && rm -rf /var/lib/apt/lists/*

# # Copy your application code to the container (make sure you create a .dockerignore file if any large files or directories should be excluded)
# RUN mkdir /code/
# WORKDIR /code/
# ADD . /code/

# # uWSGI will listen on this port
# EXPOSE 8000

# # Add any static environment variables needed by Django or your settings file here:
# # ENV DJANGO_SETTINGS_MODULE=my_project.settings.deploy

# # Call collectstatic (customize the following line with the minimal environment variables needed for manage.py to run):
# # RUN DATABASE_URL='' python manage.py collectstatic --noinput

# # Tell uWSGI where to find your wsgi file (change this):
# ENV UWSGI_WSGI_FILE=TallyLogin/wsgi.py

# # Base uWSGI configuration (you shouldn't need to change these):
# ENV UWSGI_HTTP=:8000 UWSGI_MASTER=1 UWSGI_HTTP_AUTO_CHUNKED=1 UWSGI_HTTP_KEEPALIVE=1 UWSGI_LAZY_APPS=1 UWSGI_WSGI_ENV_BEHAVIOR=holy

# # Number of uWSGI workers and threads per worker (customize as needed):
# ENV UWSGI_WORKERS=2 UWSGI_THREADS=4

# # uWSGI static file serving configuration (customize or comment out if not needed):
# ENV UWSGI_STATIC_MAP="/static/=/code/static/" UWSGI_STATIC_EXPIRES_URI="/static/.*\.[a-f0-9]{12,}\.(css|js|png|jpg|jpeg|gif|ico|woff|ttf|otf|svg|scss|map|txt) 315360000"

# # Deny invalid hosts before they get to Django (uncomment and change to your hostname(s)):
# # ENV UWSGI_ROUTE_HOST="^(?!localhost:8000$) break:400"

# # Change to a non-root user
# USER ${APP_USER}:${APP_USER}

# # Uncomment after creating your docker-entrypoint.sh
# ENTRYPOINT ["/code/docker-entrypoint.sh"]

# # Start uWSGI
# CMD ["uwsgi", "--show-config"]


# FROM python:3
# ENV PYTHONUNBUFFERED=1
# WORKDIR /code
# COPY requirements.txt /code/
# RUN pip install -r requirements.txt
# COPY . /code/


# FROM python:3.7-slim as production

# ENV PYTHONUNBUFFERED=1
# WORKDIR /app/
# COPY requirements.txt  ./requirements/prod.txt
# RUN pip install -r  ./requirements/prod.txt
# # RUN pip install --upgrade pip 
# # RUN pip install docutils
# # RUN pip install https://github.com/unbit/uwsgi/archive/uwsgi-2.0.zip#egg=uwsgi
# COPY manage.py ./manage.py
# # COPY setup.cfg ./setup.cfg
# # COPY TallyLogin ./TallyLogin
# COPY . .
# EXPOSE 8000
# FROM alpine

# # Initialize
# RUN mkdir -p /data/web
# WORKDIR /data/web
# COPY requirements.txt /data/web/

# # Setup
# RUN apk update
# RUN apk upgrade
# RUN apk add --update python3 python3-dev postgresql-client postgresql-dev build-base gettext
# RUN pip3 install --upgrade pip
# RUN pip3 install -r requirements.txt

# # Clean
# RUN apk del -r python3-dev postgresql

# # Prepare
# COPY . /data/web/
# RUN mkdir -p mydjango/static/admin

# pull official base image
FROM python:3.8-slim-buster

# set work directory
WORKDIR /usr/src/app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# install system dependencies
RUN apt-get update && apt-get install -y netcat

# RUN apk add py-cryptography
COPY ./requirements.txt .
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# copy project
COPY . .
# run entrypoint.sh
ENTRYPOINT ["/usr/src/app/entrypoint.sh"]