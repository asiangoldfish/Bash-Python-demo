#!/usr/bin/bash
## Linjen over sier noe om hvilket program dette skriptet kjører med. Denne
## filbanen eksisterer i systemet ditt. For å verifisere dette, bruk følgende
## kommando:
## ls /usr/bin | grep "bash"
## Hvis du får "bash" som resultat, så vet du at denne shebangen vil fungere.

##############################################################################
############################ I/O Kommandoer ##################################
##############################################################################

## Her er noen kommandoer for filbehandling (unngå mellomrom i filnavn):
## - cat
##      -> Lese innhold i filer
##      -> Eksempel: cat app.py readDatabase.sh
## - touch
##      -> Lage nye filer
##      -> Eksempel: touch diary.txt /usr/share/run_server.py
## - mkdir
##      -> Lage ny mappe i en gitt filbane
## - cp
##      -> Kopiere fil, mappe eller innhold i mapper
##      -> Eksempler:
##          * Kopiere fil: cp app.py ~/Documents/server/app.py
##          * Kopiere mappe og dens innhold: cp -r minMappe ~/minMappe
##          * Kopiere kun mappens innhold: cp -r minMappe/* ~/nyMappe

##############################################################################
############################ Sub-shell #######################################
##############################################################################

# En sub-shell er en ny instans av et shell. I vårt tilfelle betyr det blir
# laget en ny og uavhengig prosess av Bash. Dette gjør at vi kan utføre noen
# operasjoner i dette sub-shellet, få noen output og bruke dem videre i
# hovedprogrammet vårt. Det er flere måter å starte en ny sub-shell på, men
# en av de vanligste metodene er å lagre det i en variabel. Eksempel:
#
# alle_prosesser="$(ps ax)"
#
# "ps ax" vil printe ut alle kjørende prosesser i systemet og lagre dette i
# variabelen "alle_prosesser".

##############################################################################
################################ Demo ########################################
##############################################################################

# Printe ut alle kjørende prosesser
alle_prosesser="$(ps ax)"

# Lagre resultatet i alle_prosesser i en ny fil
prosess_fil="prosesser.txt"
echo "$alle_prosesser" > "$prosess_fil"

# Vi kan legge til nye linjer i denne filen med >> operatoren
echo "Dette er slutten av filen." >> $prosess_fil

echo "######################################################################"
echo 
echo "Du kan åpne og se innholdet prosess-filen med følgende kommando:"
echo "cat $prosess_fil"
echo
echo "######################################################################"

# Hvis du bruker kommandoen "ls", kan du se at skriptet har faktisk laget en
# ny fil som heter "prosesser.txt"

# Fjerne '#' foran linjen nedenfor for å fjerne prosesser.txt
# rm "$prosess_fil"

##############################################################################
########################## Integrere Python ##################################
##############################################################################

## De aller fleste Python-prosjekter bruker eksterne biblioteker, gjerne
## in-house eller gjennom Pip. Disse avhengighetene har ofte ulike verjsoner
## fra prosjekt til prosjekt, og fra prosjekt til datasystemet. Derfor er det
## veldig nyttig å isolere Python-prosjekter fra hverandre ved hjelp av
## virtuelle miljøer.
##
## Et virtuelt miljø er often en sub-shell som er tilpasset et formål. Med
## Python er det oftest for å sørge for at Python-prosjektets avhengigheter
## bruker riktige versjonnummer.

# Først lager vi en array med kommandoer som kreves for å jobbe med Python
python_avhengigheter=(
    "python3"
    "pip3"
    "python2"
)

echo ""                             # Skiller Python-utskrifter fra forrige
                                    # demo

# Deretter itererer vi gjennom hvert element av array-en og sjekker at de er
# gyldige. Måten vi bruker array-en som en variabel er slik:
# "${python_avhengigheter[@]}"

echo "Sjekker om Python-relaterte kommandoer er tilgjengelige..."

