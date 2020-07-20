FROM raspbian/stretch as builder

RUN apt-get update
RUN apt-get install -y git build-essential wget

WORKDIR /build
RUN git clone https://github.com/Lora-net/lora_gateway.git
COPY loragw_spi.native.c /build/lora_gateway/libloragw/src
RUN git clone https://github.com/Lora-net/packet_forwarder.git
COPY lora_pkt_fwd.c /build/packet_forwarder/lora_pkt_fwd/src
COPY global_conf.json /build/packet_forwarder/lora_pkt_fwd/
WORKDIR /build/packet_forwarder
RUN ./compile.sh
COPY start.sh .
RUN chmod +x start.sh

ENTRYPOINT ["./start.sh"]
