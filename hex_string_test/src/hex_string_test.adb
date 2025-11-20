with GNAT.IO;
with Hex_String;
with Interfaces; use Interfaces;
with System;
--  with System;

procedure Hex_String_Test is

   Vector_U32 : constant Unsigned_32 := 16#ABCD_EF01#;
   Vector_U64 : constant Unsigned_64 := 16#ABCD_EF01_2345_6789#;

   type Positive_8_Array is array (Positive range <>) of Unsigned_8 with
     Component_Size => 8;

   type Unsigned_3 is mod 2**3 with
     Size => 3;

   subtype Test_Array is Positive_8_Array (1 .. 9);

   package Hexation is new Hex_String (Item => Test_Array);

   Input : constant Test_Array :=
     [1 => 16#01#,
     2  => 16#AB#,
     3  => 16#CD#,
     4  => 16#EF#,
     5  => 16#10#,
     6  => 16#BA#,
     7  => 16#DC#,
     8  => 16#FE#,
     9  => 16#10#];

   Output_Length : constant Integer := Hexation.Image_Length (Input);

   Output : String (1 .. Output_Length) := [others => 'U'];

   Hex_Status : Hexation.Status_Code;

   subtype Test_Array_2 is Positive_8_Array (1 .. 7);

   type Input_2_T is record
      Values : Test_Array_2 :=
        [1 => 16#01#,
        2  => 16#AB#,
        3  => 16#CD#,
        4  => 16#EF#,
        5  => 16#10#,
        6  => 16#BA#,
        7  => 16#DC#];
      Two    : Unsigned_3   := 7;
      Three  : Unsigned_64  := Vector_U64;
   end record;

   --  even "with pack" this works without a use clause but this is here to
   --  limit warning(s) to those that are interesting in this case. Namely
   --  that Test_Array_2 within Input_2_T above is not affected by the
   --  High_Order_First. Note that using High_Order_First on a little endian
   --  machine can incur byte swapping overheads. High_Order_First does however
   --  provide some consistency to the reader. Where byte reversal of the whole
   --  record would not.
   for Input_2_T use record
      Values at 0 range 0 .. 55;
      Two    at 7 range 0 ..  7;
      Three  at 8 range 0 .. 63;
   end record;

   package Hexation_2 is new Hex_String
     (Item                     => Input_2_T,
      Output_Underscores_Every => 2);

   Input_2 : Input_2_T;

   Output_2_Length : constant Integer := Hexation_2.Image_Length (Input_2);

   Output_2 : String (1 .. Output_2_Length) := [others => 'U'];

   Hex_Status_2 : Hexation_2.Status_Code;

   package Hexation_U32 is new Hex_String (Item => Unsigned_32);

   Input_3 : constant Unsigned_32 := Vector_U32;

   Output_3_Length : constant Integer := Hexation_U32.Image_Length (Input_3);

   Output_3 : String (1 .. Output_3_Length) := [others => 'U'];

   Hex_Status_3 : Hexation_U32.Status_Code;

   package Hexation_U64 is new Hex_String (Item => Unsigned_64);

   Input_4 : constant Unsigned_64 := Vector_U64;

   Output_4_Length : constant Integer := Hexation_U64.Image_Length (Input_4);

   Output_4 : String (1 .. Output_4_Length) := [others => 'U'];

   Hex_Status_4 : Hexation_U64.Status_Code;

   type Positive_16_Array is array (Positive range <>) of Unsigned_16 with
     Component_Size => 16, Scalar_Storage_Order => System.High_Order_First;

   subtype Test_Array_5 is Positive_16_Array (1 .. 4);

   type Input_5_T is record
      Values : Test_Array_5 :=
        [1 => 16#01AB#,
        2  => 16#CDEF#,
        3  => 16#10BA#,
        4  => 16#DCFE#];
      Two    : Unsigned_3   := 6;
      Three  : Unsigned_64  := Vector_U64;
   end record with
     Size      => 136, Scalar_Storage_Order => System.High_Order_First,
     Bit_Order => System.High_Order_First;

   for Input_5_T use record
      Values at 0 range 0 .. 63;
      Two    at 8 range 0 ..  7;
      Three  at 9 range 0 .. 63;
   end record;

   package Hexation_5 is new Hex_String (Item => Input_5_T);

   Input_5 : Input_5_T;

   Output_5_Length : constant Integer := Hexation_5.Image_Length (Input_5);

   Output_5 : String (1 .. Output_5_Length) := [others => 'U'];

   Hex_Status_5 : Hexation_5.Status_Code;

begin
   GNAT.IO.Put_Line ("");
   GNAT.IO.Put_Line ("________________Big_Endian_Scalars________________");

   Hexation.Image_High
     (Value      => Input,
      The_Image  => Output,
      Hex_Status => Hex_Status);

   if Hex_Status in Hexation.OK
   then
      GNAT.IO.Put_Line (Output);
   else
      GNAT.IO.Put_Line ("Failed, please report");
   end if;

   Hexation_2.Image_High
     (Value      => Input_2,
      The_Image  => Output_2,
      Hex_Status => Hex_Status_2);

   if Hex_Status_2 in Hexation_2.OK
   then
      GNAT.IO.Put_Line (Output_2);
   else
      GNAT.IO.Put_Line ("Failed, please report");
   end if;

   Hexation_U32.Image_High
     (Value      => Input_3,
      The_Image  => Output_3,
      Hex_Status => Hex_Status_3);

   if Hex_Status_3 in Hexation_U32.OK
   then
      GNAT.IO.Put_Line (Output_3);
   else
      GNAT.IO.Put_Line ("Failed, please report");
   end if;

   Hexation_U64.Image_High
     (Value      => Input_4,
      The_Image  => Output_4,
      Hex_Status => Hex_Status_4);

   if Hex_Status_4 in Hexation_U64.OK
   then
      GNAT.IO.Put_Line (Output_4);
   else
      GNAT.IO.Put_Line ("Failed, please report");
   end if;

   Hexation_5.Image_High
     (Value      => Input_5,
      The_Image  => Output_5,
      Hex_Status => Hex_Status_5);

   if Hex_Status_5 in Hexation_5.OK
   then
      GNAT.IO.Put_Line (Output_5);
   else
      GNAT.IO.Put_Line ("Failed, please report");
   end if;

   GNAT.IO.Put_Line ("");
   GNAT.IO.Put_Line ("________________Little_Endian_Scalars________________");

   Hexation.Image_Low
     (Value      => Input,
      The_Image  => Output,
      Hex_Status => Hex_Status);

   if Hex_Status in Hexation.OK
   then
      GNAT.IO.Put_Line (Output);
   else
      GNAT.IO.Put_Line ("Failed, please report");
   end if;

   Hexation_2.Image_Low
     (Value      => Input_2,
      The_Image  => Output_2,
      Hex_Status => Hex_Status_2);

   if Hex_Status_2 in Hexation_2.OK
   then
      GNAT.IO.Put_Line (Output_2);
   else
      GNAT.IO.Put_Line ("Failed, please report");
   end if;

   Hexation_U32.Image_Low
     (Value      => Input_3,
      The_Image  => Output_3,
      Hex_Status => Hex_Status_3);

   if Hex_Status_3 in Hexation_U32.OK
   then
      GNAT.IO.Put_Line (Output_3);
   else
      GNAT.IO.Put_Line ("Failed, please report");
   end if;

   Hexation_U64.Image_Low
     (Value      => Input_4,
      The_Image  => Output_4,
      Hex_Status => Hex_Status_4);

   if Hex_Status_4 in Hexation_U64.OK
   then
      GNAT.IO.Put_Line (Output_4);
   else
      GNAT.IO.Put_Line ("Failed, please report");
   end if;

   Hexation_5.Image_Low
     (Value      => Input_5,
      The_Image  => Output_5,
      Hex_Status => Hex_Status_5);

   if Hex_Status_5 in Hexation_5.OK
   then
      GNAT.IO.Put_Line (Output_5);
   else
      GNAT.IO.Put_Line ("Failed, please report");
   end if;

end Hex_String_Test;
