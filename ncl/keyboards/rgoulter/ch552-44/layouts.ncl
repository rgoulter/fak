# Functions to support different layouts for the ch552-44.
#
# Virtual Keys not handled.
# Only 44 keys are returned for each layer.

let keycode = import "../../../fak/keycode.ncl" in

let XXXX = keycode.tap.none & keycode.hold.none in

{
  # Construct CH552-44 keymap from a split 3x5-3 keymap.
  lift_from_split_3x5_3 = fun split_3x5_3_keymap =>
    let lift_combo_key = fun split_3x5_3_combo_key =>
      let lift_index = fun split_3x5_3_index =>
        std.array.at split_3x5_3_index [
           0,  1,  2,  3,  4,          5,  6,  7,  8,  9,
          10, 11, 12, 13, 14,         15, 16, 17, 18, 19,
          20, 21, 22, 23, 24,         27, 28, 29, 30, 31,
                      35, 36, 37, 38, 39, 40,
        ] in
      let updated_key_indices = std.array.map lift_index split_3x5_3_combo_key.data.key_indices in
      let updated_data = std.record.update "key_indices" updated_key_indices split_3x5_3_combo_key.data in
      std.record.update "data" updated_data split_3x5_3_combo_key in
    let lift_layer = fun split_3x5_3_layer =>
      let l = fun idx => std.array.at idx split_3x5_3_layer in
      let remaining = std.array.slice 36 (std.array.length split_3x5_3_layer) split_3x5_3_layer in
      [
        l  0, l  1, l  2, l  3, l  4,             l  5, l  6, l  7, l  8, l  9,
        l 10, l 11, l 12, l 13, l 14,             l 15, l 16, l 17, l 18, l 19,
        l 20, l 21, l 22, l 23, l 24, XXXX, XXXX, l 25, l 26, l 27, l 28, l 29,
        XXXX, XXXX, XXXX, l 30, l 31, l 32, l 33, l 34, l 35, XXXX, XXXX, XXXX,
      ] @ remaining in
    {
      virtual_keys = std.array.map lift_combo_key split_3x5_3_keymap.virtual_keys,
      layers = std.array.map lift_layer split_3x5_3_keymap.layers,
    }
}
