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

   command_white_space1 : constant String := " ,|" & Ada.Characters.Latin_1.HT;
-- command_single1      : constant String := "&";


   function number_of_words
     (fs : String;
      ws : String := command_white_space1) return Natural;
   function word
     (fs          : in String;
      word_number :    Natural;
      ws          :    String := command_white_space1) return String;
   function last_word
     (fs : String;
      ws : String := command_white_space1) return String;
   function first_word
     (fs : String;
      ws : String := command_white_space1) return String;
   function collect1
     (fs               : String;
      from_word_number : Natural;
      ws               : String := command_white_space1) return String;
   function remove_comment1 (fs : String; cc : String := "#") return String;
   function expand1 (fs : String; singles : String) return String;

end split_string;
