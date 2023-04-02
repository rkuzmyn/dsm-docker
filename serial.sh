#!/bin/bash

permanent="DSM"
serialstart="2000"

HOST_SERIAL=="$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(printf "%06d" $((RANDOM % 30000 + 1)))
GUEST_SERIAL=="$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(printf "%06d" $((RANDOM % 30000 + 1)))

./run/serial.bin -cpu=1 \
                -buildnumber=42962 \
                -vmmts="1679863686" \
                -hostsn="$HOST_SERIAL" \
                -guestsn="$GUEST_SERIAL" \
                -vmmversion="2.6.1-12139" \
                -cpu_arch="QEMU, Virtual CPU, X86_64" \
                -guestuuid="ba13a19a-c0c1-4fef-9346-915ed3b98341" > /dev/null 2>&1 &

KVM_SERIAL_OPTS="\
    -serial mon:stdio \
    -device virtio-serial-pci,id=virtio-serial0,bus=pci.0,addr=0x3 \
    -chardev pty,id=charserial0 \
    -device isa-serial,chardev=charserial0,id=serial0 \
    -chardev socket,id=charchannel0,host=127.0.0.1,port=12345,reconnect=10 \
    -device virtserialport,bus=virtio-serial0.0,nr=1,chardev=charchannel0,id=channel0,name=vchannel"