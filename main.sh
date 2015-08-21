#!/bin/bash

LOG="$1"
LISTAORA=`mktemp`
LISTAOMITIR=`mktemp`

function generar_lista_omitir {
	echo ORA-00001 >> "$LISTAOMITIR"
	
}

function generar_lista_ora {
	egrep -o "^ORA-[0-9]*" "$1"|sort -u > "$2"
}

function resumen {
	for linea in `cat "$1"`; do
		if [ -z `grep $linea "$LISTAOMITIR"` ]; then
			CONT=`grep $linea "$2"|wc -l`
			DESC=`grep $linea "$2"|head -1|cut -d: -f 2|xargs -0`
			echo "$linea	$CONT	$DESC"
		fi
	done
}

#generar_lista_omitir
generar_lista_ora "$LOG" "$LISTAORA"
resumen "$LISTAORA" "$LOG"|sort -k2 -nr

rm "$LISTAORA" "$LISTAOMITIR"
