/*
  为XeTeX增加藏文处理功能
    * 自动处理藏文靠近每行开头的垂宝符号, 垂宝符前的字符数目由参数
      \RinChenShadLetters来指定(目前还不支持在一个长脚字母的时候自动多插入
      一个垂宝符的功能)
    * 自动每隔一定的行数嵌入云头符, 行数由参数\TibPageLines来指定
      插入的云头符用命令\setbox\pghdr=\hbox{...}来指定

  To do list:

    * 加入对RinChinShadLetters=1的情况的特殊处理：当一行藏文字符的最开始
      一个字符是长脚字的时候，在该字符之后的空白长度大于或者等于阈值
      SentenceSkip的时候，需要在该字符之后如外添加一个垂宝符
      (为了获得空白的长度信息，需要修改枚举过程，返回空白glue/kern)
*/

@x {1717}
wterm(version_string);
@y
wterm('T');
wterm(version_string);
@z

@x
@d eTeX_state_code=etex_int_base+13 {\eTeX\ state variables}
@y
@d RinChenShadLetters_code=etex_int_base+13 { # of letter before RinChenShad }
@d TibPageLines_code=etex_int_base+14 { The # of lines in a long Tibetan book page }
@d TibHeaderBox_code=etex_int_base+15 { The # of box register hold the Tibetan page header }
@d eTeX_state_code=etex_int_base+16 {\eTeX\ state variables}
@z

@x
@d XeTeX_linebreak_penalty==int_par(XeTeX_linebreak_penalty_code)
@y
@d XeTeX_linebreak_penalty==int_par(XeTeX_linebreak_penalty_code)
@d RinChenShadLetters==int_par(RinChenShadLetters_code)
@d TibPageLines==int_par(TibPageLines_code)
@d TibHeaderBox==int_par(TibHeaderBox_code)
@z

@x
XeTeX_linebreak_penalty_code:print_esc("XeTeXlinebreakpenalty");
@y
XeTeX_linebreak_penalty_code:print_esc("XeTeXlinebreakpenalty");
RinChenShadLetters_code:print_esc("RinChenShadLetters");
TibPageLines_code:print_esc("TibPageLines");
TibHeaderBox_code:print_esc("TibHeaderBox");
@z

@x
primitive("XeTeXlinebreakpenalty",assign_int,int_base+XeTeX_linebreak_penalty_code);@/
@!@:XeTeX_linebreak_penalty_}{\.{\\XeTeXlinebreakpenalty} primitive@>
@y
primitive("XeTeXlinebreakpenalty",assign_int,int_base+XeTeX_linebreak_penalty_code);@/
@!@:XeTeX_linebreak_penalty_}{\.{\\XeTeXlinebreakpenalty} primitive@>
primitive("RinChenShadLetters",assign_int,int_base+RinChenShadLetters_code);@/
@!@:RinChenShadLetters_}{\.{\\RinChenShadLetters} primitive@>
primitive("TibPageLines",assign_int,int_base+TibPageLines_code);@/
@!@:TibPageLines_}{\.{\\TibPageLines} primitive@>
primitive("TibHeaderBox",assign_int,int_base+TibHeaderBox_code);@/
@!@:TibHeaderBox_}{\.{\\TibHeaderBox} primitive@>
@z

@x {5720}
del_code("."):=0; {this null delimiter is used in error recovery}
@y
del_code("."):=0; {this null delimiter is used in error recovery}
RinChenShadLetters:=0;
TibPageLines:=0;
TibHeaderBox:=-1;
@z

@x {11788}
wlog(version_string);
@y
wlog('T');
wlog(version_string);
@z

@x {19141}
  else line_width:=mem[par_shape_ptr+2*l@,].sc;
  end
@y
  else line_width:=mem[par_shape_ptr+2*l@,].sc;
  end;

  if (TibPageLines>0) and ((lines_broken+l) mod (2*TibPageLines) = 1) then
  begin
  {	   print("l.");print_int(l);print(": "); }
      line_width:=line_width-width(box(TibHeaderBox));
  {    print_ln; print("line_width="); print_scaled(line_width); print_ln; }
  end
@z

@x {19674}
procedure post_line_break(@!d:boolean);
label done,done1;
var q,@!r,@!s:pointer; {temporary registers for list manipulation}
@y
@<Declare subprocedures for |tibetan_rinchenshad_proc|@>
@<Debugging subroutine for tibetan_rinchenshad_proc@>
@<tibetan_rinchenshad_proc() implementation@>
procedure post_line_break(@!d:boolean);
label done,done1;
var q,@!r,@!s:pointer; {temporary registers for list manipulation}
i:integer;
@z

@x
@:this can't happen line breaking}{\quad line breaking@>
prev_graf:=best_line-1;
@y
@:this can't happen line breaking}{\quad line breaking@>
prev_graf:=best_line-1;
if TibPageLines>0 then lines_broken:=lines_broken+prev_graf;
@z

@x
if left_skip<>zero_glue then
@y
if RinChenShadLetters>0 then tibetan_rinchenshad_proc(q);
@<Insert dBu Khyud if this line is the first in a odd page@>;
if left_skip<>zero_glue then
@z

@x {20077}
@ Now |q| points to the hlist that represents the current line of the
@y
@
  The variable to remember that how many lines has been line_broken before
this paragraph, Since last \\TibPageLines has been set.

@<Glob...@>=
@!lines_broken : integer;

@ The line break algorithm of TeX is very diffcult, if not impossible, to be
adapted to insert the dBu Khyud automatically for arbitrary odd pages, so we
take a alternative method -- assumming that most pages have the same number
of lines, which is true for almost all of the Tibetan long books. We leave
the pages that do not have fixed number of lines to the user.
we insert dBu Khyud at the beginning of every line after a number of lines
that fills a page, hoping TeX will break pages at the point we desired.

@<Insert dBu Khyud if this line is the first in a odd page@>=
if (TibPageLines>0) and 
   ((lines_broken + cur_line) mod (2*TibPageLines) = 1) then
begin
{   print("l.");print_int(cur_line);print(":@@@@|| "); }
    r:=copy_node_list(box(TibHeaderBox));
    link(r):=q; q:=r;
end;

@

@d understanded_node(#)==((type(#) = glue_node) or (type(#) = penalty_node) or
                          (type(#) = kern_node) or (type(#) = disc_node))

@<Declare subprocedures for |tibetan_rinchenshad_proc|@>=
function is_tib_1stletter(c : integer) : boolean;
begin
  is_tib_1stletter := (@"F40 <= c) and (c <= @"F6D);
end;

function is_tib_following(c : integer) : boolean;
begin
  is_tib_following := (@"F70 < c) and (c <= @"FBF);
end;

function is_tib_bkfoot(c1, c2 : integer) : boolean;
var
  c1_valid : boolean;
  c2_valid : boolean;
begin
  c1_valid := (c1 = @"F40) or (c1 = @"F42) or (c1 = @"F64);
  c2_valid := (c2 = @"F7C) or (c2 = 0);
  is_tib_bkfoot := c1_valid and c2_valid;
end;

function is_tib_tsheg(c : integer) : boolean;
begin
  is_tib_tsheg := (c = @"F0B);
end;

function is_tib_shad(c : integer) : boolean;
begin
  is_tib_shad := (c = @"F0D);
end;

function is_tib_dblshad(c : integer) : boolean;
begin
  is_tib_dblshad := (c = @"F0E);
end;

{ Advance (p,i) in the list, so that (p,i) points to the next Tibetan stack }
function next_stack(var p : pointer; var i : integer) : boolean;
label done;
var
  decided : boolean;
  j : integer;
  c : integer;
begin
  next_stack:=false;
  if is_char_node(p) then
      goto done;

  decided := false;
  j:=i+1;
  { Try to advance i in the node pointed by p }
  while not decided and (j < native_length(p)) do
  begin
      c := get_native_char(p,j);
      if is_tib_1stletter(c) then
        decided := true
      else
        j:=j+1;
  end;

  if decided then
    { found the next stack in the same node }
  begin
      i:=j;
      next_stack:=true;
  end
  else
    { if what c points to is the last stack in the node, advance p
      to the next native word node }
  begin
      p:=link(p);
      while (p<>null) and not is_native_node(p) do
      begin
          if not understanded_node(p) then
             goto done;
          p:=link(p);
      end;
      i:=0;
      if p<>null then
      begin
          next_stack:=true;
      end;
  end;
done:
end;

{ Count the length(in native chars) of the stack beginning at (p,c) }
function stack_len(p:pointer; i:integer) : integer;
var
  decided : boolean;
  j : integer;
  c : integer;
begin
  decided := false;
  j:=i+1;
  while not decided and (j < native_length(p)) do
  begin
    c := get_native_char(p,j);
    if not is_tib_1stletter(c) then
      j:=j+1
    else
      decided := true;
  end;

  stack_len := j-i;
end;

@ procedure set_rinchenshad(p:pointer; i:integer);
begin
    set_native_char(p, i, @"F11);
	set_native_metrics(p, XeTeX_use_glyph_metrics);
end;

Don't know why the former procedure definition cannot pass WEB2C compilation,
so I have to use macro for set_rinchenshad(p,i) instead.

@d set_rinchenshad(#)==begin set_native_char(p, i, @"F11);
set_native_metrics(p, XeTeX_use_glyph_metrics); end;
@d is_native_node(#)==((type(#) = whatsit_node) and (subtype(#) = native_word_node))

@ Tibetan scripts need special treatment for lines -- when a shad appears
near the beginning of a line, sometimes the shad should be replaced with
rin chin sbungs shad, depending on various conditions on which different
schools of Tibetan scholars have different point of view.

@<tibetan_rinchenshad_proc() implementation@>=
procedure tibetan_rinchenshad_proc(p : pointer);
label done;
var
    beginning_stacks : integer; { counter for beginning Tibetan stacks in a line }
    bk_foot : boolean; { does the last stack has back foot }
    i : integer; { used as (p,i) iterator }
    c1, c2 : integer;
    decided : boolean; 
begin
    @<Count the beginning Tibetan stacks, and remember 
       if the last one has back foot@>;
    @<Find the shad to be replaced@>;
    @<Replace up to two shads@>;
end;

@ Count the beginning Tibetan stacks before the 1st shad or tsheg in a line,
    if there are less than XeTeX_TibRinShadLetters letters, then it might be
    a proper place to convert the following Shad to Rin Chin sPungs Shad

@<Count the beginning Tibetan stacks...@>=

{print(".s"); print_ln;}
while not is_native_node(p) do
begin
    if not understanded_node(p) then
        goto done;
    p:=link(p);
    if (p=null) then
        goto done;
end;

beginning_stacks := 0;
decided := false;
i:=0; {We use (p,i) as the iterator through the list}

{print("..d"); print_ln;}
while (p > mem_min) and not decided do
begin
    { Here we only care about native_word_node used to hold Unicode chars }
    if is_native_node(p) then
    begin
        c1 := get_native_char(p, i);

        if is_tib_1stletter(c1) then
        { We met a first letter in a Tibetan stack, count it }
        begin
            beginning_stacks := beginning_stacks+1;

            { Remember if it is backfoot letter }
            if stack_len(p,i) > 1 then
                c2 := get_native_char(p, i+1)
            else
                c2 := 0;
            bk_foot := is_tib_bkfoot(c1, c2);
        end
        else if is_tib_following(c1) then
            { assuming backfoot chars only occurs in nodes that
              starts with tib_1stletter }
            bk_foot := false
        else if is_tib_tsheg(c1) or is_tib_shad(c1) then
            decided := true;
    end;

    if not decided then
        if not next_stack(p,i) then
            goto done;
end;

{print("   <");
print_int(beginning_stacks);
print_char(">"); }

@ After the first word, there may be either a tsheg or shad.
As of tsheg, if the next node is shad, then this is a good candidate to do
rin chen spungs shad replace.
As of shad, we've already found a good candidate to do rin chen spungs shad
replacement.

@<Find the shad to be replaced@>=
decided := false;

if is_tib_tsheg(c1) then
begin
    bk_foot := false;  { back foot letter doesn't matter after tsheg }

    { First skip to next native word node }
    if not next_stack(p,i) then
        goto done;

    { Now (p,i) must point to a native_word node }
    if not is_native_node(p) then
        print("Assertion failed after next_stack");

    c1 := get_native_char(p, i);
    if not is_tib_shad(c1) then
    begin
        {print("'");}
        goto done;
    end;
end
else if not is_tib_shad(c1) then
    goto done

@  If the previous tibetan word has back foot, we only replace
one shad.

@<Replace up to two shads@>=
if (1 <= beginning_stacks) and (beginning_stacks <= RinChenShadLetters) then
begin
    set_rinchenshad(p,i);
    {print_char("|");

    c1 := get_native_char(p, i);
    print_char("-");
    print_char(">");
    print_char(c1);
    print_char(" ");}

    { Skip to next native word node }
    if not next_stack(p,i) then
        goto done;

    c1 := get_native_char(p,i);
    if not is_tib_shad(c1) then
    begin
        {print_char("<");
        print_char(c1);
        print_char(">");}
        goto done;
    end;

    if not bk_foot then
    { if the previous tibetan word doesn't finished with backfoot letter,
         we continue replacing the 2nd Shad,
      if it does, we stop here after the previous Shad replacement }
    begin
        set_rinchenshad(p,i);
        {print_char("|");
        c1 := get_native_char(p, i);
        print_char("-");
        print_char(">");
        print_char(c1);}
    end
end;

done:
{print(" == ");
print_ln;}

@ @<Debugging subroutine for tibetan_rinchenshad_proc@>=
procedure print_line_list(p : pointer);
begin
  while p > mem_min do
  begin
    case type(p) of
      whatsit_node:
        begin
          print_char("[");
          case subtype(p) of
            native_word_node:begin
                print_native_word(p);
              end;
            glyph_node:begin
                print("glyph#");
                print_int(native_glyph(p));
              end;
            othercases print("whit");
          endcases;
          print_char("]");
        end;
      glue_node:
        if glue_ptr(p)<>zero_glue then print_char(" ");
      hlist_node:
        begin
          print("{hbox--");
          print_line_list(list_ptr(p));
          print("}");
        end;
      ins_node:
        print("{i}");
      mark_node:
        print("{m}");
      adjust_node:
        print("{a}");
      unset_node:
        print("{u}");
      rule_node: print_char("|");
      math_node: print_char("$");
      ligature_node: short_display(lig_ptr(p));

      othercases print_int(type(p));
    endcases;

    p := link(p);
  end;
end;

@ Now |q| points to the hlist that represents the current line of the
@z

@x
primitive("XeTeXlinebreaklocale", extension, XeTeX_linebreak_locale_extension_code);@/
@y
primitive("XeTeXlinebreaklocale", extension, XeTeX_linebreak_locale_extension_code);@/
primitive("TibPageLines", extension, TibPageLines_code);@/
@z

@x
  pdf_save_pos_node: print_esc("pdfsavepos");
@y
  pdf_save_pos_node: print_esc("pdfsavepos");
  TibPageLines_code: print_esc("TibPageLines");
@z

@x {28831}
XeTeX_linebreak_locale_extension_code:@<Implement \.{\\XeTeXlinebreaklocale}@>;
@y
XeTeX_linebreak_locale_extension_code:@<Implement \.{\\XeTeXlinebreaklocale}@>;
TibPageLines_code:@<Implement \.{\\TibPageLines}@>;
@z

@x
  else XeTeX_linebreak_locale:=cur_name; {we ignore the area and extension!}
end
@y
  else XeTeX_linebreak_locale:=cur_name; {we ignore the area and extension!}
end

@ @<Implement \.{\\TibPageLines}@>=
begin
  scan_optional_equals; scan_int;
  if cur_val<0 then
     TibPageLines:=0
  else
     TibPageLines:=cur_val;
  lines_broken:=0;	
end
@z
