# A trivial layout for half of a split 3x5+3,
# used to check the keyswitches have all been soldered directly
# (especially the RHS).
#
# Additionally, the bootloader can be entered by tapping the two rightmost corner keys.
#
# use by e.g. replacing ncl/keyboard.ncl with:
#   import "keymaps/split_3x5_3/checkkeys/keymap-half.ncl"

let { combo, tap, .. } = import "../../../fak/keycode.ncl" in

# Prelude aliases
let kc = tap.reg.kc in

let rhs_corner_indices = [4, 14] in

# Keymap definition
{
  virtual_keys = [
    # four corners
    combo.make 255 rhs_corner_indices
  ],
  layers = [
    [
      kc.Q,  kc.W,  kc.E,  kc.R,  kc.T,
      kc.A,  kc.S,  kc.D,  kc.F,  kc.G,
      kc.Z,  kc.X,  kc.C,  kc.V,  kc.B,
      kc.N1, kc.N2, kc.N3,

      # combo key: four corners to enter bootloader
      tap.custom.fak.BOOT,
    ],
  ]
}
