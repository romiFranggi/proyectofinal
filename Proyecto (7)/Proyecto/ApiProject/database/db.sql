USE laCandelaDB;

-- Eliminar las tablas en el orden correcto para evitar conflictos de claves foráneas
DROP TABLE IF EXISTS Suppliers;
DROP TABLE IF EXISTS Colors;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS ProductColor;
DROP TABLE IF EXISTS Categories;
DROP TABLE IF EXISTS Users;

-- Crear la tabla Categories con jerarquía de categorías y subcategorías
CREATE TABLE Categories (
    CategoryId INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    ParentCategoryId INT NULL, -- NULL para categorías generales; apunta a una categoría general para subcategorías
    FOREIGN KEY (ParentCategoryId) REFERENCES Categories(CategoryId)
);

CREATE TABLE Colors (
	ColorId INT PRIMARY KEY IDENTITY(1,1),
	Name NVARCHAR(100) NOT NULL,
)


-- Crear la tabla Products con relación a Categories, agregando Largo, Ancho y Color
CREATE TABLE Products (
    ProductId INT PRIMARY KEY IDENTITY(1,1), 
    Name NVARCHAR(100) NOT NULL,
	Price DECIMAL(18, 2),  
    Cost DECIMAL(18, 2) NOT NULL,     
    Description NVARCHAR(255),         
    Quantity INT,
    CategoryId INT FOREIGN KEY REFERENCES Categories(CategoryId),
    CreationDate DATETIME DEFAULT GETDATE(),
    ImageUrl VARCHAR(255), -- Ruta o URL de la imagen del producto
    Rate DECIMAL(3, 2) DEFAULT 0, -- Nueva columna Rate entre 0 y 5, con 2 decimales
    Base DECIMAL(10, 2) NULL,  
    Height DECIMAL(10, 2) NULL,
	Weight DECIMAL(10, 2) NULL,
	Volume DECIMAL(10, 2) NULL,
	Package INT NULL,
);

CREATE TABLE ProductColor(
	ColorId INT FOREIGN KEY REFERENCES Colors(ColorId),
	ProductId INT FOREIGN KEY REFERENCES Products(ProductId),
	PRIMARY KEY(ColorId, ProductId)
)


-- Crear la tabla Suppliers con relación a Products
CREATE TABLE Suppliers (
    SupplierId INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Phone NVARCHAR(15),
    ProductId INT FOREIGN KEY REFERENCES Products(ProductId),
    Cost DECIMAL(18, 2) NOT NULL,
    Email NVARCHAR(100) UNIQUE,
    LastPurchaseDate DATE
);

-- Crear la tabla Users con los campos adicionales
CREATE TABLE Users (
    UserId INT PRIMARY KEY IDENTITY(1,1),
    UserName NVARCHAR(50) NOT NULL,
    Password NVARCHAR(255) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    Birthdate DATE,
    Address NVARCHAR(255),
    RUT NVARCHAR(20) /*UNIQUE*/ NULL,
    Phone NVARCHAR(15),
    ContactName NVARCHAR(100)
);

-- Insertar categorías generales
INSERT INTO Categories (Name, ParentCategoryId) VALUES 
    ('Velas', NULL), --1
    ('Sahumerios', NULL), --2
    ('Decoraciones', NULL); --3

-- Insertar subcategorías relacionadas con las categorías generales
INSERT INTO Categories (Name, ParentCategoryId) VALUES 
    ('Aromáticas', 1),          -- Subcategoría de Velas
    ('Naturales', 2),           -- Subcategoría de Sahumerios
    ('Estatuas', 3),            -- Subcategoría de Decoraciones
    ('Mandala', 3);             -- Subcategoría de Decoraciones

