#!/bin/bash -ex

if [ $(grep -ci $CUPSADMIN /etc/shadow) -eq 0 ]; then
    useradd -r -G lpadmin -M $CUPSADMIN

    # add password
    echo $CUPSADMIN:$CUPSPASSWORD | chpasswd

    # add tzdata
    ln -fs /usr/share/zoneinfo/$TZ /etc/localtime
    dpkg-reconfigure --frontend noninteractive tzdata
fi

# restore default Cups config in case user does not have any
if [ ! -f /etc/cups/cupsd.conf ]; then
    cp -rpn /etc/cups-bak/* /etc/cups/
fi

/usr/sbin/cupsd

exec /usr/local/PrintNode/PrintNode \
    --computer-name $PRINTNODE_HOSTNAME \
    --headless \
    --web-interface \
    --use-enviroment-variables