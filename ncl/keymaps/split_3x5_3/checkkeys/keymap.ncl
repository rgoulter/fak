# A trivial layout for 3x5+3 keys
# used to check the keyswitches have all been soldered directly.
#
# Additionally, the bootloader can be entered by tapping the two leftmost corner keys.
#
# use by e.g. replacing ncl/keyboard.ncl with:
#   import "keymaps/split_3x5_3/checkkeys/keymap.ncl"

let { combo, tap, .. } = import "../../../fak/keycode.ncl" in

# Prelude aliases
let kc = tap.reg.kc in

let lhs_corner_indices = [0, 20] in

# Keymap definition
{
  virtual_keys = [
    # four corners
    combo.make 255 lhs_corner_indices
  ],
  layers = [
    [
      kc.Q,  kc.W,  kc.E,  kc.R,  kc.T,                    kc.Y,  kc.U,  kc.I,    kc.O,   kc.P,
      kc.A,  kc.S,  kc.D,  kc.F,  kc.G,                    kc.H,  kc.J,  kc.K,    kc.L,   kc.SCLN,
      kc.Z,  kc.X,  kc.C,  kc.V,  kc.B,                    kc.N,  kc.M,  kc.COMM, kc.DOT, kc.SLSH,
                           kc.N1, kc.N2, kc.N3,     kc.N4, kc.N5, kc.N6,

      # combo key: four corners to enter bootloader
      tap.custom.fak.BOOT,
    ],
  ]
}
