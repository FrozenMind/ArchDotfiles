while true; do
  BATTLIFE=$(acpi -b | cut -c25-26)
  if [ "$BATTLIFE" -lt 20 ]
    then
      notify-send -u critical "BATTERY LOWER THAN 20%"
  fi
  sleep 60
done
