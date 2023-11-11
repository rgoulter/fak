# A trivial layout for ch552-44
# used to check the keyswitches have all been soldered directly.
#
# Additionally, the bootloader can be entered by tapping the four corner keys.
#
# use by e.g. replacing ncl/keyboard.ncl with:
#   import "keymaps/ch552-44/checkkeys/keymap.ncl"

let { combo, tap, .. } = import "../../../fak/keycode.ncl" in

# Prelude aliases
let kc = tap.reg.kc in

let four_corner_indices = [0, 9, 32, 43] in

# Keymap definition
{
  virtual_keys = [
    # four corners
    combo.make 255 four_corner_indices
  ],
  layers = [
    [
      kc.Q,  kc.W,  kc.E,  kc.R,  kc.T,                    kc.Y,  kc.U,  kc.I,    kc.O,   kc.P,
      kc.A,  kc.S,  kc.D,  kc.F,  kc.G,                    kc.H,  kc.J,  kc.K,    kc.L,   kc.SCLN,
      kc.Z,  kc.X,  kc.C,  kc.V,  kc.B,  kc.BSLS, kc.SCLN, kc.N,  kc.M,  kc.COMM, kc.DOT, kc.SLSH,
      kc.N1, kc.N2, kc.N3, kc.N4, kc.N5, kc.LBRC, kc.RBRC, kc.N6, kc.N7, kc.N8,   kc.N9,  kc.N0,

      # combo key: four corners to enter bootloader
      tap.custom.fak.BOOT,
    ],
  ]
}
