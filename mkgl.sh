#!/bin/bash

set -Ceu

function echo_var(){
  for _n in $(seq 1 "${1}")  ; do
    echo "var x_${_n} <>= ;"
  done
  echo
  return 0
}

function echo_objective_func(){
  echo "maximize MAX: "
  echo "minimize MIN: "
  echo_vars "${1}"
  echo
  return 0
}

function echo_vars(){
  for _n in $(seq 1 "${1}")  ; do
    [ ${_n} -eq 1 ] || echo -n '+ '
    echo -n "x_${_n} *"
    [ ${_n} -eq ${1} ] || echo
  done
  echo ' ;'
}

function echo_constraint(){
  for _st in $(seq 1 "${1}")  ; do
    echo -n "s.t. CONSTRAINT${_st}: "
    echo_vars "${2}"
    echo
  done
  return 0
}

function echo_sample(){
  echo '---sample---'
  echo 'maximize MAX: x_1 * 100 + x_2 * 150 ;'
  echo 's.t. CONSTR1: x_1 *   2 + x_2 *   1 <= 100;'
  return 0
}

function echo_end(){
  echo 'end;'
  echo
  return 0
}

function make_mod(){
  local _num_of_constraint _num_of_var
  _num_of_constraint="${1}"
  _num_of_var="${2}"
  echo_var "${_num_of_var}"
  echo_objective_func "${_num_of_var}"
  echo_constraint "${_num_of_constraint}" "${_num_of_var}"
  echo_end
  echo_sample
  return 0
}

function calc_and_show(){
  local _name
  _name="${1}"
  glpsol -m "${_name}.mod"  -o "${_name}.out" --nopresol
  echo '-----------------------------------------------result-----------------------------------------------'
  cat "${_name}.out"
  return 0
}

case ${3:- } in
  ' ')
    make_mod "$1" "$2" ;;
  *)
    make_mod "$1" "$2" > "$3.mod" ;
    vim "$3.mod"
    calc_and_show "$3" ;
    ;;
esac 

#-----------------------------------------------------------------------------------------

#### 使用法
# command 制約の数(int) 変数の数(int) [ファイル名(string,拡張子なし)]
# command 7 3       # 単にテンプレートを標準出力します
# command 7 3 hoge  # テンプレートを書き出してvimを立ち上げ、編集終了後に計算と結果表示を行います

#### 例
# command 3 4
# 制約条件: [1]摂取カロリーは1000kcal以上、[2]食事時間は90分まで、[3]予算は3000円です。 ⇢ 3
# 変数: [1]タン、[2]ロース、[3]ハラミ、[4]カルビをそれぞれ何枚頼めば... ⇢ 4

