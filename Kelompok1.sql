-- -----------------------------------------------------
-- Schema academic_system
-- -----------------------------------------------------
CREATE DATABASE IF NOT EXISTS academic_system DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE academic_system;

-- -----------------------------------------------------
-- Table fakultas (Faculty)
-- -----------------------------------------------------
CREATE TABLE fakultas (
  id_fakultas INT NOT NULL AUTO_INCREMENT,
  kode_fakultas VARCHAR(10) NOT NULL,
  nama_fakultas VARCHAR(100) NOT NULL,
  status ENUM('Aktif', 'Tidak Aktif') NOT NULL DEFAULT 'Aktif',
  PRIMARY KEY (id_fakultas),
  UNIQUE INDEX kode_fakultas_UNIQUE (kode_fakultas ASC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table program_studi (Study Program)
-- -----------------------------------------------------
CREATE TABLE program_studi (
  id_prodi INT NOT NULL AUTO_INCREMENT,
  id_fakultas INT NOT NULL,
  kode_prodi VARCHAR(10) NOT NULL,
  nama_prodi VARCHAR(100) NOT NULL,
  jenjang ENUM('D3', 'D4', 'S1', 'S2', 'S3') NOT NULL,
  status ENUM('Aktif', 'Tidak Aktif') NOT NULL DEFAULT 'Aktif',
  PRIMARY KEY (id_prodi),
  UNIQUE INDEX kode_prodi_UNIQUE (kode_prodi ASC),
  INDEX fk_prodi_fakultas_idx (id_fakultas ASC),
  CONSTRAINT fk_prodi_fakultas
    FOREIGN KEY (id_fakultas)
    REFERENCES fakultas (id_fakultas)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table dosen (Lecturer)
-- -----------------------------------------------------
CREATE TABLE dosen (
  id_dosen INT NOT NULL AUTO_INCREMENT,
  id_prodi INT NOT NULL,
  nip VARCHAR(20) NULL,
  nama_lengkap VARCHAR(100) NOT NULL,
  gelar VARCHAR(50) NULL,
  email VARCHAR(100) NULL,
  jenis_kelamin ENUM('L', 'P') NULL,
  status ENUM('Aktif', 'Tidak Aktif') NOT NULL DEFAULT 'Aktif',
  PRIMARY KEY (id_dosen),
  UNIQUE INDEX email_UNIQUE (email ASC),
  INDEX fk_dosen_prodi_idx (id_prodi ASC),
  CONSTRAINT fk_dosen_prodi
    FOREIGN KEY (id_prodi)
    REFERENCES program_studi (id_prodi)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table mahasiswa (Student)
-- -----------------------------------------------------
CREATE TABLE mahasiswa (
  id_mahasiswa INT NOT NULL AUTO_INCREMENT,
  id_prodi INT NOT NULL,
  nim VARCHAR(20) NOT NULL,
  nama_lengkap VARCHAR(100) NOT NULL,
  email VARCHAR(100) NULL,
  jenis_kelamin ENUM('L', 'P') NULL,
  tanggal_lahir DATE NULL,
  tahun_masuk YEAR NOT NULL,
  status ENUM('Aktif', 'Tidak Aktif') NOT NULL DEFAULT 'Aktif',
  dosen_pembimbing INT NULL,
  PRIMARY KEY (id_mahasiswa),
  UNIQUE INDEX nim_UNIQUE (nim ASC),
  UNIQUE INDEX email_UNIQUE (email ASC),
  INDEX fk_mahasiswa_prodi_idx (id_prodi ASC),
  INDEX fk_mahasiswa_dosen_idx (dosen_pembimbing ASC),
  CONSTRAINT fk_mahasiswa_prodi
    FOREIGN KEY (id_prodi)
    REFERENCES program_studi (id_prodi)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_mahasiswa_dosen
    FOREIGN KEY (dosen_pembimbing)
    REFERENCES dosen (id_dosen)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table tahun_akademik (Academic Year)
-- -----------------------------------------------------
CREATE TABLE tahun_akademik (
  id_tahun_akademik INT NOT NULL AUTO_INCREMENT,
  tahun VARCHAR(9) NOT NULL COMMENT 'Format: 2023/2024',
  semester ENUM('Ganjil', 'Genap', 'Pendek') NOT NULL,
  tanggal_mulai DATE NOT NULL,
  tanggal_selesai DATE NOT NULL,
  status ENUM('Aktif', 'Tidak Aktif') NOT NULL DEFAULT 'Tidak Aktif',
  PRIMARY KEY (id_tahun_akademik),
  UNIQUE INDEX tahun_semester_UNIQUE (tahun ASC, semester ASC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table ruangan (Room)
-- -----------------------------------------------------
CREATE TABLE ruangan (
  id_ruangan INT NOT NULL AUTO_INCREMENT,
  nama_ruangan VARCHAR(100) NOT NULL,
  gedung VARCHAR(100) NULL,
  lantai INT NULL,
  kapasitas INT NULL DEFAULT 40,
  status ENUM('Aktif', 'Tidak Aktif') NOT NULL DEFAULT 'Aktif',
  PRIMARY KEY (id_ruangan)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table mata_kuliah (Course)
-- -----------------------------------------------------
CREATE TABLE mata_kuliah (
  id_mata_kuliah INT NOT NULL AUTO_INCREMENT,
  id_prodi INT NULL,
  kode_mata_kuliah VARCHAR(20) NOT NULL,
  nama_mata_kuliah VARCHAR(100) NOT NULL,
  sks INT NOT NULL DEFAULT 3,
  semester INT NOT NULL COMMENT 'Semester dalam kurikulum (1-8)',
  jenis ENUM('Wajib', 'Pilihan') NOT NULL DEFAULT 'Wajib',
  status ENUM('Aktif', 'Tidak Aktif') NOT NULL DEFAULT 'Aktif',
  PRIMARY KEY (id_mata_kuliah),
  UNIQUE INDEX kode_mata_kuliah_UNIQUE (kode_mata_kuliah ASC),
  INDEX fk_matkul_prodi_idx (id_prodi ASC),
  CONSTRAINT fk_matkul_prodi
    FOREIGN KEY (id_prodi)
    REFERENCES program_studi (id_prodi)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table kelas (Class)
-- -----------------------------------------------------
CREATE TABLE kelas (
  id_kelas INT NOT NULL AUTO_INCREMENT,
  id_tahun_akademik INT NOT NULL,
  id_mata_kuliah INT NOT NULL,
  id_dosen INT NOT NULL,
  kode_kelas VARCHAR(20) NOT NULL COMMENT 'Contoh: IF3210-A',
  kuota INT NOT NULL DEFAULT 40,
  status ENUM('Aktif', 'Tidak Aktif') NOT NULL DEFAULT 'Aktif',
  PRIMARY KEY (id_kelas),
  UNIQUE INDEX kode_kelas_tahun_UNIQUE (kode_kelas ASC, id_tahun_akademik ASC),
  INDEX fk_kelas_tahun_akademik_idx (id_tahun_akademik ASC),
  INDEX fk_kelas_matkul_idx (id_mata_kuliah ASC),
  INDEX fk_kelas_dosen_idx (id_dosen ASC),
  CONSTRAINT fk_kelas_tahun_akademik
    FOREIGN KEY (id_tahun_akademik)
    REFERENCES tahun_akademik (id_tahun_akademik)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_kelas_matkul
    FOREIGN KEY (id_mata_kuliah)
    REFERENCES mata_kuliah (id_mata_kuliah)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_kelas_dosen
    FOREIGN KEY (id_dosen)
    REFERENCES dosen (id_dosen)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table jadwal (Schedule)
-- -----------------------------------------------------
CREATE TABLE jadwal (
  id_jadwal INT NOT NULL AUTO_INCREMENT,
  id_kelas INT NOT NULL,
  id_ruangan INT NOT NULL,
  hari ENUM('Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu') NOT NULL,
  jam_mulai TIME NOT NULL,
  jam_selesai TIME NOT NULL,
  PRIMARY KEY (id_jadwal),
  INDEX fk_jadwal_kelas_idx (id_kelas ASC),
  INDEX fk_jadwal_ruangan_idx (id_ruangan ASC),
  CONSTRAINT fk_jadwal_kelas
    FOREIGN KEY (id_kelas)
    REFERENCES kelas (id_kelas)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_jadwal_ruangan
    FOREIGN KEY (id_ruangan)
    REFERENCES ruangan (id_ruangan)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table krs (Study Plan)
-- -----------------------------------------------------
CREATE TABLE krs (
  id_krs INT NOT NULL AUTO_INCREMENT,
  id_mahasiswa INT NOT NULL,
  id_tahun_akademik INT NOT NULL,
  tanggal_pengajuan DATE NULL,
  status ENUM('Draft', 'Diajukan', 'Disetujui', 'Ditolak') NOT NULL DEFAULT 'Draft',
  id_dosen_pembimbing INT NULL COMMENT 'Dosen pembimbing akademik',
  tanggal_persetujuan DATE NULL,
  tanggal_penolakan DATE NULL,
  alasan_penolakan TEXT NULL,
  total_sks INT NOT NULL DEFAULT 0,
  PRIMARY KEY (id_krs),
  UNIQUE INDEX mahasiswa_tahun_UNIQUE (id_mahasiswa ASC, id_tahun_akademik ASC),
  INDEX fk_krs_mahasiswa_idx (id_mahasiswa ASC),
  INDEX fk_krs_tahun_akademik_idx (id_tahun_akademik ASC),
  INDEX fk_krs_dosen_idx (id_dosen_pembimbing ASC),
  CONSTRAINT fk_krs_mahasiswa
    FOREIGN KEY (id_mahasiswa)
    REFERENCES mahasiswa (id_mahasiswa)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_krs_tahun_akademik
    FOREIGN KEY (id_tahun_akademik)
    REFERENCES tahun_akademik (id_tahun_akademik)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_krs_dosen
    FOREIGN KEY (id_dosen_pembimbing)
    REFERENCES dosen (id_dosen)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table krs_detail (Study Plan Detail)
-- -----------------------------------------------------
CREATE TABLE krs_detail (
  id_krs_detail INT NOT NULL AUTO_INCREMENT,
  id_krs INT NOT NULL,
  id_kelas INT NOT NULL,
  status ENUM('Aktif', 'Batal') NOT NULL DEFAULT 'Aktif',
  PRIMARY KEY (id_krs_detail),
  UNIQUE INDEX krs_kelas_UNIQUE (id_krs ASC, id_kelas ASC),
  INDEX fk_krs_detail_kelas_idx (id_kelas ASC),
  CONSTRAINT fk_krs_detail_krs
    FOREIGN KEY (id_krs)
    REFERENCES krs (id_krs)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_krs_detail_kelas
    FOREIGN KEY (id_kelas)
    REFERENCES kelas (id_kelas)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table pertemuan (Class Session)
-- -----------------------------------------------------
CREATE TABLE pertemuan (
  id_pertemuan INT NOT NULL AUTO_INCREMENT,
  id_kelas INT NOT NULL,
  pertemuan_ke INT NOT NULL,
  tanggal DATE NOT NULL,
  jam_mulai TIME NOT NULL,
  jam_selesai TIME NOT NULL,
  topik VARCHAR(255) NULL,
  status ENUM('Terlaksana', 'Dibatalkan', 'Diganti') NOT NULL DEFAULT 'Terlaksana',
  PRIMARY KEY (id_pertemuan),
  INDEX fk_pertemuan_kelas_idx (id_kelas ASC),
  CONSTRAINT fk_pertemuan_kelas
    FOREIGN KEY (id_kelas)
    REFERENCES kelas (id_kelas)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table absensi_mahasiswa (Student Attendance)
-- -----------------------------------------------------
CREATE TABLE absensi_mahasiswa (
  id_absensi INT NOT NULL AUTO_INCREMENT,
  id_pertemuan INT NOT NULL,
  id_mahasiswa INT NOT NULL,
  status ENUM('Hadir', 'Sakit', 'Izin', 'Alpha') NOT NULL DEFAULT 'Alpha',
  waktu_absen DATETIME NULL,
  keterangan VARCHAR(255) NULL,
  PRIMARY KEY (id_absensi),
  UNIQUE INDEX pertemuan_mahasiswa_UNIQUE (id_pertemuan ASC, id_mahasiswa ASC),
  INDEX fk_absensi_pertemuan_idx (id_pertemuan ASC),
  INDEX fk_absensi_mahasiswa_idx (id_mahasiswa ASC),
  CONSTRAINT fk_absensi_pertemuan
    FOREIGN KEY (id_pertemuan)
    REFERENCES pertemuan (id_pertemuan)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_absensi_mahasiswa
    FOREIGN KEY (id_mahasiswa)
    REFERENCES mahasiswa (id_mahasiswa)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table nilai (Grade)
-- -----------------------------------------------------
CREATE TABLE nilai (
  id_nilai INT NOT NULL AUTO_INCREMENT,
  id_kelas INT NOT NULL,
  id_mahasiswa INT NOT NULL,
  nilai_tugas DECIMAL(5,2) NULL,
  nilai_uts DECIMAL(5,2) NULL,
  nilai_uas DECIMAL(5,2) NULL,
  nilai_akhir DECIMAL(5,2) NULL,
  grade CHAR(2) NULL COMMENT 'A, A-, B+, B, B-, C+, C, D, E',
  PRIMARY KEY (id_nilai),
  UNIQUE INDEX kelas_mahasiswa_UNIQUE (id_kelas ASC, id_mahasiswa ASC),
  INDEX fk_nilai_kelas_idx (id_kelas ASC),
  INDEX fk_nilai_mahasiswa_idx (id_mahasiswa ASC),
  CONSTRAINT fk_nilai_kelas
    FOREIGN KEY (id_kelas)
    REFERENCES kelas (id_kelas)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_nilai_mahasiswa
    FOREIGN KEY (id_mahasiswa)
    REFERENCES mahasiswa (id_mahasiswa)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
