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
-- test A
--------------------------------------------------------------------------------------

with Ada.Exceptions;
with Text_IO;       use Text_IO;
with Ada;
with Ada.Text_IO;
with cpros;
with split_string; 
with cpros_exceptions;
use  cpros_exceptions;

procedure cpros_test1 is

   use Ada.Exceptions;

-- list of commands (preceeded by "c_"):

   type c_t is (c_this, c_that);

-- (you are supposed to define your own version of the type "c_t" providing your actual commands.

procedure cpros_actual1(command : in c_t; command_string : in String) is 

-- command contains actual entered/input command word (converted to type c_t).   
-- command_string contains the the whole command line. 

    lw : constant String := split_string.last_word (command_string);
    nw : constant Natural := split_string.Number_Of_Words(command_string);
--  cfe : exception;

begin

   Put_Line("You did enter" & natural'image(nw) 
                            & " command component(s) (free for use). Last argument is """ 
                            & (if nw > 1 then lw else "") 
                            & """" ); 
   For i in 1..nw loop
       Put_Line(" Word number" & integer'image(i) & "  " & split_string.word (command_string, i));
   end loop;

   New_Line;
--
-- use:
-- raise cfe0 with "** message ** ";
-- to interrupt erroneous commands (according to below).
--
   case command is
     when c_this => Put_Line(" You ended up here (this)");
                    if nw > 5 then
                       raise cfe0 with "Wrong number of command words"; 
                    end if;
     when c_that => Put_Line(" You ended up here (that)");
   end case;
   return;
end cpros_actual1;

package cpros_package1 is new cpros (c_t => c_t, cpros_main => cpros_actual1);

begin

-- cprosa below calls cpros_actual1 (which substitutes formal procedure in the generic cpros_package1) 
-- for each input command line (from terminal or file). It passes to the procedure cpros_actual1 a command 
-- name (stored in the variable "command") and also the whole command stored in "command_string": 

cpros_package1.cprosa(file1 => Ada.Text_IO.Standard_Input);

exception
   when event : others =>
        Put_Line (" Error: " & Exception_Message (event));
        raise;

end cpros_test1;

