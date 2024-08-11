# ASO: Automatic Screen Off
This service turns off the screen when it detects no change in the screen (pause or blank).
## You need
- A rooted webOS TV
- It must have the Homebrew Channel app (webosbrew.org)
- ssh access to your tv
## Installation
note: replace lgwebostv with your TV's IP

PC:
```sh
scp -r aso root@lgwebostv:/home/root/aso
```
TV:
```sh
cd /home/root/aso
cp init.d/00-mount-aso-overlay /var/lib/webosbrew/init.d/
reboot
```
## Uninstall
TV:
```sh
rm /var/lib/webosbrew/init.d/00-mount-aso-overlay
rm -rf /home/root/aso
reboot
```
