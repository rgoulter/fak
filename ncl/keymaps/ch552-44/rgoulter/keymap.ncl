# The split_3x5_3 rgoulter layout laid out onto ch552-44 keymap.
#
# use by e.g. replacing ncl/keyboard.ncl with:
#   import "keymaps/ch552-44/rgoulter/keymap.ncl"

let { combo, tap, .. } = import "../../../fak/keycode.ncl" in

let ch554_44_layouts = import "../../../keyboards/rgoulter/ch552-44/layouts.ncl" in
let split_3x5_3_layout = import "../../../layouts/split_3x5_3/rgoulter/layout.ncl" in

# Combo Indices definitions (common to CH552-44)
# the four corners of the alpha keys
let alphas_four_corner_indices = [0, 9, 20, 31] in
# the index & middle fingers on lower row, LHS ("CV" on QWERTY)
let lhs_lower_12_indices = [22, 23] in
# the index & middle fingers on lower row, RHS ("M," on QWERTY)
let rhs_lower_12_indices = [28, 29] in

# Convenience keycode definitions

# Desktop Keys
# Linux
let LINUX_DESKTOP_LEFT  = tap.reg.kc.LEFT & tap.reg.mod.lctl & tap.reg.mod.lalt in
let LINUX_DESKTOP_RIGHT = tap.reg.kc.RGHT & tap.reg.mod.lctl & tap.reg.mod.lalt in

# Keymap definition
{
  virtual_keys = [
    combo.make 255 alphas_four_corner_indices,
    combo.make 50 lhs_lower_12_indices,
    combo.make 50 rhs_lower_12_indices,
  ],
  layers =
    # the split_3x5_3 rgoulter layout, laid out on ch552-44
    let layout = ch554_44_layouts.split_3x5_3 split_3x5_3_layout in
    let combo_keys = [
      # Combo 0 (four corners of alpha keys): enter bootloader
      tap.custom.fak.BOOT,
      # Combo 1 (left lower): Desktop: Workspace left
      LINUX_DESKTOP_LEFT,
      # Combo 2 (right lower): Desktop: Workspace right
      LINUX_DESKTOP_RIGHT,
    ] in

    # Concatenate combo keys to each layer
    std.array.map
      (fun layer =>
        layer @ combo_keys)
      layout
}
