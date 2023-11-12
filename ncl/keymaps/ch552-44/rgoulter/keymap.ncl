# The split_3x5_3 rgoulter layout laid out onto ch552-44 keymap.
#
# use by e.g. replacing ncl/keyboard.ncl with:
#   import "keymaps/ch552-44/rgoulter/keymap.ncl"

let { combo, tap, .. } = import "../../../fak/keycode.ncl" in

let ch554_44_layouts = import "../../../keyboards/rgoulter/ch552-44/layouts.ncl" in
let split_3x5_3_keymap = import "../../../keymaps/split_3x5_3/rgoulter/keymap.ncl" in

ch554_44_layouts.lift_from_split_3x5_3 split_3x5_3_keymap
