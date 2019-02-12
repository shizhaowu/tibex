# 
# Sed script file to insert glue for TibeX
#

# remove spaces follwing shad and backfoot
#s/།། \+/།།/g
#s/\([ཀགཤ]\)། \+/\1།/g
s/།། \+/།།\\ss /g
s/\([ཀགཤ]\)། \+/\1།\\ss /g
s/༔ \+/༔\\ss /g
#s/\([ཀགཤ]ོ\)། \+/\1\\nb\\ss།/g #because XeTeX cannot handle backfoot with o so far
s/\([ཀགཤ]ོ\)། \+/\1\\nb །\\ss /g #because XeTeX cannot handle backfoot with o so far

# remove spaces between shad and backfoot
s/\([ཀགཤ]\) \+།/\1།/g
s/\([ཀགཤ]\) \+\([^།]\)/\1\\ss \2/g
s/\([ཀགཤ]ོ\) \+\([^།]\)/\1\\ss \2/g
s/\([ཀགཤ]ོ\) *།/\1\\nb\\ss།/g #because XeTeX cannot handle backfoot with o so far
s/། \+།/།།/g
s/\([^ཀགཤ]\)། \+\([^།]\)/\1།\\ss \2/g
s/\([^ཀགཤ]ོ\)། \+\([^།]\)/\1།\\ss \2/g

