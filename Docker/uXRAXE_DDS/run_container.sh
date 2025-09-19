#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


docker run -it --rm --privileged \
            --network host \
            --name=px4-xrace_px4 \
             xrace_px4:latest bash

