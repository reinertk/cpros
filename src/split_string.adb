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

with Ada.Strings.Fixed, Ada.Strings.Maps;
with Text_IO; use Text_IO;

package body split_string is

   use Ada.Strings;
   use Ada.Strings.Fixed;
   use Ada.Strings.Maps;

   function Word
     (FS          : String;
      Word_Number : Natural;
      WS          : String := Command_White_Space1) return String
   is
      I      : Integer;
      J      : Integer                := FS'First - 1;
      Space1 : constant Character_Set := To_Set (WS);
      n      : Integer                := 0;
      k1, k2 : Integer                := 0;
      No_matching_quotation : exception;
   begin
      if Index (FS, Set => Space1, Test => Ada.Strings.Outside) = 0 then
         return "";
      end if;
      while n < Word_Number loop
         I := J + 1;
         Find_Token
           (Source => FS (I .. FS'Last),
            Set    => Space1,
            Test   => Outside,
            First  => I,
            Last   => J);
         if J = 0 then
            return "";
         end if;
         k1 := Index (FS (I .. J), """");
         if k1 > 0 then
            k2 := Index (FS (k1 + 1 .. FS'Last), """");
            if k2 = 0 then
               raise No_matching_quotation;
            end if;
            J := k2;
         end if;
         n := n + 1;
      end loop;
      return Trim
          (Source => FS (I .. J),
           Left   => To_Set (""""),
           Right  => To_Set (""""));
   exception
      when No_matching_quotation =>
         Put ("** No matching quotation mark ** ");
         New_Line;
         return "";
   end Word;

   function Number_Of_Words (FS : String; WS : String := Command_White_Space1) return Natural is
      n : Natural := 0;
   begin
      loop
         exit when Word (FS, n + 1, WS) = "";
         n := n + 1;
      end loop;
      return n;
   end Number_Of_Words;

   function First_Word
     (FS : String;
      WS : String := Command_White_Space1) return String
   is
   begin
      return Word (FS, 1, WS);
   end First_Word;

   function Last_Word
     (FS : String;
      WS : String := Command_White_Space1) return String
   is
   begin
      return Word (FS, Number_Of_Words (FS), WS);
   end Last_Word;

end split_string;
