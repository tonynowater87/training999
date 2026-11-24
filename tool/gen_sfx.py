# Usage: python3 tool/gen_sfx.py assets/audio/effect
"""Generate original retro (chiptune-style) sound effects as 16-bit mono WAV."""
import math
import random
import struct
import sys
import wave

RATE = 22050
random.seed(999)


def square(phase):
    return 1.0 if (phase % 1.0) < 0.5 else -1.0


def triangle(phase):
    p = phase % 1.0
    return 4 * p - 1 if p < 0.5 else 3 - 4 * p


def sweep(f0, f1, dur, wave_fn=square, vol=0.5, decay=3.0, vibrato=0.0):
    out, phase = [], 0.0
    n = int(dur * RATE)
    for i in range(n):
        t = i / n
        f = f0 + (f1 - f0) * t
        if vibrato:
            f *= 1 + vibrato * math.sin(2 * math.pi * 12 * i / RATE)
        phase += f / RATE
        env = math.exp(-decay * t) * min(1.0, i / (0.004 * RATE) + 1e-9)
        out.append(wave_fn(phase) * vol * env)
    return out


def notes(freqs, note_dur, wave_fn=square, vol=0.45, last_hold=1.0):
    out = []
    for idx, f in enumerate(freqs):
        dur = note_dur * (last_hold if idx == len(freqs) - 1 else 1.0)
        out += sweep(f, f, dur, wave_fn, vol, decay=2.0)
    return out


def noise(dur, vol=0.6, decay=4.0, smooth=1):
    out, prev = [], 0.0
    n = int(dur * RATE)
    for i in range(n):
        t = i / n
        v = random.uniform(-1, 1)
        prev = prev + (v - prev) / smooth  # simple low-pass
        out.append(prev * vol * math.exp(-decay * t))
    return out


def mix(*tracks):
    n = max(len(t) for t in tracks)
    return [sum(t[i] for t in tracks if i < len(t)) for i in range(n)]


def fade_out(samples, dur=0.01):
    k = int(dur * RATE)
    for i in range(min(k, len(samples))):
        samples[-1 - i] *= i / k
    return samples


def write(path, samples):
    samples = fade_out(samples)
    with wave.open(path, 'wb') as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(RATE)
        w.writeframes(b''.join(
            struct.pack('<h', int(max(-1, min(1, s)) * 32767)) for s in samples))


SOUNDS = {
    'graze': lambda: sweep(1800, 2600, 0.06, square, 0.25, decay=5),
    'item_ready': lambda: notes([880, 1320], 0.08, triangle, 0.6),
    'shield_on': lambda: sweep(400, 1300, 0.28, square, 0.35, decay=1.5,
                               vibrato=0.05),
    'shield_break': lambda: mix(noise(0.3, 0.5, 6, smooth=2),
                                sweep(900, 180, 0.3, square, 0.3, decay=3)),
    'bomb': lambda: mix(noise(0.7, 0.8, 4, smooth=6),
                        sweep(120, 40, 0.5, triangle, 0.9, decay=3)),
    'slow': lambda: sweep(1100, 180, 0.55, triangle, 0.6, decay=1.0,
                          vibrato=0.08),
    'shrink': lambda: notes([1400, 1050, 700], 0.05, square, 0.35),
    'title_up': lambda: notes([523, 659, 784, 1047], 0.09, square, 0.35,
                              last_hold=2.5),
    'warning': lambda: notes([880, 660, 880, 660], 0.11, square, 0.22),
}

if __name__ == '__main__':
    out_dir = sys.argv[1]
    for name, make in SOUNDS.items():
        write(f'{out_dir}/{name}.wav', make())
        print('generated', name)
