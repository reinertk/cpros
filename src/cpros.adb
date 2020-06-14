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
-- 2020.06.14: Major upgrade (by Reinert Korsnes)
--------------------------------------------------------------------------------------

with split_string;      use split_string;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.IO_Exceptions;
with Ada.Exceptions;    use Ada.Exceptions;

package body cpros is

   procedure cpros0 (file1 : in File_Type; command_string : String := "") is
      term1 : constant Boolean := file1 in Ada.Text_IO.Standard_Input;

      function rep1 (str0 : String) return String is
         i1 : constant Natural := Index (str0, "$");
      begin
         if i1 > 0 then
            declare
               i2 : constant Positive := i1 + 1;
               k  : constant Positive := Positive'Value (str0 (i2 .. i2));
            begin
               return Head (str0, i1 - 1) &
                 word (command_string, k + 2) &
                 rep1 (Tail (str0, str0'Last - i2));
            end;
         else
            return str0;
         end if;
      end rep1;

   begin

      command_loop :
      loop
         if term1 then
            Put ("Enter command:");
         else
            exit command_loop when End_Of_File (file1);
         end if;
         declare
            str0 : constant String := rep1 (Get_Line (file1));
            str1 : constant String := expand1 (remove_comment1 (str0), "&");

            type aux_commands1_t is (c_do, c_repeat, c_exit, c_none);
            function aux_command1 (s : String) return aux_commands1_t is
            begin
               return aux_commands1_t'Value ("C_" & s);
            exception
               when others =>
                  return c_none;
            end aux_command1;
            acom1 : constant aux_commands1_t :=
              aux_command1 (first_word (str1));
         begin
            if not term1 then
               Put_Line (str0);
            end if;

            if number_of_words (str1) > 0 then
               exit command_loop when acom1 = c_exit;
               if acom1 in c_do | c_repeat then
                  do_loop :
                  loop
                     declare
                        cfile2 : constant String := word (str1, 2);
                        file2  : File_Type;
                     begin
                        Open (file2, In_File, cfile2);
                        cpros0 (file1 => file2, command_string => str1);
                        Close (File => file2);
                     exception
                        when event : Name_Error =>
                           New_Line;
                           Put_Line (Exception_Message (event));
                           New_Line;
                           raise cfe0;
                        when others =>
                           Close (File => file2);
                           raise cfe0;
                     end;
                     exit do_loop when acom1 /= c_repeat;
                  end loop do_loop;
               else
                  begin
                     cpros_main
                       (command => c_t'Value ("C_" & first_word (str1)),
                        str     => str1);
                  exception
                     when Constraint_Error =>
                        Put_Line (" * Unknown command: " & first_word (str1));
                        raise cfe0;
                     when event : cfe0 =>
                        New_Line;
                        Put_Line ("* Command format error *");
                        Put_Line (Exception_Message (event));
                        raise;
                     when event : others =>
                        New_Line;
                        Put_Line ("* Strange error i cpros *");
                        Put_Line (Exception_Message (event));
                        raise cfe0;
                  end;
               end if;
            end if;
         exception
            when cfe0 =>
               if not term1 then
                  raise;
               end if;
            when event : others =>
               Put_Line (" ** Error in cpros (1): ");
               Put_Line (Exception_Message (event));
               raise;
         end;
      end loop command_loop;
      return;
   exception
      when Ada.IO_Exceptions.End_Error =>
         return;
      when cfe0 =>
         if not term1 then
            raise;
         end if;
      when event : others =>
         Put_Line (" ** Error in cpros (2): ");
         Put_Line (Exception_Message (event));
         if not term1 then
            raise;
         end if;
   end cpros0;

end cpros;
