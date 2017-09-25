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

with Ada.Characters.Latin_1;

package split_string is

   White_Space1 : constant String := " ," & Ada.Characters.Latin_1.HT;
   function Number_Of_Words (FS : String) return Natural;
   function Word
     (FS          : in String;
      Word_Number :    Natural;
      S           :    String := White_Space1) return String;
   function Last_Word (FS : String; S : String := White_Space1) return String;
   function First_Word (FS : String; S : String := White_Space1) return String;

end split_string;
