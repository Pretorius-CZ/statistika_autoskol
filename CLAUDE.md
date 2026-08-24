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
- Tabulka `zaloha_stav` (`tabulka` PK, `data` JSONB, `updated_at`) – jednoslotová záloha pro UNDO v upload.html, viz níže

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

## UNDO / záloha před uploadem

Před každým uploadem (monthly i historic) se aktuální celý obsah cílové tabulky (`zkousky_testy` nebo
`zkousky_jizdy`) uloží do `zaloha_stav` (přepíše předchozí zálohu – jeden slot na tabulku, ne historie).
Tlačítko „Vrátit zpět poslední nahrání" na kartě dané záložky (viditelné jen když záloha existuje) smaže
aktuální obsah tabulky a nahradí ho zálohou; po použití se záloha vyprázdní (jedno-krokové UNDO, ne
přepínač/redo). Řeší hlavně omylem nahraná data do špatné záložky (jízdy do testů a naopak) nebo špatný
soubor pro daný měsíc.

Tlačítko „Smazat vše" (mazání všech dat) bylo z upload.html odstraněno – nedávalo smysl vedle UNDO
mechanismu.

## Aktuální stav

- Dashboard funguje, připojení Supabase OK
- Upload funguje včetně parsování českého formátu data
- Upload má jedno-krokové UNDO (zaloha_stav) – viz výše
- Modal detail autoškoly: kliknutí na název otevře přehled po rocích (počty zkoušek, úspěšnost, meziroční změna)
- Unikátní žáci v modalu nejsou – data neobsahují identifikátor žáka