-- Insertar productos de ejemplo para cada categoría, incluyendo la imagen, rate, y los nuevos campos
-- Los Sahumerios tienen las medidas y color nulos
INSERT INTO Products (Name, Price, Cost, Description, Quantity, CategoryId, CreationDate, ImageUrl, Rate, Base, Height, Weight, Volume, Color, Package) VALUES 	
('Velas lisas', 330.00, 0, 'Pack de 50 velas lisas, ideales para crear una atmósfera cálida en cualquier ocasión.', 30, 1, GETDATE(), 'https://http2.mlstatic.com/D_NQ_NP_614227-MLU50254517021_062022-O.webp', 0, NULL, NULL, NULL, NULL, NULL, 50),	--1
('Velas combinadas', 439.00, 0, 'Pack de 50 velas combinadas en varios colores, perfectas para dar un toque de color.', 30, 1, GETDATE(), 'https://mundovelas.com.uy/5314-thickbox_default/vela-familiar-combinada-25-unidades-mismo-color.jpg', 0, NULL, NULL, NULL, NULL, NULL, 50),	--2
('Velas super', 720.00, 0, 'Pack de 50 velas de tamaño grande, ideales para una iluminación duradera en el hogar.', 30, 1, GETDATE(), 'https://www.velaspampeana.com/sitio/wp-content/uploads/2024/03/Super-Blanca-x3.jpg', 0, NULL, NULL, NULL, NULL, NULL, 50),	--3
('Velon 7 dias', 139.00, 0, 'Velón de larga duración, ideal para rituales o decoraciones prolongadas.', 30, 1, GETDATE(), 'https://f.fcdn.app/imgs/d408ef/www.lacasadelasvelas.com.uy/caveuy/d555/original/catalogo/240432_azul_1/2000-2000/velon-7-dias-7-noches-liso-x12-azul.jpg', 0, NULL, NULL, NULL, NULL, NULL, 1),	--4
('Velon 7 dias combinado', 165.00, 0, 'Velón de 7 días en colores combinados, perfecto para crear un ambiente único.', 30, 1, GETDATE(), 'https://f.fcdn.app/imgs/d9ec6c/www.lacasadelasvelas.com.uy/caveuy/4a25/original/catalogo/240431_azulrojo_1/2000-2000/velon-7-dias-7-noches-combinado-x12-azul-rojo.jpg', 0, NULL, NULL, NULL, NULL, NULL, 1),	--5
('Velon', 26.00, 0, 'Velón compacto de 4x6 cm, ideal para decoraciones pequeñas o altares.', 30, 1, GETDATE(), 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTiZLmoQh-a5zKieGb8UCQEDyk8PQfRs5Ew-A&s', 0, 4, 6, NULL, NULL, NULL, 1),	--6
('Velon', 39.00, 0, 'Velón de 4x10 cm, de larga duración para espacios acogedores.', 30, 1, GETDATE(), 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTiZLmoQh-a5zKieGb8UCQEDyk8PQfRs5Ew-A&s', 0, 4, 10, NULL, NULL, NULL, 1),	--7
('Velon', 27.00, 0, 'Velón compacto de 3.5x6 cm, perfecto para crear ambientes íntimos.', 30, 1, GETDATE(), 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTiZLmoQh-a5zKieGb8UCQEDyk8PQfRs5Ew-A&s', 0, 3.5, 6, NULL, NULL, NULL, 1),	--8
('Velon', 39.00, 0, 'Velón de 5x5 cm, perfecto para decoraciones o meditaciones prolongadas.', 30, 1, GETDATE(), 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTiZLmoQh-a5zKieGb8UCQEDyk8PQfRs5Ew-A&s', 0, 5, 5, NULL, NULL, NULL, 1),	--9
('Velon', 43.00, 0, 'Velón de 5x7 cm para una iluminación duradera y suave.', 30, 1, GETDATE(), 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTiZLmoQh-a5zKieGb8UCQEDyk8PQfRs5Ew-A&s', 0, 5, 7, NULL, NULL, NULL, 1),	--10
('Velon', 66.00, 0, 'Velón de 5x10 cm, ideal para decoración en cenas o eventos.', 30, 1, GETDATE(), 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTiZLmoQh-a5zKieGb8UCQEDyk8PQfRs5Ew-A&s', 0, 5, 10, NULL, NULL, NULL, 1),	--11
('Velon', 65.00, 0, 'Velón de 6x6 cm que proporciona una luz suave y duradera.', 30, 1, GETDATE(), 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTiZLmoQh-a5zKieGb8UCQEDyk8PQfRs5Ew-A&s', 0, 6, 6, NULL, NULL, NULL, 1),	--12
('Velon', 96.00, 0, 'Velón de 6x10 cm, excelente para crear ambientes cálidos y relajantes.', 30, 1, GETDATE(), 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTiZLmoQh-a5zKieGb8UCQEDyk8PQfRs5Ew-A&s', 0, 6, 10, NULL, NULL, NULL, 1),	--13
('Velon', 139.00, 0, 'Velón de 6x15 cm, ideal para decoraciones elegantes y meditaciones prolongadas.', 30, 1, GETDATE(), 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTiZLmoQh-a5zKieGb8UCQEDyk8PQfRs5Ew-A&s', 0, 6, 15, NULL, NULL, NULL, 1),	--14
('Velon', 135.00, 0, 'Velón de 8x8 cm, diseñado para una luz suave y prolongada.', 30, 1, GETDATE(), 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTiZLmoQh-a5zKieGb8UCQEDyk8PQfRs5Ew-A&s', 0, 8, 8, NULL, NULL, NULL, 1),	--15
('Velon', 265.00, 0, 'Velón de 10x10 cm, perfecto para crear un ambiente relajante en cualquier espacio.', 30, 1, GETDATE(), 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTiZLmoQh-a5zKieGb8UCQEDyk8PQfRs5Ew-A&s', 0, 10, 10, NULL, NULL, NULL, 1),	--16
('Velon prisma', 39.00, 0, 'Velón en forma de prisma de 4x6 cm, ideal para decoraciones modernas.', 30, 1, GETDATE(), 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ7HgRfeJ9h48_rDqHbOpu4Bco5tR6ltWvP7A&s', 0, 4, 6, NULL, NULL, NULL, 1),	--17
('Vela cubo', 69.00, 0, 'Vela en forma de cubo de 6 cm, perfecta para decoraciones originales y únicas.', 30, 1, GETDATE(), 'https://imagedelivery.net/4fYuQyy-r8_rpBpcY7lH_A/sodimacPE/248255X_01/w=800,h=800,fit=pad', 0, 6, 6, NULL, NULL, NULL, 1),	--18
('Vela disco', 19.00, 0, 'Vela flotante en forma de disco de 4x3 cm, ideal para centros de mesa en agua.', 30, 1, GETDATE(), 'https://lacasadelartesano.com.uy/images/thumbs/0063087_vela-disco-flotante-artesano-de-34-cm.jpeg', 0, 4, 3, NULL, NULL, NULL, 1),	--19
('Vela flotante', 15.00, 0, 'Vela flotante de 4x1.5 cm, ideal para decoraciones acuáticas.', 30, 1, GETDATE(), 'https://i0.wp.com/www.velaspampeana.com/sitio/wp-content/uploads/2023/06/flotante-varios.jpg?fit=600%2C450&ssl=1', 0, 4, 1.5, NULL, NULL, NULL, 1),	--20
('Vela aromatica', 89.00, 0, 'Vela aromática de 5x5 cm, que proporciona un suave aroma y un ambiente acogedor.', 30, 1, GETDATE(), 'https://velasdelatlantico.com/wp-content/uploads/2022/11/velas-aromaticas.jpg', 0, 5, 5, NULL, NULL, NULL, 1),	--21
('Vela aromatica', 139.00, 0, 'Vela aromática de 5x10 cm, que crea un ambiente perfumado y cálido por horas.', 30, 1, GETDATE(), 'https://velasdelatlantico.com/wp-content/uploads/2022/11/velas-aromaticas.jpg', 0, 5, 10, NULL, NULL, NULL, 1),	--22
('Vela aromatica', 135.00, 0, 'Vela aromática de 8x8 cm, con una fragancia suave y elegante.', 30, 1, GETDATE(), 'https://velasdelatlantico.com/wp-content/uploads/2022/11/velas-aromaticas.jpg', 0, 8, 8, NULL, NULL, NULL, 1),	--23
('Vela cónica', 32.00, 0, 'Vela cónica de 30 cm, ideal para decoraciones elegantes y ceremoniales.', 30, 1, GETDATE(), 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQhGPnmUutpiy8UQepqmFZtO4hugeqQQwf3Ag&s', 0, 30, 30, NULL, NULL, NULL, 1), --24
('Vela torneada', 24.00, 0, 'Vela torneada decorativa con diseño esculpido.', 30, 1, GETDATE(), 'https://mundovelas.com.uy/3030-large_default/vela-torneada-lisa.jpg', 0, NULL, NULL, NULL, NULL, NULL, 1), --25
('Velón perfumado', 52.00, 0, 'Velón perfumado de 3x5 cm, con fragancia relajante.', 30, 1, GETDATE(), 'https://mundovelas.com.uy/4687/velon-perfumado-6-cm-base-x-5-cm-alto.jpg', 0, 3, 5, NULL, NULL, NULL, 1), --26
('Velón perfumado', 135.00, 0, 'Velón perfumado de 5x5 cm, ideal para aromatizar ambientes.', 30, 1, GETDATE(), 'https://mundovelas.com.uy/4687/velon-perfumado-6-cm-base-x-5-cm-alto.jpg', 0, 5, 5, NULL, NULL, NULL, 1), --27
('Vela perfumada en vaso', 135.00, 0, 'Vela perfumada en vaso de vidrio, perfecta para regalar.', 30, 1, GETDATE(), 'https://http2.mlstatic.com/D_NQ_NP_798860-MLU69780788019_062023-O.webp', 0, NULL, NULL, NULL, NULL, NULL, 1), --28
('Vela perfumada en lata', 135.00, 0, 'Vela perfumada en lata, práctica y fácil de transportar.', 30, 1, GETDATE(), 'https://prod-resize.tiendainglesa.com.uy/images/medium/P496916-1.jpg?20201008160054,Vela-en-Lata-Chica-Perfumada-en-Tienda-Inglesa', 0, NULL, NULL, NULL, NULL, NULL, 1), --29
('Vasito con vela', 49.00, 0, 'Vela aromática en vasito, ideal para decorar y perfumar.', 30, 1, GETDATE(), 'https://f.fcdn.app/imgs/037e97/www.haydetodo.com.uy/htoduy/d44e/original/catalogo/VYA800361_vya800361_1/1920-1200/vela-aromatica-en-vasito-5x7-3cm-vela-aromatica-en-vasito-5x7-3cm.jpg', 0, NULL, NULL, NULL, NULL, NULL, 1), --30
('Fanal', 79.00, 0, 'Fanal decorativo de 8 cm, ideal para iluminar ambientes exteriores.', 30, 3, GETDATE(), 'https://f.fcdn.app/imgs/a75d75/www.guapa.com.uy/gua/77cd/original/catalogo/HB25134_01_1/450x600/fanal-15-5-cm-x-12-5-cm-negro.jpg', 0, 8, 8, NULL, NULL, NULL, 1), --31
('Fanal', 125.00, 0, 'Fanal decorativo de 10 cm para ambientes acogedores.', 30, 3, GETDATE(), 'https://f.fcdn.app/imgs/a75d75/www.guapa.com.uy/gua/77cd/original/catalogo/HB25134_01_1/450x600/fanal-15-5-cm-x-12-5-cm-negro.jpg', 0, 10, 10, NULL, NULL, NULL, 1), --32
('Fanal', 169.00, 0, 'Fanal de 12 cm, ideal para espacios amplios.', 30, 3, GETDATE(), 'https://f.fcdn.app/imgs/a75d75/www.guapa.com.uy/gua/77cd/original/catalogo/HB25134_01_1/450x600/fanal-15-5-cm-x-12-5-cm-negro.jpg', 0, 12, 12, NULL, NULL, NULL, 1), --33
('Fanal globo', 39.00, 0, 'Mini fanal globo, diseño moderno y compacto.', 30, 3, GETDATE(), 'https://acdn.mitiendanube.com/stores/933/006/products/fanal-globo1-4ef1ebc03b543fcce716691726121922-1024-1024.jpg', 0, NULL, NULL, NULL, NULL, NULL, 1), --34
('Fanal globo', 79.00, 0, 'Fanal globo de 10 cm, de diseño contemporáneo.', 30, 3, GETDATE(), 'https://acdn.mitiendanube.com/stores/933/006/products/fanal-globo1-4ef1ebc03b543fcce716691726121922-1024-1024.jpg', 0, NULL, NULL, NULL, NULL, NULL, 1), --35
('Fanal globo', 135.00, 0, 'Fanal globo de 12 cm, perfecto para iluminar con estilo.', 30, 3, GETDATE(), 'https://acdn.mitiendanube.com/stores/933/006/products/fanal-globo1-4ef1ebc03b543fcce716691726121922-1024-1024.jpg', 0, NULL, NULL, NULL, NULL, NULL, 1), --36
('Fanal globo', 199.00, 0, 'Fanal globo de 15 cm, ilumina espacios amplios.', 30, 3, GETDATE(), 'https://acdn.mitiendanube.com/stores/933/006/products/fanal-globo1-4ef1ebc03b543fcce716691726121922-1024-1024.jpg', 0, NULL, NULL, NULL, NULL, NULL, 1), --37
('Fanal globo', 315.00, 0, 'Fanal globo de 20 cm, para decoración elegante.', 30, 3, GETDATE(), 'https://acdn.mitiendanube.com/stores/933/006/products/fanal-globo1-4ef1ebc03b543fcce716691726121922-1024-1024.jpg', 0, 10, 10, NULL, NULL, NULL, 1), --38
('Vela miel', 27.00, 0, 'Vela de miel de 3x3 cm, natural y suave.', 30, 1, GETDATE(), 'https://www.onnea.com.uy/cdn/shop/files/60955f_619340f6a6b64eb89a3768d58381b457_mv2_jpg_1200x1200.webp?v=1722727868', 0, 3, 3, NULL, NULL, NULL, 1), --39
('Vela miel', 43.00, 0, 'Vela de miel de 3x6 cm, aroma natural y relajante.', 30, 1, GETDATE(), 'https://www.onnea.com.uy/cdn/shop/files/60955f_619340f6a6b64eb89a3768d58381b457_mv2_jpg_1200x1200.webp?v=1722727868', 0, 3, 6, NULL, NULL, NULL, 1), --40
('Vela miel', 30.00, 0, 'Vela de miel de 2x10 cm, pequeña y perfumada.', 30, 1, GETDATE(), 'https://www.onnea.com.uy/cdn/shop/files/60955f_619340f6a6b64eb89a3768d58381b457_mv2_jpg_1200x1200.webp?v=1722727868', 0, 2, 10, NULL, NULL, NULL, 1), --41
('Vela miel', 45.00, 0, 'Vela miel de 2x20', 30, 1, GETDATE(), 'https://www.onnea.com.uy/cdn/shop/files/60955f_619340f6a6b64eb89a3768d58381b457_mv2_jpg_1200x1200.webp?v=1722727868', 0, 2, 20, NULL, NULL, NULL, 1),	--42
('Vela miel buda', 95.00, 0, 'Vela miel buda', 30, 1, GETDATE(), 'https://gharamartesanal.com/1982-large_default/vela-miel-pequeno-buda.jpg', 0, NULL, NULL, NULL, NULL, NULL, 1),	--43
('Vela de cera', 110.00, 0, 'Vela de cera 2x45 cm', 30, 1, GETDATE(), 'https://http2.mlstatic.com/D_NQ_NP_775522-MLM74472996775_022024-O.webp', 0, 2, 45, NULL, NULL, NULL, 1),	--44
('Vela de cera', 159.00, 0, 'Vela de cera 2.5x50 cm', 30, 1, GETDATE(), 'https://http2.mlstatic.com/D_NQ_NP_775522-MLM74472996775_022024-O.webp', 0, 2.5, 50, NULL, NULL, NULL, 1),	--45
('Vela de cera', 235.00, 0, 'Vela de cera 3.5x50cm', 30, 1, GETDATE(), 'https://http2.mlstatic.com/D_NQ_NP_775522-MLM74472996775_022024-O.webp', 0, 3.5, 50, NULL, NULL, NULL, 1),	--46
('Cirio', 829.00, 0, 'Cirio de 4x60 cm', 30, 1, GETDATE(), 'https://http2.mlstatic.com/D_NQ_NP_775522-MLM74472996775_022024-O.webp', 0, 4, 60, NULL, NULL, NULL, 1),	--47
('Cirio', 1239.00, 0, 'Cirio de 6x60 cm', 30, 1, GETDATE(), 'https://http2.mlstatic.com/D_NQ_NP_775522-MLM74472996775_022024-O.webp', 0, 6, 60, NULL, NULL, NULL, 1),	--48
('Cirio', 1859.00, 0, 'Cirio de 7x60 cm', 30, 1, GETDATE(), 'https://http2.mlstatic.com/D_NQ_NP_775522-MLM74472996775_022024-O.webp', 0, 7, 60, NULL, NULL, NULL, 1),	--49
('Cirio', 3629.00, 0, 'Cirio de 10x60 cm', 30, 1, GETDATE(), 'https://http2.mlstatic.com/D_NQ_NP_775522-MLM74472996775_022024-O.webp', 0, 10, 60, NULL, NULL, NULL, 1),	--50
('Cirio', 105.00, 0, 'Cirio de 6x7 cm', 30, 1, GETDATE(), 'https://http2.mlstatic.com/D_NQ_NP_775522-MLM74472996775_022024-O.webp', 0, 6, 7, NULL, NULL, NULL, 1),	--51
('Cirio', 135.00, 0, 'Cirio de 6x9 cm', 30, 1, GETDATE(), 'https://http2.mlstatic.com/D_NQ_NP_775522-MLM74472996775_022024-O.webp', 0, 6, 9, NULL, NULL, NULL, 1),	--52
('Cirio', 189.00, 0, 'Cirio de 6x15 cm', 30, 1, GETDATE(), 'https://http2.mlstatic.com/D_NQ_NP_775522-MLM74472996775_022024-O.webp', 0, 6, 15, NULL, NULL, NULL, 1),	--53
('Cirio', 239.00, 0, 'Cirio de 6x20 cm', 30, 1, GETDATE(), 'https://http2.mlstatic.com/D_NQ_NP_775522-MLM74472996775_022024-O.webp', 0, 6, 20, NULL, NULL, NULL, 1),	--54
('Cirio', 135.00, 0, 'Cirio de 7x7 cm', 30, 1, GETDATE(), 'https://http2.mlstatic.com/D_NQ_NP_775522-MLM74472996775_022024-O.webp', 0, 7, 7, NULL, NULL, NULL, 1),	--55
('Cirio', 159.00, 0, 'Cirio de 7x9 cm', 30, 1, GETDATE(), 'https://http2.mlstatic.com/D_NQ_NP_775522-MLM74472996775_022024-O.webp', 0, 7, 9, NULL, NULL, NULL, 1),	--56
('Cirio', 269.00, 0, 'Cirio de 7x15 cm', 30, 1, GETDATE(), 'https://http2.mlstatic.com/D_NQ_NP_775522-MLM74472996775_022024-O.webp', 0, 7, 15, NULL, NULL, NULL, 1),	--57
('Cirio', 299.00, 0, 'Cirio de 7x20 cm', 30, 1, GETDATE(), 'https://http2.mlstatic.com/D_NQ_NP_775522-MLM74472996775_022024-O.webp', 0, 7, 20, NULL, NULL, NULL, 1),	--58
('Cirio', 378.00, 0, 'Cirio de 10x10 cm', 30, 1, GETDATE(), 'https://http2.mlstatic.com/D_NQ_NP_775522-MLM74472996775_022024-O.webp', 0, 10, 10, NULL, NULL, NULL, 1),	--59
('Cirio', 529.00, 0, 'Cirio de 10x15 cm', 30, 1, GETDATE(), 'https://http2.mlstatic.com/D_NQ_NP_775522-MLM74472996775_022024-O.webp', 0, 10, 15, NULL, NULL, NULL, 1),	--60
('Cirio', 659.00, 0, 'Cirio de 10x20 cm', 30, 1, GETDATE(), 'https://http2.mlstatic.com/D_NQ_NP_775522-MLM74472996775_022024-O.webp', 0, 10, 20, NULL, NULL, NULL, 1),	--61
('Cirio', 795.00, 0, 'Cirio de 10x25 cm', 30, 1, GETDATE(), 'https://http2.mlstatic.com/D_NQ_NP_775522-MLM74472996775_022024-O.webp', 0, 10, 25, NULL, NULL, NULL, 1),	--62
('Cirio', 989.00, 0, 'Cirio de 10x30 cm', 30, 1, GETDATE(), 'https://http2.mlstatic.com/D_NQ_NP_775522-MLM74472996775_022024-O.webp', 0, 10, 30, NULL, NULL, NULL, 1),	--63
('Velon', 315.00, 0, 'Velon de 10x10 cm', 30, 1, GETDATE(), 'https://http2.mlstatic.com/D_NQ_NP_775522-MLM74472996775_022024-O.webp', 0, 10, 10, NULL, NULL, NULL, 1),	--64
('Velon', 439.00, 0, 'Velon de 10x15 cm', 30, 1, GETDATE(), 'https://http2.mlstatic.com/D_NQ_NP_775522-MLM74472996775_022024-O.webp', 0, 10, 15, NULL, NULL, NULL, 1),	--65
('Velon', 549.00, 0, 'Velon de 10x20 cm', 30, 1, GETDATE(), 'https://http2.mlstatic.com/D_NQ_NP_775522-MLM74472996775_022024-O.webp', 0, 10, 20, NULL, NULL, NULL, 1),	--66
('Vela inglesa', 289.00, 0, 'Vela inglesa de 15 cm', 30, 1, GETDATE(), 'https://prod-resize.tiendainglesa.com.uy/images/medium/P535868-1.jpg?20221021152738,Vela-Aromatica-de-15-cm-de-Alto-Serenity-Vainilla-en-Tienda-Inglesa', 0, 15, 15, NULL, NULL, NULL, 50),	--67
('Vela inglesa', 399.00, 0, 'Vela inglesa de 25 cm', 30, 1, GETDATE(), 'https://prod-resize.tiendainglesa.com.uy/images/medium/P535868-1.jpg?20221021152738,Vela-Aromatica-de-15-cm-de-Alto-Serenity-Vainilla-en-Tienda-Inglesa', 0, 25, 25, NULL, NULL, NULL, 50),	--68
('Vela N° de cumpleaños', 32.00, 0, 'Vela que representa un numero, ideal para cumpleaños', 30, 1, GETDATE(), 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSFa24NE5OrBp3KE8JMYH-MfwDmy37j14cRlw&s', 0, NULL, NULL, NULL, NULL, NULL, 1),	--69
('Vela vestido', 110.00, 0, 'Vela con forma de vestido', 30, 1, GETDATE(), 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQMSOgF0NqptQ7B-VgCnh68PJeYwZKjVh2Fbg&s', 0, NULL, NULL, NULL, NULL, NULL, 1),	--70
('Acuario con vela', 135.00, 0, 'Acuario con una vela', 30, 1, GETDATE(), 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS5BjCr3Cn7uNyzQfp44sIe5sOuSsjq2V8-5Q&s', 0, NULL, NULL, NULL, NULL, NULL, 1),	--71
('Vela corazon', 45.00, 0, 'Vela con forma de corazón', 30, 1, GETDATE(), 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQMekZB9Gyaiip0qW-3sTLgAWssn5R7RU-A3g&s', 0, NULL, NULL, NULL, NULL, NULL, 1),	--72
('Apaga velas', 345.00, 0, 'Apaga velas', 30, 1, GETDATE(), 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSg5YM-cMmHjCvBD2WBZ867UaTzmeJUIf54nw&s', 0, NULL, NULL, NULL, NULL, NULL, 1),	--73
('Vela citronella', 199.00, 0, 'Vela citronella', 30, 1, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--74
('Vela led', 28.00, 0, 'Vela led de 3x3 cm', 30, 1, GETDATE(), '', 0, 3, 3, NULL, NULL, NULL, 1),	--75
('Vasito acrilico vela led', 49.00, 0, 'Vasito acrilico para tu vela led', 30, 1, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--76
('Acuario vidrio', 49.00, 0, 'Acuario vidrio de 6 cm', 30, 1, GETDATE(), '', 0, 6, 6, NULL, NULL, NULL, 1),	--77
('Acuario vidrio', 59.00, 0, 'Acuario vidrio de 8 cm', 30, 1, GETDATE(), '', 0, 8, 8, NULL, NULL, NULL, 1),	--78
('Acuario vidrio', 105.00, 0, 'Acuario vidrio de 10 cm', 30, 1, GETDATE(), '', 0, 10, 10, NULL, NULL, NULL, 1),	--79
('Acuario vidrio', 169.00, 0, 'Acuario vidrio de 15 cm', 30, 1, GETDATE(), '', 0, 15, 15, NULL, NULL, NULL, 1),	--80
('Acuario vidrio', 249.00, 0, 'Acuario vidrio de 18 cm', 30, 1, GETDATE(), '', 0, 18, 18, NULL, NULL, NULL, 1),	--81
('Acuario vidrio', 269.00, 0, 'Acuario vidrio de 20 cm', 30, 1, GETDATE(), '', 0, 20, 20, NULL, NULL, NULL, 1),	--82
('Votivo vidrio', 29.00, 0, 'Votivo de vidrio de 5x3 cm', 30, 1, GETDATE(), '', 0, 5, 3, NULL, NULL, NULL, 1),	--83
('Votivo vidrio', 29.00, 0, 'Votivo de vidrio de 4x6 cm', 30, 1, GETDATE(), '', 0, 4, 6, NULL, NULL, NULL, 1),	--84
('Votivo vidrio campana', 29.00, 0, 'Votivo de vidrio con forma de campana', 30, 1, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--85
('Votivo vidrio conico', 39.00, 0, 'Votivo de vidrio con forma conica', 30, 1, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--86
('Vidrio cilindro', 199.00, 0, 'Vidrio con forma de cilindro de 10x15 cm', 30, 1, GETDATE(), '', 0, 10, 15, NULL, NULL, NULL, 1),	--87
('Vidrio cilindro', 215.00, 0, 'Vidrio con forma de cilindro de 9x20 cm', 30, 1, GETDATE(), '', 0, 9, 20, NULL, NULL, NULL, 1),	--88
('Vidrio cilindro', 289.00, 0, 'Vidrio con forma de cilindro de 9x25 cm', 30, 1, GETDATE(), '', 0, 9, 25, NULL, NULL, NULL, 1),	--89
('Vidrio cilindro', 255.00, 0, 'Vidrio con forma de cilindro de 12x12 cm', 30, 1, GETDATE(), '', 0, 12, 12, NULL, NULL, NULL, 1),	--90
('Vidrio cilindro', 374.00, 0, 'Vidrio con forma de cilindro de 12x20 cm', 30, 1, GETDATE(), '', 0, 12, 20, NULL, NULL, NULL, 1),	--91
('Globo vidrio facetado', 159.00, 0, 'Globo vidrio facetado chico', 30, 1, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--92
('Globo vidrio facetado', 199.00, 0, 'Globo vidrio facetado grande', 30, 1, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--93
('Vidrio campana', 29.00, 0, 'Vidrio campana', 30, 1, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--94
('Acuario marroqui', 259.00, 0, 'Acuario marroqui', 30, 1, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--95
('Lata mandala', 69.00, 0, 'Lata mandala con forma cuadrada', 30, 1, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--96
('Lata mandala', 79.00, 0, 'Lata mandala bombe', 30, 1, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--97
('Lata mandala', 99.00, 0, 'Lata mandala con forma de corazón', 30, 1, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--98
('Lata mandala', 99.00, 0, 'Lata mandala grande', 30, 1, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--99
('Candelabro vidrio mini', 99.00, 0, 'Candelabro vidrio mini', 30, 1, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--100
('Candelabro vidrio diamante', 135.00, 0, 'Candelabro vidrio diamante', 30, 1, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--101
('Candelabro vidrio facetado', 115.00, 0, 'Candelabro vidrio facetado', 30, 1, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--102
('Candelabro hierro tres patas', 215.00, 0, 'Candelabro hierro tres patas', 30, 1, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--103
('Candelabro hierro vela conica', 195.00, 0, 'Candelabro hierro vela conica', 30, 1, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--104
('Velador MDF calado con vidrio laminado', 285.00, 0, 'Velador MDF calado con vidrio laminado', 30, 3, GETDATE(), 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSPXv9uMTwEC3JHS6BlFCiNuVfrqS3uR9NxhA&s', 0, NULL, NULL, NULL, NULL, NULL, 1),	--105
('Velador MDF calado con vidrio chico', 170.00, 0, 'Velador MDF calado con vidrio chico', 30, 3, GETDATE(), 'https://acdn.mitiendanube.com/stores/002/339/329/products/laser-team-3-velador71-4b16227e8f58f8b0c816827170777682-1024-1024.png', 0, NULL, NULL, NULL, NULL, NULL, 1),	--106
('Velador MDF calado con vidrio mini', 139.00, 0, 'Velador MDF calado con vidrio mini', 30, 3, GETDATE(), 'https://acdn.mitiendanube.com/stores/002/339/329/products/laser-team-3-velador71-4b16227e8f58f8b0c816827170777682-1024-1024.png', 0, NULL, NULL, NULL, NULL, NULL, 1),	--107
('Porta velas caireles', 139.00, 0, 'Porta velas caireles', 30, 1, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--108
('Difusor chico', 169.00, 0, 'Difusor chico', 30, 3, GETDATE(), 'https://f.fcdn.app/imgs/40f7c8/mispetates.com/mipeuy/9edb/original/catalogo/GF.33-simil-madera-claro-1/1920-1200/vaporizador-chico-con-transparencia-simil-madera-claro.jpg', 0, NULL, NULL, NULL, NULL, NULL, 1),	--109
('Difusor 20 dias', 279.00, 0, 'Difusor 20 dias', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--110
('Difusor 45 dias', 445.00, 0, 'Difusor 45 dias', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--111
('Lampara de sal', 790.00, 0, 'Lampara de sal 2kg', 30, 3, GETDATE(), '', 0, NULL, NULL, 2, NULL, NULL, 1),	--112
('Lampara de sal', NULL, 0, 'Lampara de sal 3kg', 30, 3, GETDATE(), '', 0, NULL, NULL, 3, NULL, NULL, 1),	--113
('Lampara de sal', 990.00, 0, 'Lampara de sal 4kg', 30, 3, GETDATE(), '', 0, NULL, NULL, 4, NULL, NULL, 1),	--114
('Lampara de sal mini usb', 499.00, 0, 'Lampara de sal mini usb', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--115
('Antorchas jardin', 120.00, 0, 'Antorchas jardin', 30, 3, GETDATE(), '', 0, NULL, NULL ,NULL, NULL, NULL, 1),	--116
('Hornito mini', 179.00, 0, 'Hornito mini', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--117
('Hornito mediano', 325.00, 0, 'Hornito mediano', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--118
('Hornito grande', 565.00, 0, 'Hornito grande', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--119
('Hornito metal', 345.00, 0, 'Vela con aroma a canela', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--120
('Esencias para hornito liquida', 99.00, 0, 'Esencias para hornito liquida', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--121
('Esencias para hornito solida', 158.00, 0, 'Hornito mediano', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--122
('Plato barro chico', 85.00, 0, 'Plato barro chico', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--123
('Plato barro mediano', 79.00, 0, 'Plato barro mediano', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--124
('Plato barro grande', 169.00, 0, 'Plato barro grande', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--125
('Plato ceramica natural', 129.00, 0, 'Plato ceramica natural', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--126
('Plato ceramica mini', 45.00, 0, 'Plato ceramica mini', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--127
('Plato ceramica chico', 59.00, 0, 'Plato ceramica chico', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--128
('Quemador ceramica mini', 65.00, 0, 'Quemador ceramica mini', 30, 2, GETDATE(), 'https://essencewaxmelt.com/cdn/shop/files/IMG-20241104_145116.jpg?v=1730730220&width=1946', 0, NULL, NULL, NULL, NULL, NULL, 1),	--129
('Quemador ceramica con tapa', 299.00, 0, 'Quemador ceramica con tapa', 30, 2, GETDATE(), 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS8RPsoXhI0ioB1Xg3c7BKiyLy7JfpynBxdew&s', 0, NULL, NULL, NULL, NULL, NULL, 1),	--130
('Porta sahumerio ceramica buda', 129.00, 0, 'Porta sahumerio ceramica buda', 30, 2, GETDATE(), 'https://f.fcdn.app/imgs/64f6bd/mispetates.com/mipeuy/1d46/original/catalogo/OHR.MP252-blanco-1/1920-1200/porta-sahumerio-buda-blanco.jpg', 0, NULL, NULL, NULL, NULL, NULL, 1),	--131
('Quemador cemento', 199.00, 0, 'Quemador cemento', 30, 2, GETDATE(), 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQYJVYAuAhF1xcU-sIEf7SMAlq1GNzqKIxgg&s', 0, NULL, NULL, NULL, NULL, NULL, 1),	--132
('Quemador colgante', 490.00, 0, 'Quemador colgante', 30, 2, GETDATE(), 'https://m.media-amazon.com/images/I/61medT62ddL._AC_SL1500_.jpg', 0, NULL, NULL, NULL, NULL, NULL, 1),	--133
('Campana bronce mini', 279.00, 0, 'Campana bronce mini', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--134
('Campana bronce chica', 399.00, 0, 'Campana bronce chica', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--135
('Campana bronce mediana', 530.00, 0, 'Campana bronce mediana', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--136
('Campana bronce grande', 545.00, 0, 'Campana bronce grande', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--137
('Tablita porta sahumerio', 49.00, 0, 'Tablita porta sahumerio', 30, 2, GETDATE(), 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSnKQ8YGFoTkfphRjy2GtP637xxljP-rRVHPg&s', 0, NULL, NULL, NULL, NULL, NULL, 1),	--138
('Base porta sahumerio', 99.00, 0, 'Base porta sahumerio', 30, 2, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--139
('Torre porta sahumerio', 395.00, 0, 'Torreporta sahumerio', 30, 2, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--140
('Sahumerios comunes', 17.00, 0, 'Sahumerios comunes', 30, 2, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--141
('Sahumerios pasta', 25.00, 0, 'Sahumerios pasta', 30, 2, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--142
('Sahumerios naturales', 89.00, 0, 'Sahumerios naturales', 30, 2, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--143
('Conitos sahumerio', 45.00, 0, 'Conitos sahumerio', 30, 2, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--144
('Mandala MDF', 229.00, 0, 'Mandala MDF 30cm', 30, 3, GETDATE(), '', 0, 30, 30, NULL, NULL, NULL, 1),	--145
('Mandala MDF', 560.00, 0, 'Mandala MDF 60cm', 30, 3, GETDATE(), '', 0, 60, 60, NULL, NULL, NULL, 1),	--146
('Letras MDF', 19.00, 0, 'Letras MDF 7cm', 30, 3, GETDATE(), '', 0, 7, 7, NULL, NULL, NULL, 1),	--147
('Letras MDF', 49.00, 0, 'Letras MDF 15cm', 30, 3, GETDATE(), '', 0, 15, 15, NULL, NULL, NULL, 1),	--148
('Cubo MDF', 99.00, 0, 'Cubo MDF 8cm', 30, 3, GETDATE(), '', 0, 8, 8, NULL, NULL, NULL, 1),	--149
('Cubo de MDF', 145.00, 0, 'Cubo de MDF 10 cm', 30, 3, GETDATE(), '', 0, 10, 10, NULL, NULL, NULL, 1),	--150
('Cubo de MDF', 175.00, 0, 'Cubo de MDF 12 cm', 30, 3, GETDATE(), '', 0, 12, 12, NULL, NULL, NULL, 1),	--151
('Porta te', 278.00, 0, 'Porta te de madera x3', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 3),	--152
('Porta te', 349.00, 0, 'Porta te de madera x6', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 6),	--153
('Porta te', 375.00, 0, 'Porta te de madera x9', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 9),	--154
('Cajon de madera', 289.00, 0, 'Cajon de madera chico', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--155
('Cajon de madera', 385.00, 0, 'Cajon de madera mediano', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--156
('Cajon de madera', 399.00, 0, 'Cajon de madera grande', 30, 3, GETDATE(), '', 0, 0, 0, NULL, NULL, NULL, 1),	--157
('Figura de MDF', 19.00, 0, 'Figura de MDF 3 cm', 30, 3, GETDATE(), '', 0, 3, 3, NULL, NULL, NULL, 1),	--158
('Figura de MDF', 24.00, 0, 'Figura de MDF 6 cm', 30, 3, GETDATE(), '', 0, 6, 6, NULL, NULL, NULL, 1),	--159
('Figura de MDF', 45.00, 0, 'Figura de MDF 9 cm', 30, 3, GETDATE(), '', 0, 9, 9, NULL, NULL, NULL, 1),	--160
('Caja de madera', 77.00, 0, 'Caja de madera 7 cm', 30, 3, GETDATE(), '', 0, 7, 7, NULL, NULL, NULL, 1),	--161
('Caja de madera', 120.00, 0, 'Caja de madera 10 cm', 30, 3, GETDATE(), '', 0, 10, 10, NULL, NULL, NULL, 1),	--162
('Caja de madera', 240.00, 0, 'Caja de madera 15 cm', 30, 3, GETDATE(), '', 0, 15, 15, NULL, NULL, NULL, 1),	--163
('Caja de madera', 290.00, 0, 'Caja de madera 20 cm', 30, 3, GETDATE(), '', 0, 20, 20, NULL, NULL, NULL, 1),	--164
('Pintura acrilica', 89.00, 0, 'Pintura acrilica 60 cc', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, 60, NULL, 1),	--165
('Pintura acrilica', 159.00, 0, 'Pintura acrilica 120 cc', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, 120, NULL, 1),	--166
('Pintura acrilica', 279.00, 0, 'Pintura acrilica 250 cc', 30, 3, GETDATE(), '', 0, NULL, 10, NULL, 250, NULL, 1),	--167
('Tempera', 23.00, 0, 'Tempera 15 cc', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, 15, NULL, 1),	--168
('Ladrillo oasis', 89.00, 0, 'Ladrillo oasis', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--169
('Bolsa musgo', 185.00, 0, 'Bolsa musgo', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--170
('Ramo flores secas', 199.00, 0, 'Ramo de flores secas', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--171
('Parafina', 199.00, 0, 'Parafina x1 kg', 30, 1, GETDATE(), '', 0, NULL, NULL, 1, NULL, NULL, 1),	--172
('Pabilo fino', 12.00, 0, 'Pabilo fino', 30, 1, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--173
('Pabilo grueso', 15.00, 0, 'Pabilo grueso', 30, 1, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--174
('Color para velas', 65.00, 0, 'Colo para velas 60 cc', 30, 1, GETDATE(), '', 0, NULL, NULL, NULL, 60, NULL, 1),	--175
('Escencia para velas', 159.00, 0, 'Escencia para velas', 30, 1, GETDATE(), '', 0, 10, 10, NULL, 30, NULL, 1),	--176
('Molde silicona', 110.00, 0, 'Molde de silicona', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--177
('Glicerina para jabon', 490.00, 0, 'Glicerina para jabon', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--178
('Color para jabon', 55.00, 0, 'Color para jabon 60 cc', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, 60, NULL, 1),	--179
('Escencia para jabon', 130.00, 0, 'Escencia para jabon 30 cc', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, 30, NULL, 1),	--180
('Cera de soja', 790.00, 0, 'Cera de soja para velas', 30, 1, GETDATE(), '', 0, NULL, NULL, 0.5, NULL, NULL, 1),	--181
('Cera de soja', NULL, 0, 'Cera de soja para velas', 30, 1, GETDATE(), '', 0, NULL, NULL, 0.25, NULL, NULL, 1),	--182
('Pabilo para soja', 5.00, 0, 'Pabilo para soja 12 cm', 30, 1, GETDATE(), '', 0, 12, 12, NULL, NULL, NULL, 1),	--183
('Pabilo para soja', 7.00, 0, 'Pabilo para soja 20 cm', 30, 1, GETDATE(), '', 0, 20, 20, NULL, NULL, NULL, 1),	--184
('Laminas de miel', 75.00, 0, 'Laminas de miel', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--185
('Pastillero de metal', 20.00, 0, 'Pastillero de metal 5 cm', 30, 3, GETDATE(), '', 0, 5, 5, NULL, NULL, NULL, 1),	--186
('Pastillero de metal', 28.00, 0, 'Pastillero de metal 7 cm', 30, 3, GETDATE(), '', 0, 7, 7, NULL, NULL, NULL, 1),	--187
('Buda', 30.00, 0, 'Buda en yeso mini', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--188
('Buda', 124.00, 0, 'Buda en yeso chico', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--189
('Buda', 518.00, 0, 'Buda en yeso mediano', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--190
('Buda', 769.00, 0, 'Buda en yeso grande', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--191
('Rana', 145.00, 0, 'Rana en yeso', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--192
('Angeles', 65.00, 0, 'Angeles en yeso chico', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--193
('Angeles', 165.00, 0, 'Angeles en yeso mediano', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--194
('Angeles', 319.00, 0, 'Angeles en yeso grande', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--195
('Virgen', 110.00, 0, 'Virgen en yeso chica', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--196
('Virgen', 318.00, 0, 'Virgen en yeso grande', 30, 3, GETDATE(), '', 0, NULL, NUll, NULL, NULL, NULL, 1),	--197
('Flor', 89.00, 0, 'Flor de yeso', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--198
('Curcifijo', 120.00, 0, 'Curcifijo de yeso', 30, 3, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1),	--199
('Porta sahumerios', 52.00, 0, 'Porta sahumerios de yeso', 30, 2, GETDATE(), '', 0, NULL, NULL, NULL, NULL, NULL, 1);	--200



-- Insertar proveedores de ejemplo
INSERT INTO Suppliers (Name, Phone, ProductId, Cost, Email, LastPurchaseDate) VALUES 
    ('Proveedor Aromas', '123456789', 1, 8, 'aromas@example.com', '2024-10-10'),
    ('Proveedor Esencias', '987654321', 2, 5, 'esencias@example.com', '2024-10-15'),
    ('Proveedor Decoración', '555666777', 3, 18, 'decoraciones@example.com', '2024-10-20');

-- Insertar usuarios de ejemplo
INSERT INTO Users (UserName, Password, Email, Birthdate, Address, RUT, Phone, ContactName) VALUES 
    ('JuanPerez', 'password123', 'juan.perez@example.com', '1990-05-21', 'Calle Falsa 123', '12345678-9', '123456789', 'Juan Pérez'),
    ('MariaLopez', 'password456', 'maria.lopez@example.com', '1985-10-11', 'Avenida Siempre Viva 742', '98765432-1', '987654321', 'Maria Lopez'),
    ('CarlosDiaz', 'password789', 'carlos.diaz@example.com', '2000-02-29', 'Boulevard Central 500', '55555555-5', '555666777', 'Carlos Diaz');

	Select * from Products