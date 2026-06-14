# Dashboard statistik zkoušek řidičů – Magistrát Jablonec n. N.

## Co je tento projekt

Webový dashboard pro přehled výsledků zkoušek řidičů (testy + jízdy) per autoškola, per měsíc.
Používají ho úředníci magistrátu.

## Soubory

- `index.html` – hlavní dashboard (výběr měsíce, přehled autoškol, grafy, modal detail autoškoly)
- `upload.html` – nahrávání xlsx souborů s daty do Supabase
- `setup.sql` – SQL pro vytvoření tabulek a RLS politik (spustit jednou v Supabase SQL editoru)

## Stack

- Čisté HTML/CSS/JS, žádný framework
- **Supabase** (PostgreSQL + REST API) – `@supabase/supabase-js@2`
- **Chart.js@4** – grafy v dashboardu
- **SheetJS xlsx@0.18.5** – parsování Excel souborů v upload.html

## Supabase

- URL: `https://yqpqtbhknjtoyzdbsuzv.supabase.co`
- Klíč: `sb_publishable_fqNSIFNzyYWfdMk3NmZqTA_ZqV-dAit` (publishable key, funguje s SDK v2)
- Tabulky: `zkousky_testy`, `zkousky_jizdy`
- Sloupce: `id, datum (TIMESTAMPTZ), autoskola, pokus_typ (první/opakovaný), hodnoceni (prospěl/neprospěl), mesic, rok, created_at`
- RLS: SELECT + INSERT + DELETE povoleno pro `anon` roli

## Formát dat v Excel souborech

Sloupce v xlsx:
- `Datum` – datum zkoušky, formát `DD.MM.YYYY H:MM:SS` (český formát s různými časy)
- `AŠ/SŠ` – název autoškoly
- `Pokus` – číslo pokusu, hodnota `1` = první pokus
- `Zkouška výsledek` – výsledek, hodnota `Ano` = prospěl

## Upload workflow

Upload automaticky detekuje typ dat podle počtu měsíců v souboru:
- **Jeden měsíc** → měsíční upload (přepíše existující data pro daný měsíc/rok, měsíc se auto-vyplní)
- **Více měsíců** → historický import (vloží vše bez mazání)

Sloupce a hodnoty se mapují automaticky podle názvů výše.

## Aktuální stav

- Dashboard funguje, připojení Supabase OK
- Upload funguje včetně parsování českého formátu data
- Modal detail autoškoly: kliknutí na název otevře přehled po rocích (počty zkoušek, úspěšnost, meziroční změna)
- Unikátní žáci v modalu nejsou – data neobsahují identifikátor žáka
