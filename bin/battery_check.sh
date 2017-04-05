while true; do
  BATTLIFE=$(acpi -b | awk '{print $4}' | cut -c1-2)
  if [ "$BATTLIFE" -lt 20 ]
    then
      notify-send -u critical "BATTERY LOWER THAN 20%"
  fi
  sleep 60
done
