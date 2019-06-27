#!/bin/sh

#AStyle Install file for Web Search @ Baidu
#Author: ShiYuan (shiyuan@baidu.com)

TMP_DIR="astyle.inst.tmp"


rm -rf ~/$TMP_DIR
mkdir ~/$TMP_DIR
cd ~/$TMP_DIR

#Download AStyle and option file
wget http://styleguide.baidu.com/style/cpp/resources/.astyle
if [ $? -ne 0 ]
then
    echo "failed to download astyle from: http://styleguide.baidu.com/style/cpp/resources/.astyle"
    exit 255
fi

wget http://styleguide.baidu.com/style/cpp/resources/.astylerc
if [ $? -ne 0 ]
then
    echo "failed to download astyle option file from : http://styleguide.baidu.com/style/cpp/resources/.astylerc"
    exit 255
fi

#Check if a copy is installed already

if [ -e ~/bin/astyle ] || [ -e ~/.astylerc ]
then
    read -p "A version of astyle is already installed, reinstalling will reset astyle and ITS OPTION FILE!
    Press ENTER to continue, or Ctrl+C to stop"
fi

rm -rf ~/bin/astyle
rm -rf ~/.astylerc

#install
mkdir ~/bin 2>/dev/null
cp .astyle ~/bin/astyle
chmod a+x ~/bin/astyle

#.astylerc 跟us有冲突， 暂时不安装了
#cp .astylerc ~/.astylerc

echo "ARTISTIC_STYLE_OPTIONS=~/.astylerc" >> ~/.bashrc

#Modefied by liusen01
echo 'alias astyle="astyle --style=attach --convert-tabs --indent=spaces=4 --add-brackets \
--pad-header --unpad-paren --pad-oper --max-code-length=100 --formatted --align-pointer=type \
--align-reference=type --break-blocks -Y"' >> ~/.bashrc

#Clean up
cd -
rm -rf ~/$TMP_DIR


echo "Done! Enjoy astyle"
