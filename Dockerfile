FROM python:3.11

# Tip from https://stackoverflow.com/questions/63892211
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive \
    apt-get install --no-install-recommends --assume-yes \
      bc \
      sqlite3

#COPY requirements.txt .
#RUN python -mpip install --upgrade pip \
# && pip install --no-cache-dir -r ./requirements.txt

# Put `--rcfile /bashrc` after `/bin/bash` in `run_bash.sh`
# to pick these up on each login.
COPY bash.bashrc bashrc

RUN mkdir /data
WORKDIR /app

#CMD ["python", "app.py"]
