with Interfaces; use Interfaces;

--  This package produces a hex representation of many types as a String
--   @Example
--
--   declare
--   package Hex_U64 is new Hex_String (Item => Unsigned_64);
--
--   Input_4 : constant Unsigned_64 := 16#C0DE_2ACE_ACE2_C0DE#;
--
--   Output_4_Length : constant Integer := Hex_U64.Image_Length (Input_4);
--
--   Output_4 : String (1 .. Output_4_Length);
--
--   Hex_Status_4 : Hex_U64.Status_Code;
--
--   begin
--     Hex_U64.Image
--       (Value      => Input_4,
--        The_Image  => Output_4,
--        Hex_Status => Hex_Status_4);
--   end
generic
   type Item is private;
   Output_Underscores_Every : Positive := 4;

package Hex_String is

   type Status_Code is
     (OK,
      Length_Mismatch);

   Underscores_At : constant Integer := Output_Underscores_Every;

   --  Provides the length of the String needed to contain the Hex
   --  representation of Item
   function Image_Length
     (Input : Item)
      return Integer;

   --  Fills a String with the hex representation. Standalone Scalars will be
   --  in High_Order (Network Byte Order).
   --
   --  Arrays and records have their own byte order controlled via
   --   with Scalar_Storage_Order => System.High_Order_First
   --  Which can be used externally to this package on records and arrays to
   --  have the same affect all be it with a byte flipping overhead on non big
   --  endian machines for all accesses to said records. Note also that records
   --  may have extra alignment bytes.
   --   Note also that records may have extra alignment bytes.
   --   See here for details
   --   https://learn.adacore.com/courses/intro-to-embedded-sys-prog/index.html
   procedure Image_High
     (Value      :     Item;
      The_Image  : out String;
      Hex_Status : out Status_Code);

   --  Fills a String with the hex representation. Standalone Scalars will be
   --  in Low_Order (Little Endian Byte Order).
   --
   --  Arrays and records have their own byte order controlled via
   --   with Scalar_Storage_Order => System.Low_Order_First
   --  Which can be used externally to this package on records and arrays to
   --  have the same affect all be it with a potential byte flipping overhead
   --  on non little endian machines for all accesses to said records.
   --   Note also that records may have extra alignment bytes.
   --   See here for details
   --   https://learn.adacore.com/courses/intro-to-embedded-sys-prog/index.html
   procedure Image_Low
     (Value      :     Item;
      The_Image  : out String;
      Hex_Status : out Status_Code);

private

   procedure Byte_To_Hex
     (Byte             :        Unsigned_8;
      Image_Position   : in out Natural;
      Track_Underscore : in out Natural;
      The_Image        :    out String) with
     Inline_Always;

end Hex_String;
