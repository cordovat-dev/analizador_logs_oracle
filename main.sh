#!/bin/bash

LOG="$1"
LISTAORA=`mktemp`
LISTAOMITIR=`mktemp`
TEMPORAL=`mktemp`
TOTAL=0

if [ -n "`which oerr`" ] && [ "$2" != "-m" ];then
	OERR=1
	ENCABEZADO="ERROR		CANT	DS_ERR"
else
	OERR=0
	ENCABEZADO="ERROR		CANT	MUESTRA"
fi

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
			if [ $OERR -eq 1 ];then
				NERR=`echo $linea|cut -d "-" -f 2`
				DESC=`oerr ora $NERR|head -n 1|cut -d "," -f 3|sed 's/^ //g'`
			else
				DESC=`grep $linea "$2"|head -1|cut -d: -f 2|sed 's/^ //g'|xargs -0`
			fi
			echo "$linea	$CONT	$DESC"
		fi
	done
}

#generar_lista_omitir
generar_lista_ora "$LOG" "$LISTAORA"
echo $LOG
echo
resumen "$LISTAORA" "$LOG" > "$TEMPORAL"
echo "$ENCABEZADO"
echo "==================================="
sort -k2 -nr "$TEMPORAL"
echo	
echo "Total:		$TOTAL"
echo
rm "$LISTAORA" "$LISTAOMITIR" "$TEMPORAL"

