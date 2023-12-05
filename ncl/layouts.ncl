# Record with common layouts of
# the 3x10 grid of alphabetical keys.
# (QWERTY, Dvorak, etc.)

# Impl. Note: some syntax highlighters have dubious support for multiline strings
#  in Nickel. Putting the alpha layouts here works around that issue.

let keycode = import "fak/keycode.ncl" in

let
  fixup_alphas = fun alphas =>
    alphas |> std.string.replace_regex "\\s+" "" |> std.string.uppercase
in {
  colemak_dhm = m%"
    qwfpb jluy;
    arstg mneio
    zxcdv kh,./
  "%,
  # Miryoku's alphas have `;` on sym layer,
  # and `'` on base layer.
  colemak_dhm_miryoku = std.string.replace ";" "'" colemak_dhm,
  dvorak = m%"
    ',.py fgcrl
    aoeui dhtns
    ;qjkx bmwvz
  "%,
  # Miryoku's Dvorak layout uses '/'
  # to be more consistent with other alphas layouts.
  dvorak_miryoku = std.string.replace ";" "/" dvorak,
  halmak = m%"
    wlrbz ;qudj
    shnt, .aeoi
    fmvc/ gpxky
  "%,
  # Miryoku's alphas have `;` on sym layer,
  # and `'` on base layer.
  halmak_miryoku = std.string.replace ";" "'" halmak,
  qwerty = m%"
    qwert yuiop
    asdfg hjkl;
    zxcvb nm,./
  "%,
  # Miryoku's alphas have `;` on sym layer,
  # and `'` on base layer.
  qwerty_miryoku = std.string.replace ";" "'" qwerty,
  workman = m%"
    qdrwb jfup;
    ashtg yneoi
    zxmcv kl,./
  "%,
  # Miryoku's alphas have `;` on sym layer,
  # and `'` on base layer.
  workman_miryoku = std.string.replace ";" "'" workman,
} |> std.record.map_values fixup_alphas & {
  # Construct array with fak keycodes for each letter in the string.
  #
  # Casing is ignored; letters can be unshifted. i.e. "a1!" is treated the same as "A1!".
  #
  # e.g. lift_to_keycodes "qwerty" == [kc.Q, kc.W, kc.E, kc.R, kc.T, kc.Y]
  lift_to_keycodes = fun letters => letters
    |> std.string.uppercase
    |> std.string.characters
    |> std.array.map (fun c => keycode.tap.reg.kc."%{c}"),
  # Construct record where values are arrays fak keycodes for each letter,
  #  for the left and right hand side of each row.
  #
  # e.g. to_keycode_segments qwerty == { lhs1 = [kc.Q, kc.W, kc.E, kc.R, kc.T], ... }
  to_keycode_segments
    | doc "Splits an alphas layout into 5-char segments for the left and right sides of each row. `alphas` are the 30 'alphabetical' keys in the layout."
    = fun alphas => {
        lhs1 = alphas |> std.string.substring  0  5 |> lift_to_keycodes,
        rhs1 = alphas |> std.string.substring  5 10 |> lift_to_keycodes,
        lhs2 = alphas |> std.string.substring 10 15 |> lift_to_keycodes,
        rhs2 = alphas |> std.string.substring 15 20 |> lift_to_keycodes,
        lhs3 = alphas |> std.string.substring 20 25 |> lift_to_keycodes,
        rhs3 = alphas |> std.string.substring 25 30 |> lift_to_keycodes,
      }
}
