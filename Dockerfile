FROM raspbian/stretch as builder

#RUN apt-get update && apt-get upgrade -y
RUN apt-get update
RUN apt-get install -y git build-essential wget

WORKDIR /build
RUN git clone https://github.com/Lora-net/lora_gateway.git
COPY loragw_spi.native.c /build/lora_gateway/libloragw/src
#WORKDIR /build/lora_gateway/libloragw/src
#RUN rm loragw_spi.native.c
#RUN wget https://raw.githubusercontent.com/RAKWireless/RAK2245-RAK831-LoRaGateway-RPi-Raspbian-OS/master/lora/loragw_spi.native.c

WORKDIR /build
RUN git clone https://github.com/Lora-net/packet_forwarder.git
COPY lora_pkt_fwd.c /build/packet_forwarder/lora_pkt_fwd/src
#WORKDIR /build/packet_forwarder/lora_pkt_fwd
#RUN wget -O global_conf.json https://raw.githubusercontent.com/PastaGringo/h2b/master/config_alt/global_conf_868mhz.json
COPY global_conf.json /build/packet_forwarder/lora_pkt_fwd/
WORKDIR /build/packet_forwarder
RUN ./compile.sh

RUN /build/lora_gateway/reset_lgw.sh start 17

#COPY --from=builder /build/packet_forwarder/lora_pkt_fwd/lora_pkt_fwd .
#WORKDIR /build/packet_forwarder/lora_pkt_fwd

COPY start.sh .
RUN chmod +x start.sh

ENTRYPOINT ["./start.sh"]
