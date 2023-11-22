# A reasonable/default keymap for an ortho 4x12 keyboard.
#
# Port of the "default" keymap I use on ortho 5x12
#  https://github.com/rgoulter/qmk_firmware/blob/rgoulter-keyboards-and-layouts/keyboards/rgoulter/x_2/keymaps/default/keymap.c
#
# Follows the Lower/Raise/Adjust layering idiom.

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
let CW = keycode.tap.custom.caps_word.TOGG in

# Tap hold behaviors
let holdtap_behavior_common = {
  timeout_ms = 200,
} in


# Number of alpha layers, e.g. Dvorak, Qwerty, etc.
#
# (The number of layers to use before the layers used by the thumb keys).
let num_alphas_layers = 5 in
let num_base_layers = 2 * num_alphas_layers in
let num_supplemental_layers = 6 in
let num_layers = num_base_layers + num_supplemental_layers in

# Alpha layer indices
# QWERTY, Workman, Colemak, Dvorak, Halmak
let _QWERTY  = 0 in
let _WORKMAN = 1 in
let _COLEMAK = 2 in
let _DVORAK  = 3 in
let _HALMAK  = 4 in

# Keycodes to switch the alphas layer.
let QWERTY  = keycode.tap.layer.DF _QWERTY in
let WORKMAN = keycode.tap.layer.DF _WORKMAN in
let COLEMAK = keycode.tap.layer.DF _COLEMAK in
let DVORAK  = keycode.tap.layer.DF _DVORAK in
let HALMAK  = keycode.tap.layer.DF _HALMAK in

# Keycodes to switch the alphas layer (with home row mods)
let QWERTY_HRM  = keycode.tap.layer.DF (num_alphas_layers + _QWERTY) in
let WORKMAN_HRM = keycode.tap.layer.DF (num_alphas_layers + _WORKMAN) in
let COLEMAK_HRM = keycode.tap.layer.DF (num_alphas_layers + _COLEMAK) in
let DVORAK_HRM  = keycode.tap.layer.DF (num_alphas_layers + _DVORAK) in
let HALMAK_HRM  = keycode.tap.layer.DF (num_alphas_layers + _HALMAK) in

# Change alphas layers
# TapDance:
#  - tap once for simple alphas
#  - tap twice for with home row mods
let az = {
  qwerty  = keycode.td.make 255 [QWERTY, QWERTY_HRM],
  workman = keycode.td.make 255 [WORKMAN, WORKMAN_HRM],
  colemak = keycode.td.make 255 [COLEMAK, COLEMAK_HRM],
  dvorak  = keycode.td.make 255 [DVORAK, DVORAK_HRM],
  halmak  = keycode.td.make 255 [HALMAK, HALMAK_HRM],
} in


# Convenience tap-hold functions
let LT = fun layer_num tap => keycode.LT holdtap_behavior_common layer_num tap in

# Supplemental layer indices
let _LOWER  = num_base_layers + 0 in
let _RAISE  = num_base_layers + 1 in
let _ADJUST = num_base_layers + 2 in

# Tap-Hold keys used in the thumb cluster
let LWR_ESC = LT _LOWER kc.ESC in
let RSE_ENT = LT _RAISE kc.ENT in

let ADJUST = keycode.hold.reg.layer _ADJUST in


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

let bottom_row =
  let mod = keycode.tap.reg.mod in
  let lhs_pinky = [mod.lctl, mod.lgui, mod.lalt] in
  let rhs_pinky = [mod.ralt, mod.rgui, mod.rctl] in
  lhs_pinky @ [kc.TAB, LWR_ESC, kc.SPC] @ [kc.BSPC, RSE_ENT, kc.DEL] @ rhs_pinky in

