-- TẠO DATABASE
CREATE DATABASE BTL
GO

--Tạo bảng KHÁCH HÀNG
	CREATE TABLE tblKhachHang (
		sMaKH VARCHAR(10) NOT NULL,
		sTenKH NVARCHAR(20),
		sDiaChi NVARCHAR(50),
		sSoDT VARCHAR(12),	
		bGioiTinh BIT
		CONSTRAINT pk_tblKhachHang PRIMARY KEY(sMaKH)
	)
	GO 
	SELECT * FROM tblKhachHang

-- Tạo Bảng NHÂN VIÊN 
	CREATE TABLE tblNhanVien(
		sMaNV VARCHAR(10),
		sTenNV NVARCHAR(20),
		bGioiTinh BIT,
		sDiaChi NVARCHAR(50),
		sSoDT CHAR(12),
		fHSL FLOAT,
		dNgaySinh DATETIME,
		dNgayVaoLam DATETIME,
		CONSTRAINT pk_tblNhanVien PRIMARY KEY(sMaNV)
	)
	GO
-- Tạo bảng tblNCC
	CREATE TABLE tblNCC(
		sMaNCC VARCHAR(10) NOT NULL, 
		sTenNCC NVARCHAR(50),
		sSDT VARCHAR(20),
		sDiaChi  NVARCHAR(50),
		CONSTRAINT pk_tblNCC PRIMARY KEY (sMaNCC)
	)
	GO
-- Tạo bảng tblHangHoa
	CREATE TABLE tblHangHoa(
		sMaMH VARCHAR(10) NOT NULL, 
		sTenMH NVARCHAR(50),
		sLoaiMH NVARCHAR(50),
		fGia FLOAT,
		fSoLuong FLOAT,
		sMaNCC VARCHAR(10),
		sDVT NVARCHAR(20),
		CONSTRAINT pk_tblHangHoa PRIMARY KEY (sMaMH),
		CONSTRAINT fk_tblHangHoa_tblNCC FOREIGN KEY (sMaNCC) REFERENCES tblNCC(sMaNCC),
	)
	GO
-- Tao bang tblDonNhapHang
	CREATE TABLE tblDonNhapHang(
		iSoHDN	INT NOT NULL,
		sMaNV VARCHAR(10) NOT NULL, 
		sNgayLap DATETIME,
		CONSTRAINT pk_tblDonNhapHang PRIMARY KEY (iSoHDN),
		CONSTRAINT fk_tblDonNhapHang_tblNhanVien FOREIGN KEY (sMaNV) REFERENCES tblNhanVien(sMaNV)
	)
	GO
