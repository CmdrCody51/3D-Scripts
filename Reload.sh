#! /bin/bash
# Author: Brett Crapser
# Version:1.0
# License: GNU GPLV3

if [ $# -eq 0 ]
then
  echo "No arguments supplied"
  echo "Usage: Reload.sh -c -d XX"
  echo "     c - strip current DLP M117 messages"
  echo "     d - delay between files"
  echo ""
  echo "Requirements : OctoPrint. OctoPi may not have the same directory structure."
  echo "Under Folders select the Watched Folder and use the default. use a big delay value and hit Ctrl-C after a second."
  echo ""
  echo "This script does not remove any files. Your old un-Reloaded files will remain. Reloaded files are"
  echo "pre-pended with RDLP-filename. If you want to test it out, just use a long delay and Ctrl-C out."
  echo ""
  echo "Notice: If there is no layer information in the original file, DLP will still not modify the file."
  echo "The 'delay' time is useful because ALL the plugins that scan incoming files will be activated when"
  echo "the files are 'Reloaded'. The load on the RPi will be rather high."
  echo ""
  exit
fi

my_delay=0
my_strip=0

while getopts ":cd:" opt; do
  case $opt in
    d) my_delay="$OPTARG"
    ;;
    c) my_strip=1
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

my_pwd=${PWD}

[ -d "${my_pwd}/watched" ] && echo "Directory ${my_pwd}/watched exists."

[ -d "${my_pwd}/uploads" ] && echo "Directory ${my_pwd}/uploads exists."

from_dir="${my_pwd}/uploads"
to_dir="${my_pwd}/watched"

echo ""
echo "DO NOT RUN THIS SCRIPT WHILE YOU ARE PRINTING WITH OCTOPRINT! YOU HAVE BEEN WARNED!"
echo ""

echo "Ready to Reload the files in 'uploads' to the 'watched' directory."
if [ "$my_strip" -eq "0" ]; then
  echo "Leaving files as they are"
else
  echo "Stripping DLP mods"
fi
if [ "$my_delay" -eq "0" ]; then
  echo "No delay - may the RPi gods forgive you"
else
  echo "Delaying $my_delay seconds between files"
fi
echo ""

read -p "Are you sure? " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
fi

echo "Kool! Here we go!"

cd ${from_dir}

echo "Replicating Uploads directory structure to Watched directory"
# this rebuilds the upload directory structure in the watched folder
find . -type d -exec mkdir -p -- ${to_dir}/{} \;

echo "Done!"
echo "Working on $from_dir"

# gets all the directories under the current directory
mapfile -t my_uploads < <(find . -type d)

for (( i=0; i<${#my_uploads[@]}; i++ )); do
  echo ${my_uploads[i]}
  cd "${from_dir}/${my_uploads[i]}"
  echo ${PWD}
  # get files in current directory
  mapfile -t my_files < <(find ${PWD} -maxdepth 1 -type f | grep -v '/\.'1 | grep -v 'metadata.json')
  for (( j=0; j<${#my_files[@]}; j++ )); do
    echo "Processing > " ${my_files[j]}
    my_test=${my_files[j]/uploads/watched}
    my_path="${my_test%/*} ${my_test##*/}"
    my_test=${my_path/ /\/RDLP-}
    echo "        To > " ${my_test}
    if [ "$my_strip" -eq "0" ]; then
      cat "${my_files[j]}" > /tmp/RDLP
      mv /tmp/RDLP "${my_test}"
    else
      sed '/M117 INDICATOR-Layer/d' "${my_files[j]}" > /tmp/RDLP
      mv /tmp/RDLP "${my_test}"
    fi
    sleep $my_delay
  done
  unset my_files
  unset your_files

done
