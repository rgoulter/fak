# Port of rgoulter's split_3x5_3 layout,
#  which is a slightly modified Miryoku layout.

let keycode = import "../../../fak/keycode.ncl" in


# Prelude aliases
let kc = keycode.tap.reg.kc in
let ks = keycode.tap.reg.ks in
let mod = keycode.tap.reg.mod in

let fk = keycode.tap.custom.fak in
let me = keycode.tap.custom.media in
let ms = keycode.tap.custom.mouse in

let XXXX = keycode.tap.none & keycode.hold.none in
let TTTT = keycode.tap.trans & keycode.hold.trans in

let BOOT = keycode.tap.custom.fak.BOOT in
let CW = keycode.tap.custom.caps_word.TOGG in


# Tap hold behaviors
let holdtap_behavior_common = {
  timeout_ms = 200,
} in


# Number of alpha layers, e.g. Dvorak, Qwerty, etc.
#
# (The number of layers to use before the layers used by the thumb keys).
let num_base_layers = 1 in
let num_supplemental_layers = 6 in
let num_layers = num_base_layers + num_supplemental_layers in

# Convenience tap-hold functions
let LT = fun layer_num tap => keycode.LT holdtap_behavior_common layer_num tap in


# Miryoku-ish layers
let _NAVR = num_base_layers + 0 in
let _MOUR = num_base_layers + 1 in
let _MEDR = num_base_layers + 2 in
let _NSL  = num_base_layers + 3 in
let _NSSL = num_base_layers + 4 in
let _FUNL = num_base_layers + 5 in


# Tap-Hold keys used in the thumb cluster
let SPC_NAVR = LT _NAVR kc.SPC in
let TAB_MOUR = LT _MOUR kc.TAB in
let ESC_MEDR = LT _MEDR kc.ESC in
let BKSP_NSL = LT _NSL kc.BSPC in
let ENT_NSSL = LT _NSSL kc.ENT in
let DEL_FUNL = LT _FUNL kc.DEL in


# Keymap and Home-Row Modifier Helper functions

# Mods to use for home row modifiers,
#  from pinky to index finger ("asdf").
#
# LHS mods are used, because it's more common to encounter
#  situations where only LHS mods are recognised,
#  than only RHS mods.
let home_row_mods = let
  mod = keycode.hold.reg.mod
in [
    mod.lalt,
    mod.lgui,
    mod.lctl,
    mod.lsft,
] in

# Construct array with fak keycodes for each letter in the string.
#
# Casing is ignored; letters are unshifted. i.e. "a1!" is treated the same as "A1!".
#
# e.g. lift_to_keycodes "qwerty" == [kc.Q, kc.W, kc.E, kc.R, kc.T, kc.Y]
let lift_to_keycodes = fun letters => letters
  |> std.string.uppercase
  |> std.string.characters
  |> std.array.map (fun c => keycode.tap.reg.kc."%{c}") in

# Augments an array of keycodes with home row modifier behaviours,
#  for the LHS home row keycodes.
#
# The first four keycodes are augmented with the home row modifiers,
# the rest are unchanged.
let with_home_row_mods_lhs = fun keycodes =>
  std.array.generate
    (fun idx =>
      let kc = std.array.at idx keycodes in
      if idx < std.array.length home_row_mods then
        keycode.hold.reg.behavior holdtap_behavior_common &
        std.array.at idx home_row_mods &
        kc
      else
        kc)
    (std.array.length keycodes) in

# Augments an array of keycodes with home row modifier behaviours,
#  for the RHS home row keycodes.
#
# The first four keycodes are augmented with the home row modifiers,
# the rest are unchanged.
let with_home_row_mods_rhs = fun keycodes =>
  # reverse keycodes so it's "lhs", add mods, then reverse that.
  keycodes |> std.array.reverse |> with_home_row_mods_lhs |> std.array.reverse in

# Alphabetical Segments, Dvorak
let SEG5_DVORAK_LHS_1 = "',.py" |> lift_to_keycodes in
let SEG5_DVORAK_LHS_2 = "aoeui" |> lift_to_keycodes |> with_home_row_mods_lhs in
let SEG5_DVORAK_LHS_3 = ";qjkx" |> lift_to_keycodes in

let SEG5_DVORAK_RHS_1 = "fgcrl" |> lift_to_keycodes in
let SEG5_DVORAK_RHS_2 = "dhtns" |> lift_to_keycodes |> with_home_row_mods_rhs in
let SEG5_DVORAK_RHS_3 = "bmwvz" |> lift_to_keycodes in


# Different from Miryoku: LHS: miryoku has tab on the medial key; i.e. ESC/MedR, Spc/NavR, Tab/MouR.
let THUMB_ROW = [
    TAB_MOUR, ESC_MEDR, SPC_NAVR,    ENT_NSSL, BKSP_NSL, DEL_FUNL
] in

# Base Layers
# 0: Dvorak
let base_layers = [
    SEG5_DVORAK_LHS_1 @ SEG5_DVORAK_RHS_1 @
    SEG5_DVORAK_LHS_2 @ SEG5_DVORAK_RHS_2 @
    SEG5_DVORAK_LHS_3 @ SEG5_DVORAK_RHS_3 @
                  THUMB_ROW,
] in