-- Tạo bảng tblCTDonNhapHang
		CREATE TABLE tblCTDonNhapHang(
			iSoHDN INT NOT NULL,
			sMaMH VARCHAR(10) NOT NULL,   
			fSoLuong FLOAT, 
			fGiaNhap FLOAT,
			CONSTRAINT fk_tblCTDonNhapHang_tblDonNhapHang FOREIGN KEY (iSoHDN) REFERENCES tblDonNhapHang(iSoHDN),
			CONSTRAINT fk_tblCTDonNhapHang_tblMatHang FOREIGN KEY (sMaMH) REFERENCES tblHangHoa(sMaMH)
		)
		GO
	-- Tao bang tblHoaDon
	CREATE TABLE tblHoaDon(
		iSoHD INT NOT NULL,
		sMaNV VARCHAR(10),
		sMaKH VARCHAR(10),
		dNgayBan DATETIME,
		CONSTRAINT pk_tblHoaDon PRIMARY KEY (iSoHD),
		CONSTRAINT fk_tblHoaDon_tblNhanVien FOREIGN KEY (sMaNV) REFERENCES tblNhanVien(sMaNV),
		CONSTRAINT fk_tblHoaDon_tblKhachHang FOREIGN KEY (sMaKH) REFERENCES tblKhachHang(sMaKH)
	)

	-- Tao bang chi tiet hoa don 
	CREATE TABLE tblCTHoaDon(
		iSoHD INT NOT NULL,
		sMaMH VARCHAR(10), 
		fSoLuong FLOAT,
		fGiaBan FLOAT,
		fGiamGia FLOAT,
		CONSTRAINT pk_tblCTHoaDon PRIMARY KEY (iSoHD),
		CONSTRAINT fk_tblCTHoaDon_tblHoaDon FOREIGN KEY (iSoHD) REFERENCES tblHoaDon(iSoHD),
		CONSTRAINT fk_tblCTHoaDon_tblHangHoa FOREIGN KEY (sMaMH) REFERENCES tblHangHoa(sMaMH)
	)
	--Tao bang tai khoan 
	-- 1 => Admin
	-- 2 => Nhan Vien
	-- 3 => Khach hang
	CREATE TABLE tblTaiKhoan(
		sTenTK varchar(50) not null,
		sMatKhau varchar(50) not null,
		iRole int,
		sMaNV varchar(10),
		sMaKH varchar(10)
		CONSTRAINT pk_tblTaiKhoan PRIMARY KEY(sTenTK),
		CONSTRAINT fk_tblTaiKhoan_tblNhanVien FOREIGN KEY (sMaKH) REFERENCES tblKhachHang(sMaKH),
		CONSTRAINT fk_tblTaiKhoan_tblKhachHang FOREIGN KEY (sMaNV) REFERENCES tblNhanVien(sMaNV)
	)

	-- THÊM CÁC BẢN GHI 
	-- Thêm 10 KHÁCH HÀNG
	INSERT INTO tblKhachHang(sMaKH, sTenKH, sDiaChi, sSoDT, bGioiTinh) 
	VALUES 
		('KH001', N'Nguyễn Văn An', N'Hà Nội', '0123456789', 1),
		('KH002', N'Trần Thị Bình', N'Hồ Chí Minh', '0987654321', 0),
		('KH003', N'Lê Văn Căn', N'Đà Nẵng', '0365478912', 1),
		('KH004', N'Phạm Thị Duyên', N'Hải Phòng', '0657321890', 0),
		('KH005', N'Hồ Văn En', N'Quảng Ninh', '0765432198', 1),
		('KH006', N'Đặng Thị Nhân', N'Thái Bình', '0321890765', 0),
		('KH007', N'Vũ Văn Giang', N'Bắc Ninh', '0987654321', 1),
		('KH008', N'Trần Thị Hài', N'Hải Dương', '0123456789', 0),
		('KH009', N'Lê Văn Yêu', N'Bắc Giang', '0365478912', 1),
		('KH010', N'Nguyễn Thị Kiên', N'Hà Nam', '0657321890', 0);
	-- Vì ở đây nhà bán sách bans cả các văn phòng phẩm khác nên phải thêm các nhà cc cung cấp 
	-- vanư phong phẩm, đôf lưu niệm, sách, quà tăng
	-- Them bản ghi tblNCC	
	-- Thêm dữ liệu có ý nghĩa cho các nhà cung cấp vào bảng tblNCC
	INSERT INTO tblNCC(sMaNCC, sTenNCC, sSDT, sDiaChi) 
	VALUES 
		('NCC001', N'Văn Phòng Phẩm Vân Anh', '0123456789', N'123 Hoàng Diệu, Quận 1, Thành phố Hồ Chí Minh'),
		('NCC002', N'Cửa hàng Đồ Lưu Niệm Hạnh Phúc', '0987654321', N'456 Lê Lợi, Quận 2, Thành phố Hồ Chí Minh'),
		('NCC003', N'Nhà Sách Minh Trí', '0365478912', N'789 Nguyễn Huệ, Quận 3, Thành phố Hồ Chí Minh'),
		('NCC004', N'Công Ty Quà Tặng Sáng Tạo', '0657321890', N'321 Lê Thánh Tôn, Quận 4, Thành phố Hồ Chí Minh'),
		('NCC005', N'Cửa hàng Văn Phòng Phẩm Vũ Huy', '0765432198', N'987 Trần Hưng Đạo, Quận 5, Thành phố Hồ Chí Minh'),
		('NCC006', N'Công Ty Đồ Lưu Niệm Tuấn Anh', '0321890765', N'456 Nguyễn Đình Chiểu, Thành phố Hồ Chí Minh'),
		('NCC007', N'Nhà Sách Thanh Thảo', '0987654321', N'123 Bùi Viện, Quận 7, Thành phố Hồ Chí Minh'),
		('NCC008', N'Cửa hàng Quà Tặng Hoàng Long', '0123456789', N'147 Phạm Ngũ Lão, Quận 8, Thành phố Hồ Chí Minh'),
		('NCC009', N'Công Ty Văn Phòng Phẩm Minh Châu', '0365478912', N'369 Hồ Xuân Hương, Quận 9, Thành phố Hồ Chí Minh'),
		('NCC010', N'Cửa hàng Đồ Lưu Niệm Tú Uyên', '0657321890', N'258 rần Quang Khải, Quận 10, Thành phố Hồ Chí Minh');
	
	-- Thêm 20 bản ghi tblHangHoa với các mặt hàng gồm sách, văn phòng phẩm đồ lưu niệm của các nhà cung cấp
	-- Thêm dữ liệu có ý nghĩa cho các mặt hàng vào bảng tblHangHoa
	INSERT INTO tblHangHoa(sMaMH, sTenMH, sLoaiMH, fGia, fSoLuong, sMaNCC, sDVT) 
	VALUES 
		('MH001', N'Sách Toán 12', N'Sách', 150000, 50, 'NCC003', N'Quyển'),
		('MH002', N'Bút bi đỏ', N'Văn phòng phẩm', 5000, 100, 'NCC001', N'Cây'),
		('MH003', N'Quả cầu bay', N'Đồ lưu niệm', 20000, 30, 'NCC002', N'Cái'),
		('MH004', N'Sách Văn 10', N'Sách', 120000, 40, 'NCC003', N'Quyển'),
		('MH005', N'Tập vở ABC', N'Văn phòng phẩm', 8000, 80, 'NCC005', N'Cây'),
		('MH006', N'Bút mực xanh', N'Văn phòng phẩm', 7000, 60, 'NCC001', N'Cây'),
		('MH007', N'Quả cầu sáng', N'Đồ lưu niệm', 25000, 25, 'NCC002', N'Cái'),
		('MH008', N'Sách Lịch Sử 11', N'Sách', 160000, 35, 'NCC003', N'Quyển'),
		('MH009', N'Bìa còng A4', N'Văn phòng phẩm', 10000, 70, 'NCC005', N'Cái'),
		('MH010', N'Bút bi đen', N'Văn phòng phẩm', 5000, 90, 'NCC001', N'Cây'),
		('MH011', N'Chìa khóa trái tim', N'Đồ lưu niệm', 15000, 40, 'NCC002', N'Cái'),
		('MH012', N'Sách Hóa 11', N'Sách', 140000, 45, 'NCC003', N'Quyển'),
		('MH013', N'Tập vở ghi chú', N'Văn phòng phẩm', 7000, 65, 'NCC005', N'Cây'),
		('MH014', N'Bút bi xanh', N'Văn phòng phẩm', 5000, 85, 'NCC001', N'Cây'),
		('MH015', N'Quả cầu màu', N'Đồ lưu niệm', 30000, 20, 'NCC002', N'Cái'),
		('MH016', N'Sách Ngữ Văn 10', N'Sách', 130000, 55, 'NCC003', N'Quyển'),
		('MH017', N'Bìa còng A5', N'Văn phòng phẩm', 8000, 75, 'NCC005', N'Cái'),
		('MH018', N'Bút bi đỏ đen', N'Văn phòng phẩm', 6000, 95, 'NCC001', N'Cây'),
		('MH019', N'Chìa khóa hạnh phúc', N'Đồ lưu niệm', 20000, 30, 'NCC002', N'Cái'),
		('MH020', N'Sách Sinh Học 12', N'Sách', 170000, 25, 'NCC003', N'Quyển');


	-- Tạo 15 bản ghi cho tblNhanVien
	INSERT INTO tblNhanVien (sMaNV, sTenNV, bGioiTinh, sDiaChi, sSoDT, fHSL, dNgaySinh, dNgayVaoLam)
	VALUES
	('NV001', N'Nguyễn Văn An', 1, N'123 Lê Lợi, Quận 1, TP Hồ Chí Minh', '0123456789', 2.5, '1985-05-15', '2010-08-20'),
	('NV002', N'Trần Thị Bình', 0, N'456 Nguyễn Huệ, Quận 3, TP Hồ Chí Minh', '0987654321', 2.0, '1990-03-25', '2012-01-10'),
	('NV003', N'Lê Văn Cường', 1, N'789 Trần Phú, Quận Hải Châu, TP Đà Nẵng', '0365478912', 2.2, '1988-11-10', '2008-11-30'),
	('NV004', N'Phạm Thị Dung', 0, N'321 Hồ Tùng Mậu, Quận Hồng Bàng, TP Hải Phòng', '0657321890', 1.8, '1993-07-20', '2015-09-05'),
	('NV005', N'Hồ Văn Duy', 1, N'987  Lý Thái Tổ, Quận Ninh Kiều, TP Cần Thơ', '0765432198', 2.7, '1987-04-12', '2007-12-12'),
	('NV006', N'Đặng Thị Thanh', 0, N'456 Nguyễn Đình Chiểu TP Hải Dương', '0321890765', 2.1, '1991-09-30', '2013-06-20'),
	('NV007', N'Vũ Văn Dũng', 1, N'123 Trần Hưng Đạo, Quận Lê Chân, TP Hải Phòng', '0987654321', 2.3, '1989-02-18', '2011-04-15'),
	('NV008', N'Trần Thị Hà', 0, N'147 Phạm Hùng, Quận Mỹ An, TP Đà Nẵng', '0123456789', 2.4, '1992-08-05', '2014-03-08'),
	('NV009', N'Lê Văn Hùng', 1, N'369 Trần Hưng Đạo, Quận Vĩnh Yên, TP Vĩnh Phúc', '0365478912', 2.6, '1986-06-28', '2009-10-25'),
	('NV010', N'Nguyễn Thị Kim', 0, N'258 Lê Lai, Quận Hai Bà Trưng, TP Hà Nội', '0657321890', 2.9, '1984-12-03', '2006-07-02'),
	('NV011', N'Lê Văn Lợi', 1, N'789 Trần Phú, Quận Thanh Khê, TP Đà Nẵng', '0765432198', 2.8, '1983-10-08', '2005-11-15'),
	('NV012', N'Phạm Thị Mỹ', 0, N'321 Trần Phú, Quận Văn Quán, TP Hà Đông, Hà Nội', '0321890765', 1.5, '1995-01-22', '2016-08-30'),
	('NV013', N'Hoàng Văn Nam', 1, N'987 Hoàng Diệu, Quận Thanh Xuân, TP Hà Nội', '0987654321', 1.9, '1994-03-17', '2018-04-25'),
	('NV014', N'Nguyễn Thị Oanh', 0, N'456 Trần Hưng Đạo, Quận Ngô Quyền, TP Quảng Ninh', '0123456789', 2.2, '1988-07-05', '2010-12-10'),
	('NV015', N'Trần Văn Phong', 1, N'123 Lê Lợi, Quận Lê Chân, TP Hải Phòng', '0365478912', 2.3, '1987-05-30', '2009-09-20');


	-- Tạo 20 bản ghi hóa đơn: 
	-- Thêm dữ liệu có ý nghĩa cho các hóa đơn vào bảng tblHoaDon
	INSERT INTO tblHoaDon (iSoHD, sMaNV, sMaKH, dNgayBan)
	VALUES
		(1, 'NV001', 'KH001', '2024-03-10 08:15:00'),
		(2, 'NV002', 'KH002', '2024-03-11 10:30:00'),
		(3, 'NV003', 'KH003', '2024-03-12 11:45:00'),
		(4, 'NV004', 'KH004', '2024-03-13 14:20:00'),
		(5, 'NV005', 'KH005', '2024-03-14 09:10:00'),
		(6, 'NV006', 'KH006', '2024-03-15 13:05:00'),
		(7, 'NV007', 'KH007', '2024-03-16 12:30:00'),
		(8, 'NV008', 'KH008', '2024-03-17 15:40:00'),
		(9, 'NV009', 'KH009', '2024-03-18 09:55:00'),
		(10, 'NV010', 'KH010', '2024-03-19 11:20:00'),
		(11, 'NV011', 'KH010', '2024-03-20 10:15:00'),
		(12, 'NV012', 'KH010', '2024-03-21 13:50:00'),
		(13, 'NV013', 'KH008', '2024-03-22 08:45:00'),
		(14, 'NV014', 'KH009', '2024-03-23 16:30:00'),
		(15, 'NV015', 'KH004', '2024-03-24 14:25:00'),	
		(16, 'NV001', 'KH001', '2024-03-25 09:40:00'),
		(17, 'NV002', 'KH002', '2024-03-26 11:55:00'),
		(18, 'NV003', 'KH003', '2024-03-27 12:10:00'),
		(19, 'NV004', 'KH004', '2024-03-28 15:35:00'),
		(20, 'NV005', 'KH005', '2024-03-29 10:45:00');

	-- Thêm 30 bản ghi chi tiết hóa đơn với 1 hóa đơn thì có thể có 1-> 3 bản chi tiêt hóa đơn và nhiểu Mặt hàng trong mô
	-- một hóa đơn 
	-- Tao bang chi tiet hoa don 

	-- Thêm dữ liệu có ý nghĩa cho các bản ghi chi tiết hóa đơn vào bảng tblCTHoaDon
	INSERT INTO tblCTHoaDon (iSoHD, sMaMH, fSoLuong, fGiaBan, fGiamGia)
	VALUES
		(1, 'MH001', 2, 150000, 0),
		(1, 'MH002', 3, 5000, 0),
		(1, 'MH003', 1, 20000, 0),
		(2, 'MH004', 10, 120000, 0),
		(2, 'MH005', 22, 8000, 0),
		(3, 'MH006', 19, 7000, 0),
		(3, 'MH007', 17, 25000, 0),
		(4, 'MH008', 22, 160000, 0),
		(4, 'MH009', 11, 10000, 0),
		(5, 'MH010', 32, 5000, 0),
		(6, 'MH011', 10, 15000, 0),
		(7, 'MH012', 21, 140000, 0),
		(7, 'MH013', 10, 7000, 0),
		(8, 'MH014', 29, 5000, 0),
		(8, 'MH015', 12, 30000, 0),
		(9, 'MH016', 11, 130000, 0),
		(9, 'MH017', 31, 8000, 0),
		(10, 'MH018', 12, 6000, 0),
		(11, 'MH019', 11, 20000, 0),
		(11, 'MH020', 11, 170000, 0),
		(12, 'MH001', 41, 150000, 0),
		(13, 'MH002', 22, 5000, 0),
		(13, 'MH003', 12, 20000, 0),
		(14, 'MH004', 22, 120000, 0),
		(15, 'MH005', 12, 8000, 0),
		(15, 'MH006', 12, 7000, 0),
		(16, 'MH007', 32, 25000, 0),
		(17, 'MH008', 13, 160000, 0),
		(17, 'MH009', 22, 10000, 0),
		(18, 'MH010', 12, 5000, 0);


	-- Thêm 20 ban ghi đơn nhập hàng tblDonNhapHang
	-- Thêm dữ liệu có ý nghĩa cho các bản ghi đơn nhập hàng vào bảng tblDonNhapHang
	INSERT INTO tblDonNhapHang (iSoHDN, sMaNV, sNgayLap)
	VALUES
		(1, 'NV001', '2024-03-01'),
		(2, 'NV002', '2024-03-02'),
		(3, 'NV003', '2024-03-03'),
		(4, 'NV004', '2024-03-04'),
		(5, 'NV005', '2024-03-05'),
		(6, 'NV006', '2024-03-06'),
		(7, 'NV007', '2024-03-07'),
		(8, 'NV008', '2024-03-08'),
		(9, 'NV009', '2024-03-09'),
		(10, 'NV010', '2023-03-10'),
		(11, 'NV011', '2023-03-11'),
		(12, 'NV012', '2023-03-12'),
		(13, 'NV013', '2023-03-13'),
		(14, 'NV014', '2023-03-14'),
		(15, 'NV015', '2023-03-15'),
		(16, 'NV001', '2023-03-16'),
		(17, 'NV002', '2023-03-17'),
		(18, 'NV003', '2023-03-18'),
		(19, 'NV004', '2024-03-19'),
		(20, 'NV005', '2022-03-20');
		
	-- Thêm 30 bản ghi tblCTDonNhapHang
	-- Thêm dữ liệu có ý nghĩa cho các bản ghi chi tiết đơn nhập hàng vào bảng tblCTDonNhapHang
	INSERT INTO tblCTDonNhapHang (iSoHDN, sMaMH, fSoLuong, fGiaNhap)
	VALUES
		(1, 'MH001', 10, 500000),
		(1, 'MH002', 20, 300000),
		(1, 'MH003', 15, 100000),
		(2, 'MH004', 8, 70000),
		(2, 'MH005', 12, 80000),
		(2, 'MH006', 5, 15000),
		(3, 'MH007', 18, 2000),
		(3, 'MH008', 25, 6000),
		(4, 'MH009', 30, 4000),
		(4, 'MH010', 10, 9000),
		(5, 'MH011', 15, 12000),
		(5, 'MH012', 20, 11000),
		(6, 'MH013', 10, 18000),
		(6, 'MH014', 8, 25000),
		(7, 'MH015', 12, 3000),
		(7, 'MH016', 15, 7000),
		(8, 'MH017', 20, 6000),
		(8, 'MH018', 25, 8000),
		(9, 'MH019', 5, 900000),
		(9, 'MH020', 30, 5000),
		(10, 'MH009', 30, 4000),
		(11, 'MH010', 10, 9000),
		(12, 'MH011', 15, 12000),
		(13, 'MH012', 20, 11000),
		(14, 'MH013', 10, 18000),
		(15, 'MH014', 8, 25000),
		(16, 'MH015', 12, 3000),
		(17, 'MH016', 15, 7000),
		(18, 'MH017', 20, 6000),
		(19, 'MH018', 25, 8000),
		(20, 'MH019', 5, 9000),
		(20, 'MH020', 30, 5000);

	-- Thêm 10 bản ghi tblTaiKhoan với chỉ có 1 admin và 5 nhân viên và 4 khách hàng khác 
	-- 1 => Admin
	-- 2 => Nhan Vien
	-- 3 => Khach hang
	INSERT INTO tblTaiKhoan (sTenTK, sMatKhau, iRole, sMaNV, sMaKH)
	VALUES
		('admin', 'admin', 1, 'NV001', NULL), -- Admin
		('NV1', 'NVQL', 2, 'NV002', NULL), -- Nhân viên 1
		('NV2', 'NVQL', 2, 'NV003', NULL), -- Nhân viên 2
		('KH1', 'KH@123', 3, NULL, 'KH001'), -- Khách hàng 1
		('KH2', 'KH@123', 3, NULL, 'KH002'), -- Khách hàng 2
		('KH3', 'KH@123', 3, NULL, 'KH003'), -- Khách hàng 3
		('KH4', 'KH@123', 3, NULL, 'KH004'), -- Khách hàng 4
		('KH5', 'KH@123', 3, NULL, 'KH005'), -- Khách hàng 5
		('KH6', 'KH@123', 3, NULL, 'KH006'), -- Khách hàng 6
		('KH7', 'KH@123', 3, NULL, 'KH007'); -- Khách hàng 7
