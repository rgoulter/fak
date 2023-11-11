# rgoulter's keyboard labs' CH552-48 keyboard.
#
# An Ortho 4x12 keyboard which fits in PyKey40 cases.
#
# e.g. use by replacing ncl/keyboard.ncl with:
#   import "keyboards/rgoulter/ch552-48/keyboard.ncl"

let { MatrixKey, .. } = import "../../../fak/keyboard.ncl" in
let { CH552T, .. } = import "../../../fak/mcus.ncl" in

{
  mcu = CH552T,
  # The matrix is 7x7
  matrix = {
    cols = [31, 30, 33, 34, 35, 13, 12],
    rows = [32, 14, 15, 16, 17, 10, 11]
  },
  usb_dev = {
    vendor_id = 65261, # 0xFEED
    product_id = 7,
    product_ver = 256, # 0x0100
  },
  # The keys are arranged in a 4x12 grid
  keys =
    let M = MatrixKey in
    [
        M 0 0, M 0 4, M 1 1, M 1 5, M 2 2, M 2 6, M 3 3, M 4 0, M 4 4, M 5 1, M 5 5, M 6 2,
        M 0 1, M 0 5, M 1 2, M 1 6, M 2 3, M 3 0, M 3 4, M 4 1, M 4 5, M 5 2, M 5 6, M 6 3,
        M 0 2, M 0 6, M 1 3, M 2 0, M 2 4, M 3 1, M 3 5, M 4 2, M 4 6, M 5 3, M 6 0, M 6 4,
        M 0 3, M 1 0, M 1 4, M 2 1, M 2 5, M 3 2, M 3 6, M 4 3, M 5 0, M 5 4, M 6 1, M 6 5,
    ]
}
