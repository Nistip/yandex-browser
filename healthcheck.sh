#!/bin/sh
set -e
supervisorctl status xvfb           | grep -q RUNNING
supervisorctl status x11vnc         | grep -q RUNNING
supervisorctl status yandex-browser | grep -q RUNNING