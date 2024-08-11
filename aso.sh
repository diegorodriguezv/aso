# ASO: Automatic Screen Off

# exit if not in HDMI output
luna-send -n 1 -i 'luna://com.webos.applicationManager/getForegroundAppInfo' '{"subscribe":false}'\
 | grep com.webos.app.hdmi > /dev/null && echo HDMI || (echo "No HDMI" ; exit)

width=240
height=360

# move existing screenshot to old
[[ -e /tmp/aso-$1-latest.png ]] && mv /tmp/aso-$1-latest.png /tmp/aso-$1-old.png && echo "moved"

# take latest screenshot
luna-send -n 1 -f 'luna://com.webos.service.capture/executeOneShot' \
  "{\"path\":\"/tmp/aso-$1-latest.png\",\"method\":\"DISPLAY\",\"format\":\"PNG\", \
  \"width\": $width, \"height\": $height}" > /dev/null

state=`luna-send -n 1 -i 'luna://com.webos.service.tvpower/power/getPowerState' '{}'` 
(echo $state | grep '"state": "Active"') && screen=true 
(echo $state | grep '"state": "Screen Off"') && screen=false 
echo screen $screen

# Are the latest and old screenshots equal?
(diff /tmp/aso-$1-latest.png /tmp/aso-$1-old.png > /dev/null) && (
  echo equal
  [ $screen == true ] && [ $1 == "off" ] && (echo "turning off" ; luna-send -n 1 "luna://com.webos.service.tvpower/power/turnOffScreen" '{}' > /dev/null)
  true
) || (
  echo different  
  [ $screen == false ] && [ $1 == "on" ] && (echo "turning on" ; luna-send -n 1 "luna://com.webos.service.tvpower/power/turnOnScreen" '{}' > /dev/null)
)
