d20=0
d15=0
d10=0
while true; do
  CORD=$(acpi -b | awk '{print $3}' | cut -c1)
  if [ "$CORD" == "D" ]
    then
      BATTLIFE=$(acpi -b | awk '{print $4}' | cut -c1-2)
      if [ "$BATTLIFE" -lt 10 ] && [ "$d10" -eq 0 ]
        then
          notify-send -u critical "BATTERY LOWER THAN 10%"
          d10=1
        elif [ "$BATTLIFE" -lt 15 ] && [ "$d15" -eq 0 ]
          then
            notify-send -u critical "BATTERY LOWER THAN 15%"
            d15=1
        elif [ "$BATTLIFE" -lt 20 ] && [ "$d20" -eq 0 ]
          then
            notify-send -u normal "BATTERY LOWER THAN 20%"
            d20=1
      fi
    else
      d20=0
      d15=0
      d10=0
  fi
  sleep 60
done
