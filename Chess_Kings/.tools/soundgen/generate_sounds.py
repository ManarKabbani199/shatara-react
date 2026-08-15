"""Procedural epic/cinematic sound pack generator for the Shatara conquest map.

Generates 44.1kHz 16-bit mono WAVs into Chess_Kings/assets/sounds/.
Requires only numpy. Run:  python generate_sounds.py
"""

import os
import wave

import numpy as np

SR = 44100
OUT = os.path.join(os.path.dirname(__file__), "..", "..", "assets", "sounds")


# ---------------------------------------------------------------- helpers
def t(dur):
    return np.arange(int(SR * dur)) / SR


def env_exp(dur, decay=6.0):
    """Exponential decay envelope."""
    return np.exp(-decay * t(dur) / dur)


def env_adsr(dur, a=0.02, d=0.08, s=0.7, r=0.15):
    n = int(SR * dur)
    e = np.ones(n) * s
    na, nd, nr = int(SR * a), int(SR * d), int(SR * r)
    e[:na] = np.linspace(0, 1, na)
    e[na:na + nd] = np.linspace(1, s, nd)
    e[-nr:] = np.linspace(s, 0, nr)
    return e[:n]


def sine(f, dur):
    return np.sin(2 * np.pi * f * t(dur))


def brass(freq, dur, vibrato=0.006, bright=1.0):
    """Brass-ish tone: harmonic stack + vibrato + soft attack."""
    tt = t(dur)
    vib = 1 + vibrato * np.sin(2 * np.pi * 5.2 * tt)
    sig = np.zeros_like(tt)
    for h in range(1, 8):
        sig += (bright / h ** 1.4) * np.sin(2 * np.pi * freq * h * vib * tt)
    return sig * env_adsr(dur, a=0.03, d=0.1, s=0.75, r=min(0.25, dur * 0.4))


def bell(freq, dur):
    """Bell/chime: fundamental + inharmonic partials, long decay."""
    tt = t(dur)
    sig = (np.sin(2 * np.pi * freq * tt) * np.exp(-4 * tt / dur)
           + 0.5 * np.sin(2 * np.pi * freq * 2.76 * tt) * np.exp(-7 * tt / dur)
           + 0.25 * np.sin(2 * np.pi * freq * 5.4 * tt) * np.exp(-10 * tt / dur))
    return sig


def timpani(freq, dur):
    """War drum / timpani hit: pitch-dropping sine + membrane noise."""
    tt = t(dur)
    pitch = freq * (1 - 0.35 * np.minimum(tt / 0.12, 1.0))
    phase = 2 * np.pi * np.cumsum(pitch) / SR
    sig = np.sin(phase) * env_exp(dur, decay=7)
    noise = np.random.randn(len(tt)) * env_exp(dur, decay=30) * 0.25
    return sig + noise


def metal(partials, dur, decay=9):
    """Metallic clang from inharmonic partials + onset noise."""
    tt = t(dur)
    sig = np.zeros_like(tt)
    for i, f in enumerate(partials):
        sig += (1 / (i + 1)) * np.sin(2 * np.pi * f * tt)
    sig *= env_exp(dur, decay=decay)
    sig += 0.3 * np.random.randn(len(tt)) * env_exp(dur, decay=60)
    return sig


def place(track, sig, at):
    """Mix sig into track starting at `at` seconds."""
    i = int(SR * at)
    end = min(i + len(sig), len(track))
    track[i:end] += sig[:end - i]


def norm(sig, peak=0.89):
    m = np.max(np.abs(sig))
    if m > 0:
        sig = sig / m * peak
    return np.tanh(sig)  # soft clip safety


def save(rel, sig):
    path = os.path.join(OUT, rel)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    data = (norm(sig) * 32767).astype(np.int16)
    with wave.open(path, "wb") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(SR)
        w.writeframes(data.tobytes())
    print(f"  {rel}: {len(data) / SR:.2f}s")


# ---------------------------------------------------------------- sounds
def s_hover():
    dur = 0.22
    tt = t(dur)
    sweep = np.sin(2 * np.pi * (1800 + 2600 * tt / dur) * tt)
    sig = sweep * env_exp(dur, decay=14) * 0.5
    sig += 0.12 * np.random.randn(len(tt)) * env_exp(dur, decay=18)
    save("map/hover.wav", sig * 0.6)


