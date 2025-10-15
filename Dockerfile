FROM python:3.14

RUN groupadd -r uwsgi && useradd -r -g uwsgi uwsgi
RUN pip install Flask==3.1.2 uWSGI==2.0.31 
WORKDIR /app
COPY app /app

EXPOSE 9090 9191
USER uwsgi

CMD ["uwsgi", "--http", "0.0.0.0:9090", "--wsgi-file", "/app/identidock.py", "--callable", "app", "--stats", "0.0.0.0:9191"]