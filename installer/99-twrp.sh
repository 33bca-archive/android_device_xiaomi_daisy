#!/sbin/sh
# 
# ADDOND_VERSION=2
# 
# /system/system/addon.d/99-twrp.sh
#
. /tmp/backuptool.functions

SYS=$S
BACKUPDIR=$C
MAGISKBOOT="$S/bin/magiskboot"

if [ "$(getprop ro.boot.slot_suffix)" = "_a" ] 
then
  BOOTIMAGEPATHCURRENT="/dev/block/bootdevice/by-name/boot_a"
  BOOTIMAGEPATHINACTIVE="/dev/block/bootdevice/by-name/boot_b"
else
  BOOTIMAGEPATHCURRENT="/dev/block/bootdevice/by-name/boot_b"
  BOOTIMAGEPATHINACTIVE="/dev/block/bootdevice/by-name/boot_a"
fi

list_files() {
cat <<EOF
bin/magiskboot
EOF
}

case "$1" in
  backup)
    list_files | while read -r FILE DUMMY; do
      backup_file "$S"/"$FILE"
    done
  ;;
  restore)
    list_files | while read -r FILE REPLACEMENT; do
      R=""
      [ -n "$REPLACEMENT" ] && R="$S/$REPLACEMENT"
      [ -f "$C/$S/$FILE" ] && restore_file "$S"/"$FILE" "$R"
    done
  ;;
  pre-backup)
    cd "$BACKUPDIR"
    dd if="$BOOTIMAGEPATHCURRENT" of="$BACKUPDIR/boot.img"
    "$MAGISKBOOT" --unpack "$BACKUPDIR/boot.img"
    mv -f "$BACKUPDIR/ramdisk.cpio" "$BACKUPDIR/ramdisk.cpio.backup"
    "$MAGISKBOOT" --cleanup
    rm "$BACKUPDIR/boot.img"
    cd "$CURRENTDIR"
  ;;
  post-backup)
    # Stub
  ;;
  pre-restore)
    # Stub
  ;;
  post-restore)
    cd "$BACKUPDIR"
    dd if="$BOOTIMAGEPATHINACTIVE" of="$BACKUPDIR/boot.img"
    "$MAGISKBOOT" --unpack "$BACKUPDIR/boot.img"
    mv -f "$BACKUPDIR/ramdisk.cpio.backup" "$BACKUPDIR/ramdisk.cpio"
    "$MAGISKBOOT" --repack "$BACKUPDIR/boot.img"
    dd if="$BACKUPDIR/new-boot.img" of="$BOOTIMAGEPATHINACTIVE"
    "$MAGISKBOOT" --cleanup
    rm "$BACKUPDIR/boot.img"
    rm "$BACKUPDIR/new-boot.img"
    cd "$CURRENTDIR"
  ;;
esac
