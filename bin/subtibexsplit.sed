#!/bin/sed -f
# Sed script file to insert glue for TibeX
#   由於要處理將།།不分開於分開的兩種排版風格，
#   因此用兩個不同的sed腳本，這個是處理爲།    །的風格
# remove spaces follwing double shad and backfoot
s/།། \+/།།/g
s/\([ཀགཤ]\)། \+/\1།/g
#s/།། \+/།།\\ss /g
s/\([ཀགཤ]\)། \+/\1།\\ss /g
# Do not know howto use XeTeX handle backfoot with o so far,
# so use sed substitution instead.
s/\([ཀགཤ]ོ\)། \+/\1\\nb །\\ss /g

# remove spaces between shad and backfoot
s/\([ཀག]\) \+།/\1།/g
s/\([ཀགཤ]\) \+\([^།]\)/\1\\ss \2/g
s/\([ཀགཤ]ོ\) \+\([^།]\)/\1\\ss \2/g
s/\([ཀགཤ]ོ\) *།/\1\\nb\\ss །\\bws /g #don't know howto set backfoot+ོ with XeTeX so far
s/། \+།/།།/g
s/\([^ཀགཤ]\)། \+\([^།]\)/\1།\\ss \2/g
s/\([^ཀགཤ]ོ\)། \+\([^།]\)/\1།\\ss \2/g

# only good for splited shads typesetting 
s/\([^།ཀགཤ] *།\)\([ཀ-ཨ]\)/\1\\ss \2/g
s/\([^ཀགཤ]ོ *།\)\([ཀ-ཨ]\)/\1།\\ss \2/g

s/༔ \+/༔\\ss /g
s/། \+$/།/g
s/\([^།ཀགཤ]\)།$/\1།\\ss /g

