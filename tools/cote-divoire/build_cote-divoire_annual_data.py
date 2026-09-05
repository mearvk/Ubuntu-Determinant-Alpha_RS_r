#!/usr/bin/env python3
"""Build Cote d\'Ivoire annual statistical markdown records (1965-2026).

Sources fetched at build time. No interpolation. Missing observations remain N/A; 2026 is
marked incomplete unless a source reports a final annual observation. INS (Institut National de la Statistique) is the
preferred national primary family for table-level supplementation where a compatible
machine-readable series exists; FAOSTAT, World Bank WDI, and AQUASTAT via Our World in Data
provide the reproducible baseline. Mirrors tools/afghanistan/build_afghanistan_annual_data.py.
In a restricted environment every value resolves to N/A, a valid non-fabricated state.
"""
from pathlib import Path
import csv, io, json, zipfile, urllib.request

ROOT = Path('national/cote-divoire')
YEARS = range(1965, 2027)
FAO = 'https://bulks-faostat.fao.org/production/Production_Crops_Livestock_E_All_Data_(Normalized).zip'
OWID = 'https://ourworldindata.org/grapher/{slug}.csv?v=1&csvType=full&useColumnShortNames=false'
WB = 'https://api.worldbank.org/v2/country/CIV/indicator/{indicator}?format=json&per_page=100'
ENTITIES = {'Côte d\'Ivoire'}

def get(url):
    req = urllib.request.Request(url, headers={'User-Agent': 'Ubuntu.Determinant.Beta.Restricted Cote d\'Ivoire archive builder/1.0'})
    with urllib.request.urlopen(req, timeout=90) as r:
        return r.read()

def csv_rows(url):
    return list(csv.DictReader(io.StringIO(get(url).decode('utf-8-sig'))))

def wb(ind):
    try:
        data = json.loads(get(WB.format(indicator=ind)).decode())
        return {int(x['date']): x['value'] for x in (data[1] or []) if x.get('value') is not None}
    except Exception:
        return {}

def owid(slug):
    out = {}
    try:
        for r in csv_rows(OWID.format(slug=slug)):
            if r.get('Entity') in ENTITIES:
                try: out[int(r['Year'])] = r.get('Value')
                except (TypeError, ValueError): pass
    except Exception:
        pass
    return out

def fao():
    out = {}
    try:
        z = zipfile.ZipFile(io.BytesIO(get(FAO)))
        names = [n for n in z.namelist() if n.endswith('.csv') and 'Normalized' in n]
        name = names[0] if names else [n for n in z.namelist() if n.endswith('.csv')][0]
        for r in csv.DictReader(io.TextIOWrapper(z.open(name), 'utf-8-sig')):
            if r.get('Area') not in ENTITIES: continue
            try: y = int(r['Year'])
            except (TypeError, ValueError): continue
            if 1965 <= y <= 2025:
                out.setdefault((r.get('Item',''), r.get('Element',''), r.get('Unit','')), {})[y] = r.get('Value')
    except Exception:
        pass
    return out

series = {
    'GDP current LCU': wb('NY.GDP.MKTP.CN'),
    'GDP growth %': wb('NY.GDP.MKTP.KD.ZG'),
    'Agriculture value added % GDP': wb('NV.AGR.TOTL.ZS'),
    'Agriculture employment %': wb('SL.AGR.EMPL.ZS'),
    'Agricultural land %': wb('AG.LND.AGRI.ZS'),
    'Arable land %': wb('AG.LND.ARBL.ZS'),
    'Freshwater withdrawals m3': owid('annual-freshwater-withdrawals'),
    'Cereal production t': owid('cereal-production'),
    'Rice production t': owid('rice-production'),
    'Wheat production t': owid('wheat-production'),
    'Maize production t': owid('maize-production'),
    'Potato production t': owid('potato-production'),
    'Chicken meat production t': owid('chicken-meat-production'),
}
f = fao()

def find_fao(patterns, element='Production'):
    for (item, el, unit), vals in f.items():
        if el == element and all(p.lower() in item.lower() for p in patterns):
            return vals, item, unit
    return {}, 'N/A', 'N/A'

spec = {
    'soybean production t': find_fao(['soybeans']),
    'pig meat production t': find_fao(['meat, pig']),
    'cattle meat production t': find_fao(['meat, cattle']),
    'sheep meat production t': find_fao(['meat, sheep']),
    'goat meat production t': find_fao(['meat, goat']),
    'cow milk production t': find_fao(['milk, cow']),
    'eggs production t': find_fao(['eggs,']),
    'vegetables production t': find_fao(['vegetables']),
    'fruit production t': find_fao(['fruit']),
    'sugar cane production t': find_fao(['sugar cane']),
    'cassava production t': find_fao(['cassava']),
    'cattle stock': find_fao(['cattle'], 'Stocks'),
    'sheep stock': find_fao(['sheep'], 'Stocks'),
    'goats stock': find_fao(['goats'], 'Stocks'),
    'pigs stock': find_fao(['pigs'], 'Stocks'),
    'wheat area harvested': find_fao(['wheat'], 'Area harvested'),
    'rice area harvested': find_fao(['rice'], 'Area harvested'),
    'maize area harvested': find_fao(['maize'], 'Area harvested'),
    'wheat yield': find_fao(['wheat'], 'Yield'),
    'rice yield': find_fao(['rice'], 'Yield'),
    'maize yield': find_fao(['maize'], 'Yield'),
}

