FROM python:3.12-slim-bullseye
# based on https://github.com/jpmens/mqttwarn

# install mqttwarn
RUN pip install --upgrade 'mqttwarn[telegram]==0.35.0' && \
    mkdir -p /etc/mqttwarn && \
    groupadd -r mqttwarn && useradd -r -g mqttwarn mqttwarn && \
    chown -R mqttwarn:mqttwarn /etc/mqttwarn

# process run as mqttwarn user
WORKDIR /etc/mqttwarn
USER mqttwarn

# conf file from host
VOLUME ["/etc/mqttwarn"]

# set conf path
ENV MQTTWARNINI="/etc/mqttwarn/mqttwarn.ini"

# run process
CMD mqttwarn
