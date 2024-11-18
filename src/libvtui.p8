;
; Client side linkage for a small shared module
;

%import lib

vtui {
    ; library size in pages
    const ubyte size = 4
    str library = "vtui1.1.bin"
    uword libbuf = memory("vtui", size * 256, 256)

    ; byte offset from library load address
    ; aka slot in jump table (this is not the fixup location)

    ; special case due to 'bra' use that is two bytes.
    const uword initialize_         = lib_table + 00 * 3 ; $xx00

    const uword lib_table = $02
    const uword screen_set_         = lib_table + 00 * 3 ; $xx02
    const uword set_bank_           = lib_table + 01 * 3 ; $xx05
    const uword set_stride_         = lib_table + 02 * 3 ; $xx08
    const uword set_decr_           = lib_table + 03 * 3 ; $xx0b
    const uword clr_scr_            = lib_table + 04 * 3 ; $xx0e
    const uword gotoxy_             = lib_table + 05 * 3 ; $xx11
    const uword plot_char_          = lib_table + 06 * 3 ; $xx14
    const uword scan_char_          = lib_table + 07 * 3 ; $xx17
    const uword hline_              = lib_table + 08 * 3 ; $xx1a
    const uword vline_              = lib_table + 09 * 3 ; $xx1d
    const uword print_str_          = lib_table + 10 * 3 ; $xx20
    const uword fill_box_           = lib_table + 11 * 3 ; $xx23
    const uword pet2scr_            = lib_table + 12 * 3 ; $xx26
    const uword scr2pet_            = lib_table + 13 * 3 ; $xx29
    const uword border_             = lib_table + 14 * 3 ; $xx2c
    const uword save_rect_          = lib_table + 15 * 3 ; $xx2f
    const uword rest_rect_          = lib_table + 16 * 3 ; $xx32
    const uword input_str_          = lib_table + 17 * 3 ; $xx35 
    const uword input_str_lastkey_  = lib_table + 17 * 3 ; $xx35 (same as above)
    const uword input_str_retboth_  = lib_table + 17 * 3 ; $xx35 (same as above)
    const uword get_bank_           = lib_table + 18 * 3 ; $xx38
    const uword get_stride_         = lib_table + 19 * 3 ; $xx3b
    const uword get_decr_           = lib_table + 20 * 3 ; $xx3e

    ; unload (free) resources from load
    ; (only if allocated somehow)
    sub unload() -> bool {
        return true
    }

    ; simplified to use lib.loadreloc()
    sub load() -> bool {
        ubyte libpg = msb(libbuf)
        ; pass location of relocation byte based on first 'jmp' (since first slot is 'bra')
        bool result = lib.loadreloc(libbuf, library, size, screen_set_+2)

        ; do actual fixup (manual for now, delimited loop later)
        @(&initialize+2) = libpg
        @(&screen_set+2) = libpg
        @(&set_bank+2) = libpg
        @(&set_stride+2) = libpg
        @(&set_decr+2) = libpg
        @(&clr_scr+2) = libpg
        @(&gotoxy+2) = libpg
        @(&plot_char+2) = libpg
        @(&scan_char+2) = libpg
        @(&hline+2) = libpg
        @(&vline+2) = libpg
        @(&print_str+2) = libpg
        @(&fill_box+2) = libpg
        @(&pet2scr+2) = libpg
        @(&scr2pet+2) = libpg
        @(&border+2) = libpg
        @(&save_rect+2) = libpg
        @(&rest_rect+2) = libpg
        @(&input_str+2) = libpg
        @(&input_str_lastkey+2) = libpg
        @(&input_str_retboth+2) = libpg
        @(&get_bank+2) = libpg
        @(&get_stride+2) = libpg
        @(&get_decr+2) = libpg

        ; make link call with a test pointer.
        ;initialize(libbuf)

        return result
    }

    ; stub for relocatable library version of VTUI
    asmsub initialize() clobbers(A,X,Y) {
        %asm {{
            jmp p8b_vtui.p8c_initialize_
        }}
    }

    ; stub for relocatable library version of VTUI
    asmsub screen_set(ubyte mode @A) clobbers(A,X,Y) {
        %asm {{
            jmp p8b_vtui.p8c_screen_set_
        }}
    }

    ; stub for relocatable library version of VTUI
    asmsub set_bank(bool bank1 @Pc) clobbers(A) {
        %asm {{
            jmp p8b_vtui.p8c_set_bank_
        }}
    }

    ; stub for relocatable library version of VTUI
    asmsub set_stride(ubyte stride @A) clobbers(A) {
        %asm {{
            jmp p8b_vtui.p8c_set_stride_
        }}
    }

    ; stub for relocatable library version of VTUI
    asmsub set_decr(bool incrdecr @Pc) clobbers(A) {
        %asm {{
            jmp p8b_vtui.p8c_set_decr_
        }}
    }

    ; stub for relocatable library version of VTUI
    asmsub clr_scr(ubyte char @A, ubyte colors @X) clobbers(Y) {
        %asm {{
            jmp p8b_vtui.p8c_clr_scr_
        }}
    }

    ; stub for relocatable library version of VTUI
    asmsub gotoxy(ubyte column @A, ubyte row @Y) {
        %asm {{
            jmp p8b_vtui.p8c_gotoxy_
        }}
    }

    ; stub for relocatable library version of VTUI
    asmsub plot_char(ubyte char @A, ubyte colors @X) {
        %asm {{
            jmp p8b_vtui.p8c_plot_char_
        }}
    }

    ; stub for relocatable library version of VTUI
    asmsub scan_char() -> uword @AX {
        %asm {{
            jmp p8b_vtui.p8c_scan_char_
        }}
    }

    ; stub for relocatable library version of VTUI
    asmsub hline(ubyte char @A, ubyte length @Y, ubyte colors @X) clobbers(A) {
        %asm {{
            jmp p8b_vtui.p8c_hline_
        }}
    }

    ; stub for relocatable library version of VTUI
    asmsub vline(ubyte char @A, ubyte length @Y, ubyte colors @X) clobbers(A) {
        %asm {{
            jmp p8b_vtui.p8c_vline_
        }}
    }

    ; stub for relocatable library version of VTUI
    asmsub print_str(str txtstring @R0, ubyte length @Y, ubyte colors @X, ubyte convertchars @A) clobbers(A, Y) {
        %asm {{
            jmp p8b_vtui.p8c_print_str_
        }}
    }

    ; stub for relocatable library version of VTUI
    asmsub fill_box(ubyte char @A, ubyte width @R1, ubyte height @R2, ubyte colors @X) clobbers(A, Y) {
        %asm {{
            jmp p8b_vtui.p8c_fill_box_
        }}
    }

    ; stub for relocatable library version of VTUI
    asmsub pet2scr(ubyte char @A) -> ubyte @A {
        %asm {{
            jmp p8b_vtui.p8c_pet2scr_
        }}
    }

    ; stub for relocatable library version of VTUI
    asmsub scr2pet(ubyte char @A) -> ubyte @A {
        %asm {{
            jmp p8b_vtui.p8c_scr2pet_
        }}
    }

    ; stub for relocatable library version of VTUI
    ; NOTE: mode 6 means 'custom' characters taken from r3 - r6
    asmsub border(ubyte mode @A, ubyte width @R1, ubyte height @R2, ubyte colors @X) clobbers(Y) {
        %asm {{
            jmp p8b_vtui.p8c_border_
        }}
    }

    ; stub for relocatable library version of VTUI
    asmsub save_rect(ubyte ramtype @A, bool vbank1 @Pc, uword address @R0, ubyte width @R1, ubyte height @R2) clobbers(A, X, Y) {
        %asm {{
            jmp p8b_vtui.p8c_save_rect_
        }}
    }

    ; stub for relocatable library version of VTUI
    asmsub rest_rect(ubyte ramtype @A, bool vbank1 @Pc, uword address @R0, ubyte width @R1, ubyte height @R2) clobbers(A, X, Y) {
        %asm {{
            jmp p8b_vtui.p8c_rest_rect_
        }}
    }

    ; stub for relocatable library version of VTUI
    ; NOTE: returns string length
    asmsub input_str(uword buffer @R0, ubyte buflen @Y, ubyte colors @X) clobbers (A) -> ubyte @Y {
        %asm {{
            jmp p8b_vtui.p8c_input_str_
        }}
    }

    ; stub for relocatable library version of VTUI
    ; NOTE: returns lastkey press
    asmsub input_str_lastkey(uword buffer @R0, ubyte buflen @Y, ubyte colors @X) clobbers (Y) -> ubyte @A {
        %asm {{
            jmp p8b_vtui.p8c_input_str_lastkey_
        }}
    }

    ; stub for relocatable library version of VTUI
    ; NOTE: returns lastkey press, string length
    asmsub input_str_retboth(uword buffer @R0, ubyte buflen @Y, ubyte colors @X) clobbers () -> uword @AY {
        %asm {{
            jmp p8b_vtui.p8c_input_str_retboth_
        }}
    }

    ; stub for relocatable library version of VTUI
    asmsub get_bank() clobbers (A) -> bool @Pc {
        %asm {{
            jmp p8b_vtui.p8c_get_bank_
        }}
    }

    ; stub for relocatable library version of VTUI
    asmsub get_stride() -> ubyte @A {
        %asm {{
            jmp p8b_vtui.p8c_get_stride_
        }}
    }

    ; stub for relocatable library version of VTUI
    asmsub get_decr() clobbers (A) -> bool @Pc {
        %asm {{
            jmp p8b_vtui.p8c_get_decr_
        }}
    }

    ; helper function to do string length counting for you internally
    ; and turn the convertchars flag into a boolean again
    asmsub print_str2(str txtstring @R0, ubyte colors @X, bool convertchars @Pc) clobbers(A, Y) {
        %asm {{
            lda  #0
            bcs  +
            lda  #$80
+           pha
            lda  cx16.r0
            ldy  cx16.r0+1
            jsr  prog8_lib.strlen
            pla
            jmp  p8b_vtui.p8s_print_str
        }}
    }

}