# Takes in a 30-character string for the alphabetical keys,
# and constructs the base layer for the keymap.
#
# The home row keys are augmented with home row modifiers.
let make_base_layer = fun alphas_str pinky_kc =>
  let segments = layouts.to_keycode_segments alphas_str in
  let lhs1 = segments.lhs1 in
  let lhs2 = segments.lhs2 in
  let lhs3 = segments.lhs3 in

  let rhs1 = segments.rhs1 in
  let rhs2 = segments.rhs2 in
  let rhs3 = segments.rhs3 in

  [kc.TAB]   @ lhs1 @ rhs1 @ [kc.BSPC] @
  [kc.ESC]   @ lhs2 @ rhs2 @ [pinky_kc] @
  [mod.lsft] @ lhs3 @ rhs3 @ [mod.rsft] @
               bottom_row in

# Takes in a 30-character string for the alphabetical keys,
# and constructs the base layer for the keymap.
#
# The home row keys are augmented with home row modifiers.
let make_base_layer_hrm = fun alphas_str pinky_kc =>
  let segments = layouts.to_keycode_segments alphas_str in
  let lhs1 = segments.lhs1 in
  let lhs2 = segments.lhs2 |> with_home_row_mods_lhs in
  let lhs3 = segments.lhs3 in

  let rhs1 = segments.rhs1 in
  let rhs2 = segments.rhs2 |> with_home_row_mods_rhs in
  let rhs3 = segments.rhs3 in

  [kc.TAB]   @ lhs1 @ rhs1 @ [kc.BSPC] @
  [kc.ESC]   @ lhs2 @ rhs2 @ [pinky_kc] @
  [mod.lsft] @ lhs3 @ rhs3 @ [mod.rsft] @
               bottom_row in


# Alphas Layers
# ------------------------------------------------------------------------------------.
# | Tab  |      |      |      |      |      |      |      |      |      |      | Bksp |
# |------+------+------+------+------+------+------+------+------+------+------+------|
# | Esc  |      |      |      |      |      |      |      |      |      |      |      |
# |------+------+------+------+------+------+------+------+------+------+------+------|
# | Shift|      |      |      |      |      |      |      |      |      |      |Shift |
# |------+------+------+------+------+------+------+------+------+------+------+------|
# | Ctrl | GUI  | Alt  | Tab  |Esc/L1| Spc  | Bksp |Ent/L2| Del  | Alt  | GUI  | Ctrl |
# ------------------------------------------------------------------------------------'
let alphas_layers = [
    make_base_layer layouts.qwerty kc.QUOT,
    make_base_layer layouts.workman kc.QUOT,
    make_base_layer layouts.colemak_dhm kc.QUOT,
    make_base_layer layouts.dvorak kc.SLSH,
    make_base_layer layouts.halmak kc.QUOT,

    make_base_layer_hrm layouts.qwerty kc.QUOT,
    make_base_layer_hrm layouts.workman kc.QUOT,
    make_base_layer_hrm layouts.colemak_dhm kc.QUOT,
    make_base_layer_hrm layouts.dvorak kc.SLSH,
    make_base_layer_hrm layouts.halmak kc.QUOT,
] in


