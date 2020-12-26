#!/bin/sed -f
# Sed script file to insert glue for TibeX
#   the DO NOT split double shad version
#   由於要處理將།།不分開於分開的兩種排版風格，
#   因此用兩個不同的sed腳本，這個是處理爲།།的風格

s/། \+།/།།/g
# 處理跟།有關的行尾
s/། *+$/།\\ss /g
s/།། *+$/།།\\ss /g
s/\([^།ཀགཤ]\)།$/\1།\\ss /g
# replace spaces follwing double shad and backfoot with glue
s/།། \+/།།\\ss /g
s/\([ཀགཤ]\)། \+/\1།\\ss /g
#s/།། \+/།།\\ss /g
#s/\([ཀགཤ]\)། \+/\1།\\ss /g
# Do not know howto use XeTeX handle backfoot with o so far,
# so use sed substitution instead.
#s/\([ཀགཤ]ོ\)། \+/\1\\nb\\ss།/g 
s/\([ཀགཤ]ོ\)། \+/\1།\\ss /g

# remove spaces between shad and backfoot
s/\([ཀག]\) \+།/\1།/g
s/\([ཀགཤ]\) \+\([^།]\)/\1\\ss \2/g
#because XeTeX cannot handle backfoot with o so substitute
s/\([ཀགཤ]ོ\) \+\([^།]\)/\1\\ss \2/g
s/\([ཀགཤ]ོ\) *།/\1\\nb །\\ss /g 
s/\([^ཀགཤ]\)། \+\([^།]\)/\1།\\ss \2/g
s/\([^ཀགཤ]ོ\)། \+\([^།]\)/\1།\\ss \2/g

s/༔ \+/༔\\ss /g
s/། *$/།\\ss /g
