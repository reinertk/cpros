with Ada.Strings.Fixed;
with Ada.Strings.Maps;
with Text_IO;
use Text_IO;

package body split_string is

   function collect1
     (fs               : String;
      from_word_number : Natural;
      ws               : String := command_white_space1) return String
   is
   begin
      if from_word_number <= number_of_words (fs, ws => ws) then
         return word (fs, from_word_number, ws => ws) &
           " " &
           collect1 (fs, from_word_number + 1, ws);
      else
         return "";
      end if;
   end collect1;

   function shrink1 (fs : String) return String is
      fs1 : String  := Ada.Strings.Fixed.Trim (fs, Ada.Strings.Both);
      i1  : Integer := Ada.Strings.Fixed.Index (fs1, "  ");
   begin
      while i1 > 0 loop
         Ada.Strings.Fixed.Delete (fs1, i1, i1);
         i1 := Ada.Strings.Fixed.Index (Ada.Strings.Fixed.Trim (fs1, Ada.Strings.Both), "  ");
      end loop;
      return Ada.Strings.Fixed.Trim (fs1, Ada.Strings.Both);
   end shrink1;

   function expand1 (fs : String; singles : String) return String is
      use Ada.Strings.Fixed;
      singles1 : constant Ada.Strings.Maps.Character_Set := Ada.Strings.Maps.To_Set (singles);
      fs1      : String := Ada.Strings.Fixed.Trim (shrink1 (fs), Ada.Strings.Both) & 10 * " ";
      i1       : Integer                := fs1'First;
      i2       : Integer;
   begin
      loop
         i2 := Ada.Strings.Fixed.Index (fs1 (i1 .. fs1'Last), singles1, Ada.Strings.Inside);
         exit when i2 = 0;
         if fs1 (i2 - 1) /= ' ' then
            Insert (fs1, i2, " ", Drop => Ada.Strings.Right);
            i1 := i2 + 1;
         elsif fs1 (i2 + 1) /= ' ' then
            Insert (fs1, i2 + 1, " ", Drop => Ada.Strings.Right);
            i1 := i2 + 2;
         else
            i1 := i2 + 1;
         end if;
      end loop;
      return Trim (fs1, Ada.Strings.Both);
   end expand1;

   function word
     (fs          : String;
      word_number : Natural;
      ws          : String := command_white_space1) return String
   is
      use Ada.Strings.Maps;
      i      : Integer;
      j      : Integer                := fs'First - 1;
      space1 : constant Character_Set := To_Set (ws);
      k1, k2 : Integer                := 0;
      no_matching_quotation : exception;
   begin
      if Ada.Strings.Fixed.Index (fs, Set => space1, Test => Ada.Strings.Outside) = 0 then
         return "";
      end if;
      for n in 0 .. word_number - 1 loop
         i := j + 1;
         Ada.Strings.Fixed.Find_Token
           (Source => fs (i .. fs'Last),
            Set    => space1,
            Test   => Ada.Strings.Outside,
            First  => i,
            Last   => j);
         if j = 0 then
            return "";
         end if;
         k1 := Ada.Strings.Fixed.Index (fs (i .. j), """");
         if k1 > 0 then
            k2 := Ada.Strings.Fixed.Index (fs (k1 + 1 .. fs'Last), """");
            if k2 = 0 then
               raise no_matching_quotation;
            end if;
            j := k2;
         end if;
      end loop;
      return Ada.Strings.Fixed.Trim
          (Source => fs (i .. j),
           Left   => To_Set (""""),
           Right  => To_Set (""""));
   exception
      when no_matching_quotation =>
         Put ("** No matching quotation mark ** ");
         New_Line;
         return "";
   end word;

   function number_of_words
     (fs : String;
      ws : String := command_white_space1) return Natural
   is
      n : Natural := 0;
   begin
      while word (fs, n + 1, ws)'Length > 0 loop
         n := n + 1;
      end loop;
      return n;
   end number_of_words;

   function first_word
     (fs : String;
      ws : String := command_white_space1) return String
   is
   begin
      return word (fs, 1, ws);
   end first_word;

   function last_word
     (fs : String;
      ws : String := command_white_space1) return String
   is
   begin
      return word (fs, number_of_words (fs, ws), ws);
   end last_word;

   function remove_comment1 (fs : String; cc : String := "#") return String is
      use Ada.Strings.Fixed;
      i0 : constant Natural := Index (fs, cc);
   begin
      return fs (fs'First .. (if i0 > 0 then i0 - 1 else fs'Last));
   end remove_comment1;

end split_string;
