#!/usr/bin/env python3
"""AI UX Analysis - Modern tech-themed background with neural network aesthetics.
Cool slate + teal palette. Clean, analytical, forward-looking."""
import os, sys

PAGE_W, PAGE_H = 794, 1123
# Cool slate + teal palette - professional, analytical, AI-themed
C = {
    'bg': '#f5f7fa',
    'slate': '#334155',
    'teal': '#0d9488',
    'teal_light': '#99f6e4',
    'gray': '#94a3b8',
    'gray_light': '#e2e8f0',
    'accent': '#14b8a6'
}

GRAIN = '<filter id="g"><feTurbulence type="fractalNoise" baseFrequency="0.65" numOctaves="3" stitchTiles="stitch" result="n"/><feColorMatrix type="saturate" values="0" in="n" result="m"/><feBlend in="SourceGraphic" in2="m" mode="multiply"/></filter>'

SVG = lambda body: f'<!DOCTYPE html><html><head><meta charset="utf-8"><style>*{{margin:0;padding:0}}body{{width:{PAGE_W}px;height:{PAGE_H}px;background:{C["bg"]}}}</style></head><body><svg width="{PAGE_W}" height="{PAGE_H}" xmlns="http://www.w3.org/2000/svg">{GRAIN}<rect width="100%" height="100%" fill="{C["bg"]}"/>{body}<rect width="100%" height="100%" filter="url(#g)" opacity="0.02"/></svg></body></html>'

# Cover: Neural network nodes + connection lines - represents AI decision making
COVER = SVG(f'''
<!-- Top-right: Abstract neural network visualization -->
<circle cx="620" cy="140" r="4" fill="{C['teal']}" opacity="0.8"/>
<circle cx="680" cy="100" r="3" fill="{C['teal']}" opacity="0.6"/>
<circle cx="720" cy="160" r="5" fill="{C['accent']}" opacity="0.7"/>
<circle cx="660" cy="200" r="3.5" fill="{C['teal']}" opacity="0.5"/>
<circle cx="700" cy="240" r="2.5" fill="{C['gray']}" opacity="0.4"/>
<circle cx="580" cy="180" r="3" fill="{C['gray']}" opacity="0.5"/>

<!-- Connection lines between nodes -->
<line x1="620" y1="140" x2="680" y2="100" stroke="{C['teal_light']}" stroke-width="0.8" opacity="0.6"/>
<line x1="680" y1="100" x2="720" y2="160" stroke="{C['teal_light']}" stroke-width="0.8" opacity="0.5"/>
<line x1="720" y1="160" x2="660" y2="200" stroke="{C['teal_light']}" stroke-width="0.8" opacity="0.6"/>
<line x1="660" y1="200" x2="620" y2="140" stroke="{C['teal_light']}" stroke-width="0.8" opacity="0.4"/>
<line x1="620" y1="140" x2="580" y2="180" stroke="{C['gray_light']}" stroke-width="0.6" opacity="0.5"/>
<line x1="660" y1="200" x2="700" y2="240" stroke="{C['gray_light']}" stroke-width="0.6" opacity="0.4"/>
<line x1="680" y1="100" x2="660" y2="200" stroke="{C['teal_light']}" stroke-width="0.6" opacity="0.3"/>
<line x1="720" y1="160" x2="700" y2="240" stroke="{C['gray_light']}" stroke-width="0.6" opacity="0.4"/>

<!-- Left accent: horizontal teal bar -->
<line x1="72" y1="420" x2="220" y2="420" stroke="{C['teal']}" stroke-width="2.5" opacity="0.9"/>
<line x1="72" y1="435" x2="160" y2="435" stroke="{C['teal_light']}" stroke-width="1" opacity="0.6"/>

<!-- Bottom-left: subtle node cluster -->
<circle cx="120" cy="950" r="3" fill="{C['gray']}" opacity="0.3"/>
<circle cx="160" cy="980" r="2.5" fill="{C['gray']}" opacity="0.25"/>
<circle cx="100" cy="1020" r="2" fill="{C['gray']}" opacity="0.2"/>
<line x1="120" y1="950" x2="160" y2="980" stroke="{C['gray_light']}" stroke-width="0.5" opacity="0.3"/>
<line x1="160" y1="980" x2="100" y2="1020" stroke="{C['gray_light']}" stroke-width="0.5" opacity="0.2"/>

<!-- Bottom rule -->
<line x1="72" y1="1060" x2="722" y2="1060" stroke="{C['slate']}" stroke-width="0.4" opacity="0.3"/>
''')

# Body: Minimal, clean - just subtle accents
BODY = SVG(f'''
<!-- Top hairline -->
<line x1="72" y1="48" x2="722" y2="48" stroke="{C['gray_light']}" stroke-width="0.4"/>
<!-- Bottom hairline -->
<line x1="72" y1="1075" x2="722" y2="1075" stroke="{C['gray_light']}" stroke-width="0.4"/>
<!-- Small teal dot accent -->
<circle cx="722" cy="48" r="2" fill="{C['teal']}" opacity="0.25"/>
''')

# Backcover: Mirror of cover aesthetics, calmer
BACK = SVG(f'''
<!-- Bottom-right: smaller node echo -->
<circle cx="680" cy="920" r="3.5" fill="{C['teal']}" opacity="0.5"/>
<circle cx="720" cy="960" r="2.5" fill="{C['accent']}" opacity="0.4"/>
<circle cx="640" cy="980" r="2" fill="{C['gray']}" opacity="0.3"/>
<line x1="680" y1="920" x2="720" y2="960" stroke="{C['teal_light']}" stroke-width="0.6" opacity="0.4"/>
<line x1="720" y1="960" x2="640" y2="980" stroke="{C['gray_light']}" stroke-width="0.5" opacity="0.3"/>

<!-- Left accent echo -->
<line x1="72" y1="820" x2="280" y2="820" stroke="{C['teal']}" stroke-width="1.8" opacity="0.7"/>
<line x1="72" y1="835" x2="200" y2="835" stroke="{C['teal_light']}" stroke-width="0.8" opacity="0.4"/>

<!-- Top rule echo -->
<line x1="72" y1="80" x2="722" y2="80" stroke="{C['slate']}" stroke-width="0.4" opacity="0.2"/>
''')

def _render(tpl, out):
    from playwright.sync_api import sync_playwright
    os.makedirs(out, exist_ok=True)
    pairs = list(tpl.items())
    with sync_playwright() as p:
        b = p.chromium.launch()
        pg = b.new_page(viewport={'width': PAGE_W, 'height': PAGE_H}, device_scale_factor=2)
        for n, h in pairs:
            pg.set_content(h)
            pg.screenshot(path=os.path.join(out, n), type='png')
            print(n)
        b.close()

if __name__=='__main__':
    out=sys.argv[1] if len(sys.argv)>1 else os.path.dirname(os.path.abspath(__file__))
    _render({'cover_bg.png':COVER,'backcover_bg.png':BACK,'body_bg.png':BODY},out)
    print("Done - AI UX Neural Backgrounds")
