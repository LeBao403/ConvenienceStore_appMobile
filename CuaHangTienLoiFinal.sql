--CREATE DATABASE CUA_HANG_TIEN_LOI_Final
--USE CUA_HANG_TIEN_LOI_Final


go
CREATE DATABASE CuaHangTienLoiFinal

go
USE CuaHangTienLoiFinal

-- Nhà cung cấp
CREATE TABLE NHACUNGCAP
(
	MANCC VARCHAR(10) NOT NULL,
	TENNCC NVARCHAR(200),
	DIACHI NVARCHAR(500),
	SDT CHAR(13),
	CONSTRAINT PK_NHACC PRIMARY KEY(MANCC)
)

--ALTER TABLE NHACUNGCAP
--ALTER COLUMN DIACHI NVARCHAR(500);

-- Danh mục
CREATE TABLE DANHMUC
(
	MADM INT IDENTITY(1,1),
	TENDM NVARCHAR(100),
	CONSTRAINT PK_DANHMUC PRIMARY KEY(MADM)
)


-- Sản phẩm
CREATE TABLE SANPHAM
(
	MASP INT IDENTITY(1,1) NOT NULL,
	TENSP NVARCHAR(100),
	MOTA NVARCHAR(MAX),
	GIABAN FLOAT,
	DVT NVARCHAR(50),
	SOLUONGTON INT,
	MADM INT,
	MANCC VARCHAR(10),
	ANH1 VARCHAR(500),
	ANH2 VARCHAR(500),
	ANH3 VARCHAR(500),
	CONSTRAINT PK_SANPHAM PRIMARY KEY(MASP),
	CONSTRAINT FK_SANPHAM_NHACC FOREIGN KEY (MANCC) REFERENCES NHACUNGCAP(MANCC),
	CONSTRAINT FK_SANPHAM_DANHMUC FOREIGN KEY (MADM) REFERENCES DANHMUC(MADM)
)




-- Phiếu nhập
CREATE TABLE PHIEUNHAP
(
	MAPN INT NOT NULL IDENTITY(1,1),
	NGAYNHAP DATE,
	MANCC VARCHAR(10),
	THANHTIEN FLOAT,
	CONSTRAINT PK_PHIEUNHAP PRIMARY KEY(MAPN),
	CONSTRAINT FK_PHIEUNHAP_NHACC FOREIGN KEY (MANCC) REFERENCES NHACUNGCAP(MANCC)
)
-- Chi tiết phiếu nhập
CREATE TABLE CHITIETPHIEUNHAP
(
	MAPN INT,
	MASP INT,
	SOLUONG INT,
	GIANHAP FLOAT,
	TONGTIEN FLOAT,
	CONSTRAINT PK_CHITIETPN PRIMARY KEY(MAPN, MASP),
	CONSTRAINT FK_CHITIETPN_PHIEUNHAP FOREIGN KEY (MAPN) REFERENCES PHIEUNHAP(MAPN),
	CONSTRAINT FK_CHITIETPN_SANPHAM FOREIGN KEY (MASP) REFERENCES SANPHAM(MASP)
)






CREATE TABLE KHACHHANG
(
	MAKH INT IDENTITY(1,1) NOT NULL,
	SDT VARCHAR(13),
	MATKHAU CHAR(100),
	TENKH NVARCHAR(50),
	DIACHI NVARCHAR(100),
	GIOITINH NVARCHAR(3), 
	HINHANH NVARCHAR(100), 
	CONSTRAINT PK_KHACHHANG PRIMARY KEY(MAKH),
	
)

CREATE TABLE TICHDIEM
(
	MAKH INT NOT NULL,
	DIEM FLOAT DEFAULT 0,
	NGAYCAPNHAT DATETIME DEFAULT GETDATE(),
	CONSTRAINT PK_TICHDIEM PRIMARY KEY(MAKH),
	CONSTRAINT FK_TICHDIEM_KHACHHANG FOREIGN KEY (MAKH) REFERENCES KHACHHANG(MAKH)
)

-- Đánh giá
CREATE TABLE DANHGIA
(
	MADANHGIA INT IDENTITY(1,1) NOT NULL,
	MATK INT,
	MASP INT,
	SOSAO INT,
	BINHLUAN NVARCHAR(200),
	NGAYDANHGIA DATETIME,
	CONSTRAINT PK_DANHGIA PRIMARY KEY(MADANHGIA),
	CONSTRAINT FK_DANHGIA_SANPHAM FOREIGN KEY (MASP) REFERENCES SANPHAM(MASP)
)

-- Khuyến mãi
CREATE TABLE KHUYENMAI
(
	
	MAKM CHAR(50),
	TENKH NVARCHAR(100),
	MASP INT,
	MUCGIAMGIA FLOAT,
	MOTA NVARCHAR(MAX),
	NGAYBD DATETIME,
	NGAYKT DATETIME,
	CONSTRAINT PK_KHUYENMAI PRIMARY KEY(MAKM),
	CONSTRAINT FK_KHUYENMAI_SANPHAM FOREIGN KEY (MASP) REFERENCES SANPHAM(MASP)
)

-- Đơn hàng
CREATE TABLE DONHANG
(
	MADH INT IDENTITY(1,1) NOT NULL,
	MAKH INT,
	PTTT INT,
	NGAYDAT DATE,
	THANHTIEN FLOAT,
	TRANGTHAITT NVARCHAR(50),
	TRANGTHAIGH NVARCHAR(50),
	CONSTRAINT PK_DONHANG PRIMARY KEY(MADH),
	CONSTRAINT FK_DONHANG_KHACHHANG FOREIGN KEY (MAKH) REFERENCES KHACHHANG(MAKH)
)


-- Chi tiết đơn hàng
CREATE TABLE CHITIETDH
(
	MADH INT,
	MASP INT,
	SOLUONG INT,
	DONGIA FLOAT,
	MAKM CHAR(50),
	TONGTIEN FLOAT,
	CONSTRAINT PK_CHITIETDH PRIMARY KEY(MADH, MASP),
	CONSTRAINT FK_CHITIETDH_DONHANG FOREIGN KEY (MADH) REFERENCES DONHANG(MADH),
	CONSTRAINT FK_CHITIETDH_SANPHAM FOREIGN KEY (MASP) REFERENCES SANPHAM(MASP),
	CONSTRAINT FK_CHITIETDH_KHUYENMAI FOREIGN KEY (MAKM) REFERENCES KHUYENMAI(MAKM),
)

-- Giỏ hàng
CREATE TABLE GIOHANG
(
	MAGH INT IDENTITY(1,1) NOT NULL,
	MAKH INT,
	CONSTRAINT PK_GIOHANG PRIMARY KEY(MAGH),
	CONSTRAINT FK_GIOHANG_KHACHHANG FOREIGN KEY (MAKH) REFERENCES KHACHHANG(MAKH)


)

-- Chi tiết giỏ hàng
CREATE TABLE CHITIETGH
(
	MAGH INT,
	MASP INT,
	SOLUONG INT,
	TONGTIEN FLOAT,
	CONSTRAINT PK_CHITIETGH PRIMARY KEY(MAGH, MASP),
	CONSTRAINT FK_CHITIETGH_GIOHANG FOREIGN KEY (MAGH) REFERENCES GIOHANG(MAGH),
	CONSTRAINT FK_CHITIETGH_SANPHAM FOREIGN KEY (MASP) REFERENCES SANPHAM(MASP)
)

CREATE TABLE NHANVIEN
(
    MANHANVIEN CHAR(10) PRIMARY KEY,
    USERNAME VARCHAR(100) NOT NULL,
    EMAIL VARCHAR(100) NOT NULL,
    PASS VARCHAR(100) NOT NULL,
    HINHANH NVARCHAR(MAX),
);



--select *from SANPHAM

-- Thêm địa chỉ
-- Tỉnh/Thành phố
CREATE TABLE TINHTHANH (
    MATINH CHAR(10) PRIMARY KEY,
    TENTINH NVARCHAR(100) NOT NULL
);

-- Quận/Huyện
CREATE TABLE QUANHUYEN (
    MAQUAN CHAR(10) PRIMARY KEY,
    TENQUAN NVARCHAR(100) NOT NULL,
    MATINH CHAR(10) NOT NULL,
);

-- Phường/Xã
CREATE TABLE PHUONGXA (
    MAPHUONG CHAR(10) PRIMARY KEY,
    TENPHUONG NVARCHAR(100) NOT NULL,
    MAQUAN CHAR(10) NOT NULL,
);

-- Địa chỉ giao hàng
CREATE TABLE DIACHIGIAOHANG (
    MAKH INT NOT NULL,
    MATINH CHAR(10) NOT NULL,
    MAQUANHUYEN CHAR(10) NOT NULL,
    MAPHUONGXA CHAR(10) NOT NULL,
    DIACHI_CHITIET NVARCHAR(MAX) NOT NULL,
    GHICHU NVARCHAR(MAX), 
);
CREATE TABLE CHINHANH
(
	MACN NVARCHAR(6),
	DIACHI NVARCHAR(MAX),
	CONSTRAINT PK_CHINHANH PRIMARY KEY(MACN)
)





ALTER TABLE QUANHUYEN
ADD FOREIGN KEY (MATINH) REFERENCES TINHTHANH(MATINH);

ALTER TABLE PHUONGXA
ADD FOREIGN KEY (MAQUAN) REFERENCES QUANHUYEN(MAQUAN);

ALTER TABLE DIACHIGIAOHANG
ADD FOREIGN KEY (MAKH) REFERENCES KHACHHANG(MAKH);

ALTER TABLE DIACHIGIAOHANG
ADD FOREIGN KEY (MATINH) REFERENCES TINHTHANH(MATINH);

ALTER TABLE DIACHIGIAOHANG
ADD FOREIGN KEY (MAQUANHUYEN) REFERENCES QUANHUYEN(MAQUAN);

ALTER TABLE DIACHIGIAOHANG
ADD FOREIGN KEY (MAPHUONGXA) REFERENCES PHUONGXA(MAPHUONG);

ALTER TABLE DONHANG
ADD MACN NVARCHAR(6)

ALTER TABLE DONHANG
ADD PTNHANHANG NVARCHAR(100)

ALTER TABLE DONHANG
ADD CONSTRAINT FK_DONHANG_CHINHANH FOREIGN KEY(MACN) REFERENCES CHINHANH(MACN)


ALTER TABLE DONHANG
ADD CONSTRAINT CK_TRANGTHAIGH
CHECK (TRANGTHAIGH IN (N'Đang xử lý', N'Đang giao', N'Đang chờ', N'Hoàn thành', N'Đã huỷ', N'Đã hủy'));

INSERT INTO CHINHANH
VALUES
('CN0001', N'537/29/2P Nguyễn Oanh, Phường 17, Gò Vấp, Thành phố Hồ Chí Minh'),
('CN0002', N'Đường ĐHT 02, Khu phố 04, Phường Đông Hưng Thuận, Quận 12, Thành phố Hồ Chí Minh')


INSERT INTO NHANVIEN (MANHANVIEN, USERNAME, EMAIL, PASS, HINHANH)
VALUES 
('NV001', N'nguyenvana', 'a@gmail.com', '123456', NULL),
('NV002', N'tranthib', 'b@yahoo.com', 'abc123', NULL),
('NV003', N'leductrung', 'trung@outlook.com', 'pass001', NULL);


-- Insert
-- Nhà cung cấp
INSERT INTO NHACUNGCAP (MANCC, TENNCC, DIACHI, SDT) VALUES
('NCC001', N'Công ty TNHH iWater', N'94/1C Đường Nguyễn Thị Minh Khai', '03800118000'),
('NCC002', N'Nước giải khát Tân Đô - Công ty TNHH Nước giải khát Tân Đô', N'Km 9,2 Đường Thăng Long Nội Bài', '0982958918'),
('NCC003', N'Gia công sữa Thanh Hằng - Công ty TNHH Thảo Dược Thanh Hằng', N'Thôn Yên Viên, Xã Vân Hà, Thị xã', '0934273737'),
('NCC004', N'Đà Lạt GAP Store', N'152 Điện Biên Phủ, Phường 6, Quận 3', '0838 202 720'),
('NCC005', N'Fresh From Farm', N'15A/53 Lê Thánh Tôn, phường Bến Nghé', '0982 277 739'),
('NCC006', N'Rau củ, Trái cây Việt - Công ty TNHH cung cấp trái cây Việt', N'Số 9, Ngõ 89, Đường Yên Thái', '0962929739'),
('NCC007', N'Thực phẩm Đại Thuận - Công ty Cổ phần hàng tiêu dùng Đại Thuận', N'Số 42 Củ Chi, P. Vĩnh Hải, TP. Nha Trang', '025883836825'),
('NCC008', N'Thực phẩm Hoàng Đông - Công ty TNHH Thực phẩm Hoàng Đông', N'Phòng 201, Nhà C6 Mai Động, Hà Nội', '02422182181');