let supplemental_layers = [

  # Lower
  # ,-----------------------------------------------------------------------------------.
  # |   ~  |   !  |   @  |   #  |   $  |   %  |   ^  |   &  |   *  |   (  |   )  |  |   |
  # |------+------+------+------+------+-------------+------+------+------+------+------|
  # | Ins  |  F1  |  F2  |  F3  |  F4  |  F5  |  F6  |   _  |   +  |   {  |   }  |  ?   |
  # |------+------+------+------+------+------|------+------+------+------+------+------|
  # |      |  F7  |  F8  |  F9  |  F10 |  F11 |  F12 |      | Home | PgDn | PgUp | End  |
  # |------+------+------+------+------+------+------+------+------+------+------+------|
  # |      |      |      |      |      |             |      | Left | Down | Up   | Rght |
  # `-----------------------------------------------------------------------------------'
  [
    ks.TILD, ks.EXLM, ks.AT,   ks.HASH, ks.DLR,  ks.PERC,    ks.CIRC, ks.AMPR, ks.ASTR, ks.LPRN, ks.RPRN, ks.PIPE,
    kc.INS,  kc.F1,   kc.F2,   kc.F3,   kc.F4,   kc.F5,      kc.F6,   ks.UNDS, ks.PLUS, ks.LCBR, ks.RCBR, ks.QUES,
    TTTT,    kc.F7,   kc.F8,   kc.F9,   kc.F10,  kc.F11,     kc.F12,  TTTT,    kc.HOME, kc.PGDN, kc.PGUP, kc.END,
    TTTT,    TTTT,    TTTT,    TTTT,    XXXX,    TTTT,       TTTT,    ADJUST,   kc.LEFT, kc.DOWN, kc.UP,   kc.RGHT,
  ],

  # Raise
  # ,-----------------------------------------------------------------------------------.
  # |   `  |   1  |   2  |   3  |   4  |   5  |   6  |   7  |   8  |   9  |   0  |  \   |
  # |------+------+------+------+------+-------------+------+------+------+------+------|
  # | Del  |  F1  |  F2  |  F3  |  F4  |  F5  |  F6  |   -  |   =  |   [  |   ]  |  /   |
  # |------+------+------+------+------+------|------+------+------+------+------+------|
  # |      |  F7  |  F8  |  F9  |  F10 |  F11 |  F12 |      |      |      |      |      |
  # |------+------+------+------+------+------+------+------+------+------+------+------|
  # |      |      |      |      |      |             |      | Next | Vol- | Vol+ | Play |
  # `-----------------------------------------------------------------------------------'
  [
    kc.GRV,  kc.N1,   kc.N2,   kc.N3,   kc.N4,   kc.N5,     kc.N6,   kc.N7,   kc.N8,   kc.N9,   kc.N0,   kc.BSLS,
    kc.DEL,  kc.F1,   kc.F2,   kc.F3,   kc.F4,   kc.F5,     kc.F6,   kc.MINS, kc.EQL,  kc.LBRC, kc.RBRC, kc.SLSH,
    TTTT,    kc.F7,   kc.F8,   kc.F9,   kc.F10,  kc.F11,    kc.F12,  TTTT,    TTTT,    TTTT,    TTTT,    TTTT,
    TTTT,    TTTT,    TTTT,    TTTT,    ADJUST,  TTTT,      TTTT,    XXXX,    me.NEXT, me.VOLD, me.VOLU, me.PLAY,
  ],

  # Adjust (Lower + Raise)
  # ,-----------------------------------------------------------------------------------.
  # |      | Boot |      |      |      |      |      |      |      |      |      |      |
  # |------+------+------+------+------+-------------+------+------+------+------+------|
  # |CPSLCK|      |      |      |      |      |      |Qwerty|Workmn|Colemk|Dvorak|Halmak|
  # |------+------+------+------+------+------|------+------+------+------+------+------|
  # |      |      |      |      |      |      |      |      |      |      |      |      |
  # |------+------+------+------+------+------+------+------+------+------+------+------|
  # |      |      |      |      |      |             |      |      |      |      |      |
  # `-----------------------------------------------------------------------------------'
  [
    TTTT, BOOT, TTTT, TTTT, TTTT, TTTT,    TTTT, kc.PSCR, kc.SCRL, kc.PAUS, TTTT, TTTT,
    CW,   TTTT, TTTT, TTTT, TTTT, TTTT,    TTTT, az.qwerty, az.workman, az.colemak, az.dvorak, az.halmak,
    TTTT, TTTT, TTTT, TTTT, TTTT, TTTT,    TTTT, TTTT, TTTT, TTTT, TTTT, TTTT,
    TTTT, TTTT, TTTT, TTTT, XXXX, TTTT,    TTTT, XXXX, TTTT, TTTT, TTTT, TTTT,
  ],

] in


# Keymap definition
{
  virtual_keys = [],
  layers = alphas_layers @ supplemental_layers,
}
