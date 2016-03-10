#!/bin/bash

LOG="$1"
LISTAORA=`mktemp`
LISTAOMITIR=`mktemp`
TEMPORAL=`mktemp`
TOTAL=0

function generar_lista_omitir {
	echo "ORA-00001" >> "$LISTAOMITIR"
	
}

function generar_lista_ora {
	egrep -o "^ORA-[0-9]*" "$1"|sort -u > "$2"
}

function resumen {
	for linea in `cat "$1"`; do
		if [ -z "`grep $linea \"$LISTAOMITIR\"`" ]; then
			CONT=`grep -c $linea "$2"`
			TOTAL=$[ $TOTAL + $CONT ]
			DESC=`grep $linea "$2"|head -1|cut -d: -f 2|xargs -0`
			echo "$linea	$CONT	$DESC"
		fi
	done
}

#generar_lista_omitir
generar_lista_ora "$LOG" "$LISTAORA"
echo $LOG
echo
resumen "$LISTAORA" "$LOG" > "$TEMPORAL"
echo "ERROR		CANT	MUESTRA"
echo "==================================="
sort -k2 -nr "$TEMPORAL"
echo	
echo "Total:		$TOTAL"
echo
rm "$LISTAORA" "$LISTAOMITIR" "$TEMPORAL"
