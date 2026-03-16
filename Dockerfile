FROM eclipse-mosquitto:2
COPY config/mosquitto.dev.conf /mosquitto/config/mosquitto.conf
COPY certs/ /certs/
