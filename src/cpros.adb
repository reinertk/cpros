with split_string;      use split_string;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
-- with Ada.Text_IO;
with Ada.Directories;         use Ada.Directories;
with Ada.IO_Exceptions;
with Ada.Exceptions;
with Ada.Characters.Handling; use Ada.Characters.Handling;
-- use Ada.Exceptions;

package body cpros is

   procedure cprosa (file1 : in File_Type; command_string : String := "") is
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

      function eq_command
        (s1, s2 : String) return Boolean is
        (To_Lower (Head (s1, s2'Length + 1)) = s2 & " ");

   begin

      command_loop :
      loop
         if term1 then
            Put ("Enter command:");
         else
            exit command_loop  when End_Of_File (file1);
         end if;
         declare
            str0 : constant String := rep1 (Get_Line (file1));
            str1 : constant String := expand1 (remove_comment1 (str0), "&");
         begin
            if not term1 then
               Put_Line (str0);
            end if;

            if number_of_words (str1) > 0 then
               exit command_loop when eq_command (str1, "exit");
               if eq_command (str1, "do") or eq_command (str1, "repeat") then
                  do_loop:
                  loop
                     declare
                        cfile2 : constant String := word (str1, 2);
                        file2  : File_Type;
                     begin
                        if not Exists (cfile2) then
                           raise cfe1 with " ** File not found: " & cfile2;
                        end if;
                        Open (file2, In_File, cfile2);
                        cprosa (file1 => file2, command_string => str1);
                        exit do_loop when eq_command(str1,"do") and not Is_Open (file2);
                        Close (File => file2);
                     exception
                        when event : cfe1 =>
                           New_Line;
                           Put_Line (Ada.Exceptions.Exception_Message (event));
                           if not term1 then
                              Close (file2);
                              raise;
                           end if;
                        when others =>
                           Close (file2);
                           raise;
                     end;
                     exit do_loop when not eq_command (str1, "repeat");
                  end loop do_loop;
               else
                  cpros_main (command => c_t'Value ("C_" & first_word(str1)), str => str1);
               end if;
            end if;
         exception
            when Constraint_Error =>
               if not term1 then
                  raise;
               end if;
               Put_Line (" *** Command format error (cpros) *** ");
            when event : cfe1 =>
               Put_Line (Ada.Exceptions.Exception_Message (event));
               if not term1 then
                  raise;
               end if;
            when event : others =>
               Put_Line (Ada.Exceptions.Exception_Message (event));
               raise;
         end;
      end loop command_loop;
      return;
exception
      when Ada.IO_Exceptions.End_Error =>
               Put_Line("Stop");
               return;
   end cprosa;

end cpros;
