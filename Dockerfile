FROM python:3.8-alpine

COPY ./requirements.txt .
RUN apk add --update --no-cache --virtual .tmp gcc libc-dev linux-headers
RUN pip install -r requirements.txt
RUN apk del .tmp

RUN mkdir /app
COPY ./app /app
WORKDIR /app

RUN adduser -D user
RUN chown -R user:user /app
RUN chmod -R 755 /app
USER user

CMD ["entrypoint.sh"]