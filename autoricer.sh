PACMANPKGS=(
            ttf-fira-mono
            xorg-server
            xorg-xwininfo
            xorg-xinit
            xorg-xrandr
            xorg-xsetroot
            xorg-xprop
            xdg-utils
            xdg-user-dirs
            libxft
            imagemagick
            python-pip
            picom
            feh
            mpv
            qutebrowser
            ranger
            exfat-utils
            ntfs-3g
            maim
            neovim
            cmus
            )

AURPKGS=(
         ttf-symbola
         clipster
        )
            
PIPPKGS=(
         youtube-dl
         pywal
        )
                    
SUCKLESSREPOS=(
                https://github.com/hurutparittya/dmenu.git 
                https://github.com/hurutparittya/dwm.git
                https://github.com/hurutparittya/st.git
                    )
                    
SCRIPTREPO=https://github.com/hurutparittya/scripts.git
YAYREPO=https://aur.archlinux.org/yay-git.git

SCRIPT=$(readlink -f $0)
SCRIPTDIR=`dirname $SCRIPT`

for ((i = 0; i < ${#PACMANPKGS[@]}; i++))
do
    sudo pacman -S --noconfirm --needed ${PACMANPKGS[$i]}
done

for ((i = 0; i < ${#PIPPKGS[@]}; i++))
do
    sudo pip install ${PIPPKGS[$i]}
done

YAY_TEMP=$(mktemp -d)
git clone $YAYREPO ${YAY_TEMP}/yay
cd ${YAY_TEMP}/yay
yes | makepkg -si
cd ~
rm -rf $YAY_TEMP

for ((i = 0; i < ${#AURPKGS[@]}; i++))
do
    yay -S --noconfirm ${AURPKGS[$i]}
done


git clone $SCRIPTREPO ~/scripts
bash ~/scripts/installscripts.sh

xdg-user-dirs-update
PICDIR=`xdg-user-dir PICTURES`
mkdir ${PICDIR}/wallpapers
cp ${SCRIPTDIR}/wallpaper.jpg ${PICDIR}/wallpapers
echo feh --no-fehbg --bg-fill ${PICDIR}/wallpapers/wallpaper.jpg > ~/.fehbg
chmod +x ~/.fehbg
python -m pywal -i ${PICDIR}/wallpapers/wallpaper.jpg

mkdir ~/suckless
cd ~/suckless

for ((i = 0; i < ${#SUCKLESSREPOS[@]}; i++))
do
    git clone ${SUCKLESSREPOS[$i]}
done

for REPO in */
do
    cd $REPO
    sudo make clean install
    cd ..
done

while IFS="	", read -r location localname
do
    cp -rf ${SCRIPTDIR}/dotfiles/${localname} "${location/#\~/$HOME}"
done < ${SCRIPTDIR}/dotfiles.csv

cd ~
startx
