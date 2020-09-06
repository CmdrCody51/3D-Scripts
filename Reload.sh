#! /bin/bash

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
  echo "pre-pended with RDLP-filename. If you want to test it out, "
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
    d) my_delay="$OPTARG"echo "Replicating Uploads directory structure to Watched directory"
# this rebuilds the upload directory structure in the watched folder
find . -type d -exec mkdir -p -- /home/pi/.octoprint/watched/{} \;

echo "Done!"
echo "Working on $from_dir"

# gets all the directories under the current directory
mapfile -t my_uploads < <(find . -type d)

for (( i=0; i<${#my_uploads[@]}; i++ )); do
  echo ${my_uploads[i]}
  cd "${from_dir}/${my_uploads[i]}"
  # get files in current directory
  mapfile -t my_files < <(ls -p1 | grep -v /)
  for (( j=0; j<${#my_files[@]}; j++ )); do
    echo "${from_dir}/${my_uploads[i]}/${my_files[j]}"
    if [ "$my_strip" -eq "0" ]; then
      cp ${from_dir}/${my_uploads[i]}/${my_files[j]} /tmp/RDLP
# if you feel very safe you can comment out the next line and uncomment the next two to remove the original filesecho "Replicating Uploads directory structure to Watched directory"
# this rebuilds the upload directory structure in the watched folder
find . -type d -exec mkdir -p -- /home/pi/.octoprint/watched/{} \;

echo "Done!"
echo "Working on $from_dir"

# gets all the directories under the current directory
mapfile -t my_uploads < <(find . -type d)

for (( i=0; i<${#my_uploads[@]}; i++ )); do
  echo ${my_uploads[i]}
  cd "${from_dir}/${my_uploads[i]}"
  # get files in current directory
  mapfile -t my_files < <(ls -p1 | grep -v /)
  for (( j=0; j<${#my_files[@]}; j++ )); do
    echo "${from_dir}/${my_uploads[i]}/${my_files[j]}"
    if [ "$my_strip" -eq "0" ]; then
      cp ${from_dir}/${my_uploads[i]}/${my_files[j]} /tmp/RDLP
# if you feel very safe you can comment out the next line and uncomment the next two to remove the original filesecho "Replicating Uploads directory structure to Watched directory"
# this rebuilds the upload directory structure in the watched folder
find . -type d -exec mkdir -p -- /home/pi/.octoprint/watched/{} \;

echo "Done!"
echo "Working on $from_dir"

# gets all the directories under the current directory
mapfile -t my_uploads < <(find . -type d)

for (( i=0; i<${#my_uploads[@]}; i++ )); do
  echo ${my_uploads[i]}
  cd "${from_dir}/${my_uploads[i]}"
  # get files in current directory
  mapfile -t my_files < <(ls -p1 | grep -v /)
  for (( j=0; j<${#my_files[@]}; j++ )); do
    echo "${from_dir}/${my_uploads[i]}/${my_files[j]}"
    if [ "$my_strip" -eq "0" ]; then
      cp ${from_dir}/${my_uploads[i]}/${my_files[j]} /tmp/RDLP
# if you feel very safe you can comment out the next line and uncomment the next two to remove the original files
      mv /tmp/RDLP ${to_dir}/${my_uploads[i]}/RDLP-${my_files[j]}
#      rm ${from_dir}/${my_uploads[i]}/${my_files[j]}
#      mv /tmp/RDLP ${to_dir}/${my_uploads[i]}/${my_files[j]}
    else
      sed '/M117 INDICATOR-Layer/d' ${from_dir}/${my_uploads[i]}/${my_files[j]} > /tmp/RDLP
# if you feel very safe you can comment out the next line and uncomment the next two to remove the original files
      mv /tmp/RDLP ${to_dir}/${my_uploads[i]}/RDLP-${my_files[j]}
#      rm ${from_dir}/${my_uploads[i]}/${my_files[j]}
#      mv /tmp/RDLP ${to_dir}/${my_uploads[i]}/${my_files[j]}
    fi
    # echo `uptime`
    sleep $my_delay
  done

done

      mv /tmp/RDLP ${to_dir}/${my_uploads[i]}/RDLP-${my_files[j]}
#      rm ${from_dir}/${my_uploads[i]}/${my_files[j]}
#      mv /tmp/RDLP ${to_dir}/${my_uploads[i]}/${my_files[j]}
    else
      sed '/M117 INDICATOR-Layer/d' ${from_dir}/${my_uploads[i]}/${my_files[j]} > /tmp/RDLP
# if you feel very safe you can comment out the next line and uncomment the next two to remove the original files
      mv /tmp/RDLP ${to_dir}/${my_uploads[i]}/RDLP-${my_files[j]}
#      rm ${from_dir}/${my_uploads[i]}/${my_files[j]}
#      mv /tmp/RDLP ${to_dir}/${my_uploads[i]}/${my_files[j]}
    fi
    # echo `uptime`
    sleep $my_delay
  done

done

      mv /tmp/RDLP ${to_dir}/${my_uploads[i]}/RDLP-${my_files[j]}
#      rm ${from_dir}/${my_uploads[i]}/${my_files[j]}
#      mv /tmp/RDLP ${to_dir}/${my_uploads[i]}/${my_files[j]}
    else
      sed '/M117 INDICATOR-Layer/d' ${from_dir}/${my_uploads[i]}/${my_files[j]} > /tmp/RDLP
# if you feel very safe you can comment out the next line and uncomment the next two to remove the original files
      mv /tmp/RDLP ${to_dir}/${my_uploads[i]}/RDLP-${my_files[j]}
#      rm ${from_dir}/${my_uploads[i]}/${my_files[j]}
#      mv /tmp/RDLP ${to_dir}/${my_uploads[i]}/${my_files[j]}
    fi
    # echo `uptime`
    sleep $my_delay
  done

done

    ;;
    c) my_strip=1
    ;;
    \?) echo "Invalid option -$OPTARG" >&2echo "Replicating Uploads directory structure to Watched directory"
# this rebuilds the upload directory structure in the watched folder
find . -type d -exec mkdir -p -- /home/pi/.octoprint/watched/{} \;

echo "Done!"
echo "Working on $from_dir"

# gets all the directories under the current directory
mapfile -t my_uploads < <(find . -type d)

for (( i=0; i<${#my_uploads[@]}; i++ )); do
  echo ${my_uploads[i]}
  cd "${from_dir}/${my_uploads[i]}"
  # get files in current directory
  mapfile -t my_files < <(ls -p1 | grep -v /)
  for (( j=0; j<${#my_files[@]}; j++ )); do
    echo "${from_dir}/${my_uploads[i]}/${my_files[j]}"
    if [ "$my_strip" -eq "0" ]; then
      cp ${from_dir}/${my_uploads[i]}/${my_files[j]} /tmp/RDLP
# if you feel very safe you can comment out the next line and uncomment the next two to remove the original files
      mv /tmp/RDLP ${to_dir}/${my_uploads[i]}/RDLP-${my_files[j]}
#      rm ${from_dir}/${my_uploads[i]}/${my_files[j]}
#      mv /tmp/RDLP ${to_dir}/${my_uploads[i]}/${my_files[j]}
    else
      sed '/M117 INDICATOR-Layer/d' ${from_dir}/${my_uploads[i]}/${my_files[j]} > /tmp/RDLP
# if you feel very safe you can comment out the next line and uncomment the next two to remove the original files
      mv /tmp/RDLP ${to_dir}/${my_uploads[i]}/RDLP-${my_files[j]}
#      rm ${from_dir}/${my_uploads[i]}/${my_files[j]}
#      mv /tmp/RDLP ${to_dir}/${my_uploads[i]}/${my_files[j]}
    fi
    # echo `uptime`
    sleep $my_delay
  done

done

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
  echo "Stripping DLP mods"echo "Replicating Uploads directory structure to Watched directory"
# this rebuilds the upload directory structure in the watched folder
find . -type d -exec mkdir -p -- /home/pi/.octoprint/watched/{} \;

echo "Done!"
echo "Working on $from_dir"

# gets all the directories under the current directory
mapfile -t my_uploads < <(find . -type d)

for (( i=0; i<${#my_uploads[@]}; i++ )); do
  echo ${my_uploads[i]}
  cd "${from_dir}/${my_uploads[i]}"
  # get files in current directory
  mapfile -t my_files < <(ls -p1 | grep -v /)
  for (( j=0; j<${#my_files[@]}; j++ )); do
    echo "${from_dir}/${my_uploads[i]}/${my_files[j]}"
    if [ "$my_strip" -eq "0" ]; then
      cp ${from_dir}/${my_uploads[i]}/${my_files[j]} /tmp/RDLP
# if you feel very safe you can comment out the next line and uncomment the next two to remove the original files
      mv /tmp/RDLP ${to_dir}/${my_uploads[i]}/RDLP-${my_files[j]}
#      rm ${from_dir}/${my_uploads[i]}/${my_files[j]}
#      mv /tmp/RDLP ${to_dir}/${my_uploads[i]}/${my_files[j]}
    else
      sed '/M117 INDICATOR-Layer/d' ${from_dir}/${my_uploads[i]}/${my_files[j]} > /tmp/RDLP
# if you feel very safe you can comment out the next line and uncomment the next two to remove the original files
      mv /tmp/RDLP ${to_dir}/${my_uploads[i]}/RDLP-${my_files[j]}
#      rm ${from_dir}/${my_uploads[i]}/${my_files[j]}
#      mv /tmp/RDLP ${to_dir}/${my_uploads[i]}/${my_files[j]}
    fi
    # echo `uptime`
    sleep $my_delay
  done

done

fi
if [ "$my_delay" -eq "0" ]; then
  echo "No delay - may the RPi gods forgive you"
else
  echo "Delaying $my_delay between files"
fi
echo ""

read -p "Are you sure? " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
fi

echo "Kool! Here we go!"

cd uploads/

echo "Replicating Uploads directory structure to Watched directory"
# this rebuilds the upload directory structure in the watched folder
find . -type d -exec mkdir -p -- /home/pi/.octoprint/watched/{} \;

echo "Done!"
echo "Working on $from_dir"

# gets all the directories under the current directory
mapfile -t my_uploads < <(find . -type d)

for (( i=0; i<${#my_uploads[@]}; i++ )); do
  echo ${my_uploads[i]}
  cd "${from_dir}/${my_uploads[i]}"
  # get files in current directory
  mapfile -t my_files < <(ls -p1 | grep -v /)
  for (( j=0; j<${#my_files[@]}; j++ )); do
    echo "${from_dir}/${my_uploads[i]}/${my_files[j]}"
    if [ "$my_strip" -eq "0" ]; then
      cp ${from_dir}/${my_uploads[i]}/${my_files[j]} /tmp/RDLP
# if you feel very safe you can comment out the next line and uncomment the next two to remove the original files
      mv /tmp/RDLP ${to_dir}/${my_uploads[i]}/RDLP-${my_files[j]}
#      rm ${from_dir}/${my_uploads[i]}/${my_files[j]}
#      mv /tmp/RDLP ${to_dir}/${my_uploads[i]}/${my_files[j]}
    else
      sed '/M117 INDICATOR-Layer/d' ${from_dir}/${my_uploads[i]}/${my_files[j]} > /tmp/RDLP
# if you feel very safe you can comment out the next line and uncomment the next two to remove the original files
      mv /tmp/RDLP ${to_dir}/${my_uploads[i]}/RDLP-${my_files[j]}
#      rm ${from_dir}/${my_uploads[i]}/${my_files[j]}
#      mv /tmp/RDLP ${to_dir}/${my_uploads[i]}/${my_files[j]}
    fi
    # echo `uptime`
    sleep $my_delay
  done

done
