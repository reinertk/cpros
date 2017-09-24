with Text_IO;      use Text_IO;

with Ada;
with Ada.Text_IO;
with cpros;
with rsplit;         use rsplit;

procedure cpros_test1 is

type c_t is (c_exit, c_do, c_this, c_that);

procedure cpros_actual1(command : in c_t; str : in String) with
                        pre => command not in c_exit | c_do is
begin
   case command is
     when c_exit | c_do => null;
     when c_this => Put_Line(" this " & word (str, 2)); 
     when c_that => Put_Line(" this " & word (str, 2)); 
   end case;
end cpros_actual1;

package cpros_package1 is new cpros (c_t => c_t, cpros_main => cpros_actual1);

begin

cpros_package1.cprosa(file1 => Ada.Text_IO.Standard_Input);

end cpros_test1;
