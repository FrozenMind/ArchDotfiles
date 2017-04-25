while true; do
CORD=$(acpi -b | awk '{print $3}' | cut -c1)
if [ "$CORD" == "D" ]
  then
    BATTLIFE=$(acpi -b | awk '{print $4}' | cut -c1-2)
    if [ "$BATTLIFE" -lt 10 ]
      then
        notify-send -u critical "BATTERY LOWER THAN 10%"
      elif [ "$BATTLIFE" -lt 15 ]
        then
          notify-send -u critical "BATTERY LOWER THAN 15%"
      elif [ "$BATTLIFE" -lt 20 ]
        then
          notify-send -u normal "BATTERY LOWER THAN 20%"
    fi
fi
notify-send -u normal "bat service done"
sleep 20
done
