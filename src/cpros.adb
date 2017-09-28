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
---
--------------------------------------------------------------------------------------

with split_string;

with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.Text_IO;
with Ada.Directories; use Ada.Directories;

package body cpros is

   procedure cprosa (file1 : in File_Type; command_string : String := "") is
      command : c_t;
      term1   : constant Boolean := file1 in Ada.Text_IO.Standard_Input;
      file2   : File_Type;

      function rep1 (str0 : String) return String is
         i1 : constant Natural := Index (str0, "$");
         k  : Positive;
      begin
         if i1 > 0 then
            k := Positive'Value (str0 (i1 + 1 .. i1 + 1));
            return str0 (str0'First .. i1 - 1) &
              split_string.word (command_string, k + 2) &
              rep1 (str0 (i1 + 2 .. str0'Last));
         end if;
         return str0;
      end rep1;

   begin

      command_loop :
      loop
         if term1 then
            New_Line;
            Put ("Enter command:");
         end if;
         exit when End_Of_File (file1);
         declare
            str1 : constant String := rep1 (Get_Line (file1));
         begin
            if not term1 then
               Put_Line (str1);
            end if;
            if split_string.number_of_words (str1) > 0
              and then str1 (str1'First) /= '#'
            then
               declare
               begin
                 command := c_t'Value ("C_" & split_string.first_word (str1));
                 exception
                   when Constraint_Error => Put_Line(" * Comman format error * (Constraint_Error)");
                                            raise;
                   when others           => Put_Line(" * Strange error in cpros * ");
                                            raise;
               end;
               exit when command = c_t'Value ("C_Exit");
               if command = c_t'Value ("C_DO") then
                  New_Line;
                  declare
                    cfile2 : constant String := split_string.word (str1, 2);
                  begin
                     if not Exists (cfile2) then
                        Put_Line("  ** File not found: " & cfile2 & ".");
                     end if;
                     Open (file2, Text_IO.In_File, cfile2);
                     cprosa (file1 => file2, command_string => str1);
                     exit when not Is_Open (file2);
                     Close (File => file2);
                  end;
                  New_Line;
               else
                  cpros_main (command, str1);
               end if;
            end if;
            exception
               when others =>
                    if not term1 then
                       Close (file2);
                       return;
                    end if;
         end;
      end loop command_loop;

      return;

   end cprosa;

end cpros;
