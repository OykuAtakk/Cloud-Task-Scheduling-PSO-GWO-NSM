# 📘 Hybrid PSO-GWO-NSM Tabanlı Bulut Bilişimde Görev Zamanlama

## 🧾 Proje Özeti

Bu proje, *“Task Scheduling in Cloud Computing Using Hybrid Optimization Algorithm”* başlıklı akademik çalışmadan ilham alınarak geliştirilmiştir. Bulut bilişim ortamında görevlerin sanal makinelere atanmasını optimize etmek amacıyla **PSO (Particle Swarm Optimization)**, **GWO (Grey Wolf Optimization)** ve **NSM (Neighborhood Search Mutation)** algoritmaları hibrit bir yapıda birleştirilmiştir.

MATLAB tabanlı bu sistem, farklı lider seçim stratejileri ile görevleri sanal makinelere verimli bir şekilde eşleştirir.

---

## 🎯 Amaç

Görev zamanlamasını optimize ederek aşağıdaki performans metriklerini iyileştirmek:

- ⏱️ **Makespan** (Toplam tamamlanma süresi)
- ⏳ **Ortalama bekleme süresi**
- ⚡ **Enerji tüketimi**
- ⚖️ **Yük dengesi**
- 💻 **Kaynak kullanımı**

---

## 📌 Kullanılan Yöntemler

### ⚙️ 1. PSO – Particle Swarm Optimization
- Görev atamaları parçacıklar (particles) ile temsil edilir.
- Her parçacığın hızı ve konumu iteratif olarak güncellenir.

### 🐺 2. GWO – Grey Wolf Optimization
- Alfa, beta ve delta liderleri sürüyü yönlendirerek çözüm uzayında arama yapar.
- Gri kurtların avlanma davranışı benzetilerek çözüm iyileştirilir.

### 🔁 3. NSM – Neighborhood Search Mutation
- Son iterasyonların ikinci yarısında yalnızca **alpha birey** için uygulanır.
- Komşu görev atamaları taranarak yerel iyileştirme yapılır.

### 🔢 4. CASE Tabanlı Lider Seçim Stratejileri

Aşağıdaki tablo, farklı `CASE` değerlerine göre lider seçim stratejilerini özetlemektedir:

| CASE | Alpha Seçimi   | Beta Seçimi  | Delta Seçimi          |
|------|----------------|--------------|------------------------|
| 1    | En iyi         | Turnuva      | Sıralı                 |
| 2    | En iyi         | FDB          | Rulet                 |
| 3    | Sıralı (1-2-3) | Sıralı       | Sıralı                 |
| 4    | Rulet          | FDB          | En iyi                 |
| 5    | Rastgele       | Turnuva      | Sıralı                 |
| 6    | En iyi         | FDB          | Alpha/Beta hariç ilk   |

---

## 🧠 Fitness Fonksiyonu

Toplam maliyet, aşağıdaki dört metriğin ağırlıklı ortalamasıyla hesaplanır:

cost = 0.4 * makespan ...
     + 0.3 * load_std ...
     + 0.2 * average_utilization ...
     + 0.1 * energy;
Bu fonksiyon ile hem verimlilik hem de yük dengesi sağlanması hedeflenmiştir.

## 🛠️ Kurulum ve Çalıştırma

1. MATLAB’i açın.
2. Tüm `.m` uzantılı dosyaları aynı klasöre yerleştirin.
3. Komut penceresine aşağıdaki komutu girin:
run_vm_scheduler
4. Sistem sizden 1–6 arasında bir CASE stratejisi seçmenizi isteyecektir.

## 🧪 Örnek Çıktı

```matlab
Lider seçim stratejisi (CASE 1-6) seçin: 5
CASE-5  En iyi maliyet = 1.5407
Görev-VM eşlemesi:
     3     3     1     4     1     1     4     1
     4     5     2     2     3     3     3     4
     5     3     2     3     1     5

## 📊 Simülasyon Parametreleri

| Parametre              | Değer |
|------------------------|-------|
| Görev sayısı           | 20    |
| Sanal makine sayısı    | 5     |
| Popülasyon büyüklüğü   | 50    |
| Maksimum iterasyon     | 150   |
