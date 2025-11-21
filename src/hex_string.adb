with Ada.Unchecked_Conversion;
with System;

package body Hex_String is

   function Image_Length
     (Input : Item)
      return Integer
   is
      Bytes : constant Integer := Input'Size / 8;
   begin
      if Bytes mod Underscores_At = 0
      then
         return ((Bytes * 2) + (Bytes / Underscores_At)) - 1;
      else
         return ((Bytes * 2) + (Bytes / Underscores_At));
      end if;
   end Image_Length;

   procedure Byte_To_Hex
     (Byte             :        Unsigned_8;
      Image_Position   : in out Natural;
      Track_Underscore : in out Natural;
      The_Image        :    out String)
   is
      Hex_Codes : constant array (0 .. 15) of Character := "0123456789ABCDEF";
   begin
      if Track_Underscore = Underscores_At
      then
         The_Image (Image_Position) := '_';
         Image_Position             := @ + 1;
         Track_Underscore           := 1;
      else
         Track_Underscore := @ + 1;
      end if;
      The_Image (Image_Position) := Hex_Codes (Integer ((Byte / 16) mod 16));
      Image_Position             := @ + 1;
      The_Image (Image_Position) := Hex_Codes (Integer (Byte mod 16));
      Image_Position             := @ + 1;
   end Byte_To_Hex;

   procedure Image_High
     (Value      :     Item;
      The_Image  : out String;
      Hex_Status : out Status_Code)
   is
      Image_Position   : Natural := The_Image'First;
      N_Value          : Integer;
      Track_Underscore : Natural := 0;
      Length           : Integer;
   begin

      if The_Image'Length /= Image_Length (Value)
      then
         The_Image  := (others => 'X');
         Hex_Status := Length_Mismatch;
         return;
      end if;

      declare
         type Positive_8_Array is array (Positive range <>) of Unsigned_8 with
           Component_Size       => 8,
           Scalar_Storage_Order => System.High_Order_First;
         subtype Byte_Array is Positive_8_Array (1 .. (Value'Size / 8));
         function To_Bytes is new Ada.Unchecked_Conversion
           (Source => Item,
            Target => Byte_Array);
         Bytes : constant Byte_Array := To_Bytes (Value);
      begin
         for I in Bytes'Range loop
            Byte_To_Hex
              (Byte             => Bytes (I),
               Image_Position   => Image_Position,
               Track_Underscore => Track_Underscore,
               The_Image        => The_Image);
         end loop;

      end;

      Hex_Status := OK;
   end Image_High;

   procedure Image_Low
     (Value      :     Item;
      The_Image  : out String;
      Hex_Status : out Status_Code)
   is
      Image_Position   : Natural := The_Image'First;
      N_Value          : Integer;
      Track_Underscore : Natural := 0;
      Length           : Integer;
   begin

      if The_Image'Length /= Image_Length (Value)
      then
         The_Image  := (others => 'X');
         Hex_Status := Length_Mismatch;
         return;
      end if;

      declare
         type Positive_8_Array is array (Positive range <>) of Unsigned_8 with
           Component_Size       => 8,
           Scalar_Storage_Order => System.Low_Order_First;
         subtype Byte_Array is Positive_8_Array (1 .. (Value'Size / 8));
         function To_Bytes is new Ada.Unchecked_Conversion
           (Source => Item,
            Target => Byte_Array);
         Bytes : constant Byte_Array := To_Bytes (Value);
      begin

         for I in Bytes'Range loop
            Byte_To_Hex
              (Byte             => Bytes (I),
               Image_Position   => Image_Position,
               Track_Underscore => Track_Underscore,
               The_Image        => The_Image);
         end loop;

      end;

      Hex_Status := OK;
   end Image_Low;

end Hex_String;

--  BSD License
--
--  Copyright (c) 2025, Kevin Chadwick <kc-open_source@elansys.co>
--
--  Permission to use, copy, modify, and distribute this software for any
--  purpose with or without fee is hereby granted, provided that the above
--  copyright notice and this permission notice appear in all copies.
--
--  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
--  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
--  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
--  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
--  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
--  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
--  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
