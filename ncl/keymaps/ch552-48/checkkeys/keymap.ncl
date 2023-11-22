# A trivial layout for ch552-48
# used to check the keyswitches have all been soldered directly.
#
# Additionally, the bootloader can be entered by tapping the four corner keys.
#
# use by e.g. replacing ncl/keyboard.ncl with:
#   import "keymaps/ch552-48/checkkeys/keymap.ncl"

let { combo, tap, .. } = import "../../../fak/keycode.ncl" in

# Prelude aliases
let kc = tap.reg.kc in

let four_corner_indices = [0, 11, 36, 47] in

# Keymap definition
{
  virtual_keys = [
    # four corners
    combo.make 255 four_corner_indices
  ],
  layers = [
    [
      kc.N0, kc.Q,  kc.W,  kc.E,  kc.R,  kc.T,  kc.Y,  kc.U,  kc.I,    kc.O,   kc.P,    kc.N4,
      kc.N1, kc.A,  kc.S,  kc.D,  kc.F,  kc.G,  kc.H,  kc.J,  kc.K,    kc.L,   kc.SCLN, kc.N5,
      kc.N2, kc.Z,  kc.X,  kc.C,  kc.V,  kc.B,  kc.N,  kc.M,  kc.COMM, kc.DOT, kc.SLSH, kc.N6,
      kc.N3, kc.N1, kc.N2, kc.N3, kc.N4, kc.N5, kc.N6, kc.N7, kc.N8,   kc.N9,  kc.N0,   kc.N7,

      # combo key: four corners to enter bootloader
      tap.custom.fak.BOOT,
    ],
  ]
}
