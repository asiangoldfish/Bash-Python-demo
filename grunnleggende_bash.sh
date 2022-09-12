#!/usr/bin/bash

##############################################################################
############# Dette er en liten demo om skripting med Bash. ##################
##############################################################################

## Formater på kommentarer:
## '#' er en kommentar og kort forklarer hva de neste linjene gjør
## '##' beskriver prinsipper eller begreper

## Datatyper- Akkurat som med Python, vil Bash automatisk identifisere
## hvilke datatyper du bruker

hund='Milo'         # string
alder=3             # int
vekt=2.5            # float
initialer='M'       # char

# Skriv ut variablene vi har deklarert
echo "Disse variablene har nå blitt deklarerte:"    # Singel-line
                                                    # Multi-line i linjen
                                                    # under
echo """Hundens navn: '$hund'
Alder: $alder
Vekt: $vekt
Intialer: $initialer
"""

## Strenger:
## Det er to uliker måte å skrive strenger på:
##     - 'Milo er fin':       Denne strengen vil bli tolket akkurat slik som
##                            den er, ikke mer eller mindre
##     - "Milo er $adjektiv": Denne strengen (merk: "") lar deg bruke variabler
##                            og "string substitutions"

function hund() {
    ## Dette er en funksjon. Den trenger ikke å starte med "function", men for
    ## leselighetsskyld er det lurt å gjøre det.
    ## Terminologi:
    ##      - local: Lokale variabler eksisterer kun i denne funksjonen
    
    ## Alle funksjoner har parametere. Disse lar deg innhente data og
    ## opplysninger fra den som påkaller funksjonen. I dette eksempelet
    ## ønsker vi å ha en generell funksjon for en hund, med mulighet for å
    ## lage flere hunder. Da kan vi gi hver av dem individuelle egenskaper.

    ## I bash tar alle funksjoner navngitte argumenter. Det betyr at
    ## rekkefølgen i opplysninger gitt, telles. Hvert argument blir lagret
    ## i egne variabler: $1, $2, osv... Nummeret er argumentets plassering.
    local hund_navn="$1"         # Første argument
    local hund_alder="$2"        # Andre argument
    local hund_vekt="$3"         # Tredje argument

    # Print ut detaljer om denne hunden
    echo """Dette er en funksjon som heter hund. Her er litt om hunden:
Navn: $hund_navn
Alder: $hund_alder
Vekt: $hund_vekt
"""
}

# Påkall noen hund-funksjoner med forskjellige egenskaper
echo -n "Funksjon 1: "      # '-n' vil forhindre ny linje
hund "Milo" 2 3

echo -n "Funksjon 2: "
hund "Chica" 10 29