for y in YEARS:
    for fn in ['ECONOMY','AGRICULTURE','PRODUCE','FARMING_STATS','GRAINS','MEAT','LIVESTOCK','VEGETABLES','FRUIT','WATER']:
        lines = [f'# Cote d\'Ivoire {y} \u2014 {fn}', '', f'- **Year:** {y}', '- **Geography:** Republic of Côte d\'Ivoire, national aggregate', '- **Method:** source observations only; no interpolation or invented annual totals.', '- **Metadata:** see `./META.md` and `../META.md`.']
        if y == 2026:
            lines += ['', '> **2026 status:** Current-year data are incomplete/live. A final annual total is not manufactured.']
        lines += ['', '## Annual observations', '', '| Indicator | Value | Unit | Source |', '|---|---:|---|---|']
        def add(nm, val, unit, source):
            lines.append(f"| {nm} | {'N/A' if val in (None, '') else val} | {unit} | {source} |")
        if fn == 'ECONOMY':
            add('GDP', series['GDP current LCU'].get(y), 'LCU', 'World Bank WDI')
            add('GDP real growth', series['GDP growth %'].get(y), '%', 'World Bank WDI')
            add('Agriculture value added', series['Agriculture value added % GDP'].get(y), '% GDP', 'World Bank WDI')
        elif fn == 'AGRICULTURE':
            add('Agriculture value added', series['Agriculture value added % GDP'].get(y), '% GDP', 'World Bank WDI')
            add('Agricultural employment', series['Agriculture employment %'].get(y), '% employment', 'World Bank WDI')
            add('Agricultural land', series['Agricultural land %'].get(y), '% land area', 'World Bank WDI')
            add('Arable land', series['Arable land %'].get(y), '% land area', 'World Bank WDI')
            add('Cereal production', series['Cereal production t'].get(y), 'tonnes', 'FAO via Our World in Data')
        elif fn == 'FARMING_STATS':
            add('Cereal production', series['Cereal production t'].get(y), 'tonnes', 'FAO via Our World in Data')
            add('Wheat production', series['Wheat production t'].get(y), 'tonnes', 'FAO via Our World in Data')
            add('Rice production', series['Rice production t'].get(y), 'tonnes', 'FAO via Our World in Data')
            add('Maize production', series['Maize production t'].get(y), 'tonnes', 'FAO via Our World in Data')
            for n in ('wheat area harvested','rice area harvested','maize area harvested'):
                vals, item, unit = spec[n]; add(n, vals.get(y), unit, 'FAOSTAT QCL')
            for n in ('wheat yield','rice yield','maize yield'):
                vals, item, unit = spec[n]; add(n, vals.get(y), unit, 'FAOSTAT QCL')
            for n in ('cattle stock','sheep stock','goats stock','pigs stock'):
                vals, item, unit = spec[n]; add(n, vals.get(y), unit, 'FAOSTAT QCL')
        elif fn == 'PRODUCE':
            for n in ('soybean production t','sugar cane production t','cassava production t','vegetables production t','fruit production t'):
                vals, item, unit = spec[n]; add(n, vals.get(y), unit, 'FAOSTAT QCL')
        elif fn == 'GRAINS':
            add('Cereal production', series['Cereal production t'].get(y), 'tonnes', 'FAO via Our World in Data')
            add('Wheat production', series['Wheat production t'].get(y), 'tonnes', 'FAO via Our World in Data')
            add('Rice production', series['Rice production t'].get(y), 'tonnes', 'FAO via Our World in Data')
            add('Maize production', series['Maize production t'].get(y), 'tonnes', 'FAO via Our World in Data')
            for n in ('wheat area harvested','rice area harvested','maize area harvested'):
                vals, item, unit = spec[n]; add(n, vals.get(y), unit, 'FAOSTAT QCL')
            for n in ('wheat yield','rice yield','maize yield'):
                vals, item, unit = spec[n]; add(n, vals.get(y), unit, 'FAOSTAT QCL')
        elif fn == 'MEAT':
            for n in ('cattle meat production t','pig meat production t','sheep meat production t','goat meat production t'):
                vals, item, unit = spec[n]; add(n, vals.get(y), unit, 'FAOSTAT QCL')
            add('Chicken meat production', series['Chicken meat production t'].get(y), 'tonnes', 'FAO via Our World in Data')
        elif fn == 'LIVESTOCK':
            for n in ('cattle stock','sheep stock','goats stock','pigs stock'):
                vals, item, unit = spec[n]; add(n, vals.get(y), unit, 'FAOSTAT QCL')
            for n in ('cow milk production t','eggs production t'):
                vals, item, unit = spec[n]; add(n, vals.get(y), unit, 'FAOSTAT QCL')
        elif fn == 'VEGETABLES':
            vals, item, unit = spec['vegetables production t']; add('Vegetables production', vals.get(y), unit, 'FAOSTAT QCL')
        elif fn == 'FRUIT':
            vals, item, unit = spec['fruit production t']; add('Fruit production', vals.get(y), unit, 'FAOSTAT QCL')
        elif fn == 'WATER':
            add('Annual freshwater withdrawals', series['Freshwater withdrawals m3'].get(y), 'billion m\u00b3', 'AQUASTAT/World Bank via Our World in Data')
        lines += ['', '## Source notes', '- INS (Institut National de la Statistique) is the preferred national primary family for table-level replacement or supplementation where an equivalent series exists.', '- FAOSTAT Crops and livestock products (QCL) supplies item-level crop/livestock production, area, yield and stock observations (coverage from 1961).', '- World Bank WDI supplies reproducible macroeconomic, land and employment series.', '- AQUASTAT freshwater withdrawals are represented through the World Bank/Our World in Data series.', '- Definitions, revisions, flags and coverage remain source-controlled; missing observations remain `N/A`.', '', 'Generated by `tools/cote-divoire/build_cote-divoire_annual_data.py`.']
        p = ROOT / str(y); p.mkdir(parents=True, exist_ok=True); (p / f'{fn}.md').write_text('\n'.join(lines) + '\n', encoding='utf-8')
