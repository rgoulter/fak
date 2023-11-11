# Functions to support different layouts for the ch552-44.
#
# Virtual Keys not handled.
# Only 44 keys are returned for each layer.

let keycode = import "../../../fak/keycode.ncl" in

let XXXX = keycode.tap.none & keycode.hold.none in

{
  # Construct CH552-44 layout from a 36-key layout.
  split_3x5_3 = fun split_3x5_3_layout =>
    let to_ch554_44_layer = fun split_3x5_3_layer =>
      let l = fun idx => std.array.at idx split_3x5_3_layer in
      [
        l  0, l  1, l  2, l  3, l  4,             l  5, l  6, l  7, l  8, l  9,
        l 10, l 11, l 12, l 13, l 14,             l 15, l 16, l 17, l 18, l 19,
        l 20, l 21, l 22, l 23, l 24, XXXX, XXXX, l 25, l 26, l 27, l 28, l 29,
        XXXX, XXXX, XXXX, l 30, l 31, l 32, l 33, l 34, l 35, XXXX, XXXX, XXXX,
      ]
    in
    std.array.map to_ch554_44_layer split_3x5_3_layout,
}
