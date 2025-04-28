FROM debian:bookworm AS build
WORKDIR /src
RUN apt update; apt install -y curl pip git python3-venv pkg-config libgpiod-dev libyaml-cpp-dev libbluetooth-dev wget
RUN apt install -y libusb-1.0-0-dev libuv1-dev libi2c-dev
ENV VIRTUAL_ENV=/src
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN pip install -U platformio adafruit-nrfutil 
RUN git clone https://github.com/meshtastic/firmware 
WORKDIR /src/firmware 
RUN git submodule update --init 
RUN bin/build-native.sh
RUN mv release/meshtasticd_linux_$(uname -m) release/meshtasticd
WORKDIR /src/web
RUN wget https://github.com/meshtastic/web/releases/download/latest/build.tar
RUN tar -xvf build.tar
RUN rm build.tar

FROM debian:bookworm
WORKDIR /app
RUN apt update; apt install -y pip python3-venv libgpiod2 libyaml-cpp0.7
ENV VIRTUAL_ENV=/app
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN pip install -U meshtastic wcwidth
COPY --from=build /src/firmware/release/meshtasticd /app/meshtasticd
COPY --from=build /src/web/ /usr/share/doc/meshtasticd/web/
ENTRYPOINT ["/app/meshtasticd"]
