# **LitTrack_RS2**
---

Seminarski rad iz predmeta Razvoj softvera 2 na Fakultetu informacijskih tehnologija u Mostaru.

---

## **Upute za pokretanje**

### **Backend setup**
1. Klonirati repozitorij
2. Extractovati: `fit-build-2026-01-14-env.zip`
3. Postaviti `.env` fajl u: `\LitTrack_RS2\litTrack`
4. Otvoriti `\LitTrack_RS2\litTrack` u terminalu i pokrenuti komandu:  
   `docker-compose up --build`

### **Frontend setup**
1. Vratiti se u root folder i locirati `fit-build-2026-01-14.zip` arhivu.
2. Extract arhive daje dva foldera: `Release` i `flutter-apk`.
3. U `Release` folderu pokrenuti: `littrack_desktop.exe`
4. Prije pokretanja mobilne aplikacije pobrinuti se da aplikacija već ne postoji na android emulatoru, ukoliko postoji, uraditi deinstalaciju iste
5. U `flutter-apk` folderu nalazi se fajl: `app-release.apk` Prenijeti ga na Android emulator. 

---

## **Kredencijali za prijavu**
---

### **Desktop aplikacija**

#### **Admin**
- Korisničko ime: `admin`
- Lozinka: `test`

#### **Radnik**
- Korisničko ime: `radnik`
- Lozinka: `test`

---

### **Mobilna aplikacija**

#### **Korisnik 1**
- Korisničko ime: `korisnik`
- Lozinka: `test`

#### **Korisnik 2**
- Korisničko ime: `korisnik2`
- Lozinka: `test`

---

## **Paypal kredencijali**
- Email: `sb-8ifc648690108@personal.example.com`
- Lozinka: `kSQ2O$SK`

---

## **RabbitMQ**
---

RabbitMQ je korišten za slanje mailova dobrodošlice korisnicima prilikom registracije.
