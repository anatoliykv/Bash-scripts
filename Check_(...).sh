стопудовый вариант
#!/bin/bash
echo $0

if [[ `egrep -v '(.*?)\(([0-9]|[a-z]|[A-Z])*\)(.*?)' $1` ]]; then

echo -e "File $1 is \e[31mINVALID\e[0m"

else
echo -e "File $1 is \e[37;42;1mVALID\e[0m"

fi