-- Danh mục
INSERT INTO DANHMUC (TENDM) VALUES
(N'Nước giải khát'),
(N'Sữa'),
(N'Củ quả'),
(N'Trái cây tươi'),
(N'Thực phẩm khô');

-- Sản phẩm
INSERT INTO SANPHAM (TENSP, MOTA, GIABAN, DVT, SOLUONGTON, MADM, MANCC, ANH1, ANH2, ANH3) VALUES
(N'Xoài keo 1kg (trái từ 300g)', 
N'Như bạn đã biết thì xoài là một loại trái cây nhiệt đới phổ biến ở nước ta, được nhiều người dùng ưa chuộng. Loại trái cây này cực kỳ giàu chất xơ, vitamin, khoáng chất thiết yếu không chỉ giúp cung cấp chất dinh dưỡng cho cơ thể con người mà còn mang lại nhiều lợi ích tuyệt vời cho sức khỏe.', 
23900, N'kg', 45, 4, 'NCC006', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748762178/XoaiKeo1_sfqtz7.jpg','https://res.cloudinary.com/degzytdz5/image/upload/v1748762179/XoaiKeo2_rumy4j.jpg','https://res.cloudinary.com/degzytdz5/image/upload/v1748762180/XoaiKeo3_jjflu2.jpg'),

(N'Quýt giống Úc trái từ 120g trở lên', 
N'Quýt giống Úc tươi ngon, chất lượng, ngọt thanh. Quýt giống Úc được xem như là loại quýt ngon nhất thế giới. Quýt giống Úc có màu vàng ươm, quả hơi đẹp, trên vỏ quýt có các đốm tinh dầu to bóng. Các tép quýt mọng nước, có vị ngọt.', 
39000, N'kg', 30, 4, 'NCC006', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748762177/Quyt1_ljzffb.jpg','https://res.cloudinary.com/degzytdz5/image/upload/v1748762177/Quyt2_o9z90c.jpg','https://res.cloudinary.com/degzytdz5/image/upload/v1748762178/Quyt3_aklsas.jpg'),

(N'Thùng 12 hộp sữa tươi tiệt trùng có đường TH true MILK', 
N'Đảm bảo không sử dụng thêm hương liệu, vị ngon 100% đến từ sữa tươi từ trang trại của TH True Milk nên được các bà mẹ ưu tiên lựa chọn hàng đầu.', 
450000, N'Thùng', 38, 2, 'NCC003', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748762132/THtrueMilk1_gzcbsj.jpg','https://res.cloudinary.com/degzytdz5/image/upload/v1748762132/THtrueMilk2_ggrbzk.jpg','https://res.cloudinary.com/degzytdz5/image/upload/v1748762132/THtrueMilk3_d7hsr4.jpg'),

(N'Cà rốt', 
N'Cà rốt tươi ngon, màu cam tươi, vỏ trơn láng, có màu sáng. Cà rốt không bị mềm, dập hay bị héo. Cà rốt giòn ngọt, được lựa chọn cho nhiều món ngon.',
28000, N'kg', 12, 3, 'NCC005', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748762059/CaRot1_ixtyro.jpg','https://res.cloudinary.com/degzytdz5/image/upload/v1748762061/CaRot2_tldwng.jpg','https://res.cloudinary.com/degzytdz5/image/upload/v1748762059/CaRot3_b6gxmo.jpg');


-- Củ quả
INSERT INTO SANPHAM (TENSP, MOTA, GIABAN, DVT, SOLUONGTON, MADM, MANCC, ANH1, ANH2, ANH3) VALUES
(N'Bắp ngọt Mỹ hạt vàng óng ánh', 
N'Bắp ngọt Mỹ hạt vàng óng ánh là lựa chọn hoàn hảo cho những ai yêu thích rau củ tươi ngon. Được tuyển chọn từ những cánh đồng hữu cơ tại Mỹ, mỗi hạt bắp đều to, đều, mang vị ngọt thanh tự nhiên, không chất bảo quản. Loại bắp này lý tưởng để luộc, nướng, hoặc làm nguyên liệu cho các món salad, súp, mang lại bữa ăn gia đình vừa ngon miệng vừa bổ dưỡng, đồng thời cung cấp năng lượng dồi dào và hỗ trợ tiêu hóa.', 
25000, N'kg', 50, 3, 'NCC005', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748775904/bap1_ses6y5.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748775905/bap2_z0uwth.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748775904/bap3_zyil7o.jpg'),

(N'Bắp cải trắng Đà Lạt tươi mọng', 
N'Bắp cải trắng Đà Lạt tươi mọng được trồng tại vùng đất cao nguyên mát mẻ, nổi tiếng với khí hậu trong lành. Lá bắp cải xanh mướt, cuộn chặt, mọng nước, giàu vitamin C và chất xơ, giúp tăng cường sức đề kháng và hỗ trợ tiêu hóa. Loại rau này thích hợp để chế biến các món xào, canh, hoặc làm salad tươi mát, đảm bảo độ giòn ngọt tự nhiên, không sử dụng hóa chất, mang đến sự an tâm cho mọi bữa ăn gia đình.', 
18000, N'kg', 40, 3, 'NCC005', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748775905/bapcai1_duy6vn.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748775905/bapcai2_pwfte3.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748775907/bapcai3_atbacc.jpg'),

(N'Bắp cải tím organic cao cấp', 
N'Bắp cải tím organic cao cấp được trồng theo tiêu chuẩn hữu cơ, không sử dụng hóa chất hay phân bón tổng hợp, mang đến màu tím đặc trưng đầy cuốn hút. Loại rau củ này không chỉ đẹp mắt mà còn chứa nhiều chất chống oxy hóa, hỗ trợ sức khỏe tim mạch và làm đẹp da. Bắp cải tím thích hợp để làm các món luộc, nộm, hoặc trang trí món ăn cao cấp, đem lại trải nghiệm ẩm thực vừa ngon vừa tốt cho sức khỏe, phù hợp cho mọi lứa tuổi.', 
20000, N'kg', 35, 3, 'NCC005', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748775908/bapcaitim1_lde96x.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748775910/bapcaitim2_llm2ip.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748775912/bapcaitim3_ixso8q.jpg'),

(N'Bí đao hữu cơ không tẩm hóa chất', 
N'Bí đao hữu cơ không tẩm hóa chất được trồng tự nhiên trên đất sạch, mang đến vỏ xanh mướt, ruột trắng ngần, giàu nước và chất xơ. Loại củ này nổi tiếng với khả năng thanh nhiệt, hỗ trợ giảm cân và làm đẹp da nhờ chứa nhiều vitamin và khoáng chất. Bí đao rất phù hợp để nấu canh, làm nước ép giải nhiệt, hoặc chế biến các món ăn thanh đạm, giúp cơ thể nhẹ nhàng và khỏe mạnh, đặc biệt trong những ngày hè nóng bức.', 
15000, N'kg', 60, 3, 'NCC005', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748775913/bidao2_ykuoh1.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748775912/bidao1_xkelbv.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748775914/bidao3_fwqstd.png'),

(N'Bí đỏ Nhật Bản siêu ngon', 
N'Bí đỏ Nhật Bản siêu ngon với vỏ ngoài màu cam rực rỡ, ruột vàng óng, thịt bí bở mịn và ngọt tự nhiên. Loại củ này được trồng tại Nhật Bản theo phương pháp hiện đại, giàu vitamin A, giúp hỗ trợ thị lực, tăng cường sức đề kháng và cải thiện làn da. Bí đỏ phù hợp để hấp, nấu chè, làm bánh hoặc súp, mang đến hương vị đậm đà khó cưỡng, là nguyên liệu không thể thiếu trong các bữa ăn dinh dưỡng của gia đình.', 
22000, N'kg', 45, 3, 'NCC005', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748775917/bido2_jqkpmi.png', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748775915/bido1_zkyzj7.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748775918/bido3_gpighg.jpg'),

(N'Cà chua bi organic đỏ mọng', 
N'Cà chua bi organic đỏ mọng được trồng trên đất sạch theo tiêu chuẩn hữu cơ, không hóa chất, mang đến những quả cà chua căng tròn, đỏ tươi, chứa nhiều lycopene tốt cho tim mạch. Hương vị chua ngọt tự nhiên của cà chua bi rất thích hợp để ăn trực tiếp, làm salad, hoặc chế biến sốt, mang lại bữa ăn vừa ngon miệng vừa bổ dưỡng. Sản phẩm đảm bảo tươi mới, an toàn, là lựa chọn lý tưởng cho những ai yêu thích thực phẩm lành mạnh.', 
35000, N'kg', 30, 3, 'NCC005', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748775919/cachua1_exynij.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748775921/cachua2_myo5ch.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748775922/cachua3_vxstn9.jpg'),

(N'Dưa leo Nhật Bản giòn ngọt', 
N'Dưa leo Nhật Bản giòn ngọt được trồng tại các trang trại nổi tiếng ở Nhật, với vỏ xanh bóng, ruột giòn tan, vị ngọt nhẹ và không đắng. Loại dưa này giàu nước, vitamin K và các chất chống oxy hóa, hỗ trợ làm đẹp da, giải nhiệt cơ thể, đặc biệt tốt trong mùa hè. Dưa leo Nhật Bản thích hợp để ăn sống, ngâm chua, hoặc kết hợp trong các món salad thanh mát, mang đến sự tươi mới và dinh dưỡng cho mọi bữa ăn.', 
18000, N'kg', 50, 3, 'NCC005', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748775925/dualeo3_df0h1g.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748775924/dualeo2_gyhzhm.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748775923/dualeo1_ya6x88.jpg'),

(N'Hành tây đỏ New Zealand', 
N'Hành tây đỏ New Zealand được trồng theo phương pháp hiện đại tại vùng đất giàu dinh dưỡng, mang đến củ hành tây với vỏ tím đỏ, ruột trắng ngần, vị cay nhẹ và ngọt hậu. Loại củ này chứa nhiều chất chống oxy hóa, hỗ trợ giảm cholesterol và tăng cường sức khỏe tim mạch. Hành tây đỏ rất lý tưởng để làm salad, nướng, hoặc nấu các món ăn phương Tây, mang lại hương vị đậm đà và màu sắc bắt mắt cho từng món ăn.', 
30000, N'kg', 40, 3, 'NCC005', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748775927/hanhtay1_dyempu.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748775928/hanhtay2_i9emkz.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748775929/hanhtay3_ze39df.jpg'),

(N'Khoai lang mật Hàn Quốc', 
N'Khoai lang mật Hàn Quốc với vỏ tím mịn, ruột vàng óng, được trồng tại các cánh đồng nổi tiếng ở Hàn Quốc, mang đến vị ngọt đậm đà tự nhiên. Loại củ này giàu tinh bột, vitamin A và chất xơ, hỗ trợ tiêu hóa, tăng cường năng lượng và làm đẹp da. Khoai lang mật rất thích hợp để nướng, luộc, hoặc làm món tráng miệng hấp dẫn, là lựa chọn hoàn hảo cho những ai yêu thích thực phẩm lành mạnh và thơm ngon.', 
20000, N'kg', 55, 3, 'NCC005', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748775930/khoailang1_kdw5bw.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748775931/khoailang2_qrs4bc.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748775932/khoailang3_y3p7ze.jpg'),

(N'Khoai tây Pháp chất lượng cao', 
N'Khoai tây Pháp chất lượng cao được nhập khẩu trực tiếp từ Pháp, với vỏ vàng óng, ruột trắng mịn, giòn ngon khi chiên hoặc luộc. Loại củ này chứa nhiều carbohydrate và kali, cung cấp năng lượng dồi dào và hỗ trợ cơ bắp. Khoai tây Pháp rất lý tưởng để làm khoai tây chiên, nghiền, hoặc nấu súp, mang lại trải nghiệm ẩm thực phương Tây tuyệt vời, phù hợp cho mọi bữa ăn gia đình hoặc tiệc tùng.', 
25000, N'kg', 45, 3, 'NCC005', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748775934/khoaitay2_kyck98.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748775936/khoaitay3_ua4ni7.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748775934/khoaitay1_l9rkoo.jpg'),

(N'Nấm hương khô tự nhiên', 
N'Nấm hương khô tự nhiên được sấy khô từ những cây nấm tươi ngon nhất, giữ nguyên hương thơm đặc trưng và giá trị dinh dưỡng cao. Loại nấm này chứa nhiều vitamin D, hỗ trợ tăng cường miễn dịch, cải thiện sức khỏe xương và giúp cơ thể khỏe mạnh hơn. Nấm hương khô rất phù hợp để nấu canh, xào, hoặc làm nước dùng đậm đà, mang đến hương vị thơm ngon và bổ dưỡng cho các món ăn truyền thống.', 
120000, N'kg', 20, 3, 'NCC005', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748775937/namhuong1_dhjdxz.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748775938/namhuong2_k0vsnp.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748775939/namhuong3_sshkwq.jpg'),

(N'Ớt chuông vàng organic', 
N'Ớt chuông vàng organic được trồng trên đất sạch, không sử dụng hóa chất, mang đến những quả ớt vàng rực rỡ, giòn ngọt, chứa nhiều vitamin C và A. Loại ớt này không chỉ làm đẹp món ăn mà còn tăng cường sức đề kháng và hỗ trợ thị lực. Ớt chuông vàng rất thích hợp để xào, nướng, hoặc làm salad, mang lại hương vị tươi mới và màu sắc bắt mắt, là nguyên liệu không thể thiếu trong các bữa ăn hiện đại.', 
40000, N'kg', 25, 3, 'NCC005', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748775940/otchuong1_mwycbt.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748775941/otchuong2_fxuakv.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748775943/otchuong3_uayv8m.jpg'),

(N'Thơm Thái Lan chín cây', 
N'Thơm Thái Lan chín cây được thu hoạch từ các vườn trái cây nổi tiếng ở Thái Lan, với vỏ vàng óng, ruột vàng mọng nước, mang vị ngọt thanh đặc trưng. Loại trái này giàu vitamin C, hỗ trợ tiêu hóa, làm đẹp da và tăng cường sức đề kháng. Thơm Thái Lan rất phù hợp để ăn trực tiếp, ép nước, hoặc làm món tráng miệng mát lạnh, mang đến trải nghiệm trái cây đỉnh cao trong những ngày hè nóng bức.', 
35000, N'kg', 30, 3, 'NCC005', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748775944/thom1_uo0pfd.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748775945/thom2_mng5uv.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748775946/thom3_rvvjsw.jpg');

-- Nước giải khát
INSERT INTO SANPHAM (TENSP, MOTA, GIABAN, DVT, SOLUONGTON, MADM, MANCC, ANH1, ANH2, ANH3) VALUES
(N'Bí đao thanh nhiệt túi 500ml', 
N'Nước bí đao thanh nhiệt túi 500ml được chiết xuất 100% từ bí đao tươi tự nhiên, không sử dụng đường hóa học, mang lại vị ngọt thanh mát, giúp giải nhiệt cơ thể, hỗ trợ giảm cân và thanh lọc độc tố. Sản phẩm đóng gói tiện lợi, phù hợp cho mọi lứa tuổi, đặc biệt là trong những ngày hè oi bức hoặc khi cần bổ sung nước. Đây là thức uống lý tưởng để giữ cơ thể khỏe mạnh và tràn đầy năng lượng.', 
12000, N'chai', 100, 1, 'NCC002', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748775999/bidao1_pz35pg.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776000/bidao2_lvbq51.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776002/bidao3_tr2ayi.jpg'),

(N'Nước Boncha xanh mát lành', 
N'Nước Boncha xanh mát lành được làm từ những lá trà tự nhiên chất lượng cao, kết hợp với hương vị thanh mát, không chứa calo, giúp hydrat hóa cơ thể một cách hiệu quả. Sản phẩm được đóng chai tiện lợi, phù hợp cho dân văn phòng, học sinh hoặc những ai yêu thích lối sống lành mạnh. Boncha xanh không chỉ giải khát mà còn hỗ trợ tinh thần sảng khoái, là thức uống hoàn hảo cho mọi thời điểm trong ngày.', 
10000, N'chai', 120, 1, 'NCC002', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776003/boncha1_zaw95w.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776004/boncha2_cr8tkh.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776005/boncha3_p4bltb.jpg'),

(N'Trà C2 vị chanh tươi', 
N'Trà C2 vị chanh tươi mang đến hương vị chua nhẹ, ngọt thanh từ đường tự nhiên, được bổ sung vitamin C để tăng cường sức đề kháng và làm đẹp da. Sản phẩm đóng lon 330ml tiện lợi, dễ dàng mang theo, phù hợp để giải khát nhanh chóng trong những ngày bận rộn. Trà C2 không chỉ là thức uống sảng khoái mà còn mang lại cảm giác tươi mới, là lựa chọn yêu thích của giới trẻ hiện nay.', 
9000, N'lon', 150, 1, 'NCC002', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776007/c21_twzmft.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776008/c22_fkhhho.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776009/c23_ox3hbe.jpg'),

(N'Coca-Cola nguyên chất lon 330ml', 
N'Coca-Cola nguyên chất lon 330ml được sản xuất theo công thức bí truyền nổi tiếng toàn cầu, mang đến vị ga sảng khoái, ngọt dịu, giúp bạn cảm thấy tươi mới ngay từ ngụm đầu tiên. Sản phẩm đóng lon tiện lợi, lý tưởng để thưởng thức trong các buổi tụ tập bạn bè, tiệc tùng hoặc làm mới khẩu vị sau giờ làm việc căng thẳng. Coca-Cola không chỉ là thức uống mà còn là biểu tượng của niềm vui và sự kết nối.', 
11000, N'lon', 200, 1, 'NCC002', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776011/coca1_xuvfmm.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776012/coca2_obfwhd.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776013/coca3_sqfjgk.jpg'),

(N'Fanta cam tự nhiên lon 320ml', 
N'Fanta cam tự nhiên lon 320ml với hương vị cam chua ngọt đặc trưng, được bổ sung vitamin C từ nước cam nguyên chất, mang lại cảm giác sảng khoái tức thì. Sản phẩm có thiết kế lon bắt mắt, tiện lợi, phù hợp cho cả trẻ em và người lớn trong những ngày hè nắng nóng. Fanta cam không chỉ giải khát mà còn mang đến niềm vui và năng lượng, là thức uống lý tưởng cho mọi dịp vui chơi, giải trí.', 
10000, N'lon', 180, 1, 'NCC002', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776014/fanta1_nji6ku.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776016/fanta2_dsjzyn.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776017/fanta3_smtda8.jpg'),

(N'Nước ép Juss táo mèo', 
N'Nước ép Juss táo mèo được làm từ 100% trái táo mèo tươi, không chứa chất bảo quản, mang đến vị chua nhẹ, ngọt thanh tự nhiên, giàu chất chống oxy hóa giúp bảo vệ cơ thể. Sản phẩm đóng chai 500ml tiện lợi, phù hợp để uống hàng ngày, hỗ trợ tăng cường sức khỏe và làm đẹp da. Juss táo mèo là lựa chọn hoàn hảo cho những ai yêu thích thức uống thiên nhiên, vừa ngon miệng vừa tốt cho sức khỏe.', 
15000, N'chai', 90, 1, 'NCC002', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776019/Juss1_ysej5x.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776020/Juss2_gqyyny.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776022/Juss3_jfc8a2.jpg'),

(N'Mirinda cam lon 330ml', 
N'Mirinda cam lon 330ml mang đến hương vị cam đậm đà, sủi bọt nhẹ nhàng, tạo cảm giác tươi mới ngay từ ngụm đầu tiên. Sản phẩm được đóng lon tiện lợi, dễ dàng mang theo, phù hợp để thưởng thức tại nhà, đi picnic hoặc trong các buổi tiệc tùng. Mirinda cam không chỉ là thức uống giải khát mà còn mang lại niềm vui và sự hứng khởi, là lựa chọn yêu thích của mọi lứa tuổi, đặc biệt là giới trẻ.', 
10000, N'lon', 160, 1, 'NCC002', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776025/mirinda3_ronxno.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776024/mirinda2_oq7keu.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776023/mirinda1_mwpoqi.jpg'),

(N'Pepsi lon 330ml', 
N'Pepsi lon 330ml với vị ga mạnh mẽ, ngọt dịu đặc trưng, mang đến sự sảng khoái tức thì cho mọi khoảnh khắc trong ngày. Sản phẩm được đóng lon tiện lợi, dễ dàng mang theo, phù hợp để thưởng thức trong các buổi gặp gỡ bạn bè, tiệc tùng hoặc giải trí tại nhà. Pepsi không chỉ là thức uống mà còn là biểu tượng của phong cách trẻ trung, năng động, giúp bạn luôn tràn đầy năng lượng và cảm hứng.', 
11000, N'lon', 170, 1, 'NCC002', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776026/pepsi1_oo1oy4.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776028/pepsi2_slpd1g.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776029/pepsi3_gtuzot.jpg'),

(N'Sting dâu xanh năng lượng', 
N'Sting dâu xanh năng lượng kết hợp hương dâu tự nhiên với các thành phần tăng cường năng lượng, giúp bạn tỉnh táo và tràn đầy sức sống suốt ngày dài. Sản phẩm đóng lon 330ml tiện lợi, phù hợp cho học sinh, sinh viên hoặc người làm việc với cường độ cao. Sting dâu xanh không chỉ giải khát mà còn mang lại sự hứng khởi, là thức uống lý tưởng để tiếp thêm năng lượng cho những ngày bận rộn.', 
12000, N'lon', 140, 1, 'NCC002', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776031/sting1_mx8hf8.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776032/sting2_idpka9.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776034/sting3_uk8kmw.jpg'),

(N'Trà xanh không độ túi 500ml', 
N'Trà xanh không độ túi 500ml được chiết xuất từ những lá trà tự nhiên thượng hạng, mang đến hương vị thanh khiết, không đường, không calo, giúp hỗ trợ giảm cân và làm đẹp da. Sản phẩm đóng túi tiện lợi, phù hợp để mang theo khi đi làm, đi học hoặc các hoạt động ngoài trời. Trà xanh không độ không chỉ giải khát mà còn giúp thư giãn tinh thần, là lựa chọn hoàn hảo cho lối sống lành mạnh và hiện đại.', 
11000, N'túi', 130, 1, 'NCC002', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776035/tea1_slftv5.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776036/tea2_zpg2c5.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776038/tea3_tjdbzu.jpg');

-- Sữa
INSERT INTO SANPHAM (TENSP, MOTA, GIABAN, DVT, SOLUONGTON, MADM, MANCC, ANH1, ANH2, ANH3) VALUES
(N'Sữa bột Bfast bổ sung canxi', 
N'Sữa bột Bfast bổ sung canxi được thiết kế dành cho cả trẻ em và người lớn tuổi, với công thức đặc biệt giàu canxi, vitamin D và khoáng chất, hỗ trợ phát triển xương chắc khỏe, tăng cường sức đề kháng. Sản phẩm có vị ngọt nhẹ, dễ uống, hòa tan nhanh, là lựa chọn lý tưởng để bổ sung dinh dưỡng hàng ngày. Sữa Bfast không chỉ mang lại sức khỏe mà còn là món quà ý nghĩa cho gia đình Việt Nam, đảm bảo chất lượng và an toàn.', 
250000, N'hộp', 50, 2, 'NCC003', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776110/bfast1_oym8e8.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776111/bfast2_kvdel3.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776113/bfast3_rxxbja.jpg'),

(N'Sữa Ensure Gold cho người lớn', 
N'Sữa Ensure Gold cho người lớn được nghiên cứu dành riêng cho người cao tuổi, bổ sung protein, vitamin và khoáng chất cần thiết để tăng cường sức khỏe và phục hồi cơ thể. Sản phẩm có hương vị vani thơm ngon, dễ hấp thụ, giúp duy trì năng lượng suốt ngày dài. Ensure Gold không chỉ là nguồn dinh dưỡng hoàn hảo mà còn hỗ trợ cải thiện hệ miễn dịch, là người bạn đồng hành đáng tin cậy cho sức khỏe của người thân yêu.', 
300000, N'hộp', 40, 2, 'NCC003', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776117/ensure1_uuwqfm.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776118/ensure2_ibfn2b.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776119/ensure3_teu9aq.jpg'),

(N'Sữa Glucerna dành cho bệnh nhân tiểu đường', 
N'Sữa Glucerna dành cho bệnh nhân tiểu đường được thiết kế với công thức đặc biệt, chứa hàm lượng carbohydrate thấp, giúp kiểm soát đường huyết hiệu quả mà vẫn đảm bảo dinh dưỡng cân bằng. Sản phẩm giàu chất xơ, vitamin và khoáng chất, hỗ trợ sức khỏe toàn diện cho người bệnh. Glucerna có hương vị thơm ngon, dễ uống, là lựa chọn tối ưu để duy trì sức khỏe lâu dài, mang lại sự an tâm cho những ai đang đối mặt với bệnh tiểu đường.', 
320000, N'hộp', 30, 2, 'NCC003', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776121/glucerna1_b2tchj.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776122/glucerna2_we3dya.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776123/glucerna3_ihj6ct.jpg'),

(N'Sữa Grow Plus cho trẻ em', 
N'Sữa Grow Plus cho trẻ em từ 1-6 tuổi được phát triển với công thức bổ sung DHA, canxi và sắt, hỗ trợ sự phát triển toàn diện về cả thể chất và trí tuệ. Sản phẩm có hương vị vani thơm ngon, dễ uống, giúp bé yêu thích và phát triển khỏe mạnh mỗi ngày. Grow Plus không chỉ cung cấp năng lượng mà còn giúp bé tăng trưởng chiều cao và cân nặng tối ưu, là lựa chọn hàng đầu của các bậc phụ huynh hiện đại.', 
280000, N'hộp', 60, 2, 'NCC003', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776125/grow1_k4ziug.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776127/grow2_umufvo.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776128/grow3_joofvw.jpg'),

(N'Sữa bột Kun vị socola', 
N'Sữa bột Kun vị socola được làm từ sữa tươi tự nhiên, kết hợp với bột ca cao cao cấp, bổ sung vitamin A, D và khoáng chất cần thiết cho sự phát triển của trẻ. Sản phẩm có hương vị socola đậm đà, kích thích vị giác, phù hợp cho cả trẻ em và người lớn yêu thích sự ngọt ngào. Sữa Kun không chỉ mang lại nguồn dinh dưỡng dồi dào mà còn giúp tăng cường sức đề kháng, là thức uống lý tưởng cho mọi gia đình.', 
200000, N'hộp', 45, 2, 'NCC003', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776130/kun1_x8fqdj.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776132/kun2_i1zs5w.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776134/kun3_y9rixy.jpg'),

(N'Sữa Milo năng lượng', 
N'Sữa Milo năng lượng là sự kết hợp hoàn hảo giữa sữa tươi và bột ca cao, bổ sung vitamin B, sắt và canxi, mang lại nguồn năng lượng tức thì cho cơ thể. Sản phẩm phù hợp cho học sinh, sinh viên hoặc người vận động nhiều, giúp tăng cường sức bền và hỗ trợ hoạt động thể chất. Sữa Milo có hương vị ca cao thơm ngon, dễ uống, là thức uống lý tưởng để tiếp thêm năng lượng và sự tỉnh táo cho những ngày bận rộn.', 
150000, N'hộp', 70, 2, 'NCC003', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776135/milo1_tce21j.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776138/milo2_g5fm4i.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776141/milo3_l0rk9g.jpg'),

(N'Sữa Ngôi Sao bổ sung trí tuệ', 
N'Sữa Ngôi Sao bổ sung trí tuệ được thiết kế đặc biệt cho trẻ em, với công thức chứa DHA, ARA và các vi chất cần thiết để hỗ trợ phát triển não bộ và khả năng học hỏi. Sản phẩm có hương vị nhẹ nhàng, dễ uống, giúp bé yêu thích và hấp thụ dinh dưỡng tốt hơn. Sữa Ngôi Sao không chỉ mang lại sức khỏe mà còn là người bạn đồng hành giúp bé thông minh, sáng tạo, là lựa chọn đáng tin cậy của các bậc cha mẹ.', 
270000, N'hộp', 50, 2, 'NCC003', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776142/ngoisao1_x4vc3d.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776143/ngoisao2_c6kiko.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776144/ngoisao3_wg5gn8.jpg'),

(N'Sữa Nutimilk đậu nành nguyên chất', 
N'Sữa Nutimilk đậu nành nguyên chất được làm từ đậu nành tự nhiên, không chứa cholesterol, giàu protein thực vật và canxi, hỗ trợ sức khỏe tim mạch và xương chắc khỏe. Sản phẩm mang hương vị đậu nành thơm ngon, tự nhiên, là lựa chọn lý tưởng cho người ăn chay hoặc những ai muốn sống khỏe mạnh. Nutimilk không chỉ là thức uống bổ dưỡng mà còn giúp thanh lọc cơ thể, mang lại sự tươi mới cho từng ngày.', 
180000, N'hộp', 60, 2, 'NCC003', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776147/nutimilk2_udf2pk.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776145/nutimilk1_knfool.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776148/nutimilk3_regb3q.jpg'),

(N'Sữa Nuvie tăng chiều cao', 
N'Sữa Nuvie tăng chiều cao được bổ sung canxi nano và vitamin D3, giúp trẻ em phát triển chiều cao tối ưu và xương chắc khỏe. Sản phẩm có hương vị trái cây tự nhiên, dễ uống, kích thích vị giác của bé. Sữa Nuvie không chỉ cung cấp dinh dưỡng toàn diện mà còn hỗ trợ tăng trưởng vượt trội, là giải pháp vàng cho các bậc phụ huynh muốn con phát triển toàn diện về thể chất và trí tuệ.', 
290000, N'hộp', 40, 2, 'NCC003', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776150/nuvi1_esjevj.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776151/nuvi2_wb7gcb.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776153/nuvi3_agbzii.jpg'),

(N'Sữa Ovaltine bổ sung dinh dưỡng', 
N'Sữa Ovaltine bổ sung dinh dưỡng với sự kết hợp độc đáo của malt, ca cao và vitamin, mang lại nguồn năng lượng và dinh dưỡng vượt trội cho cơ thể. Sản phẩm phù hợp cho mọi lứa tuổi, đặc biệt là trẻ em và người năng động, giúp tăng cường sức khỏe và sự tỉnh táo. Sữa Ovaltine có hương vị ca cao thơm ngon, dễ hòa tan, là thức uống lý tưởng để khởi đầu ngày mới hoặc bổ sung năng lượng trong ngày bận rộn.', 
200000, N'hộp', 55, 2, 'NCC003', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776156/ovaltine3_ttghwc.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776155/ovaltine2_mtzeif.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776154/ovaltine1_cfixcx.jpg'),

(N'Sữa Vinamilk 100% organic', 
N'Sữa Vinamilk 100% organic được sản xuất từ nguồn sữa bò chăn thả tự nhiên, không chứa hóa chất, đảm bảo độ tinh khiết và giàu canxi, vitamin cần thiết cho cơ thể. Sản phẩm có hương vị sữa tươi nguyên bản, dễ uống, phù hợp cho cả gia đình, từ trẻ em đến người lớn tuổi. Sữa Vinamilk organic không chỉ mang lại nguồn dinh dưỡng dồi dào mà còn hỗ trợ sức khỏe tổng thể, là lựa chọn hàng đầu cho lối sống lành mạnh.', 
250000, N'hộp', 45, 2, 'NCC003', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776161/vinamilk3_diueqx.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776159/vinamilk2_ew3lui.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776158/vinamilk1_bpazor.jpg');

-- Thực phẩm khô
INSERT INTO SANPHAM (TENSP, MOTA, GIABAN, DVT, SOLUONGTON, MADM, MANCC, ANH1, ANH2, ANH3) VALUES
(N'Bánh tráng nướng Đà Lạt', 
N'Bánh tráng nướng Đà Lạt là món ăn vặt đặc trưng được làm thủ công từ gạo ngon, nướng trên than hồng, mang đến hương vị giòn rụm, thơm lừng, khó cưỡng. Sản phẩm được tẩm gia vị đặc biệt, vừa miệng, phù hợp để nhâm nhi cùng bạn bè, gia đình hoặc làm quà tặng ý nghĩa. Bánh tráng nướng không chỉ là món ăn vặt mà còn là một phần ký ức tuổi thơ, mang đậm nét văn hóa ẩm thực Việt Nam.', 
50000, N'gói', 80, 5, 'NCC007', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776190/banhtrang1_rlutdk.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776206/banhtrang2_byzh3u.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776211/banhtrang3_dndcex.jpg'),

(N'Bột khoai màu tự nhiên', 
N'Bột khoai màu tự nhiên được làm từ khoai tươi xay nhuyễn, không sử dụng phẩm màu, giữ nguyên hương vị và màu sắc tự nhiên của khoai. Sản phẩm rất lý tưởng để làm bánh, nấu chè, hoặc làm nguyên liệu chế biến các món ăn truyền thống, mang lại màu sắc bắt mắt và dinh dưỡng dồi dào. Bột khoai không chỉ giúp món ăn thêm ngon mà còn đảm bảo an toàn, phù hợp cho mọi lứa tuổi, đặc biệt là trẻ em.', 
30000, N'gói', 100, 5, 'NCC007', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776214/botkhoai1_xogxb6.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776215/botkhoai2_o9mnyw.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776216/botkhoai3_vzn3he.jpg'),

(N'Chân gà ngâm sả tắc', 
N'Chân gà ngâm sả tắc là món ăn vặt được chế biến từ chân gà tươi ngon, ngâm cùng sả, tắc và các gia vị đặc trưng, mang đến vị giòn dai, chua ngọt đậm đà, thơm lừng khó cưỡng. Sản phẩm không chỉ hấp dẫn bởi hương vị độc đáo mà còn giàu collagen, hỗ trợ làm đẹp da và tăng cường sức khỏe xương khớp. Chân gà ngâm sả tắc rất phù hợp để nhâm nhi cùng bạn bè trong những buổi xem phim, tụ tập, hoặc làm món ăn nhẹ bổ dưỡng, là lựa chọn lý tưởng cho những ai yêu thích ẩm thực chế biến sáng tạo.', 
70000, N'gói', 50, 5, 'NCC007', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776218/changa1_zxaunt.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776220/changa2_p0d3s9.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776221/changa3_vconm7.jpg'),

(N'Đậu nành rang nguyên chất', 
N'Đậu nành rang nguyên chất được chế biến từ những hạt đậu nành tự nhiên, rang khô giòn, mang đến vị bùi bùi, thơm ngon đặc trưng. Sản phẩm giàu protein và chất xơ, là món ăn vặt lành mạnh, không dầu, phù hợp cho mọi lứa tuổi, đặc biệt là người ăn kiêng. Đậu nành rang cũng có thể dùng làm nguyên liệu để làm sữa đậu nành tại nhà, mang lại sự tiện lợi và dinh dưỡng cho bữa ăn hàng ngày.', 
35000, N'gói', 90, 5, 'NCC007', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776223/daunanh1_d8qocm.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776224/daunanh2_ibkh00.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776225/daunanh3_mfgvza.jpg'),

(N'Đậu phộng rang muối', 
N'Đậu phộng rang muối được chọn lọc từ những hạt đậu phộng to, rang đều tay, tẩm muối vừa miệng, mang đến vị bùi bùi, mặn mà, khó cưỡng. Sản phẩm không sử dụng dầu, đảm bảo an toàn và tốt cho sức khỏe, là món ăn vặt lý tưởng để nhâm nhi cùng bạn bè, gia đình trong những buổi trò chuyện vui vẻ. Đậu phộng rang muối cũng rất phù hợp để làm nguyên liệu cho các món bánh, kẹo truyền thống.', 
30000, N'gói', 100, 5, 'NCC007', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776227/dauphong1_ujced3.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776228/dauphong2_qmuawk.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776230/dauphong3_sfth2k.jpg'),

(N'Gạo tám thơm Điện Biên', 
N'Gạo tám thơm Điện Biên được trồng trên vùng đất phù sa màu mỡ của miền Tây Bắc, với hạt gạo dài, trắng ngần, khi nấu lên dẻo thơm đặc trưng, mang đậm hương vị truyền thống Việt Nam. Loại gạo này giàu dinh dưỡng, không chất bảo quản, phù hợp để nấu cơm hàng ngày, làm cơm nắm hoặc các món ăn lễ tết. Gạo tám thơm không chỉ là nguyên liệu mà còn là biểu tượng của sự tinh túy trong ẩm thực Việt.', 
25000, N'kg', 150, 5, 'NCC007', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776231/gao1_ceizgn.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776232/gao2_k0f9q2.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776234/gao3_lbsw6q.jpg'),

(N'Gimbag rong biển Hàn Quốc', 
N'Gimbag rong biển Hàn Quốc được làm từ những lá rong biển chất lượng cao, nướng giòn, tẩm gia vị nhẹ, mang đến hương vị đậm đà của biển cả. Sản phẩm giàu i-ốt, tốt cho tuyến giáp, rất tiện lợi để cuốn cơm hoặc ăn trực tiếp như một loại snack lành mạnh. Gimbag không chỉ mang lại trải nghiệm ẩm thực Hàn Quốc mà còn là lựa chọn dinh dưỡng, phù hợp cho mọi lứa tuổi, đặc biệt là trẻ em và người lớn tuổi.', 
40000, N'gói', 70, 5, 'NCC007', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776235/gimbag1_yxrykd.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776237/gimbag2_jftrh4.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776238/gimbag3_xs34vf.jpg'),

(N'Heo lát chay giòn rụm', 
N'Heo lát chay giòn rụm được làm từ đậu nành và nấm tự nhiên, chiên giòn, mang đến hương vị giống thịt heo thật, nhưng hoàn toàn phù hợp cho người ăn chay. Sản phẩm có vị dai ngọt, thơm ngon, rất thích hợp để ăn vặt, làm món khai vị, hoặc kết hợp trong các món ăn chay sáng tạo. Heo lát chay không chỉ ngon mà còn giàu protein thực vật, là lựa chọn lý tưởng cho những ai muốn thay đổi khẩu vị mà vẫn đảm bảo sức khỏe.', 
50000, N'gói', 60, 5, 'NCC007', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776240/heolat1_alpda3.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776241/heolat2_jdahnr.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776243/heolat3_ygokb3.jpg'),

(N'Khô heo sấy tỏi', 
N'Khô heo sấy tỏi được làm từ thịt heo tươi chọn lọc, sấy khô và ướp gia vị tỏi thơm lừng, mang đến vị dai ngọt tự nhiên, đậm đà, khó cưỡng. Sản phẩm không chứa chất bảo quản, là món ăn vặt hoàn hảo cho những buổi xem phim, tụ tập bạn bè, hoặc làm quà tặng ý nghĩa. Khô heo sấy tỏi không chỉ mang lại trải nghiệm ẩm thực thú vị mà còn là món ăn giàu protein, giúp bạn luôn tràn đầy năng lượng.', 
60000, N'gói', 50, 5, 'NCC007', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776244/khoheo1_zyfcoh.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776245/khoheo2_nnsu4b.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776247/khoheo3_ovbdxr.jpg'),

(N'Lá kim cuốn cơm Kimbap', 
N'Lá kim cuốn cơm Kimbap được làm từ rong biển tự nhiên, nướng giòn, giữ nguyên hương vị biển cả, mang lại trải nghiệm ẩm thực Hàn Quốc đích thực. Sản phẩm giàu i-ốt và dinh dưỡng, rất tiện lợi để làm món Kimbap, cuốn cơm hoặc ăn kèm các món ăn khác. Lá kim không chỉ giúp món ăn thêm ngon mà còn mang lại giá trị dinh dưỡng cao, là lựa chọn lý tưởng cho những bữa ăn gia đình hoặc tiệc tùng sáng tạo.', 
35000, N'gói', 80, 5, 'NCC007', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776249/lacuonkc1_bbeltz.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776250/lacuonkc2_o92gq7.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776252/lacuonkc3_dlqccs.jpg'),

(N'Miến dong cao cấp', 
N'Miến dong cao cấp được làm từ sợi dong tự nhiên, trong suốt, dai ngon khi nấu, mang đến hương vị thanh đạm, đặc trưng của ẩm thực Việt Nam. Sản phẩm không chứa gluten, rất phù hợp để nấu canh, xào, hoặc làm món nướng, mang lại bữa ăn nhẹ nhàng, dễ tiêu hóa. Miến dong không chỉ là nguyên liệu quen thuộc mà còn là lựa chọn lý tưởng cho những ai yêu thích thực phẩm lành mạnh, đảm bảo sức khỏe.', 
40000, N'gói', 70, 5, 'NCC007', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776253/mieng1_eczyqh.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776255/mieng2_b2ldgx.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776256/mieng3_y1jm4c.jpg'),

(N'Mực xé tẩm gia vị', 
N'Mực xé tẩm gia vị được làm từ mực tươi ngon, sấy khô và ướp gia vị đậm đà, mang đến vị giòn tan, thơm ngon, đậm chất biển cả. Sản phẩm là món ăn vặt hoàn hảo để nhâm nhi trong những buổi xem phim, tụ tập bạn bè, hoặc làm quà tặng cho người thân. Mực xé không chỉ ngon mà còn giàu protein và dinh dưỡng, là lựa chọn lý tưởng để bổ sung năng lượng mà vẫn giữ được vị ngon đặc trưng.', 
70000, N'gói', 40, 5, 'NCC007', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776258/muc1_v3plk3.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776259/muc2_fp5xev.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776261/muc3_uvzfet.jpg'),

(N'Nấm tuyết khô tự nhiên', 
N'Nấm tuyết khô tự nhiên được sấy khô từ những cây nấm tuyết tươi ngon, giữ nguyên hương vị ngọt thanh và giá trị dinh dưỡng cao, đặc biệt là vitamin D, giúp hỗ trợ miễn dịch và sức khỏe xương. Sản phẩm rất phù hợp để nấu canh, xào cùng rau củ, hoặc làm nguyên liệu cho các món chè thanh mát. Nấm tuyết không chỉ mang lại hương vị thơm ngon mà còn là lựa chọn lý tưởng cho những ai muốn bổ sung dinh dưỡng từ thiên nhiên.', 
90000, N'kg', 30, 5, 'NCC007', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776262/namtuyet1_nbbnan.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776264/namtuyet2_elgpbi.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776265/namtuyet3_tmfptk.jpg'),

(N'Gạo nếp cái hoa vàng', 
N'Gạo nếp cái hoa vàng được trồng trên vùng đất phù sa màu mỡ, với hạt gạo tròn, dẻo thơm đặc trưng, mang đậm hương vị truyền thống của ẩm thực Việt Nam. Loại gạo này rất lý tưởng để nấu xôi, làm bánh chưng, bánh giầy, hoặc ủ rượu, mang lại bữa ăn đậm chất quê hương. Gạo nếp cái hoa vàng không chỉ là nguyên liệu mà còn là biểu tượng của sự đoàn viên, là lựa chọn hoàn hảo cho các dịp lễ tết hoặc gia đình sum họp.', 
30000, N'kg', 120, 5, 'NCC007', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776266/nep1_wk37xy.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776268/nep2_kkqwdf.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776270/nep3_owxgkp.jpg'),

(N'Posi thịt bò khô cao cấp', 
N'Posi thịt bò khô cao cấp được làm từ thịt bò thượng hạng, sấy khô và ướp gia vị đặc biệt, mang đến vị dai ngọt tự nhiên, đậm đà, khó cưỡng. Sản phẩm không chứa chất bảo quản, là món ăn vặt cao cấp, phù hợp để nhâm nhi hoặc làm quà tặng ý nghĩa trong các dịp đặc biệt. Posi thịt bò khô không chỉ mang lại trải nghiệm ẩm thực tuyệt vời mà còn là nguồn protein dồi dào, giúp bạn luôn tràn đầy năng lượng.', 
80000, N'gói', 50, 5, 'NCC007', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776271/posi1_jyaam4.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776272/posi2_lrhg7n.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776274/posi3_j8typx.jpg'),

(N'Rong biển nướng giòn', 
N'Rong biển nướng giòn được làm từ rong biển tự nhiên, nướng khô với muối biển, mang đến vị mặn mà, giòn rụm, đậm chất biển cả. Sản phẩm giàu i-ốt, tốt cho tuyến giáp, rất phù hợp để ăn trực tiếp như snack hoặc ăn kèm cơm, mang lại trải nghiệm ẩm thực thú vị. Rong biển nướng không chỉ là món ăn vặt mà còn là lựa chọn dinh dưỡng, giúp bổ sung khoáng chất cần thiết cho cơ thể, đặc biệt là trẻ em và người lớn tuổi.', 
40000, N'gói', 90, 5, 'NCC007', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776306/rongbien1_ti5kam.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776307/rongbien2_ydlx0y.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776309/rongbien3_wxfza9.jpg'),

(N'Rong nho tươi ngâm mắm', 
N'Rong nho tươi ngâm mắm được làm từ rong nho tự nhiên, ngâm cùng mắm cá cơm, mang đến vị ngọt thanh, giòn ngon, đậm đà hương vị biển cả. Sản phẩm giàu dinh dưỡng, chứa nhiều khoáng chất và vitamin, rất tốt cho sức khỏe tim mạch và tiêu hóa. Rong nho rất thích hợp để ăn kèm cơm, làm salad, hoặc làm món khai vị, mang lại trải nghiệm ẩm thực độc đáo, phù hợp cho những ai yêu thích thực phẩm biển.', 
60000, N'gói', 60, 5, 'NCC007', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776310/rongnho1_xlkkzg.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776312/rongnho2_ypm0ch.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776313/rongnho3_byf859.jpg'),

(N'Gạo tấm chất lượng cao', 
N'Gạo tấm chất lượng cao được xay từ những hạt gạo nguyên chất, mềm dẻo khi nấu, mang đến hương vị thơm ngon, đậm chất truyền thống Việt Nam. Sản phẩm rất phù hợp để nấu cháo, làm bánh, hoặc nấu cơm tấm, mang lại bữa ăn tiết kiệm nhưng vẫn đảm bảo dinh dưỡng. Gạo tấm không chỉ là nguyên liệu quen thuộc mà còn là lựa chọn lý tưởng cho những ai yêu thích sự giản dị, gần gũi trong từng bữa ăn hàng ngày.', 
20000, N'kg', 150, 5, 'NCC007', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776315/tam1_wbviwt.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776316/tam2_olhjah.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776320/tam3_ie7td7.jpg');

-- Trái cây tươi
INSERT INTO SANPHAM (TENSP, MOTA, GIABAN, DVT, SOLUONGTON, MADM, MANCC, ANH1, ANH2, ANH3) VALUES
(N'Bơ sáp Việt Nam chín tự nhiên', 
N'Bơ sáp Việt Nam chín tự nhiên được thu hoạch từ các vườn trái cây nổi tiếng, với vỏ xanh mướt, ruột vàng béo ngậy, mang đến vị bùi bùi, ngọt nhẹ, đặc trưng. Loại trái này giàu vitamin E và chất béo lành mạnh, hỗ trợ sức khỏe tim mạch và làm đẹp da. Bơ sáp rất thích hợp để ăn trực tiếp, làm sinh tố, hoặc trộn salad, mang lại trải nghiệm ẩm thực vừa ngon vừa bổ dưỡng, là lựa chọn lý tưởng cho mọi gia đình.', 
40000, N'kg', 40, 4, 'NCC006', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776358/bo1_vgxu4e.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776359/bo2_irvuxg.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776378/bo3_n7jw8t.jpg'),

(N'Bưởi da xanh Đồng Nai', 
N'Bưởi da xanh Đồng Nai được trồng trên vùng đất phù sa màu mỡ, với vỏ xanh mịn, ruột trắng ngần, mang đến vị ngọt thanh, chua nhẹ, rất dễ ăn. Loại trái này giàu vitamin C, hỗ trợ tăng cường sức đề kháng, cải thiện tiêu hóa và làm đẹp da. Bưởi da xanh rất phù hợp để ăn tráng miệng, ép nước, hoặc làm món khai vị, mang lại sự tươi mới và dinh dưỡng cho từng bữa ăn, đặc biệt trong những ngày hè nóng bức.', 
35000, N'kg', 50, 4, 'NCC006', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776379/buoi1_uwr93v.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776381/buoi2_rroepd.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776382/buoi3_damkh4.jpg'),

(N'Cam vàng Úc ngọt lịm', 
N'Cam vàng Úc ngọt lịm được nhập khẩu từ những vườn cam nổi tiếng tại Úc, với vỏ mỏng, múi mọng nước, mang đến vị ngọt thanh, chua nhẹ, rất dễ chịu. Loại trái này chứa nhiều vitamin C và chất chống oxy hóa, giúp tăng cường sức đề kháng, làm đẹp da và hỗ trợ tiêu hóa. Cam vàng Úc rất thích hợp để ăn trực tiếp, ép nước, hoặc làm món tráng miệng, là lựa chọn hoàn hảo để bổ sung năng lượng và sự tươi mới mỗi ngày.', 
45000, N'kg', 60, 4, 'NCC006', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776385/cam1_lmnyqe.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776470/cam2_kywv8h.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776471/cam3_fndqzz.jpg'),

(N'Chuối laba Thái Lan chín vàng', 
N'Chuối laba Thái Lan chín vàng tự nhiên được thu hoạch từ các vườn trái cây Thái Lan, với quả nhỏ xinh, vỏ vàng óng, mang đến vị ngọt đậm, mềm mịn, dễ ăn. Loại chuối này giàu kali và năng lượng, hỗ trợ cơ bắp, tăng cường sức khỏe tim mạch, rất phù hợp để ăn sáng, làm món tráng miệng, hoặc mang theo khi đi làm. Chuối laba không chỉ ngon mà còn là nguồn dinh dưỡng tự nhiên, giúp bạn luôn tràn đầy sức sống.', 
30000, N'kg', 70, 4, 'NCC006', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776473/chuoi1_aatcf5.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776475/chuoi2_ngsiy7.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776531/chuoi3_lkha4o.jpg'),

(N'Dưa lưới Nhật Bản thơm lừng', 
N'Dưa lưới Nhật Bản thơm lừng được trồng tại các trang trại nổi tiếng ở Nhật, với vỏ vàng óng, ruột xanh mướt, mang đến hương thơm quyến rũ và vị ngọt thanh đặc trưng. Loại trái này chứa nhiều vitamin A và C, hỗ trợ làm đẹp da, tăng cường sức đề kháng và giải nhiệt cơ thể. Dưa lưới rất phù hợp để ăn trực tiếp, làm sinh tố, hoặc làm món tráng miệng mát lạnh, mang đến trải nghiệm trái cây cao cấp trong những ngày hè nóng bức.', 
60000, N'kg', 30, 4, 'NCC006', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776602/dauluoi3_rqzdbx.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776614/dualuoi1_ruotix.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776615/dualuoi2_f8uew2.jpg'),

(N'Dưa gang Hàn Quốc giòn ngọt', 
N'Dưa gang Hàn Quốc giòn ngọt được nhập khẩu từ Hàn Quốc, với vỏ xanh mịn, ruột đỏ hồng, chứa nhiều nước và vitamin, mang đến vị ngọt thanh, giòn tan, rất dễ ăn. Loại trái này giúp giải nhiệt, hỗ trợ tiêu hóa và làm đẹp da, là lựa chọn lý tưởng để ăn trực tiếp hoặc làm món tráng miệng mát lạnh. Dưa gang không chỉ mang lại sự tươi mới mà còn là nguồn dinh dưỡng tự nhiên, phù hợp cho mọi lứa tuổi, đặc biệt trong mùa hè.', 
40000, N'kg', 40, 4, 'NCC006', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776603/duagan1_ehyobm.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776605/duagan2_eihwue.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776607/duagan3_mrxukr.jpg'),

(N'Dưa hấu không hạt Mỹ', 
N'Dưa hấu không hạt Mỹ được trồng tại các trang trại lớn ở Mỹ, với vỏ xanh đậm, ruột đỏ mọng, mang đến vị ngọt tự nhiên, không hạt khó chịu, rất dễ ăn. Loại trái này giàu lycopene và nước, giúp thanh nhiệt cơ thể, hỗ trợ tiêu hóa và làm đẹp da. Dưa hấu không hạt rất phù hợp để ăn trực tiếp, ép nước, hoặc làm món tráng miệng, là lựa chọn hoàn hảo để giải nhiệt trong những ngày hè nắng nóng.', 
25000, N'kg', 60, 4, 'NCC006', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776608/duahau1_msnfbp.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776610/duahau2_s4xr3t.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776612/duahau3_pidk3a.jpg'),

(N'Kiwi vàng New Zealand hữu cơ', 
N'Kiwi vàng New Zealand hữu cơ được trồng theo tiêu chuẩn hữu cơ tại New Zealand, với vỏ mịn, ruột vàng óng, mang đến vị ngọt thanh xen chút chua nhẹ, rất dễ chịu. Loại trái này chứa nhiều vitamin C và chất xơ, hỗ trợ tiêu hóa, tăng cường sức đề kháng và làm đẹp da. Kiwi vàng rất thích hợp để ăn trực tiếp, làm sinh tố, hoặc trang trí món ăn, mang lại trải nghiệm trái cây cao cấp và dinh dưỡng cho mọi bữa ăn.', 
70000, N'kg', 25, 4, 'NCC006', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776621/kiwi3_ofz0nz.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776619/kiwi2_xvx72k.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776617/kiwi1_rcq78j.jpg'),

(N'Lê Hàn Quốc nuôi bằng nước sạch', 
N'Lê Hàn Quốc nuôi bằng nước sạch tinh khiết được trồng tại các trang trại hiện đại ở Hàn Quốc, với vỏ vàng mịn, ruột trắng giòn, mang đến vị ngọt mát, dễ ăn. Loại trái này giàu chất chống oxy hóa, hỗ trợ làm đẹp da, thanh lọc cơ thể và tăng cường sức khỏe tim mạch. Lê Hàn Quốc rất phù hợp để ăn trực tiếp, làm nước ép, hoặc làm món tráng miệng, là lựa chọn lý tưởng để bổ sung dinh dưỡng tự nhiên mỗi ngày.', 
50000, N'kg', 35, 4, 'NCC006', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776622/le1_meeqga.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776623/le2_tlrtrl.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776626/le3_zdnmna.jpg'),

(N'Mít tố nữ Thái Lan chín cây', 
N'Mít tố nữ Thái Lan chín cây được thu hoạch từ các vườn trái cây nổi tiếng ở Thái Lan, với múi vàng ươm, vị ngọt đậm, thơm lừng, mang đậm hương vị nhiệt đới. Loại trái này giàu vitamin A và C, hỗ trợ tăng cường thị lực, cải thiện sức đề kháng và làm đẹp da. Mít tố nữ rất phù hợp để ăn trực tiếp, làm mứt, hoặc nấu chè, mang lại trải nghiệm ẩm thực thú vị, là lựa chọn tuyệt vời cho những ai yêu thích trái cây ngọt ngào.', 
45000, N'kg', 40, 4, 'NCC006', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776627/mit1_ztrsnx.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776629/mit2_xtrdge.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776630/mit3_isgzf4.jpg'),

(N'Nho xanh Chile tươi ngon', 
N'Nho xanh Chile tươi ngon được nhập khẩu từ các vườn nho nổi tiếng ở Chile, với hạt tròn mọng, vỏ xanh mịn, mang đến vị ngọt thanh, chua nhẹ, rất dễ ăn. Loại trái này giàu chất chống oxy hóa và vitamin K, hỗ trợ sức khỏe tim mạch, làm đẹp da và tăng cường sức đề kháng. Nho xanh rất thích hợp để ăn vặt, làm salad, hoặc ép nước, là lựa chọn hoàn hảo để bổ sung dinh dưỡng và sự tươi mới cho từng ngày.', 
90000, N'kg', 30, 4, 'NCC006', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776636/nho3_gsp3of.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776634/nho2_qiig6n.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776632/nho1_vixvuh.jpg'),

(N'Nho đen Mỹ cao cấp', 
N'Nho đen Mỹ cao cấp được nhập khẩu từ Mỹ, với quả to, vỏ tím đậm, ruột mọng nước, mang đến vị ngọt đậm, đậm chất trái cây cao cấp. Loại nho này chứa nhiều resveratrol, tốt cho tim mạch và làm đẹp da, rất phù hợp để ăn trực tiếp, làm rượu vang tự nhiên, hoặc làm món tráng miệng. Nho đen Mỹ không chỉ mang lại trải nghiệm ẩm thực tuyệt vời mà còn là nguồn dinh dưỡng tự nhiên, là lựa chọn lý tưởng cho mọi gia đình.', 
100000, N'kg', 25, 4, 'NCC006', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776637/nhoden1_wl01qv.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776639/nhoden2_nt69vj.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776640/nhoden3_fq3r4u.jpg'),

(N'Ổi không hạt Thái Lan', 
N'Ổi không hạt Thái Lan được trồng tại các vườn trái cây Thái Lan, với vỏ xanh mịn, ruột trắng giòn, mang đến vị ngọt thanh tự nhiên, không hạt khó chịu. Loại trái này giàu vitamin C và chất xơ, hỗ trợ tiêu hóa, tăng cường sức đề kháng và làm đẹp da. Ổi không hạt rất thích hợp để ăn trực tiếp, làm sinh tố, hoặc làm món khai vị, mang lại sự tươi mới và dinh dưỡng cho từng bữa ăn, đặc biệt trong những ngày hè nóng bức.', 
30000, N'kg', 50, 4, 'NCC006', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776644/oi2_thhofr.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776643/oi1_gcfffa.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776646/oi3_atddvt.jpg'),

(N'Táo Hàn Quốc nuôi bằng nước sạch', 
N'Táo Hàn Quốc nuôi bằng nước sạch tinh khiết được trồng tại các trang trại hiện đại ở Hàn Quốc, với vỏ đỏ bóng, ruột giòn ngọt, mang đến vị ngọt thanh, đậm đà. Loại trái này chứa nhiều chất chống oxy hóa, hỗ trợ giảm cân, làm đẹp da và tăng cường sức đề kháng. Táo Hàn Quốc rất thích hợp để ăn trực tiếp, làm nước ép, hoặc làm món tráng miệng, là lựa chọn hoàn hảo để bổ sung dinh dưỡng tự nhiên và sự tươi mới mỗi ngày.', 
60000, N'kg', 40, 4, 'NCC006', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776647/tao1_psfsaj.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776650/tao2_bm4qhc.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776651/tao3_gwywpv.jpg'),

(N'Táo nhỏ Nhật Bản organic', 
N'Táo nhỏ Nhật Bản organic được trồng theo tiêu chuẩn hữu cơ tại Nhật Bản, với vỏ vàng mịn, ruột giòn tan, mang đến vị ngọt thanh tự nhiên, rất dễ ăn. Loại trái này giàu vitamin và chất chống oxy hóa, hỗ trợ tăng cường sức đề kháng, làm đẹp da và cải thiện tiêu hóa. Táo nhỏ Nhật Bản rất thích hợp để ăn vặt, làm nước ép, hoặc trang trí món ăn, mang lại trải nghiệm trái cây cao cấp và dinh dưỡng cho mọi bữa ăn gia đình.', 
70000, N'kg', 30, 4, 'NCC006', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776657/taonho3_ydrvyj.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776655/taonho2_fblv8n.jpg', 'https://res.cloudinary.com/degzytdz5/image/upload/v1748776653/taonho1_deq7sz.jpg');



INSERT INTO DANHGIA (MATK, MASP, SOSAO, BINHLUAN, NGAYDANHGIA) VALUES
-- Đánh giá tốt (4-5 sao)
(1, 1, 5, N'Sản phẩm rất ngon, chất lượng tuyệt vời, sẽ mua lại!', '2025-01-15 14:30:00'), -- Xoài keo
(2, 1, 4, N'Giá hợp lý, trái to và ngọt, hài lòng!', '2025-03-10 09:15:00'),
(3, 3, 5, N'Sữa TH True Milk thơm ngon, con tôi rất thích!', '2025-02-20 11:00:00'),
(4, 4, 4, N'Cà rốt tươi, giòn, phù hợp để làm salad!', '2025-04-05 16:45:00'),
(5, 6, 5, N'Cà chua bi organic tuyệt vời, vị ngọt tự nhiên!', '2025-05-12 13:20:00'),
(6, 8, 4, N'Hành tây đỏ chất lượng, nấu ăn rất ngon!', '2025-01-28 10:10:00'),
(7, 10, 5, N'Khoai tây Pháp ngon, chiên giòn, đáng tiền!', '2025-03-15 15:30:00'),
(8, 12, 4, N'Ớt chuông vàng đẹp mắt, xào rau rất hợp!', '2025-04-22 14:00:00'),
(9, 14, 5, N'Nước C2 chanh ngon, giải khát tốt!', '2025-05-01 17:50:00'),
(10, 15, 4, N'Coca-Cola sảng khoái, chất lượng ổn định!', '2025-02-10 12:40:00'),
(1, 17, 5, N'Sữa Bfast bổ sung canxi rất tốt cho xương!', '2025-03-25 09:30:00'),
(2, 19, 4, N'Glucerna hỗ trợ đường huyết hiệu quả!', '2025-04-18 11:15:00'),
(3, 22, 5, N'Sữa Milo năng lượng, con tôi thích lắm!', '2025-05-20 16:00:00'),
(4, 25, 4, N'Nutimilk đậu nành thơm, phù hợp ăn chay!', '2025-01-30 14:25:00'),
(5, 28, 5, N'Bánh tráng nướng giòn, ăn rất đã!', '2025-02-14 10:45:00'),
(6, 30, 4, N'Chả lụa chay ngon, giống chả thật!', '2025-03-05 13:10:00'),
(7, 33, 5, N'Gimbag rong biển ngon, con tôi mê!', '2025-04-10 15:20:00'),
(8, 35, 4, N'Khô heo sấy tỏi thơm, ăn vặt thích!', '2025-05-15 12:30:00'),
(9, 38, 5, N'Miến dong dai, nấu canh rất ngon!', '2025-01-20 11:00:00'),
(10, 41, 4, N'Posi thịt bò khô đậm đà, chất lượng!', '2025-03-30 16:40:00'),
(1, 44, 5, N'Bưởi da xanh ngọt, ăn rất đã khát!', '2025-04-25 09:15:00'),
(2, 46, 4, N'Táo nhỏ Nhật ngon, giòn, đáng mua!', '2025-05-10 14:50:00'),
(3, 47, 5, N'Chân gà ngâm sả tắc giòn, ngon tuyệt!', '2025-02-05 13:30:00'), -- Chân gà

-- Đánh giá xấu (2-3 sao)
(4, 2, 2, N'Quýt giống Úc chua, không ngọt như quảng cáo!', '2025-01-12 15:00:00'),
(5, 5, 3, N'Thùng sữa TH True Milk giao muộn, hư 1 hộp!', '2025-03-18 10:20:00'),
(6, 7, 2, N'Cà chua bi nhỏ, không mọng nước!', '2025-04-30 16:10:00'),
(7, 9, 3, N'Dưa leo Nhật bị héo, không giòn!', '2025-02-25 12:45:00'),
(8, 11, 2, N'Nấm hương khô mùi lạ, không ngon!', '2025-05-05 14:30:00'),
(9, 13, 3, N'Thơm Thái chát, không ngọt như mong đợi!', '2025-01-10 11:30:00'),
(10, 16, 2, N'Fanta cam lạt, không đáng tiền!', '2025-03-12 15:15:00'),
(1, 18, 3, N'Ensure Gold đắng, khó uống!', '2025-04-20 09:50:00'),
(2, 20, 2, N'Grow Plus con tôi không thích, bỏ thừa!', '2025-05-25 13:40:00'),
(3, 23, 3, N'Sữa Ngôi Sao nhạt, không thấy hiệu quả!', '2025-02-15 10:30:00'),
(4, 26, 2, N'Ovaltine quá ngọt, không hợp khẩu vị!', '2025-03-28 16:20:00'),
(5, 29, 3, N'Bột khoai màu lợn cợn, không mịn!', '2025-04-12 12:10:00'),
(6, 31, 2, N'Đậu nành rang mặn quá, ăn không ngon!', '2025-05-18 14:00:00'),
(7, 34, 3, N'Heo lát chay mềm, không giòn như quảng cáo!', '2025-01-25 11:45:00'),
(8, 36, 2, N'Lá kim cuốn cơm bị rách, khó dùng!', '2025-03-05 15:30:00'),
(9, 39, 3, N'Mực xé tẩm gia vị nhạt, không đậm!', '2025-04-15 13:20:00'),
(10, 42, 2, N'Rong nho ngâm mắm chua gắt, không ngon!', '2025-05-20 10:10:00'),
(1, 45, 3, N'Kiwi vàng chát, không ngọt như kỳ vọng!', '2025-02-10 16:50:00');



INSERT INTO KHACHHANG (SDT, MATKHAU, TENKH, DIACHI, GIOITINH, HINHANH) VALUES
('0123456789012', 'matkhau123', N'Nguyễn Văn A', N'123 Đường ABC, Quận 1, TP.HCM', N'Nam', 'hinhanhA.jpg'),
('0123456789013', 'matkhau456', N'Trần Thị B', N'456 Đường XYZ, Quận 2, TP.HCM', N'Nữ', 'hinhanhB.jpg'),
('0123456789014', 'matkhau789', N'Lê Minh C', N'789 Đường DEF, Quận 3, TP.HCM', N'Nam', 'hinhanhC.jpg'),
('0934567890', 'Login789@def', N'Lê Văn C', N'78 Đường Nguyễn Trãi, Thanh Xuân, Hà Nội', N'Nam', NULL),
('0976543210', 'Pass321@ghi', N'Phạm Thị D', N'12A Trần Phú, Nha Trang, Khánh Hòa', N'Nữ', NULL),
('0912345678', 'Secure987#jkl', N'Hoàng Văn E', N'56 Đường 3/2, Quận 10, TP.HCM', N'Nam', NULL),
('0945678901', 'Login654@mno', N'Đỗ Thị F', N'89 Nguyễn Huệ, Biên Hòa, Đồng Nai', N'Nữ', NULL),
('0967890123', 'Pass654@pqrs', N'Vũ Văn G', N'34 Hùng Vương, Đà Nẵng', N'Nam', NULL),
('0923456789', 'Secure321#tuv', N'Ngô Thị H', N'67 Lý Thường Kiệt, Cần Thơ', N'Nữ', NULL),
('0956789012', 'Login987@wxy', N'Bùi Văn I', N'23 Đường CMT8, Quận 3, TP.HCM', N'Nam', NULL),
('0989012345', 'Pass987@zabc', N'Phan Thị K', N'90 Trần Hưng Đạo, Hải Phòng', N'Nữ', NULL),
('0905678901', 'Secure654#def', N'Trần Văn L', N'15 Nguyễn Văn Cừ, Long An', N'Nam', NULL),
('0938901234', 'Login321@ghi', N'Lý Thị M', N'48 Đường Láng, Đống Đa, Hà Nội', N'Nữ', NULL),
('0971234567', 'Pass456@jkl', N'Hoàng Văn N', N'72 Huỳnh Thúc Kháng, Đà Lạt', N'Nam', NULL),
('0918902345', 'Secure789#mno', N'Nguyễn Thị O', N'31 Đường Hai Bà Trưng, Huế', N'Nữ', NULL),
('0942345678', 'Login123@pqrs', N'Phạm Văn P', N'99 Đường Phạm Văn Đồng, Bình Dương', N'Nam', NULL),
('0963456789', 'Pass789@tuv', N'Đỗ Thị Q', N'14 Đường Hoàng Văn Thụ, Vũng Tàu', N'Nữ', NULL),
('0925678901', 'Secure123@wxy', N'Lê Văn R', N'57 Đường Lê Đại Hành, Quảng Ninh', N'Nam', NULL),
('0958901234', 'Login456@zabc', N'Trần Thị S', N'80 Đường Nguyễn Thị Minh Khai, TP.HCM', N'Nữ', NULL),
('0982345678', 'Pass321@def', N'Ngô Văn T', N'26 Đường Trần Quang Khải, Hà Tĩnh', N'Nam', NULL),
('0913456789', 'Secure987#ghi', N'Vũ Thị U', N'33 Đường Hải Thượng Lãn Ông, Quảng Nam', N'Nữ', NULL);





INSERT INTO DONHANG (MAKH, PTTT, NGAYDAT, THANHTIEN, TRANGTHAITT, TRANGTHAIGH) VALUES
(4, 1, '2025-01-15', 81000, N'Đã thanh toán', N'Hoàn thành'),
(5, 2, '2025-01-20', 345000, N'Chưa thanh toán', N'Đang giao'),
(1, 1, '2025-02-01', 67900, N'Đã thanh toán', N'Hoàn thành'),
(6, 2, '2025-02-10', 22000, N'Chưa thanh toán', N'Đang xử lý'),
(7, 1, '2025-02-15', 550000, N'Đã thanh toán', N'Hoàn thành'),
(8, 2, '2025-02-20', 900000, N'Chưa thanh toán', N'Đã huỷ'),
(2, 1, '2025-03-01', 190000, N'Đã thanh toán', N'Đang giao'),
(9, 2, '2025-03-05', 30000, N'Chưa thanh toán', N'Hoàn thành'),
(10, 1, '2025-03-10', 120000, N'Đã thanh toán', N'Đang xử lý'),
(3, 2, '2025-03-15', 240000, N'Chưa thanh toán', N'Hoàn thành'),
(11, 1, '2025-03-20', 40000, N'Đã thanh toán', N'Đang giao'),
(12, 2, '2025-04-01', 160000, N'Chưa thanh toán', N'Đang xử lý'),
(13, 1, '2025-04-05', 210000, N'Đã thanh toán', N'Hoàn thành'),
(14, 2, '2025-04-10', 230000, N'Chưa thanh toán', N'Đã huỷ'),
(15, 1, '2025-04-15', 70000, N'Đã thanh toán', N'Hoàn thành'),
(16, 2, '2025-04-20', 155000, N'Chưa thanh toán', N'Đang giao'),
(17, 1, '2025-05-01', 142000, N'Đã thanh toán', N'Đang xử lý'),
(18, 2, '2025-05-05', 283000, N'Chưa thanh toán', N'Hoàn thành'),
(19, 1, '2025-05-10', 450000, N'Đã thanh toán', N'Đang giao'),
(20, 2, '2025-05-15', 100000, N'Chưa thanh toán', N'Đã huỷ'),
(1, 1, '2025-01-03', 122800, N'Đã thanh toán', N'Hoàn thành'),
(2, 2, '2025-01-05', 35000, N'Chưa thanh toán', N'Đang giao'),
(3, 1, '2025-01-07', 273000, N'Đã thanh toán', N'Đang xử lý'),
(4, 2, '2025-01-10', 11000, N'Chưa thanh toán', N'Đã huỷ'),
(5, 1, '2025-01-12', 800000, N'Đã thanh toán', N'Hoàn thành'),
(6, 2, '2025-01-15', 900000, N'Chưa thanh toán', N'Đang giao'),
(7, 1, '2025-01-18', 50000, N'Đã thanh toán', N'Đang xử lý'),
(8, 2, '2025-01-20', 180000, N'Chưa thanh toán', N'Hoàn thành'),
(9, 1, '2025-01-22', 40000, N'Đã thanh toán', N'Đang giao'),
(10, 2, '2025-01-25', 100000, N'Chưa thanh toán', N'Đã huỷ'),
(11, 1, '2025-01-28', 140000, N'Đã thanh toán', N'Hoàn thành'),
(12, 2, '2025-02-01', 50000, N'Chưa thanh toán', N'Đang xử lý'),
(13, 1, '2025-02-03', 115000, N'Đã thanh toán', N'Đang giao'),
(14, 2, '2025-02-05', 100000, N'Chưa thanh toán', N'Hoàn thành'),
(15, 1, '2025-02-07', 60000, N'Đã thanh toán', N'Đang xử lý'),
(16, 2, '2025-02-10', 140000, N'Chưa thanh toán', N'Đã huỷ'),
(17, 1, '2025-02-12', 22000, N'Đã thanh toán', N'Hoàn thành'),
(18, 2, '2025-02-15', 33000, N'Chưa thanh toán', N'Đang giao'),
(19, 1, '2025-02-18', 250000, N'Đã thanh toán', N'Đang xử lý'),
(20, 2, '2025-02-20', 240000, N'Chưa thanh toán', N'Hoàn thành'),
(1, 1, '2025-02-22', 11000, N'Đã thanh toán', N'Đang giao'),
(2, 2, '2025-02-25', 200000, N'Chưa thanh toán', N'Đã huỷ'),
(3, 1, '2025-02-28', 50000, N'Đã thanh toán', N'Hoàn thành'),
(4, 2, '2025-03-01', 80000, N'Chưa thanh toán', N'Đang xử lý'),
(5, 1, '2025-03-03', 120000, N'Đã thanh toán', N'Đang giao'),
(6, 2, '2025-03-05', 60000, N'Chưa thanh toán', N'Hoàn thành'),
(7, 1, '2025-03-07', 140000, N'Đã thanh toán', N'Đang xử lý'),
(8, 2, '2025-03-10', 100000, N'Chưa thanh toán', N'Đã huỷ'),
(9, 1, '2025-03-12', 250000, N'Đã thanh toán', N'Hoàn thành'),
(10, 2, '2025-03-15', 22000, N'Chưa thanh toán', N'Đang giao'),
(11, 1, '2025-03-18', 180000, N'Đã thanh toán', N'Đang xử lý'),
(12, 2, '2025-03-20', 40000, N'Chưa thanh toán', N'Hoàn thành'),
(13, 1, '2025-03-22', 50000, N'Đã thanh toán', N'Đang giao'),
(14, 2, '2025-03-25', 60000, N'Chưa thanh toán', N'Đã huỷ'),
(15, 1, '2025-03-28', 140000, N'Đã thanh toán', N'Hoàn thành'),
(16, 2, '2025-04-01', 200000, N'Chưa thanh toán', N'Đang xử lý'),
(17, 1, '2025-04-03', 100000, N'Đã thanh toán', N'Đang giao'),
(18, 2, '2025-04-05', 300000, N'Chưa thanh toán', N'Hoàn thành'),
(19, 1, '2025-04-07', 70000, N'Đã thanh toán', N'Đang xử lý'),
(20, 2, '2025-04-10', 140000, N'Chưa thanh toán', N'Đã huỷ'),
(1, 1, '2025-04-12', 22000, N'Đã thanh toán', N'Hoàn thành'),
(2, 2, '2025-04-15', 33000, N'Chưa thanh toán', N'Đang giao'),
(3, 1, '2025-04-18', 250000, N'Đã thanh toán', N'Đang xử lý'),
(4, 2, '2025-04-20', 240000, N'Chưa thanh toán', N'Hoàn thành'),
(5, 1, '2025-04-22', 11000, N'Đã thanh toán', N'Đang giao'),
(6, 2, '2025-04-25', 200000, N'Chưa thanh toán', N'Đã huỷ'),
(7, 1, '2025-04-28', 50000, N'Đã thanh toán', N'Hoàn thành'),
(8, 2, '2025-05-01', 80000, N'Chưa thanh toán', N'Đang xử lý'),
(9, 1, '2025-05-03', 120000, N'Đã thanh toán', N'Đang giao'),
(10, 2, '2025-05-05', 60000, N'Chưa thanh toán', N'Hoàn thành'),
(11, 1, '2025-05-07', 140000, N'Đã thanh toán', N'Đang xử lý'),
(12, 2, '2025-05-10', 100000, N'Chưa thanh toán', N'Đã huỷ'),
(13, 1, '2025-05-12', 250000, N'Đã thanh toán', N'Hoàn thành'),
(14, 2, '2025-05-15', 22000, N'Chưa thanh toán', N'Đang giao'),
(15, 1, '2025-05-18', 180000, N'Đã thanh toán', N'Đang xử lý'),
(16, 2, '2025-05-20', 40000, N'Chưa thanh toán', N'Hoàn thành'),
(17, 1, '2025-05-22', 50000, N'Đã thanh toán', N'Đang giao'),
(18, 2, '2025-05-25', 60000, N'Chưa thanh toán', N'Đã huỷ'),
(19, 1, '2025-05-28', 140000, N'Đã thanh toán', N'Hoàn thành'),
(20, 2, '2025-05-30', 200000, N'Chưa thanh toán', N'Đang xử lý');


INSERT INTO CHITIETDH (MADH, MASP, SOLUONG, DONGIA, MAKM, TONGTIEN) VALUES
(5, 4, 2, 28000, NULL, 56000),    -- Cà rốt
(5, 5, 1, 25000, NULL, 25000),    -- Bắp ngọt Mỹ
(6, 10, 3, 35000, NULL, 105000),  -- Cà chua bi organic
(6, 15, 1, 120000, NULL, 120000), -- Nấm hương khô
(7, 1, 1, 23900, NULL, 23900),    -- Xoài keo 1kg
(7, 20, 4, 11000, NULL, 44000),   -- Trà C2 vị chanh
(8, 25, 2, 11000, NULL, 22000),   -- Pepsi lon
(9, 30, 1, 250000, NULL, 250000), -- Sữa bột Bfast
(9, 31, 1, 300000, NULL, 300000), -- Sữa Ensure Gold
(10, 35, 2, 200000, NULL, 400000), -- Sữa bột Kun
(10, 36, 1, 150000, NULL, 150000), -- Sữa Milo
(11, 40, 2, 50000, NULL, 100000), -- Bánh tráng nướng
(11, 41, 3, 30000, NULL, 90000),  -- Bột khoai
(12, 45, 1, 30000, NULL, 30000),  -- Đậu phộng rang muối
(13, 50, 2, 40000, NULL, 80000),  -- Lá kim cuốn cơm
(13, 51, 1, 40000, NULL, 40000),  -- Miến dong cao cấp
(14, 55, 3, 40000, NULL, 120000), -- Rong biển nướng
(14, 56, 2, 60000, NULL, 120000), -- Rong nho tươi
(15, 60, 1, 40000, NULL, 40000),  -- Bơ sáp Việt Nam
(16, 65, 2, 60000, NULL, 120000), -- Dưa lưới Nhật Bản
(16, 66, 1, 40000, NULL, 40000),  -- Dưa gang Hàn Quốc
(17, 70, 2, 70000, NULL, 140000), -- Kiwi vàng New Zealand
(18, 71, 2, 100000, NULL, 200000), -- Nho đen Mỹ
(18, 1, 1, 30000, NULL, 30000),   -- Ổi không hạt Thái Lan (điều chỉnh giá và số lượng)
(19, 2, 1, 70000, NULL, 70000),   -- Táo nhỏ Nhật Bản (điều chỉnh giá)
(20, 5, 2, 25000, NULL, 50000),   -- Bắp ngọt Mỹ
(20, 10, 3, 35000, NULL, 105000), -- Cà chua bi organic
(21, 15, 1, 120000, NULL, 120000), -- Nấm hương khô
(21, 20, 2, 11000, NULL, 22000),  -- Trà C2 vị chanh
(22, 25, 3, 11000, NULL, 33000),  -- Pepsi lon
(22, 30, 1, 250000, NULL, 250000), -- Sữa bột Bfast
(23, 35, 2, 200000, NULL, 400000), -- Sữa bột Kun
(23, 40, 1, 50000, NULL, 50000),  -- Bánh tráng nướng
(24, 45, 2, 30000, NULL, 60000),  -- Đậu phộng rang muối
(24, 50, 1, 40000, NULL, 40000),  -- Lá kim cuốn cơm
(25, 1, 2, 23900, NULL, 47800),   -- Xoài keo 1kg
(25, 5, 2, 25000, NULL, 50000),   -- Bắp ngọt Mỹ
(26, 10, 1, 35000, NULL, 35000),  -- Cà chua bi organic
(27, 15, 1, 120000, NULL, 120000), -- Nấm hương khô
(27, 20, 1, 11000, NULL, 11000),  -- Trà C2 vị chanh
(28, 25, 1, 11000, NULL, 11000),  -- Pepsi lon
(29, 30, 2, 250000, NULL, 500000), -- Sữa bột Bfast
(29, 31, 1, 300000, NULL, 300000), -- Sữa Ensure Gold
(30, 35, 2, 200000, NULL, 400000), -- Sữa bột Kun
(30, 36, 1, 150000, NULL, 150000), -- Sữa Milo
(31, 40, 1, 50000, NULL, 50000),  -- Bánh tráng nướng
(32, 45, 2, 30000, NULL, 60000),  -- Đậu phộng rang muối
(32, 50, 1, 40000, NULL, 40000),  -- Lá kim cuốn cơm
(33, 55, 1, 40000, NULL, 40000),  -- Rong biển nướng
(34, 60, 2, 40000, NULL, 80000),  -- Bơ sáp Việt Nam
(34, 61, 1, 18000, NULL, 18000),  -- Bắp cải trắng Đà Lạt
(35, 65, 3, 60000, NULL, 180000), -- Dưa lưới Nhật Bản
(36, 70, 2, 70000, NULL, 140000), -- Kiwi vàng New Zealand
(36, 2, 1, 20000, NULL, 20000),   -- Bắp cải tím organic (điều chỉnh giá)
(37, 71, 1, 100000, NULL, 100000), -- Nho đen Mỹ
(38, 1, 2, 70000, NULL, 140000),  -- Táo nhỏ Nhật Bản (điều chỉnh giá)
(39, 5, 1, 25000, NULL, 25000),   -- Bắp ngọt Mỹ
(40, 10, 2, 35000, NULL, 70000),  -- Cà chua bi organic
(40, 15, 1, 120000, NULL, 120000), -- Nấm hương khô
(41, 20, 2, 11000, NULL, 22000),  -- Trà C2 vị chanh
(42, 25, 2, 11000, NULL, 22000),  -- Pepsi lon
(43, 30, 1, 250000, NULL, 250000), -- Sữa bột Bfast
(44, 35, 1, 200000, NULL, 200000), -- Sữa bột Kun
(45, 40, 2, 50000, NULL, 100000), -- Bánh tráng nướng
(46, 45, 1, 30000, NULL, 30000),  -- Đậu phộng rang muối
(47, 50, 1, 40000, NULL, 40000),  -- Lá kim cuốn cơm
(48, 55, 1, 40000, NULL, 40000),  -- Rong biển nướng
(49, 60, 1, 40000, NULL, 40000),  -- Bơ sáp Việt Nam
(50, 65, 2, 60000, NULL, 120000), -- Dưa lưới Nhật Bản
(51, 70, 2, 70000, NULL, 140000), -- Kiwi vàng New Zealand
(52, 71, 1, 100000, NULL, 100000), -- Nho đen Mỹ
(53, 1, 2, 23900, NULL, 47800),   -- Xoài keo 1kg
(54, 5, 1, 25000, NULL, 25000),   -- Bắp ngọt Mỹ
(55, 10, 1, 35000, NULL, 35000),  -- Cà chua bi organic
(56, 15, 1, 120000, NULL, 120000), -- Nấm hương khô
(57, 20, 3, 11000, NULL, 33000),  -- Trà C2 vị chanh
(58, 25, 2, 11000, NULL, 22000),  -- Pepsi lon
(59, 30, 2, 250000, NULL, 500000), -- Sữa bột Bfast
(60, 35, 2, 200000, NULL, 400000), -- Sữa bột Kun
(61, 40, 1, 50000, NULL, 50000),  -- Bánh tráng nướng
(62, 45, 2, 30000, NULL, 60000),  -- Đậu phộng rang muối
(63, 50, 1, 40000, NULL, 40000),  -- Lá kim cuốn cơm
(64, 55, 1, 40000, NULL, 40000),  -- Rong biển nướng
(65, 60, 2, 40000, NULL, 80000),  -- Bơ sáp Việt Nam
(66, 65, 1, 60000, NULL, 60000),  -- Dưa lưới Nhật Bản
(67, 70, 2, 70000, NULL, 140000), -- Kiwi vàng New Zealand
(68, 71, 1, 100000, NULL, 100000), -- Nho đen Mỹ
(69, 1, 2, 23900, NULL, 47800),   -- Xoài keo 1kg
(70, 5, 1, 25000, NULL, 25000),   -- Bắp ngọt Mỹ
(71, 10, 2, 35000, NULL, 70000),  -- Cà chua bi organic
(72, 15, 1, 120000, NULL, 120000), -- Nấm hương khô
(73, 20, 2, 11000, NULL, 22000),  -- Trà C2 vị chanh
(74, 25, 3, 11000, NULL, 33000);  -- Pepsi lon




INSERT INTO GIOHANG (MAKH) VALUES
(1),   
(3),    
(5),   
(7),  
(9),    
(11),  
(13),  
(15),  
(17),  
(19),   
(2),    
(4),    
(6);    


INSERT INTO CHITIETGH (MAGH, MASP, SOLUONG, TONGTIEN) VALUES
-- Giỏ hàng 1 (MAKH 1) 
(1, 1, 2, 47800),    -- Xoài keo 1kg (23,900 * 2)
(1, 14, 1, 9000),    -- Trà C2 vị chanh

-- Giỏ hàng 2 (MAKH 3)
(2, 3, 1, 450000),   -- Thùng sữa TH True Milk
(2, 5, 3, 1350000),  -- Cà rốt (28,000 * 3)
(2, 28, 2, 100000),  -- Bánh tráng nướng (50,000 * 2)

-- Giỏ hàng 3 (MAKH 5)
(3, 17, 1, 250000),  -- Sữa Bfast

-- Giỏ hàng 4 (MAKH 7) 
(4, 6, 2, 70000),    -- Cà chua bi organic (35,000 * 2)
(4, 10, 1, 25000),   -- Khoai tây Pháp
(4, 15, 3, 33000),   -- Coca-Cola (11,000 * 3)
(4, 47, 1, 70000),   -- Chân gà ngâm sả tắc

-- Giỏ hàng 5 (MAKH 9)
(5, 19, 1, 320000),  -- Sữa Glucerna
(5, 33, 2, 80000),   -- Gimbag rong biển (40,000 * 2)

-- Giỏ hàng 6 (MAKH 11) 
(6, 22, 1, 150000),  -- Sữa Milo
(6, 30, 2, 90000),   -- Chả lụa chay (45,000 * 2)
(6, 44, 1, 35000),   -- Bưởi da xanh

-- Giỏ hàng 7 (MAKH 13)
(7, 8, 2, 60000),    -- Hành tây đỏ (30,000 * 2)
(7, 12, 1, 40000),   -- Ớt chuông vàng
(7, 25, 1, 180000),  -- Sữa Nutimilk
(7, 35, 2, 120000),  -- Khô heo sấy tỏi (60,000 * 2)
(7, 46, 1, 70000),   -- Táo nhỏ Nhật

-- Giỏ hàng 8 (MAKH 15)
(8, 9, 1, 18000),    -- Dưa leo Nhật
(8, 41, 1, 80000),   -- Posi thịt bò khô

-- Giỏ hàng 9 (MAKH 17) 
(9, 13, 2, 70000),   -- Thơm Thái Lan (35,000 * 2)
(9, 26, 1, 200000),  -- Sữa Ovaltine
(9, 38, 1, 40000),   -- Miến dong

-- Giỏ hàng 10 (MAKH 19) 
(10, 16, 2, 20000),  -- Fanta cam (10,000 * 2)
(10, 20, 1, 280000), -- Sữa Grow Plus
(10, 29, 1, 30000),  -- Bột khoai màu
(10, 45, 1, 70000),  -- Kiwi vàng

-- Giỏ hàng 11 (MAKH 2)
(11, 2, 1, 39000),   -- Quýt giống Úc
(11, 31, 1, 35000),  -- Đậu nành rang

-- Giỏ hàng 12 (MAKH 4)
(12, 4, 2, 56000),   -- Cà rốt (28,000 * 2)
(12, 18, 1, 300000), -- Ensure Gold
(12, 37, 1, 90000),  -- Nấm tuyết khô

-- Giỏ hàng 13 (MAKH 6) 
(13, 27, 1, 290000); -- Sữa Nuvie




-- DELETE FROM TINHTHANH;

-- DBCC CHECKIDENT (DONHANG, RESEED, 0);

/*
SELECT 
    KH.MAKH,
    KH.TENKH,
    KH.SDT,
    KH.DIACHI AS DIACHI_MACDINH,
    KH.GIOITINH,
    KH.HINHANH,
    DC.DIACHI_CHITIET,
    TT.TENTINH,
    QH.TENQUAN,
    PX.TENPHUONG,
    DC.GHICHU
FROM KHACHHANG KH
LEFT JOIN DIACHIGIAOHANG DC ON KH.MAKH = DC.MAKH
LEFT JOIN TINHTHANH TT ON DC.MATINH = TT.MATINH
LEFT JOIN QUANHUYEN QH ON DC.MAQUANHUYEN = QH.MAQUAN
LEFT JOIN PHUONGXA PX ON DC.MAPHUONGXA = PX.MAPHUONG;
*/



