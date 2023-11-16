# A keymap which largely resembles the miryoku keymap.
# https://github.com/manna-harbour/miryoku/tree/master/docs/reference

let keycode = import "../../../fak/keycode.ncl" in
let layouts = import "../../../layouts.ncl" in


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

# Alphabetical Segments, QWERTY
let alphas_segments = layouts.to_keycode_segments layouts.qwerty in
let SEG5_QWERTY_LHS_1 = alphas_segments.lhs1 in
let SEG5_QWERTY_LHS_2 = alphas_segments.lhs2 |> with_home_row_mods_lhs in
let SEG5_QWERTY_LHS_3 = alphas_segments.lhs3 in

let SEG5_QWERTY_RHS_1 = alphas_segments.rhs1 in
let SEG5_QWERTY_RHS_2 = alphas_segments.rhs2 |> with_home_row_mods_rhs in
let SEG5_QWERTY_RHS_3 = alphas_segments.rhs3 in


let THUMB_ROW = [
    ESC_MEDR, SPC_NAVR, TAB_MOUR,    ENT_NSSL, BKSP_NSL, DEL_FUNL
] in

# Base Layers
# 0: QWERTY
let base_layers = [
    SEG5_QWERTY_LHS_1  @                SEG5_QWERTY_RHS_1 @
    SEG5_QWERTY_LHS_2  @                SEG5_QWERTY_RHS_2 @
    SEG5_QWERTY_LHS_3  @ [XXXX, XXXX] @ SEG5_QWERTY_RHS_3 @
    [XXXX, XXXX, XXXX] @  THUMB_ROW   @ [XXXX, XXXX, XXXX],
] in


# Implementation of Miryoku-ish layout.
# Changes noted.
# https://github.com/manna-harbour/miryoku/tree/master/docs/reference
#
# Nav style:
#   MIRYOKU_NAV=VI
let supplemental_layers = [

# NavR (Navigation keys)
## TBI: Different from Miryoku: Nav, RHS, upper: TBI the convenience cut/copy/paste and undo/redo
[
  TTTT, TTTT, TTTT, TTTT, TTTT,               TTTT,    TTTT,    TTTT,    TTTT,    TTTT,
  TTTT, TTTT, TTTT, TTTT, TTTT,               kc.LEFT, kc.DOWN, kc.UP,   kc.RGHT, kc.CAPS,
  TTTT, TTTT, TTTT, TTTT, TTTT, TTTT, TTTT,   kc.HOME, kc.PGDN, kc.PGUP, kc.END,  kc.INS,
  TTTT, TTTT, TTTT, TTTT, TTTT, TTTT, kc.SPC, kc.BSPC, kc.DEL,  TTTT,    TTTT,    TTTT,
],

# MouR (Mouse keys)
[
  TTTT, TTTT, TTTT, TTTT, TTTT,                TTTT,    TTTT,    TTTT,    TTTT,    TTTT,
  TTTT, TTTT, TTTT, TTTT, TTTT,                ms.LEFT, ms.DOWN, ms.UP,   ms.RGHT, TTTT,
  TTTT, TTTT, TTTT, TTTT, TTTT, TTTT, TTTT,    TTTT,    ms.WH_D, ms.WH_U, TTTT,    TTTT,
  TTTT, TTTT, TTTT, TTTT, TTTT, TTTT, ms.BTN1, ms.BTN2, ms.BTN3, TTTT,    TTTT,    TTTT,
],

# MedR (Media keys)
# Different from Miryoku: No RGB, no external power, no bluetooth.
# Different from Miryoku: Used to enter bootloader.
# TBI: fak/keycodencl: tap.custom.media.STOP key.
[
  TTTT, TTTT, TTTT, TTTT, TTTT,                TTTT,    TTTT,    TTTT,    TTTT,    TTTT,
  TTTT, TTTT, TTTT, TTTT, TTTT,                me.PREV, me.VOLD, me.VOLU, me.NEXT, TTTT,
  TTTT, TTTT, TTTT, TTTT, TTTT, TTTT, TTTT,    TTTT,    TTTT,    TTTT,    TTTT,    BOOT,
  TTTT, TTTT, TTTT, TTTT, TTTT, TTTT, me.PLAY, TTTT,    me.MUTE, TTTT,    TTTT,    TTTT,
],

# NSL (Numbers/Symbols)
[
  kc.LBRC, kc.N7, kc.N8, kc.N9,  kc.RBRC,                TTTT, TTTT, TTTT, TTTT, TTTT,
  kc.SCLN, kc.N4, kc.N5, kc.N6,  kc.EQL,                 TTTT, TTTT, TTTT, TTTT, TTTT,
  kc.GRV,  kc.N1, kc.N2, kc.N3,  kc.BSLS, TTTT,    TTTT, TTTT, TTTT, TTTT, TTTT, TTTT,
  TTTT,    TTTT,  TTTT,  kc.DOT, kc.N0,   kc.MINS, TTTT, TTTT, TTTT, TTTT, TTTT, TTTT,
],

# NSL (Numbers/Symbols (Shifted))
[
  ks.LCBR, ks.AMPR, ks.ASTR, ks.LPRN, ks.RCBR,                TTTT, TTTT, TTTT, TTTT, TTTT,
  ks.COLN, ks.DLR,  ks.PERC, ks.CIRC, ks.PLUS,                TTTT, TTTT, TTTT, TTTT, TTTT,
  ks.TILD, ks.EXLM, ks.AT,   ks.HASH, ks.PIPE, TTTT,    TTTT, TTTT, TTTT, TTTT, TTTT, TTTT,
  TTTT,    TTTT,    TTTT,    ks.LPRN, ks.RPRN, ks.UNDS, TTTT, TTTT, TTTT, TTTT, TTTT, TTTT,
],

# FunL (Function keys etc.)
[
  kc.F12, kc.F7, kc.F8, kc.F9, kc.PSCR,             TTTT, TTTT, TTTT, TTTT, TTTT,
  kc.F11, kc.F4, kc.F5, kc.F6, kc.SCRL,             TTTT, TTTT, TTTT, TTTT, TTTT,
  kc.F10, kc.F1, kc.F2, kc.F3, kc.PAUS, TTTT, TTTT, TTTT, TTTT, TTTT, TTTT, TTTT,
  TTTT,   TTTT,  TTTT,  TTTT,  TTTT,    TTTT, TTTT, TTTT, TTTT, TTTT, TTTT, TTTT,
],

] in


# Combo Indices definitions
# the four corners of the alpha keys
let alphas_four_corner_indices = [0, 9, 20, 31] in


# Keymap definition
{
  virtual_keys = [
    keycode.combo.make 255 alphas_four_corner_indices,
  ],
  layers =
    let combo_keys = [
      # Combo 0 (four corners of alpha keys): enter bootloader
      keycode.tap.custom.fak.BOOT,
    ] in

    # Concatenate combo keys to each layer
    std.array.map
      (fun layer =>
        layer @ combo_keys)
      (base_layers @ supplemental_layers),
}
