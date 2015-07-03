#!/bin/bash
echo "Killing xcode..."
kill $(ps aux | grep 'Xcode' | awk '{print $2}')