let supplemental_layers = [

# NavR (Navigation keys)
## TBI: "Desktop Keys": set-OS (Win, MacOS, Linux)
## TBI: Different from Miryoku: Nav, RHS, upper: TBI the convenience cut/copy/paste and undo/redo
[
  TTTT, TTTT, TTTT, TTTT, TTTT,               TTTT,    TTTT,    TTTT,    TTTT,    TTTT,
  TTTT, TTTT, TTTT, TTTT, TTTT,               kc.LEFT, kc.DOWN, kc.UP,   kc.RGHT, CW,
  TTTT, TTTT, TTTT, TTTT, TTTT,               kc.HOME, kc.PGDN, kc.PGUP, kc.END,  kc.INS,
                    TTTT, TTTT, TTTT, kc.SPC, kc.BSPC, kc.DEL,
],

# MouR (Mouse keys)
[
  TTTT, TTTT, TTTT, TTTT, TTTT,                TTTT,    TTTT,    TTTT,    TTTT,    TTTT,
  TTTT, TTTT, TTTT, TTTT, TTTT,                ms.LEFT, ms.DOWN, ms.UP,   ms.RGHT, TTTT,
  TTTT, TTTT, TTTT, TTTT, TTTT,                TTTT,    ms.WH_D, ms.WH_U, TTTT,    TTTT,
                    TTTT, TTTT, TTTT, ms.BTN1, ms.BTN2, ms.BTN3,
],

# MedR (Media keys)
# Different from Miryoku: No RGB, no external power, no bluetooth.
# Different from Miryoku: Used to change default base layer / enter bootloader.
# TBI: fak/keycodencl: tap.custom.media.STOP key.
[
  TTTT, TTTT, TTTT, TTTT, TTTT,                TTTT,    TTTT,    TTTT,    TTTT,    TTTT,
  TTTT, TTTT, TTTT, TTTT, TTTT,                me.PREV, me.VOLD, me.VOLU, me.NEXT, TTTT,
  TTTT, TTTT, TTTT, TTTT, TTTT,                TTTT,    TTTT,    TTTT,    TTTT,    BOOT,
                    TTTT, TTTT, TTTT, me.PLAY, TTTT,    me.MUTE,
],

# NSL (Numbers/Symbols)
# Different from Miryoku: Number layer, LHS: GRV in middle & slash (rather than semicolon)
[
  kc.LBRC, kc.N7, kc.N8, kc.N9,  kc.RBRC,                TTTT, TTTT, TTTT, TTTT, TTTT,
  kc.GRV,  kc.N4, kc.N5, kc.N6,  kc.EQL,                 TTTT, TTTT, TTTT, TTTT, TTTT,
  kc.SLSH, kc.N1, kc.N2, kc.N3,  kc.BSLS,                TTTT, TTTT, TTTT, TTTT, TTTT,
                         kc.DOT, kc.N0,   kc.MINS, TTTT, TTTT, TTTT,
],

# NSL (Numbers/Symbols (Shifted))
# Different from Miryoku: Number layer, LHS: TILD in middle & slash (rather than colon)
[
  ks.LCBR, ks.AMPR, ks.ASTR, ks.LPRN, ks.RCBR,                TTTT, TTTT, TTTT, TTTT, TTTT,
  ks.TILD, ks.DLR,  ks.PERC, ks.CIRC, ks.PLUS,                TTTT, TTTT, TTTT, TTTT, TTTT,
  ks.QUES, ks.EXLM, ks.AT,   ks.HASH, ks.PIPE,                TTTT, TTTT, TTTT, TTTT, TTTT,
                             ks.LPRN, ks.RPRN, ks.UNDS, TTTT, TTTT, TTTT,
],

# FunL (Function keys etc.)
[
  kc.F12, kc.F7, kc.F8, kc.F9, kc.PSCR,             TTTT, TTTT, TTTT, TTTT, TTTT,
  kc.F11, kc.F4, kc.F5, kc.F6, kc.SCRL,             TTTT, TTTT, TTTT, TTTT, TTTT,
  kc.F10, kc.F1, kc.F2, kc.F3, kc.PAUS,             TTTT, TTTT, TTTT, TTTT, TTTT,
                        TTTT,  TTTT,    TTTT, TTTT, TTTT, TTTT,
],

] in


# Combo Indices definitions
# the four corners of the alpha keys
let alphas_four_corner_indices = [0, 9, 20, 29] in
# the index & middle fingers on lower row, LHS ("CV" on QWERTY)
let lhs_lower_12_indices = [22, 23] in
# the index & middle fingers on lower row, RHS ("M," on QWERTY)
let rhs_lower_12_indices = [26, 27] in

# Convenience keycode definitions

# Desktop Keys
# Linux
let LINUX_DESKTOP_LEFT  = kc.LEFT & mod.lctl & mod.lalt in
let LINUX_DESKTOP_RIGHT = kc.RGHT & mod.lctl & mod.lalt in


# Keymap definition
{
  virtual_keys = [
    keycode.combo.make 255 alphas_four_corner_indices,
    keycode.combo.make 50 lhs_lower_12_indices,
    keycode.combo.make 50 rhs_lower_12_indices,
  ],
  layers =
    let combo_keys = [
      # Combo 0 (four corners of alpha keys): enter bootloader
      BOOT,
      # Combo 1 (left lower): Desktop: Workspace left
      LINUX_DESKTOP_LEFT,
      # Combo 2 (right lower): Desktop: Workspace right
      LINUX_DESKTOP_RIGHT,
    ] in

    # Concatenate combo keys to each layer
    std.array.map
      (fun layer =>
        layer @ combo_keys)
      (base_layers @ supplemental_layers),
}
