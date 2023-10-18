#!/bin/bash

set -Ceu

function calc_and_show(){
  local _name
  _name="${1}"
  glpsol -m "${_name}.mod" -o "${_name}.out" --nopresol
  echo '-----------------------------------------------result-----------------------------------------------'
  cat "${_name}.out"
  return 0
}

calc_and_show "${1}"

#### 使用法
# command ファイル名 # ファイル名.modからファイル名.outを生成し、ファイル名.outをcatします。
