# RHS-only half of CH552-36.
# Useful for checking the RHS is soldered correctly.

let ch552_36 = import "./keyboard.ncl"  in

let rhs = ch552_36.split.peripheral in
{
  matrix = rhs.matrix,
  mcu = rhs.mcu,
  keys = rhs.keys,
  usb_dev = ch552_36.usb_dev,
}
