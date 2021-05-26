#!/bin/bash

# for PHP website deploy
# SSH登録は反映までに５分程度必要なので、同期が失敗してもrebuildすれば次回は成功するはず

before_sync(){

  # ==================================
  # SSH registration to Coresever
  # This file must be saved by UTF-8
  # src: http://mo.kerosoft.com/0119
  echo ''
  log '- SSH Registration'
  MYIP=`wget -q -O - http://dyn.value-domain.com/cgi-bin/dyn.fcg?ip`
  log "- SSH Registration -> My IP: $MYIP"
  RET=`wget -q -O - --post-data="id=$DEP_USER&pass=$DEP_PASSWORD&remote_host=$MYIP&ssh2=SSH登録" "https://ss1.coressl.jp/$DEP_HOST/jp/admin.cgi?telnet=1" | iconv -f cp932 -t utf-8`
  if [ `log "$RET" | egrep "データベースに追加しました"` ] ; then
    log '- SSH Registration -> Registration Successful.'
  else
    log '- SSH Registration -> Registation Failed.'
  fi
  # ==================================

  # extension of backup files which are created before replacement
  ext=".temp_bakup"

  # remove "DEP_XXX_RM "
  find . -name "*.htaccess" -exec sed -i$ext "s|#DEP_REMOTE_RM ||" {} \;
  find . -name "*.htaccess" -exec sed -i$ext "s|#DEP_${DRONE_BRANCH^^}_RM ||" {} \;
  find . -name "*robots.txt" -exec sed -i$ext "s|#DEP_REMOTE_RM ||" {} \;
  find . -name "*robots.txt" -exec sed -i$ext "s|#DEP_${DRONE_BRANCH^^}_RM ||" {} \;
  find . -name "*.php" -exec sed -i$ext "s|//DEP_REMOTE_RM ||" {} \;
  find . -name "*.php" -exec sed -i$ext "s|//DEP_${DRONE_BRANCH^^}_RM ||" {} \;

  # delete backup files
  find . -name "*$ext" -exec rm {} \;

  return
}
