#!/bin/bash

if [ ! -d /sys/class/pwm/pwmchip0 ]; then
    echo "this model does not support pwm."
    exit 1
fi

if [ ! -d /sys/class/pwm/pwmchip0/pwm0 ]; then
    echo -n 0 > /sys/class/pwm/pwmchip0/export
fi
sleep 1
while [ ! -d /sys/class/pwm/pwmchip0/pwm0 ];
do
    sleep 1
done
ISENABLE=`cat /sys/class/pwm/pwmchip0/pwm0/enable`
if [ $ISENABLE -eq 1 ]; then
    echo -n 0 > /sys/class/pwm/pwmchip0/pwm0/enable
fi
echo -n 60000 > /sys/class/pwm/pwmchip0/pwm0/period
echo -n 1 > /sys/class/pwm/pwmchip0/pwm0/enable

echo -n 59990 > /sys/class/pwm/pwmchip0/pwm0/duty_cycle

while true
do
        temp=$(cat /sys/class/thermal/thermal_zone0/temp)
        if  [ $temp -gt 60000 ]; then
                echo 40000 > /sys/class/pwm/pwmchip0/pwm0/duty_cycle;
        elif  [ $temp -le 50000 ]; then
                echo 59990 > /sys/class/pwm/pwmchip0/pwm0/duty_cycle;
        fi
        sleep 60s;
done
