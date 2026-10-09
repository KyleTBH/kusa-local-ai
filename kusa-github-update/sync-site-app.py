"""Copy the current Kusa PWA into the GitHub Pages site folder."""
from pathlib import Path
import shutil

ROOT = Path(__file__).resolve().parent
SOURCE = ROOT / 'web'
DESTINATION = ROOT / 'docs' / 'app'

if not SOURCE.is_dir():
    raise SystemExit('Could not find the web app folder.')

shutil.rmtree(DESTINATION, ignore_errors=True)
shutil.copytree(SOURCE, DESTINATION)
print(f'Updated hosted PWA files: {DESTINATION}')
