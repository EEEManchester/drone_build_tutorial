# Mavlink interface between autopilot and onboard computer

## Mavpoxy
```shell
sudo apt-get install python3-dev python3-opencv python3-wxgtk4.0 python3-pip python3-matplotlib python3-lxml python3-pygame
pip3 install PyYAML mavproxy --user
echo 'export PATH="$PATH:$HOME/.local/bin"' >> ~/.bashrc

```

1. Connect to autopilot
```shell
    mavproxy.py --master=/dev/ttyUSB0
```

