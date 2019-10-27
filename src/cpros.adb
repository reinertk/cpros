with split_string; use split_string;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.Text_IO;
with Ada.Directories; use Ada.Directories;
with Ada.IO_Exceptions;
with Ada.Exceptions; use Ada.Exceptions;

package body cpros is

   procedure cprosa (file1 : in File_Type; command_string : String := "") is
      command : c_t;
      term1   : constant Boolean := file1 in Ada.Text_IO.Standard_Input;

      function rep1 (str0 : String) return String is
         i1 : constant Natural := Index (str0, "$");
      begin
         if i1 > 0 then 
            declare
               i2 : constant Positive := i1 + 1;
               k  : constant Positive := Positive'Value (str0 (i2 .. i2)); 
            begin
               return Head(str0,i1 - 1) & Word(command_string,k+2) & rep1 (Tail(str0,str0'Last-i2));
            end;
         else
            return str0;
         end if;
      end rep1;

begin

    command_loop :
    loop
       declare
       begin
         if term1 then
            Put ("Enter command:");
         end if;
         declare
            str0 : constant String := rep1 (Get_Line (file1));
            str1 : constant String := Expand1(Remove_Comment1(str0),"&");
         begin
            if not term1 then
               Put_Line (str0);
            end if;

            if number_of_words (str1) > 0 then
               declare
               begin
                  command := c_t'Value ("C_" & first_word (str1));
               exception
                  when Constraint_Error => raise cfe1 with "** Command format error **";
               end;
               exit when command = c_t'Value ("C_Exit");
               if command = c_t'Value ("C_DO") then
                  declare
                    cfile2 : constant String := word (str1, 2);
                    file2  : File_Type;
                  begin
                    if not Exists (cfile2) then
                       raise cfe1 with " ** File not found: " & cfile2;
                    end if;
                    Open (file2, Text_IO.In_File, cfile2);
                    cprosa (file1 => file2, command_string => str1);
                    exit when not Is_Open (file2);
                    Close (File => file2);
                    exception
                       when Event : cfe1 => new_line; Put_Line (Exception_Message (Event)); 
                                            exit when not term1; 
                       when others       => Close(file2);
                                            raise;
                  end;
                  New_Line;
               else
                  cpros_main (command, str1);
               end if;
            end if;
         exception 
            when Event : cfe0 => Put_Line (Exception_Message (Event));raise; 
         end;

       exception
          when ADA.IO_EXCEPTIONS.END_ERROR  => exit;
               when Event : cfe1 => Put_Line (Exception_Message (Event)); 
                    exit when not term1; 
               when others => 
                    if not term1 then
                       raise;
                    end if;
       end;
    end loop command_loop;
    return;
exception
    when Event : cfe1 => Put_Line (Exception_Message (Event));raise; 
end cprosa;

end cpros;
