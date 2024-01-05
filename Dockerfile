FROM public.ecr.aws/docker/library/python:3-alpine

WORKDIR /app


# Set the username to rails if it's not specified
ARG USERNAME=admin

# Create the user
RUN adduser -D -H ${USERNAME} ${USERNAME}

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1


# install dependencies
RUN pip install --upgrade pip 
COPY ./requirements.txt .



RUN \
 apk add --no-cache postgresql-libs curl && \
 apk add --no-cache --virtual .build-deps gcc musl-dev postgresql-dev && \
 python3 -m pip install -r requirements.txt --no-cache-dir && \
 apk --purge del .build-deps




# USER ${USERNAME}:${USERNAME}

# RUN pip install -r requirements.txt

# copy project
COPY ./ecommerce .
# Collect static files
# RUN python3 manage.py collectstatic --noinput

EXPOSE 8000

COPY ./docker-entrypoint.sh .

RUN chmod +x ./docker-entrypoint.sh

ENTRYPOINT ["./docker-entrypoint.sh"]