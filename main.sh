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

function contar {
	for linea in `cat "$1"`; do
		if [ -z `grep $linea "$LISTAOMITIR"` ]; then
			CONT=`grep $linea "$2"|wc -l`
			echo "$linea	$CONT"
		fi
	done
}

function resumen {
	for linea in `cat "$1"`; do
		if [ -z `grep $linea "$LISTAOMITIR"` ]; then
			DESC=`grep $linea "$2"|head -1`
			echo "$DESC"
		fi
	done	
}

#generar_lista_omitir
generar_lista_ora "$LOG" "$LISTAORA"
#cat "$LISTAORA"
contar "$LISTAORA" "$LOG"
resumen "$LISTAORA" "$LOG"

rm "$LISTAORA" "$LISTAOMITIR"