def s_click():
    dur = 0.35
    sig = timpani(95, dur)
    sig += 0.35 * metal([2400, 3600], dur, decay=40)
    save("map/click.wav", sig)


def s_locked():
    dur = 0.32
    sig = timpani(58, dur) * 1.1
    sig += 0.15 * sine(110, dur) * env_exp(dur, decay=12)
    save("map/locked.wav", sig)


def s_unlock():
    dur = 1.3
    tr = np.zeros(int(SR * dur))
    notes = [(261.6, 0.0), (329.6, 0.16), (392.0, 0.32), (523.3, 0.48)]
    for f, at in notes:
        place(tr, brass(f, 0.8), at)
    place(tr, timpani(90, 0.6), 0.48)
    place(tr, metal([3200, 4800], 0.5, decay=14), 0.48)
    save("map/unlock.wav", tr)


def s_victory():
    dur = 2.6
    tr = np.zeros(int(SR * dur))
    chords = [
        ([261.6, 329.6, 392.0], 0.0),    # C
        ([349.2, 440.0, 523.3], 0.55),   # F
        ([392.0, 493.9, 587.3], 1.1),    # G
        ([523.3, 659.3, 784.0], 1.6),    # C up
    ]
    for fs, at in chords:
        for f in fs:
            place(tr, brass(f, 1.0, bright=0.9), at)
        place(tr, timpani(75, 0.5), at)
    # cymbal swell at the end
    tt = t(0.9)
    cym = np.random.randn(len(tt)) * np.linspace(0.4, 0, len(tt)) * 0.35
    place(tr, cym, 1.6)
    save("map/victory.wav", tr)


def s_defeat():
    dur = 1.7
    tr = np.zeros(int(SR * dur))
    for f, at in [(220.0, 0.0), (174.6, 0.45), (146.8, 0.9)]:
        place(tr, brass(f, 0.85, vibrato=0.004, bright=0.55), at)
    place(tr, timpani(55, 1.0), 0.9)
    save("map/defeat.wav", tr)


def s_coins():
    dur = 0.85
    tr = np.zeros(int(SR * dur))
    rng = np.random.default_rng(7)
    at = 0.0
    for _ in range(9):
        f = rng.uniform(2600, 5200)
        place(tr, bell(f, 0.22) * 0.7, at)
        at += rng.uniform(0.05, 0.1)
    save("map/coins.wav", tr)


def s_battle_start():
    dur = 1.9
    tr = np.zeros(int(SR * dur))
    place(tr, brass(146.8, 1.5, vibrato=0.005, bright=1.1), 0.0)   # war horn D3
    place(tr, brass(220.0, 1.2, vibrato=0.005, bright=0.9), 0.35)  # + fifth
    at = 0.0                                        # drum roll
    step = 0.22
    while at < 1.2:
        place(tr, timpani(85, 0.18) * 0.5, at)
        at += step
        step = max(0.07, step * 0.82)
    save("map/battle_start.wav", tr)


def s_shop():
    dur = 0.6
    tr = np.zeros(int(SR * dur))
    place(tr, bell(1318.5, 0.5), 0.0)
    place(tr, bell(1760.0, 0.5), 0.12)
    save("map/shop.wav", tr)


def s_move():
    dur = 0.14
    sig = sine(190, dur) * env_exp(dur, decay=40)
    sig += 0.4 * np.random.randn(int(SR * dur)) * env_exp(dur, decay=90)
    save("move.wav", sig * 0.8)


def s_capture():
    dur = 0.5
    sig = metal([812, 1347, 2130, 3380], dur, decay=11)
    sig += 0.4 * timpani(110, dur)
    save("capture.wav", sig)


def s_check():
    dur = 0.55
    sig = brass(233.1, dur, vibrato=0.008, bright=1.2)   # Bb3 stab
    sig += brass(349.2, dur, vibrato=0.008, bright=0.8)
    save("check.wav", sig)


if __name__ == "__main__":
    print("Generating Shatara epic sound pack ->", os.path.abspath(OUT))
    s_hover(); s_click(); s_locked(); s_unlock(); s_victory(); s_defeat()
    s_coins(); s_battle_start(); s_shop(); s_move(); s_capture(); s_check()
    print("Done.")
