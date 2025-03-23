#!/bin/bash
sudo dnf update -y
sudo dnf install -y python3 python3-pip
sudo dnf install -y amazon-linux-extras
sudo amazon-linux-extras enable ansible2
sudo dnf install -y ansible