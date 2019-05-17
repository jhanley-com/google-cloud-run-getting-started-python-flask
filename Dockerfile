# Use the official Python 3 image.
# https://hub.docker.com/_/python
#
# python:3 builds a 954 MB image - 342.3 MB in Google Container Registry
# FROM python:3
#
# python:3-slim builds a 162 MB image - 51.6 MB in Google Container Registry
# FROM python:3-slim
#
# python:3-alpine builds a 97 MB image - 33.2 MB in Google Container Registry
FROM python:3-alpine

# RUN apt-get update -y
# RUN apt-get install -y python-pip

COPY . /app

# Create and change to the app directory.
WORKDIR /app

RUN pip install --no-cache-dir -r requirements.txt

RUN chmod 444 app.py
RUN chmod 444 requirements.txt

# Service must listen to $PORT environment variable.
# This default value facilitates local development.
ENV PORT 8080

# Run the web service on container startup.
CMD [ "python", "app.py" ]
