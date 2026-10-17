# VIKOR-MATLAB

Excel tabanlı VIKOR çözüm programı · *Excel-based VIKOR solver for MATLAB*

[Türkçe](#türkçe) · [English](#english)

---

## Türkçe

Bu program, çok kriterli karar verme yöntemlerinden **VIKOR**'u MATLAB'da çalıştırır. Karar matrisi, kriter ağırlıkları ve kriter tipleri bir Excel dosyasından okunur. Sonuçlar aynı dosyada yeni bir sayfaya yazılır. Alternatif veya kriter eklemek ya da çıkarmak için yalnızca Excel dosyasını güncellemek yeterlidir; kodda değişiklik gerekmez.

Program şunları hesaplar:

- $S$ (grup faydası), $R$ (bireysel pişmanlık) ve $Q$ (VIKOR indeksi) değerleri ve sıraları (eşit değerlere ortalama sıra verilir)
- Kabul edilebilir avantaj (C1) ve kabul edilebilir istikrar (C2) koşulları
- Uzlaşık çözüm kümesi

### Gereksinimler

- MATLAB R2020a veya sonrası
- Ek araç kutusu gerekmez

### Dosyalar

| Dosya | Açıklama |
|---|---|
| `vikor_main.m` | Ana program ve fonksiyonlar |
| `vikor_veri.xlsx` | Örnek veri: G20 ülkelerinin sürdürülebilir kalkınma performansı (19 ülke, 7 kriter) |

### Excel dosyasının düzeni

Program yalnızca **ilk sayfayı** okur:

|  | C1 | C2 | … | Cn |
|---|---|---|---|---|
| Ağırlık | w1 | w2 | … | wn |
| Kriter Tipi | 1 / −1 | 1 / −1 | … | 1 / −1 |
| A1 | x11 | x12 | … | x1n |
| … | … | … | … | … |
| Am | xm1 | xm2 | … | xmn |

- **Ağırlık:** Toplamlarının 1 olması gerekmez; program ağırlıkları normalize eder.
- **Kriter Tipi:** 1 = fayda (büyük değer iyi), −1 = maliyet (küçük değer iyi).

### Kullanım

1. `vikor_main.m` ve Excel dosyasını aynı klasöre koyun ve bu klasörü MATLAB'da çalışma dizini (Current Folder) yapın.
2. Gerekirse kodun başındaki iki parametreyi değiştirin:
   ```matlab
   dosya = 'vikor_veri.xlsx';   % Excel dosyasının adı
   v     = 0.5;                 % Strateji ağırlığı (0 ≤ v ≤ 1)
   ```
3. `vikor_main.m` dosyasını çalıştırın.

Sonuçlar ekrana ve Excel dosyasındaki **VIKOR_Rankings** sayfasına yazılır. $S$, $R$, $Q$ değerleri ve sıraları A–G sütunlarında, DQ, C1, C2 ve uzlaşık çözüm kümesi ise I–J sütunlarında yer alır. Sayfa önceden varsa üzerine yazılır.

### Örnek çıktı (G20 verisi, v = 0,5)

| Alternatif | S | R | Q | Sıra (Q) |
|---|---|---|---|---|
| Almanya (A7) | 0,2771 | 0,0771 | 0,0000 | 1 |
| Birleşik Krallık (A18) | 0,2823 | 0,1033 | 0,0856 | 2 |
| İtalya (A10) | 0,3423 | 0,0946 | 0,1147 | 3 |

DQ = 0,0556 · C1 = 1 · C2 = 1 · Uzlaşık çözüm: **Almanya (A7)**

### Veri kaynağı

Örnek veri ve CRITIC ağırlıkları şu çalışmadan alınmıştır:

> Cayir Ervural, B. (2026). Evaluating the sustainable development performance of G20 economies using an integrated decision-making framework. *Journal of Engineering Management and Systems Engineering, 5*(1), 63–84. https://doi.org/10.56578/jemse050105

### Atıf

Bu programı kullanırsanız lütfen şu şekilde atıf yapın:

> Atalay, Ö. (2026). *VIKOR-MATLAB: Excel tabanlı VIKOR çözüm programı* (Sürüm 1.0) [Bilgisayar yazılımı]. Zenodo. https://doi.org/10.5281/zenodo.XXXXXXX

### Lisans

MIT Lisansı. Ayrıntılar için `LICENSE` dosyasına bakın.

---

## English

This program runs the **VIKOR** multi-criteria decision-making method in MATLAB. The decision matrix, criteria weights and criterion types are read from an Excel file, and the results are written to a new sheet of the same file. To add or remove alternatives or criteria, only the Excel file needs to be updated; the code does not change.

The program computes:

- $S$ (group utility), $R$ (individual regret) and $Q$ (VIKOR index) values and their rankings (ties receive average ranks)
- The acceptable advantage (C1) and acceptable stability (C2) conditions
- The compromise solution set

### Requirements

- MATLAB R2020a or later
- No additional toolboxes required

### Excel layout

Only the **first sheet** is read. Row 1 holds the criterion names, row 2 the weights (they do not need to sum to 1), and row 3 the criterion types (1 = benefit, −1 = cost). From row 4 onward, column A holds the alternative names and the remaining columns hold the decision matrix.

### Usage

1. Put `vikor_main.m` and the Excel file in the same folder and make it MATLAB's Current Folder.
2. Set the file name and the strategy weight `v` at the top of the script if needed.
3. Run `vikor_main.m`.

The results are printed to the command window and written to the **VIKOR_Rankings** sheet: $S$, $R$, $Q$ and their ranks in columns A–G, and DQ, C1, C2 and the compromise set in columns I–J.

### Citation

> Atalay, Ö. (2026). *VIKOR-MATLAB: Excel-based VIKOR solver* (Version 1.0) [Computer software]. Zenodo. https://doi.org/10.5281/zenodo.XXXXXXX

### License

MIT License. See `LICENSE`.
