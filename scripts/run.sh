#!/bin/bash

ARCH=$(uname -m)
VERSION="b6fce59a3"

if [ "$ARCH" == "x86_64" ]; then
    ARCH_TYPE=x64
elif [ "$ARCH" == "aarch64" ]; then
    ARCH_TYPE=arm64
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

if ! curl -L -o sdrconnect.run https://www.sdrplay.com/software/SDRconnect_linux-${ARCH_TYPE}_${VERSION}.run; then
    echo "Failed to download SDRconnect." && exit 1
fi

chmod +x sdrconnect.run \

./sdrconnect.run --noexec --target /opt/sdrconnect

ln -s /opt/sdrconnect/SDRconnect /usr/local/bin/

rm sdrconnect.run

echo "SDRconnect installation completed."
