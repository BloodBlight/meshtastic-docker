```bash
docker build --platform=linux/arm/v7 . -f Dockerfile -t cisien/meshtastic-docker
```

```bash
wget https://raw.githubusercontent.com/meshtastic/firmware/master/bin/config-dist.yaml
mkdir -p "${HOME}/meshtastic/data"
cp config-dist.yaml "${HOME}/meshtastic/config.yaml"
```
Edit `${HOME}/meshtastic/config.yaml`

Adjust the devices to match those your hardware and config
```bash
sudo docker run --device /dev/ttyAMA10 --device /dev/gpiochip4 --device /dev/gpiomem4 --device /dev/spidev0.0 --device /dev/i2c-1 -v ${HOME}/meshtastic/data:/root/.portduino -v ${HOME}/meshtastic/config.yaml:/etc/meshtasticd/config.yaml -p 0.0.0.0:80:80 -p 0.0.0.0:443:443 -d --name meshtastic cisien/meshtastic-docker
```
