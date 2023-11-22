# The split_3x5_3 rgoulter layout laid out onto ch552-48 keymap.
#
# use by e.g. replacing ncl/keyboard.ncl with:
#   import "keymaps/ch552-48/rgoulter/keymap.ncl"

let { combo, tap, .. } = import "../../../fak/keycode.ncl" in

let ch554_48_layouts = import "../../../keyboards/rgoulter/ch552-48/layouts.ncl" in
let split_3x5_3_keymap = import "../../../keymaps/split_3x5_3/rgoulter/keymap.ncl" in

ch554_48_layouts.lift_from_split_3x5_3 split_3x5_3_keymap
