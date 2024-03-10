FROM python:3.8.13-slim-buster 

RUN apt-get update 
#&& yes|apt-get install p7zip-full tmux docker
RUN python3 -m pip install when-changed messenger_python invoke
RUN echo "echo \"BASEDOCKER\"" >/bin/whodis && chmod 777 /bin/whodis

RUN cat .bash_aliases ~/.bash_aliases
COPY . /bin/
RUN chmod 777 /bin/*_mini

WORKDIR /sync/
CMD /bin/bash
