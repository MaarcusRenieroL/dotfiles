#!/usr/bin/env python3
"""Render theme/templates/* from theme/palette.env into each tool's config.

Placeholders: @KEY@ (#rrggbb)  @KEY_BARE@ (rrggbb)  @KEY_A0X@ (0xffrrggbb)  @KEY_RGB@ (r;g;b, for ANSI 24-bit)
The first line of a template may be `# OUT: <path relative to repo root>`.
"""
import re, sys
from pathlib import Path

root = Path(__file__).resolve().parent.parent
pal = {}
for line in (root / "theme/palette.env").read_text().splitlines():
    line = line.strip()
    if line and not line.startswith("#"):
        k, v = line.split("=", 1)
        pal[k] = v

def variants(k, v):
    out = {k: v}
    if re.fullmatch(r"#[0-9a-fA-F]{6}", v):
        h = v[1:]
        out[k + "_BARE"] = h
        out[k + "_A0X"] = "0xff" + h
        out[k + "_RGB"] = ";".join(str(int(h[i:i + 2], 16)) for i in (0, 2, 4))
    return out

table = {}
for k, v in pal.items():
    table.update(variants(k, v))

count = 0
for tpl in sorted((root / "theme/templates").iterdir()):
    text = tpl.read_text()
    first, _, body = text.partition("\n")
    m = re.match(r"#+ OUT: (.+)", first.strip()) or re.match(r"-- OUT: (.+)", first.strip())
    if not m:
        sys.exit(f"{tpl.name}: missing 'OUT:' header")
    dest = root / m.group(1).strip()

    def rep(mo):
        key = mo.group(1)
        if key not in table:
            sys.exit(f"{tpl.name}: unknown placeholder @{key}@")
        return table[key]

    dest.parent.mkdir(parents=True, exist_ok=True)
    header = "GENERATED from theme/palette.env by theme/apply.py - do not edit by hand"
    rendered = re.sub(r"@([A-Z0-9_]+)@", rep, body.replace("@@GENERATED@@", header))
    dest.write_text(rendered)
    if tpl.name.endswith(".sh.tpl"):
        dest.chmod(0o755)
    count += 1
    print(f"  {tpl.name} -> {dest.relative_to(root)}")
print(f"rendered {count} files")
