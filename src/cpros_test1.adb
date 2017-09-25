--------------------------------------------------------------------------------------
--
--  Copyright (c) 2016 Reinert Korsnes

--  Permission is hereby granted, free of charge, to any person obtaining a
--  copy of this software and associated documentation files (the "Software"),
--  to deal in the Software without restriction, including without limitation
--  the rights to use, copy, modify, merge, publish, distribute, sublicense,
--  and/or sell copies of the Software, and to permit persons to whom the
--  Software is furnished to do so, subject to the following conditions:

--  The above copyright notice and this permission notice shall be included in
--  all copies or substantial portions of the Software.

--  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
--  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
--  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
--  DEALINGS IN THE SOFTWARE.
--
--  NB: this is the MIT License, as found 2016-09-27 on the site
--  http://www.opensource.org/licenses/mit-license.php
--------------------------------------------------------------------------------------
-- Change log:
--
--------------------------------------------------------------------------------------

with Text_IO;      use Text_IO;

with Ada;
with Ada.Text_IO;
with cpros;
with rsplit;         use rsplit;

procedure cpros_test1 is

type c_t is (c_exit, c_do, c_this, c_that);

procedure cpros_actual1(command : in c_t; str : in String) with
                        pre => command not in c_exit | c_do is

    lw : constant String := last_word (str);
    nw : constant Natural := Number_Of_Words(str);

begin

   Put_Line("You did enter" & natural'image(nw) & " command component(s) (free for use). Last argument is """ 
                              & (if nw > 1 then lw else "") & """" ); 
   For i in 1..nw loop
       Put_Line(" Word number" & integer'image(i) & "  " & word (str, i));
   end loop;

   New_Line;
   case command is
     when c_exit | c_do => null;
     when c_this => Put_Line(" You ended up here (this)");
     when c_that => Put_Line(" You ended up here (that)");
   end case;
end cpros_actual1;

package cpros_package1 is new cpros (c_t => c_t, cpros_main => cpros_actual1);

begin

cpros_package1.cprosa(file1 => Ada.Text_IO.Standard_Input);

end cpros_test1;