for element in "${python_avhengigheter[@]}"; do
    # Sjekk om elementet finnes. ">> /dev/null" sørger for å ikke printe
    # resultatet av kommandoen til skjermen
    echo -n "$element... "
    command -v "$element" >> /dev/null
    
    # Hvis kommandoen er ugyldig, så gir vi beskjed om dette på terminalen
    # med navnet på kommandoen
    if [ "$?" == 1 ]; then          # $? er variabelen til den forrige
                                    # kommando sin exit code
        echo -ne "\t\tMislyktes\n"
        echo "Feilmelding: '$element' er en ugyldig kommando"
        exit                        # Denne kommandoen avslutter skriptet
    else
        echo -ne "\t\t\t\tOK\n"
    fi
done

# Hvis alle kommandoene er gyldige, fortsetter vi med å lage et nytt miljø...
echo -ne "\nGenerer eksempel-miljø..."
python3 -m venv ./venv
echo -e "\t\tOK"

# så aktiverer vi dette miljøet
source ./venv/bin/activate

## Nå befinner vi oss i et nytt miljø for python3. Alle biblioteker installert
## med pip er separert fra resten av datasystemet og alle andre
## Python-prosjekt

# Deaktivér miljøet og slett mappen
deactivate; rm -rf ./venv

echo

## Vi kan åpne nye Python-filer i egne miljøer og lagre deres output i egne
## variabler. Først lager vi python-filene med dette skriptet, bare for å
## illustrere hvordan lage en ny fil fra et skript

# Python3
python3_filnavn='ny_python3.py'

if [ ! -f "$python3_filnavn" ]; then    # Lag en ny Python3-skript hvis den
                                        # ikke eksisterer allerede
    touch "$python3_filnavn"
fi

echo """#!/usr/bin/python3

python_versjon = 3
print(f'Dette er en skript fra Python versjon {python_versjon}')
""" > "$python3_filnavn"

# Python2
python2_filnavn='ny_python2.py'
if [ ! -f "$python2_filnavn" ]; then    # Lag en ny Python2-skript hvis den
                                        # ikke eksisterer allerede
    touch "$python2_filnavn"
fi

echo """#!/usr/bin/python2

python_versjon = 2
print \"Dette er en skript fra Python versjon\", python_versjon
""" > "$python2_filnavn"

## Nå kan vi lage egne miljøer for begge Python-versjonene. Vi kan også
## installere pakker for dene ene versjonen uten å påvirke den andre
## versjoner. Vær obs på at dette kan virke annerledes med miljøer som conda

# Lager miljø for Python3 og installerer pakker for den
echo -n -e "Lager nytt Python3 miljø...\t\t"
python -m venv python3_venv         # Generere mappen for miljøet
echo 'OK'

source python3_venv/bin/activate    # Aktivere miljøet

echo -ne "Installerer numpy...\t\t\t"
pip install numpy &> /dev/null      # Installere en ny pakke i miljøet
echo 'OK'

## Vi lagrer outputtet til ny_python3.py og ny_python2.py i egne variabler
## og deretter printer dem ut til terminalen
##
## Obs! Når vi forlater $(), så avsluttes sub-shellet automatisk

python3_output="$(python3 "ny_python3.py")"
deactivate                          # Deaktiverer slik at vi kan kjøre python2
                                    # skriptet utenfor python3-miljøet

python2_output="$(python2 "ny_python2.py")"


# Til slutt printer vi ut resultatet av python-skriptene til terminalen og
# sletter filene deretter

echo
echo "Resultatet av Python3-skriptet:"
echo "$python3_output"
echo
echo "Resultatet av Python2-skriptet:"
echo "$python2_output"

# Fjerne '#' fra linjen under for å slette auto-genererte filer
rm -rf 'prosesser.txt' "$python3_filnavn" "$python2_filnavn" 'python3_venv'

