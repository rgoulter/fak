# Port of rgoulter's split_3x5_3 layout,
#  which is a slightly modified Miryoku layout.
#
# A "layout" is the list of layers for a keymap,
#  without the virtual keys.
#
# The layout can be used by including it in a keymap.

let keycode = import "../../../fak/keycode.ncl" in
let { BoundedInt, .. } = import "../../../fak/util_types.ncl" in


# Prelude aliases
let kc = keycode.tap.reg.kc in
let ks = keycode.tap.reg.ks in

let fk = keycode.tap.custom.fak in
let me = keycode.tap.custom.media in
let ms = keycode.tap.custom.mouse in

let XXXX = keycode.tap.none & keycode.hold.none in
let TTTT = keycode.tap.trans & keycode.hold.trans in


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
# Impl. note: Reassure Nickel/Fak that we only reference valid layers.
let LayerIndex = BoundedInt 0 num_layers in

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


# Home-Row Modifier Helper functions
let LALT_T = fun tap =>
    keycode.hold.reg.behavior holdtap_behavior_common &
    keycode.hold.reg.mod.lalt &
    tap in
let LGUI_T = fun tap =>
    keycode.hold.reg.behavior holdtap_behavior_common &
    keycode.hold.reg.mod.lgui &
    tap in
let LCTL_T = fun tap =>
    keycode.hold.reg.behavior holdtap_behavior_common &
    keycode.hold.reg.mod.lctl &
    tap in
let LSFT_T = fun tap =>
    keycode.hold.reg.behavior holdtap_behavior_common &
    keycode.hold.reg.mod.lsft &
    tap in


# Home Row Mod Segments

# Home Row Mods, Dvorak, LH
let LALTT_A = LALT_T kc.A in
let LGUIT_O = LGUI_T kc.O in
let LCTLT_E = LCTL_T kc.E in
let LSFTT_U = LSFT_T kc.U in

# Home Row Mods, Dvorak, RH
# Use LHS mods instead of RHS.
let RSFTT_H = LSFT_T kc.H in
let RCTLT_T = LCTL_T kc.T in
let RGUIT_N = LGUI_T kc.N in
let RALTT_S = LALT_T kc.S in

# Alphabetical Segments, Dvorak
let SEG5_DVORAK_LHS_1 = [
  kc.QUOT, kc.COMM, kc.DOT,  kc.P,    kc.Y,
] in
let SEG5_DVORAK_LHS_2 = [
  LALTT_A, LGUIT_O, LCTLT_E, LSFTT_U, kc.I,
] in
let SEG5_DVORAK_LHS_3 = [
  kc.SCLN, kc.Q,    kc.J,    kc.K,    kc.X,
] in

let SEG5_DVORAK_RHS_1 = [
  kc.F,    kc.G,    kc.C,    kc.R,    kc.L,
] in
let SEG5_DVORAK_RHS_2 = [
  kc.D,    RSFTT_H, RCTLT_T, RGUIT_N, RALTT_S,
] in
let SEG5_DVORAK_RHS_3 = [
  kc.B,    kc.M,    kc.W,    kc.V,    kc.Z,
] in


# Enter/NSSL on medial key.

#  define THUMB_ROW TAB_MOUR, ESC_MEDR, SPC_NAVR,    ENT_NSSL, BKSP_NSL, DEL_FUNL
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
  TTTT, TTTT, TTTT, TTTT, TTTT,               kc.LEFT, kc.DOWN, kc.UP,   kc.RGHT, kc.CAPS,
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
  TTTT, TTTT, TTTT, TTTT, TTTT,                TTTT,    TTTT,    TTTT,    TTTT,    TTTT,
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

# Layout definition
base_layers @ supplemental_layers
