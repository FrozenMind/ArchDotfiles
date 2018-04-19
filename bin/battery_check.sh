#!/bin/sh

STATUS=$(acpi -b | awk '{print $3}' | cut -c1)
if [ "$STATUS" == "D" ]
  then
    BATTLIFE=$(acpi -b | awk '{print $4}' | cut -c1-2)
    if [ "$BATTLIFE" -lt 10 ]
      then
        notify-send -u critical "BATTERY LIFE: $BATTLIFE %"
      elif [ "$BATTLIFE" -lt 15 ]
        then
          notify-send -u normal "BATTERY LIFE: $BATTLIFE %"
      elif [ "$BATTLIFE" -lt 20 ]
        then
          notify-send -u low "BATTERY LIFE: $BATTLIFE %"
    fi
fi
